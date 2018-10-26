Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42760 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbeJZJNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 05:13:05 -0400
Date: Thu, 25 Oct 2018 17:38:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] libxfs: add missing agfl free deferred op type
Message-ID: <20181026003810.GE28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

Soo... I tried to run xfs_repair in gdb on arekm's big filesystem, but
we forgot to port deferred agfl free defer ops type to xfsprogs so it
blew up earlier this afternoon.  This is a patch to add it in, but since
it takes a while to get far enough to start rebuilding directories, this
is basically an untested patch.

Which I'm sending out in case sandeen/dchinner are doing the same thing
I am. :P

--D

---
From: Darrick J. Wong <darrick.wong@oracle.com>

When we added a new defer op type for agfl block freeing to the kernel,
we forgot to add that type to the userspace side of things.  This will
cause spontaneous combustion in xfs_repair if we try to rebuild
directories.

Fixes: d5c1b462232 ("xfs: defer agfl block frees when dfops is available")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b7185c1a..82aa32a8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -118,11 +118,55 @@ static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+/*
+ * AGFL blocks are accounted differently in the reserve pools and are not
+ * inserted into the busy extent list.
+ */
+STATIC int
+xfs_agfl_free_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_extent_free_item	*free;
+	struct xfs_buf			*agbp;
+	int				error;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	ASSERT(free->xefi_blockcount == 1);
+	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (!error)
+		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
+					    &free->xefi_oinfo);
+	kmem_free(free);
+	return error;
+}
+
+/* sub-type with special handling for AGFL deferred frees */
+static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	.diff_items	= xfs_extent_free_diff_items,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.log_item	= xfs_extent_free_log_item,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_agfl_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+};
+
 /* Register the deferred op type. */
 void
 xfs_extent_free_init_defer_op(void)
 {
 	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
+	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
 }
 
 /* Reverse Mapping */
