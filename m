Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55A7764E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 12:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712062222; cv=none; b=grFjCqkFQU3YCuaJxKrAuIX+0PkPjK/hWWz8c3XQR6yEtcqOa5xThWMWa7LvHE0NtpvhBvSOh2OKIL3dJdaZ5TwTGJXMG25n355zuN17eQuoJTipW0opLAJCmnst98ujzYA4EHRofLnLifUb9jmlhIIKX1gsRkYgu3yEe1t4UQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712062222; c=relaxed/simple;
	bh=9PHdROx8UfCXh4ObqeeSQkHiKyvdHsv4iQn8Fxt8NpE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NixWD7FXUkt8guQhGogtoFuTM5Xm14tf0fRkAjrdMlEM9ZU7Grj7BFLePZiQ7TMHPEBtDX3mrFKL6ZeQ2AqLlpzHSNSr0KknZxDb44LK7q+C1bna1V5TdDwBzVd1TTn9ReteC8YM8WkFs/oqmOfKPft2KMaIE6sEXXZilF0Uzpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JHTepFVq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHTepFVq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Y/jB9O+wgzHQNwYNOPYjPeumA4ZkpgJsP6D7+3M1FjI=; b=JHTepFVq4FzD75rMUDKY1Nx3xS
	2b1A1WRyXvk/aGYjcphXJw427MzNswqeaqeNmCMve5rq5a8ipps2qwatKaBWzXaQ+fupIyUH7ao/B
	R+PxgJ7bbM2v2cqkEwR2ew//ngti+gkxHNwhvrVef4pdoMUO5t0R9uNAzheLI78WD7UO+ylte6D39
	ECx+ATdXoCl2nYz0cthi72VynIPyct/8/lMFr7slw7rnKxq8Jl0DEbiOSiJZcJF1sT68jcbBUmm4x
	kASovcQlZljAApHxV04eCnWmvY0jVFbRdrP1U41Z31WWId/wagDDcEoU0HUnGmETWem896mNlsFy9
	g2c/d/ow==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdak-0000000BAJ8-0Uma;
	Tue, 02 Apr 2024 12:50:18 +0000
Date: Tue, 2 Apr 2024 14:50:15 +0200
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: [GIT PULL] bring back RT delalloc support
Message-ID: <Zgv_B07xhnE-pl6x@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Chandan,

Please pull this branch with changes for 6.10-rc:

The following changes since commit f2e812c1522dab847912309b00abcc762dd696da:

  xfs: don't use current->journal_info (2024-03-25 10:21:01 +0530)

are available in the Git repository at:

  git://git.infradead.org/users/hch/xfs.git tags/xfs-realtime-delalloc-2024-04-02

for you to fetch changes up to e3b3bbc181dedebc4192f938c98699e127d70c8e:

  xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1) (2024-03-28 09:19:53 +0100)

----------------------------------------------------------------
xfs:  bring back RT delalloc support

Add back delalloc support for RT inodes, at least if the RT
extent size is a single file system block.

----------------------------------------------------------------
Christoph Hellwig (12):
      xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
      xfs: free RT extents after updating the bmap btree
      xfs: move RT inode locking out of __xfs_bunmapi
      xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive
      xfs: split xfs_mod_freecounter
      xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
      xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
      xfs: support RT inodes in xfs_mod_delalloc
      xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
      xfs: rework splitting of indirect block reservations
      xfs: stop the steal (of data blocks for RT indirect blocks)
      xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)

Darrick J. Wong (1):
      xfs: refactor realtime inode locking

 fs/xfs/libxfs/xfs_ag.c           |   4 +-
 fs/xfs/libxfs/xfs_ag_resv.c      |  24 ++-----
 fs/xfs/libxfs/xfs_ag_resv.h      |   2 +-
 fs/xfs/libxfs/xfs_alloc.c        |   4 +-
 fs/xfs/libxfs/xfs_bmap.c         | 152 +++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.c     |  57 +++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h     |  17 +++++
 fs/xfs/libxfs/xfs_shared.h       |   6 +-
 fs/xfs/scrub/common.c            |   1 +
 fs/xfs/scrub/fscounters.c        |  12 ++--
 fs/xfs/scrub/fscounters.h        |   1 +
 fs/xfs/scrub/fscounters_repair.c |  12 +++-
 fs/xfs/scrub/repair.c            |   5 +-
 fs/xfs/xfs_fsmap.c               |   4 +-
 fs/xfs/xfs_fsops.c               |  29 +++-----
 fs/xfs/xfs_fsops.h               |   2 +-
 fs/xfs/xfs_inode.c               |   3 +-
 fs/xfs/xfs_iomap.c               |  45 ++++++++----
 fs/xfs/xfs_iops.c                |   2 +-
 fs/xfs/xfs_mount.c               |  85 +++++++++++++---------
 fs/xfs/xfs_mount.h               |  36 +++++++---
 fs/xfs/xfs_rtalloc.c             |  22 +++---
 fs/xfs/xfs_super.c               |  17 +++--
 fs/xfs/xfs_trace.h               |   1 -
 fs/xfs/xfs_trans.c               |  63 ++++++++--------
 25 files changed, 358 insertions(+), 248 deletions(-)
