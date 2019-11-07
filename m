Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC649C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 955B9214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I5M31RId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfKGSZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RyiBerCAmZ9A0uL+WnKyPJPtxzcZOtw75Q0/mYyrCzY=; b=I5M31RIdP24p0youCKxT+4Jtq
        xihntmE9kjDPffdc8cz3VHLWIRxT5GHbbC1GgjAgm1GHNV88tzSciNBnKLp0uzWDw8M5IqJ5emcL1
        5V52HLj3S6BCt3ppJ8F/iDQE/bfOwkg5zz5moeJRl9POXRRKj90kqzqrgUDGHJB+LZzSHz6voGjbK
        U3lj28CWwKAbX43LKBxT8evURnhQLy28Lmo23RJF+wHfcSFtGJTYizoY3Bbryc9oF96dh/MbgddAG
        MW+07VkQ23Z5KWFps6l1DKUHZksrMibSVViQBfxW/ORjBmPH+9usSU+YdM2ZvvdRa2Au+66DRSTix
        RqopTgcSw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTH-0004Oi-Da
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/46] xfs: remove the ->data_unused_p method
Date:   Thu,  7 Nov 2019 19:23:52 +0100
Message-Id: <20191107182410.12660-29-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the two users of the ->data_unused_p dir ops method with a
direct calculation using ->data_entry_offset, and clean them up a bit.
xfs_dir2_sf_to_block already had an offset variable containing the
value of ->data_entry_offset, which we are now reusing to make it
clear that the initial freespace entry is at the same place that
we later fill in the 1 entry, and in xfs_dir3_data_init the function
is cleaned up a bit to keep the initialization of fields of a given
structure close to each other, and to avoid a local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 17 ---------------
 fs/xfs/libxfs/xfs_dir2.h       |  2 --
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c  | 40 +++++++++++++++-------------------
 4 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 711faff4aea2..347092ec28ab 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -130,13 +130,6 @@ xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
 }
 
-static struct xfs_dir2_data_unused *
-xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
 static struct xfs_dir2_data_entry *
 xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 {
@@ -144,13 +137,6 @@ xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
-static struct xfs_dir2_data_unused *
-xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
@@ -164,7 +150,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
 	.data_entry_p = xfs_dir2_data_entry_p,
-	.data_unused_p = xfs_dir2_data_unused_p,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -180,7 +165,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
 	.data_entry_p = xfs_dir2_data_entry_p,
-	.data_unused_p = xfs_dir2_data_unused_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
@@ -196,7 +180,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 
 	.data_entry_p = xfs_dir3_data_entry_p,
-	.data_unused_p = xfs_dir3_data_unused_p,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 8bfcf4c1b9c4..75aec05aae10 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -45,8 +45,6 @@ struct xfs_dir_ops {
 
 	struct xfs_dir2_data_entry *
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
-	struct xfs_dir2_data_unused *
-		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index e7719356829d..9061f378d52a 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1112,7 +1112,7 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = dp->d_ops->data_unused_p(hdr);
+	dup = bp->b_addr + offset;
 	needlog = needscan = 0;
 	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
 			i, &needlog, &needscan);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4c3153..3ecec8e1c5f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -631,24 +631,20 @@ xfs_dir2_data_freescan(
  */
 int						/* error */
 xfs_dir3_data_init(
-	xfs_da_args_t		*args,		/* directory operation args */
-	xfs_dir2_db_t		blkno,		/* logical dir block number */
-	struct xfs_buf		**bpp)		/* output block buffer */
+	struct xfs_da_args		*args,	/* directory operation args */
+	xfs_dir2_db_t			blkno,	/* logical dir block number */
+	struct xfs_buf			**bpp)	/* output block buffer */
 {
-	struct xfs_buf		*bp;		/* block buffer */
-	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
-	xfs_inode_t		*dp;		/* incore directory inode */
-	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
-	struct xfs_dir2_data_free *bf;
-	int			error;		/* error return value */
-	int			i;		/* bestfree index */
-	xfs_mount_t		*mp;		/* filesystem mount point */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	int                     t;              /* temp */
-
-	dp = args->dp;
-	mp = dp->i_mount;
-	tp = args->trans;
+	struct xfs_trans		*tp = args->trans;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_buf			*bp;
+	struct xfs_dir2_data_hdr	*hdr;
+	struct xfs_dir2_data_unused	*dup;
+	struct xfs_dir2_data_free 	*bf;
+	int				error;
+	int				i;
+
 	/*
 	 * Get the buffer set up for the block.
 	 */
@@ -677,6 +673,8 @@ xfs_dir3_data_init(
 
 	bf = dp->d_ops->data_bestfree_p(hdr);
 	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset);
+	bf[0].length =
+		cpu_to_be16(args->geo->blksize - dp->d_ops->data_entry_offset);
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
 		bf[i].length = 0;
 		bf[i].offset = 0;
@@ -685,13 +683,11 @@ xfs_dir3_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = dp->d_ops->data_unused_p(hdr);
+	dup = bp->b_addr + dp->d_ops->data_entry_offset;
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
-
-	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
-	bf[0].length = cpu_to_be16(t);
-	dup->length = cpu_to_be16(t);
+	dup->length = bf[0].length;
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
+
 	/*
 	 * Log it and return it.
 	 */
-- 
2.20.1

