Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932390AbdIRJQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 42/78] xfs: set firstfsb to NULLFSBLOCK before feeding it to _bmapi_write
Date: Mon, 18 Sep 2017 11:11:51 +0200
Message-Id: <20170918091132.707444469@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4c1a67bd3606540b9b42caff34a1d5cd94b1cf65 upstream.

We must initialize the firstfsb parameter to _bmapi_write so that it
doesn't incorrectly treat stack garbage as a restriction on which AGs
it can search for free space.

Fixes-coverity-id: 1402025
Fixes-coverity-id: 1415167
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    9 +++++++++
 fs/xfs/xfs_reflink.c     |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6639,6 +6639,15 @@ xfs_bmap_finish_one(
 	bmap.br_blockcount = *blockcount;
 	bmap.br_state = state;
 
+	/*
+	 * firstfsb is tied to the transaction lifetime and is used to
+	 * ensure correct AG locking order and schedule work item
+	 * continuations.  XFS_BUI_MAX_FAST_EXTENTS (== 1) restricts us
+	 * to only making one bmap call per transaction, so it should
+	 * be safe to have it as a local variable here.
+	 */
+	firstfsb = NULLFSBLOCK;
+
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -333,7 +333,7 @@ xfs_reflink_convert_cow_extent(
 	struct xfs_defer_ops		*dfops)
 {
 	struct xfs_bmbt_irec		irec = *imap;
-	xfs_fsblock_t			first_block;
+	xfs_fsblock_t			first_block = NULLFSBLOCK;
 	int				nimaps = 1;
 
 	if (imap->br_state == XFS_EXT_NORM)


