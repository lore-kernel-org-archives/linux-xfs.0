Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0104C63F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388687; cv=none; b=E/JhZNzYAlWzANMsBBafc8Ygm6GbkK/B6MtrW1L6kZwum8IrS7SUxFThbKGy/bspj4e2y2ipzyxU/J9DPy2FuD/R+jYQ6KJS0nBV2lRid9nihYKdO/Ln1PbtpE1lY9LMaaiQgC1MAkF7GIh77+I+04KpVd/Vn4H17CWTr3yPN+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388687; c=relaxed/simple;
	bh=ZTML6RoaUMCMwjBVgqv65GSMzz6NzK99V3cQyFQvDb4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHbDuUk9RQZS2mDl+m0+O7+emkSX7Z2y0/oysM10lhN4Y0R+3rNWPJ0/cCOrVarIDkCHNLHAwEQiMJqRe4/x2gvcvE81u/g0Hy/g+XZRfhtbVuMAlpE0e0hjk5DbldH3K6mDrtaBnE+kVegfo0UjV1xVkl64wWOWUmca3fIF+88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OL8ye7SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OL8ye7SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D42C072AA;
	Wed, 17 Apr 2024 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388687;
	bh=ZTML6RoaUMCMwjBVgqv65GSMzz6NzK99V3cQyFQvDb4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OL8ye7SIhYtzVFuEMviPjYJC4BqSNZupm6Ov8raC8/8Gmk/algmaGtutrxyiY3F2M
	 fZh8suwpaVWT4WTEQbEkZnEa21JYd8Cam0bs6dbg5bo/P7+52hmQwjnC3rndxzuGu6
	 WM/yFFAg7lXvLh3DCMRv/f/4rIpQG+akhJ9bSI4DhEW6Zj/2k/5M2r8xWlpSmJ/S//
	 saYh0ZqfTMAvC2ILzWVxvNeSvf9gzor4LbO8A9vkktx5Zjp5DAHVfihx92MUS+6jfi
	 ZuVBt5Ni7zapNEh+J2x+HVbLf2Z2XWn5TfyalX29KdMML8H2RnNYenN6bK1qSxqlTz
	 GeGY4RVUCT8xA==
Date: Wed, 17 Apr 2024 14:18:06 -0700
Subject: [PATCHSET 11/11] xfs_repair: support more than 4 billion records
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-support-4bn-records-6.8
---
Commits in this patchset:
 * xfs_db: add a bmbt inflation command
 * xfs_repair: slab and bag structs need to track more than 2^32 items
 * xfs_repair: support more than 2^32 rmapbt records per AG
 * xfs_repair: support more than 2^32 owners per physical block
 * xfs_repair: clean up lock resources
 * xfs_repair: constrain attr fork extent count
 * xfs_repair: don't create block maps for data files
 * xfs_repair: support more than INT_MAX block maps
---
 db/Makefile       |   65 +++++-
 db/bmap_inflate.c |  551 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    1 
 man/man8/xfs_db.8 |   23 ++
 repair/bmap.c     |   23 +-
 repair/bmap.h     |    7 -
 repair/dinode.c   |   18 +-
 repair/dir2.c     |    2 
 repair/incore.c   |    9 +
 repair/rmap.c     |   25 +-
 repair/rmap.h     |    4 
 repair/slab.c     |   36 ++-
 repair/slab.h     |   36 ++-
 14 files changed, 725 insertions(+), 76 deletions(-)
 create mode 100644 db/bmap_inflate.c

