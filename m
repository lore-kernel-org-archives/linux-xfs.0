Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECC318A6D7;
	Mon, 23 Dec 2024 23:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995866; cv=none; b=m39SroKpy83XgKmMk1TXOdbOLR15xsjuHYEnG77P/HX61qlw1wPKLh/XUhQmzTL8NkU3RTIsqATQaPZJ1/GKwOybjFzvOdEieWIZcfFcXcUyFSwcDTjVLLRjkncrciLKS6Hp7OVHMYkKR5oUfxm8WFmlIj2LqD9qKgHfVNxahRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995866; c=relaxed/simple;
	bh=9F6E7B/+UpnV8oVtP3agx7yhISfWGR0CYE6CInjQsfk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=uXO/A5+diEAyNWOwLuZnibqfF25OhICuyOzxvq2wgUVMTyAUI2zjm7EcuK6zu0na0ayBh9dcyDsF5tbROI0WzEmdSncbSg28NjDVNMr9HcRYrp9cr838KmvqTFlEkXYrKXlOnAEBoqtwF1MHcnVnY8kolIwJJHTWnr3lTGgVqcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6t4vUNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6t4vUNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9EFC4CED3;
	Mon, 23 Dec 2024 23:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995865;
	bh=9F6E7B/+UpnV8oVtP3agx7yhISfWGR0CYE6CInjQsfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k6t4vUNz1Ng9wpDNTuqlyYK9VhAdZ7mI7v8djP6Y/cT9J9hqBp3JeI/ispzsSpeQV
	 vKChh0Ds1LlEOPTUmrYdz7oPHJaJL+1QH0WdVTqQJNP9//q59gLs5svxOXFhtRjt1t
	 4xrBbpiZBQU1lA0NX4fLoG3uMCgFU1pKTvJGZ/4S8tGb7IO9ZQ8BB0F7MjC/c+MbMO
	 peqwvzeb0MB+HovdNgkb4nX1PIgks6kH1VFZlFV9vG4p0IUAcBzGmY46Fxdhxcvaon
	 SwnwY5HcI3gm8WbJxeLFdTgJtJVA5DZ1Yg71e9SlssTaif0RcDmn8+cS6yyzZO0Ec9
	 gufi6dakKCcdw==
Date: Mon, 23 Dec 2024 15:17:44 -0800
Subject: [GIT PULL 1/5] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: eflorac@intellique.com, hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org, syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Message-ID: <173499428661.2382820.13397448738755922887.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4bbf9020becbfd8fc2c3da790855b7042fad455b:

Linux 6.13-rc4 (2024-12-22 13:22:21 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfs-6.13-fixes_2024-12-23

for you to fetch changes up to 1aacd3fac248902ea1f7607f2d12b93929a4833b:

xfs: release the dquot buf outside of qli_lock (2024-12-23 13:06:01 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.13 [01/14]

Bug fixes for 6.13.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: don't over-report free space or inodes in statvfs
xfs: release the dquot buf outside of qli_lock

fs/xfs/xfs_dquot.c  | 12 ++++++++----
fs/xfs/xfs_qm_bhv.c | 27 +++++++++++++++++----------
2 files changed, 25 insertions(+), 14 deletions(-)

