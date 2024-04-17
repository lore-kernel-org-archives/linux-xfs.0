Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC222338
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391813; cv=none; b=s61q52n5d0VHuG0BaE0dft0am6Zl87GVCb8/GbUsUc2WACyKxJaPU1a8Q59ZCdMrU5vpnD0WVi7jOOmlC9tZ+ffRCJbX+3LiulU8dZDMEh9Xjh798vh4AtVv/jYypYo0ZOwpG5fynLt3RG2pZJNthpQeSwEyMZtAfFZwxZGluI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391813; c=relaxed/simple;
	bh=j6JUmIkid4uTfqNbk2EnxgcpfSIAokFgSyDVsYkz01k=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=ZyM5Y5uIER+yuepo+yfoIYAgehTEArX51chb+JGALvAgfhdBZ+MjT2T1I7w2/9BlqvFuZrGo/O1SM/PXAkXEYCIUCuQJh1d4MBtqKfgwLRCtRiVNKE1mN//sHILiCAUGJR4/3wUjeZYQUSVvWRFRoFccKdzwRmexoKvbCk0L/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJeDOtEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJeDOtEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F87C072AA;
	Wed, 17 Apr 2024 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391812;
	bh=j6JUmIkid4uTfqNbk2EnxgcpfSIAokFgSyDVsYkz01k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tJeDOtEry8lqYndUjUD6KXIHx9OotnaYhVGP+AVbCY04fj/hECyzzsUwfcUH/cfkq
	 Ff7eC4ZlSod3Mbn5WvWO0mjIVbp7/sAgb6h8sNUevO25CuMA44ytmlJe0RTNSwUkHz
	 yg1GnFJeCnTCAP/9vaNqpEjwZQFC4aKGC7gnRThKM6c3T18NFttGRs+TXfrAhdVaWt
	 uPY9/McnmdPbN2kUnU5T0mnH2bSnvRbcCncmlgl7FK8ibgBkIeip0OSrL6MSr7PBaR
	 8zpn/F1ueUQuBgkxv6dnjPcmd8qNXxDjZUPOQ8JQf8B3shH8XIXOQ4k+y6YJsbjfLY
	 D8w6DbIVDEbDA==
Date: Wed, 17 Apr 2024 15:10:12 -0700
Subject: [GIT PULL 11/11] xfs_repair: support more than 4 billion records
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: djwong@djwong.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339162291.1911630.9932999805644506997.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit b3bcb8f0a8b5763defc09bc6d9a04da275ad780a:

xfs_repair: rebuild block mappings from rmapbt data (2024-04-17 14:06:28 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-support-4bn-records-6.8_2024-04-17

for you to fetch changes up to 90ee2c3a94511da87929989a06199fd537c94db4:

xfs_repair: support more than INT_MAX block maps (2024-04-17 14:06:28 -0700)

----------------------------------------------------------------
xfs_repair: support more than 4 billion records [11/20]

I started looking through all the places where XFS has to deal with the
rc_refcount attribute of refcount records, and noticed that offline
repair doesn't handle the situation where there are more than 2^32
reverse mappings in an AG, or that there are more than 2^32 owners of a
particular piece of AG space.  I've estimated that it would take several
months to produce a filesystem with this many records, but we really
ought to do better at handling them than crashing or (worse) not
crashing and writing out corrupt btrees due to integer truncation.

Once I started using the bmap_inflate debugger command to create extreme
reflink scenarios, I noticed that the memory usage of xfs_repair was
astronomical.  This I observed to be due to the fact that it allocates a
single huge block mapping array for all files on the system, even though
it only uses that array for data and attr forks that map metadata blocks
(e.g. directories, xattrs, symlinks) and does not use it for regular
data files.

So I got rid of the 2^31-1 limits on the block map array and turned off
the block mapping for regular data files.  This doesn't answer the
question of what to do if there are a lot of extents, but it kicks the
can down the road until someone creates a maximally sized xattr tree,
which so far nobody's ever stuck to long enough to complain about.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs_db: add a bmbt inflation command
xfs_repair: slab and bag structs need to track more than 2^32 items
xfs_repair: support more than 2^32 rmapbt records per AG
xfs_repair: support more than 2^32 owners per physical block
xfs_repair: clean up lock resources
xfs_repair: constrain attr fork extent count
xfs_repair: don't create block maps for data files
xfs_repair: support more than INT_MAX block maps

db/Makefile       |  65 ++++++-
db/bmap_inflate.c | 551 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
db/command.c      |   1 +
db/command.h      |   1 +
man/man8/xfs_db.8 |  23 +++
repair/bmap.c     |  23 +--
repair/bmap.h     |   7 +-
repair/dinode.c   |  18 +-
repair/dir2.c     |   2 +-
repair/incore.c   |   9 +
repair/rmap.c     |  25 ++-
repair/rmap.h     |   4 +-
repair/slab.c     |  36 ++--
repair/slab.h     |  36 ++--
14 files changed, 725 insertions(+), 76 deletions(-)
create mode 100644 db/bmap_inflate.c

