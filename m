Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58650C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 07:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280562145D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 07:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CvbAgG2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgGNH56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgGNH56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 03:57:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ADDC061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 00:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iFLVop7k6lGR9P9sb00ck0FKyGaqRL1GG34C2HV9cdc=; b=CvbAgG2rn/BrSqff2zIsj38DZs
        7Fc3bErNLimZKUc6ta1vzKNcge+ZdsBYAb4TAxlgvMwaN7nYzcaHQ2Jfsw28rLRmjhFXYYG4zM1b7
        t31Y7xNiTfTFyTwDr2WPXXSuBIWoVHxZDzPTbxxJmmieQbQTE1MWLMKg3y6JqHTmFOYBOdK5alVSF
        7FeqMIfmWbQQO08QUXkFLjEhDvUCQSx5KJjidRaJQ1dWNcmdn1oD4EMzXNMyq9qekHV4f6b8xYRxg
        TcOnljyE6tMj5WJUUFzabu7OCBy1oXkifsbMlAiF7OAesPmqyQeycJY9Y9w+fsHAt3Q7uLTnQ/ixI
        C56xJy1g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFp6-0006sN-Ns; Tue, 14 Jul 2020 07:57:56 +0000
Date:   Tue, 14 Jul 2020 08:57:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200714075756.GB19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469032038.2914673.4780928031076025099.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new type (xfs_dqtype_t) to represent the type of an incore
> dquot.  Break the type field out from the dq_flags field of the incore
> dquot.

I don't understand why we need separate in-core vs on-disk values for
the type.  Why not something like this on top of the whole series:


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 889e34b1a03335..ef9b8559ff6197 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -62,15 +62,14 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (ddq->d_type & ~XFS_DDQTYPE_ANY)
+	if (ddq->d_type & ~XFS_DQTYPE_ANY)
 		return __this_address;
-	ddq_type = ddq->d_type & XFS_DDQTYPE_REC_MASK;
-	if (type != XFS_DQTYPE_NONE &&
-	    ddq_type != xfs_dquot_type_to_disk(type))
+	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
+	if (type != XFS_DQTYPE_NONE && ddq_type != type)
 		return __this_address;
-	if (ddq_type != XFS_DDQTYPE_USER &&
-	    ddq_type != XFS_DDQTYPE_PROJ &&
-	    ddq_type != XFS_DDQTYPE_GROUP)
+	if (ddq_type != XFS_DQTYPE_USER &&
+	    ddq_type != XFS_DQTYPE_PROJ &&
+	    ddq_type != XFS_DQTYPE_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
@@ -129,7 +128,7 @@ xfs_dqblk_repair(
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	dqb->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
+	dqb->dd_diskdq.d_type = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index eed0c4d5baddbe..e4178c804abf06 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1150,16 +1150,25 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
-#define XFS_DDQTYPE_USER	0x01		/* user dquot record */
-#define XFS_DDQTYPE_PROJ	0x02		/* project dquot record */
-#define XFS_DDQTYPE_GROUP	0x04		/* group dquot record */
+#define XFS_DQTYPE_NONE		0
+#define XFS_DQTYPE_USER		0x01		/* user dquot record */
+#define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
+#define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+
+#define XFS_DQTYPE_STRINGS \
+	{ XFS_DQTYPE_NONE,	"NONE" }, \
+	{ XFS_DQTYPE_USER,	"USER" }, \
+	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
+	{ XFS_DQTYPE_GROUP,	"GROUP" }
 
 /* bitmask to determine if this is a user/group/project dquot */
-#define XFS_DDQTYPE_REC_MASK	(XFS_DDQTYPE_USER | \
-				 XFS_DDQTYPE_PROJ | \
-				 XFS_DDQTYPE_GROUP)
+#define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
+				 XFS_DQTYPE_PROJ | \
+				 XFS_DQTYPE_GROUP)
+
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
 
