Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE814262C
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723070975; cv=none; b=hNFJffyAIO0tmpUxlSaFO+C6MWU+DflrBjpkV1vUvg9P56th6a8lur5PFbt0NyZWNcIDx2XHY3ySjKB1jOlimK+w4lPgiu5oLhk71LNqttibCVb+zWoA9qPyujI93HXvkozqjzj8YKGk0yoaO66ny1uQuksuZXagDs3B8vOwVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723070975; c=relaxed/simple;
	bh=ZVzAEi77WNaHdVQQh23nj+hWGFMll+1H4l72RQfqSaI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=qnMgKYP+mG6VqcWIQ5OnfNVP1lvE5WOIxW7HMlR0No3/NXcTq0PKUDQ2/uS8fdwrtTmZiiQvNAr11PoPbUGKVn0gTEyDctS11R84500w/Qlp9c4oJoaBwecGBIqYsVZZjkLwKSO0HA0Dmv8Cuk9bfMtcYAVX/xxXZwIdjWQKpiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdD2vK7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdD2vK7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7767C32781;
	Wed,  7 Aug 2024 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723070974;
	bh=ZVzAEi77WNaHdVQQh23nj+hWGFMll+1H4l72RQfqSaI=;
	h=Date:Subject:From:To:Cc:From;
	b=TdD2vK7C/1Ff515qDxU8nFa8ysPzAu+e/gb2wOTldux4Z8mJLsm5pjYjArZFs0PLM
	 9nL3slMexP3bsLkwXS9apj8/AG9LoxMAEkJee2euo9deUG2cOUivH5W4E2ArysJsiC
	 94kGkJ+QNM0VcCnG3mlIaQuL1h6u6GvywMQky7juZ8v2fIX2J5I/WmbpmeV7Xcj6K3
	 Y/XxO+LuiuG+Qi+UuoaxzlbZFGyaZPo7eeMB83B/3vfnXDAFx36W90NDp0o7r7mb7L
	 m41DEJ80bd+D0kAAKwB/ryEtZKN8npORmtBYwaloP4Tm/bunn4+IN1QQ+yMi+Uq2tY
	 uoIYF+RjAF5rw==
Date: Wed, 07 Aug 2024 15:49:34 -0700
Subject: [GIT PULL] xfs: random fixes for 6.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <172307092881.1180834.12656496144947295548.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.11-rc2.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed:

Linux 6.11-rc2 (2024-08-04 13:50:53 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/random-fixes-6.11_2024-08-07

for you to fetch changes up to b9b972e5b7ee1c26fb555ee708037919aecfad34:

xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set (2024-08-06 09:03:57 -0700)

----------------------------------------------------------------
xfs: random fixes for 6.11

Here are some bugfixes for 6.11.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: attr forks require attr, not attr2
xfs: revert AIL TASK_KILLABLE threshold
xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set

fs/xfs/scrub/bmap.c    |  8 +++++++-
fs/xfs/xfs_ioctl.c     | 11 +++++++++++
fs/xfs/xfs_trans_ail.c |  7 ++++++-
3 files changed, 24 insertions(+), 2 deletions(-)

