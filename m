Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfGYRzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:55:54 -0400
Date: Thu, 25 Jul 2019 10:53:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: fix stack contents leakage in the v1 inumber ioctls
Message-ID: <20190725175346.GF1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Eric Sandeen <sandeen@redhat.com>

Explicitly initialize the onstack structures to zero so we don't leak
kernel memory into userspace when converting the in-core inumbers
structure to the v1 inogrp ioctl structure.  Add a comment about why we
have to use memset to ensure that the padding holes in the structures
are set to zero.

Fixes: 5f19c7fc6873351 ("xfs: introduce v5 inode group structure")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add comments, use memset this time
---
 fs/xfs/xfs_itable.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 30fe17d25518..39374c680c49 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -283,6 +283,7 @@ xfs_bulkstat_to_bstat(
 	struct xfs_bstat		*bs1,
 	const struct xfs_bulkstat	*bstat)
 {
+	/* memset is needed here because of padding holes in the structure. */
 	memset(bs1, 0, sizeof(struct xfs_bstat));
 	bs1->bs_ino = bstat->bs_ino;
 	bs1->bs_mode = bstat->bs_mode;
@@ -399,6 +400,8 @@ xfs_inumbers_to_inogrp(
 	struct xfs_inogrp		*ig1,
 	const struct xfs_inumbers	*ig)
 {
+	/* memset is needed here because of padding holes in the structure. */
+	memset(ig1, 0, sizeof(struct xfs_inogrp));
 	ig1->xi_startino = ig->xi_startino;
 	ig1->xi_alloccount = ig->xi_alloccount;
 	ig1->xi_allocmask = ig->xi_allocmask;