-#define XFS_DDQTYPE_ANY		(XFS_DDQTYPE_REC_MASK)
+typedef uint8_t		xfs_dqtype_t;
 
 /*
  * This is the main portion of the on-disk representation of quota
@@ -1170,7 +1179,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
-	__u8		d_type;		/* XFS_DDQTYPE_* */
+	xfs_dqtype_t	d_type;		/* XFS_DQTYPE_* */
 	__be32		d_id;		/* user,project,group id */
 	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
 	__be64		d_blk_softlimit;/* preferred limit on disk blks */
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 0650fa71fa2bcf..6edd249fdef4ea 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -18,36 +18,6 @@
 typedef uint64_t	xfs_qcnt_t;
 typedef uint16_t	xfs_qwarncnt_t;
 
-typedef uint8_t		xfs_dqtype_t;
-
-#define XFS_DQTYPE_NONE		(0)
-#define XFS_DQTYPE_USER		(1)
-#define XFS_DQTYPE_PROJ		(2)
-#define XFS_DQTYPE_GROUP	(3)
-
-#define XFS_DQTYPE_STRINGS \
-	{ XFS_DQTYPE_NONE,	"NONE?" }, \
-	{ XFS_DQTYPE_USER,	"USER" }, \
-	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
-	{ XFS_DQTYPE_GROUP,	"GROUP" }
-
-static inline __u8
-xfs_dquot_type_to_disk(
-	xfs_dqtype_t		type)
-{
-	switch (type) {
-	case XFS_DQTYPE_USER:
-		return XFS_DDQTYPE_USER;
-	case XFS_DQTYPE_GROUP:
-		return XFS_DDQTYPE_GROUP;
-	case XFS_DQTYPE_PROJ:
-		return XFS_DDQTYPE_PROJ;
-	default:
-		ASSERT(0);
-		return 0;
-	}
-}
-
 /*
  * flags for q_flags field in the dquot.
  */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index dd150f8bbf5a2a..c2f19d35e05dbd 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -548,11 +548,11 @@ xlog_recover_do_dquot_buffer(
 
 	type = 0;
 	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
-		type |= XFS_DDQTYPE_USER;
+		type |= XFS_DQTYPE_USER;
 	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
-		type |= XFS_DDQTYPE_PROJ;
+		type |= XFS_DQTYPE_PROJ;
 	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
-		type |= XFS_DDQTYPE_GROUP;
+		type |= XFS_DQTYPE_GROUP;
 	/*
 	 * This type of quotas was turned off, so ignore this buffer
 	 */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 14b0c62943d54e..0581cb930cd75e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -182,7 +182,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
-		d->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
+		d->dd_diskdq.d_type = type;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -481,13 +481,13 @@ xfs_dquot_from_disk(
 	struct xfs_buf		*bp)
 {
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
-	__u8			ddq_type = xfs_dquot_type_to_disk(dqp->q_type);
+	__u8			ddq_type = dqp->q_type;
 
 	/*
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_type & XFS_DDQTYPE_REC_MASK) != ddq_type ||
+	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != ddq_type ||
 	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
@@ -537,7 +537,7 @@ xfs_dquot_to_disk(
 {
 	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	ddqp->d_version = XFS_DQUOT_VERSION;
-	ddqp->d_type = xfs_dquot_type_to_disk(dqp->q_type);
+	ddqp->d_type = dqp->q_type;
 	ddqp->d_id = cpu_to_be32(dqp->q_id);
 	ddqp->d_pad0 = 0;
 	ddqp->d_pad = 0;
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 0955f183a02758..b5afb9fb8cd4fd 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;
@@ -185,11 +185,11 @@ xlog_recover_quotaoff_commit_pass1(
 	 * group/project quotaoff or both.
 	 */
 	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DDQTYPE_USER;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_USER;
 	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DDQTYPE_PROJ;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_PROJ;
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DDQTYPE_GROUP;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_GROUP;
 
 	return 0;
 }
