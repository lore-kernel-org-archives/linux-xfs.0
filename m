Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E80DF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307234; cv=none; b=VmrCqkBHXR3SWzKeG0sqmr67Td/eAb4r/Tii4w5pquEQ2IGd+wMFVoUq6S9PfycQn+i3NuSile+xPFcgaC3G3+/ONYUrz0CF01pC9F+kEhVfmvw/txUmmiAK6aswxx3fqDJYMsQz1Ua6TcVommTIrhSKpMc+QMLpU2KwJNxYDak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307234; c=relaxed/simple;
	bh=vLrt2NAEOWbjCUv8bLt43NV7zo7xhRYHDw0GIQMjrbE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=egRSyiRrG/BkIu1Q7d75C/a7WdFOVwnOujXOIXANKWw6fWYg/DeqORMkAdl5N9G7X/CwVeCm8RunosSG3sabm10pOWKaz3kFDxYuewhsPpHUZ7J3T0GMNl1KYJQic820a8f59SY07jiWAEz17PN5xIG3PAdaYmIlJIuERKd8OTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChQOMYUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChQOMYUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4BCC32786;
	Tue, 30 Jul 2024 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307234;
	bh=vLrt2NAEOWbjCUv8bLt43NV7zo7xhRYHDw0GIQMjrbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ChQOMYUf+9JOINhlU+1GVMOP6sui3da4UzshpvGuXesFM/5Xdm8/P5I+XQmvNk7iK
	 121xkdalNV+n/iHzpeA7z8obV5hw60PfaO71NaR1obTAQ6BtxaF1szsrgji5g/hM5i
	 74SgIafxFcXrH7AcQXTZ3hOXKA0uNAO9mi4klxV3S8wKQfF0G1roAN+GmrTxRNlPRI
	 a1b7VogFAyknJAC+QBCJRT3WgpGaarLPb2/LK3pEpGAniCpw0vMkl23Qnb4U46lxvP
	 2/FcQgBUXSkvGeY/xU6nqszoLRexqJdkPK5VQdg3LAtML2vRd4yB9kU+W1cNrb2Qjg
	 LVB5FjapLfVkg==
Date: Mon, 29 Jul 2024 19:40:33 -0700
Subject: [GIT PULL 01/23] libxfs: fixes for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, santiago_kraus@yahoo.com, zeha@debian.org
Message-ID: <172230457841.1455085.11565175736015940609.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 42fc61ebd061ffc63a0302a8422ed21f67e38b5f:

xfsprogs: Release v6.9.0 (2024-07-22 11:05:03 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-6.9-fixes_2024-07-29

for you to fetch changes up to c6438c3e740e139adcd6c236606498d49bbb5655:

xfs_repair: don't crash on -vv (2024-07-29 17:00:59 -0700)

----------------------------------------------------------------
libxfs: fixes for 6.9 [01/28]

A couple more last minute fixes for 6.9.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Chris Hofstaedtler (1):
Remove support for split-/usr installs

Christoph Hellwig (1):
repair: btree blocks are never on the RT subvolume

Darrick J. Wong (3):
xfile: fix missing error unlock in xfile_fcb_find
xfs_repair: don't leak the rootdir inode when orphanage already exists
xfs_repair: don't crash on -vv

configure.ac                | 21 ---------------------
debian/Makefile             |  4 ++--
debian/local/initramfs.hook |  2 +-
debian/rules                |  5 ++---
fsck/Makefile               |  4 ++--
include/builddefs.in        |  2 --
include/buildmacros         | 20 ++++++++++----------
libxfs/xfile.c              |  6 +++---
mkfs/Makefile               |  4 ++--
repair/Makefile             |  4 ++--
repair/phase6.c             |  7 +++++--
repair/progress.c           |  2 +-
repair/scan.c               | 21 +++++----------------
repair/xfs_repair.c         |  2 +-
14 files changed, 36 insertions(+), 68 deletions(-)

