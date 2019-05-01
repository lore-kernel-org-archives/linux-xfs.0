Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfEAOFG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 May 2019 10:05:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D992985543
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:05 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9451C17502
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:05 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: don't set bmapi total block req where minleft is sufficient
Date: Wed,  1 May 2019 10:05:04 -0400
Message-Id: <20190501140504.16435-3-bfoster@redhat.com>
In-Reply-To: <20190501140504.16435-1-bfoster@redhat.com>
References: <20190501140504.16435-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_bmapi_write() takes a total block requirement parameter that is
passed down to the block allocation code and is used to specify the
total block requirement of the associated transaction. This is used
to try and select an AG that can not only satisfy the requested
extent allocation, but can also accommodate subsequent allocations
that might be required to complete the transaction. For example,
additional bmbt block allocations may be required on insertion of
the resulting extent to an inode data fork.

While it's important for callers to calculate and reserve such extra
blocks in the transaction, it is not necessary to pass the total
value to xfs_bmapi_write() in all cases. The latter automatically
sets minleft to ensure that sufficient free blocks remain after the
allocation attempt to expand the format of the associated inode
(i.e., such as extent to btree conversion, btree splits, etc).
Therefore, any callers that pass a total block requirement of the
bmap mapping length plus worst case bmbt expansion essentially
specify the additional reservation requirement twice. These callers
can pass a total of zero to rely on the bmapi minleft policy.

Beyond being superfluous, the primary motivation for this change is
that the total reservation logic in the bmbt code is dubious in
scenarios where minlen < maxlen and a maxlen extent cannot be
allocated (which more common for data extent allocations where
contiguity is not required). The total value is based on maxlen in
the xfs_bmapi_write() caller. If the bmbt code falls back to an
allocation between minlen and maxlen, that allocation will not
succeed until total is reset to minlen, which essentially throws
away any additional reservation included in total by the caller. In
addition, the total value is not reset until after alignment is
dropped, which means that such callers drop alignment far too
aggressively than necessary.

Update all callers of xfs_bmapi_write() that pass a total block
value of the mapping length plus bmbt reservation to instead pass
zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
requirement. This trades off slightly less conservative AG selection
for the ability to preserve alignment in more scenarios.
xfs_bmapi_write() callers that incorporate unrelated or additional
reservations in total beyond what is already included in minleft
must continue to use the former.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 fs/xfs/xfs_bmap_util.c   | 4 ++--
 fs/xfs/xfs_dquot.c       | 4 ++--
 fs/xfs/xfs_iomap.c       | 4 ++--
 fs/xfs/xfs_reflink.c     | 4 ++--
 fs/xfs/xfs_rtalloc.c     | 3 +--
 6 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 184ce11d9aee..1d1b5600273f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4512,7 +4512,6 @@ xfs_bmapi_convert_delalloc(
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
 	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
-	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 	if (whichfork == XFS_COW_FORK)
 		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06d07f1e310b..83e23d33096f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -967,8 +967,8 @@ xfs_alloc_file_space(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-					allocatesize_fsb, alloc_type, resblks,
-					imapp, &nimaps);
+					allocatesize_fsb, alloc_type, 0, imapp,
+					&nimaps);
 		if (error)
 			goto error0;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a1af984e4913..c1928e3c58ba 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -309,8 +309,8 @@ xfs_dquot_disk_alloc(
 	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
-			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
-			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
+			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
+			&nmaps);
 	if (error)
 		return error;
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 63d323916bba..1ed7b8869c78 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -280,8 +280,8 @@ xfs_iomap_write_direct(
 	 * caller gave to us.
 	 */
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				bmapi_flags, resblks, imap, &nimaps);
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
+				imap, &nimaps);
 	if (error)
 		goto out_res_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 680ae7662a78..0c9cb3410554 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -421,8 +421,8 @@ xfs_reflink_allocate_cow(
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
-			resblks, imap, &nimaps);
+			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
+			&nimaps);
 	if (error)
 		goto out_unreserve;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ac0fcdad0c4e..4ed0ab1852e4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -798,8 +798,7 @@ xfs_growfs_rt_alloc(
 		 */
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
-					XFS_BMAPI_METADATA, resblks, &map,
-					&nmap);
+					XFS_BMAPI_METADATA, 0, &map, &nmap);
 		if (!error && nmap < 1)
 			error = -ENOSPC;
 		if (error)
-- 
2.17.2
