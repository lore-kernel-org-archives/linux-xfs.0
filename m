Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A53C13E9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362931; cv=none; b=HkT5UKqUZotqhY6I6O+Rf86p1P8uqqxwYVkmLZg64pxR2kEM1zx5QpUM3ax1FSd5vSJTA04yFNLsBJ60+8dmfVrHSWgClEhhxSz2KXGs1uvQwyS/YLbBnGSPzMQtKUenTfkXO4bbyjClhoxkYkfyB6slg+j/5F3eNDwhyRvV0NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362931; c=relaxed/simple;
	bh=FyFLhH7W2mHeOVjHYNPaktqXwFQSJZPAz0TOPtFgyco=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O2eLdAFwl8qdIlKBisbhByRN+AAcGhxXKhSsue6zReT7Cmnw2jFBhzd9tVTzvNCuJtXkTveS7M+qJnVth4LOruC+RekXslyaWBpX0/7gymr7c2m2D26BCNKmwSmBFF9o525wczVY74eakPPrcmX6rvETduXadVsL34QvG+Pw6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZXSklpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZXSklpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8AC1F000E9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 11:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362930;
	bh=268kAPYwft2h7Eo7HaL60TnyeQSro3XB0ogoSGM8d4s=;
	h=Date:From:To:Subject;
	b=lZXSklpVCdHB83KKlXo/9vn0b5SEZCsbFiLrgvByY5o36fSR2P+vp8LvCtag9P9qg
	 ji+sx1jrKNlPel9ENzLfVyP5Bgv4ayMV2cqAm7SlL2RO5iSoRcQqWDXlbNOUXkmWmC
	 BkgZdXtrzS/YsfIX1yqKnianAufUKV9soerGgxsXsMwJAu2lHDpKOjNLHy6Wsrk8WH
	 6sDJQm70fp9esfwy4AoyUCxZx2eO2mrGmtsAQKBivmnGsp+3ccB096rp0nIsF87/+X
	 Mc/HgbLaUBMzPkYcHayHZczu7Mop8IMCATwcQPlJyghojyzhDGjtN3D9r4XZ6OBJaN
	 PNsCJLsE4q77Q==
Date: Mon, 10 Aug 2026 13:55:26 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0877338ade31
Message-ID: <anm7ibwkbXHILA7r@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

0877338ade31 Merge branch 'xfs-7.3-merge' into for-next

17 new commits:

Carlos Maiolino (1):
      [0877338ade31] Merge branch 'xfs-7.3-merge' into for-next

Christoph Hellwig (12):
      [45fd506c334c] xfs: don't get a pag reference in xfs_buf_get_map
      [568c8798a3d0] xfs: consolidate buffer locking in xfs_buf_get_map
      [b6ba780af010] xfs: split out a lower-level xfs_buf_get_map helper from xfs_find_get_buf
      [7a4eae80b5b3] xfs: remove spurious XBF_DONE clearing on readahead validation failure
      [d80fe85bb2fc] xfs: remove _XBF_LOGRECOVERY
      [9f224de410d7] xfs: hide b_flags manipulation from code outside of xfs_buf.c
      [b15f6520ab64] xfs: use WRITE_ONCE to update b_flags
      [3d102727432b] xfs: don't reverify buffers in xfs_buf_readahead_map
      [819f1cc98aaf] xfs: use goto based error unwinding in xfs_buf_read_map
      [21cc7775ee5c] xfs: merge xfs_buf_reverify into xfs_buf_read_map
      [2aedf844be1d] xfs: move buffer locking out of xfs_find_get_buf
      [00f40876f417] xfs: add lockless xfs_buf_readahead_map fast path

Hongling Zeng (3):
      [a94e648f03cf] xfs: use file target for post-log fsync fallback flush
      [6e6a31401445] xfs: check split_sectors validity before bio_split call
      [b7eea80be25f] xfs: validate attr entry pointer before field access

Yun Zhou (1):
      [0241ea5fb0fe] xfs: restore nofs context unconditionally in xfs_trans_roll

Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c     |  14 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   7 +-
 fs/xfs/libxfs/xfs_dquot_buf.c     |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c        |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c     |  15 +-
 fs/xfs/xfs_buf.c                  | 392 ++++++++++++++++++++------------------
 fs/xfs/xfs_buf.h                  |   8 +-
 fs/xfs/xfs_buf_item.c             |  10 +-
 fs/xfs/xfs_buf_item_recover.c     |   3 -
 fs/xfs/xfs_dquot_item_recover.c   |   1 -
 fs/xfs/xfs_file.c                 |  26 ++-
 fs/xfs/xfs_fsops.c                |   2 +-
 fs/xfs/xfs_inode.c                |   4 +-
 fs/xfs/xfs_inode_item_recover.c   |   1 -
 fs/xfs/xfs_log_recover.c          |   5 +-
 fs/xfs/xfs_trace.h                |   2 +-
 fs/xfs/xfs_trans.c                |  16 +-
 fs/xfs/xfs_trans_buf.c            |   7 +-
 fs/xfs/xfs_zone_gc.c              |   2 +-
 19 files changed, 279 insertions(+), 246 deletions(-)
