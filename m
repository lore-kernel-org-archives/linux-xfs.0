Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B10C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F44920656
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hfwE56Cg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgGORnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgGORnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:43:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E422FC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y2Bwin2nWYDu+Moq33PLqmqbWqGs6jBymX7JOTiG9Sw=; b=hfwE56CgpyaJ7P/2e08Dpt42Jz
        O/26jLYDBFGytkXCAd0t0/DKJz1JZFRtP3GBr2K+T7JNn8ECI+GkQJEb6kc9Ldd++PScykWclrfTr
        xOCEKeM/wYRL4OsMQQPETq0PBX7PRajbInmu92p9c4xTnIO7qRiNAsAOuuR6lSCHuL/HHo8o9gBii
        4mQxU4nmvHGs++sYThKgeHNh4GItfx8vfFkCyxXGOkuh8e/Qym+OuHbuSLFxshcK6cIqOlNLGFh7E
        gth5cgW8QPVVQSUTeLOj5g5C6/ci3E2RyMJoIcbEu1sOircdhhzFvu9Cf1wuYIfWm8bj+blfcJelz
        fRJT63Gg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlRU-0003OD-B6; Wed, 15 Jul 2020 17:43:40 +0000
Date:   Wed, 15 Jul 2020 18:43:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200715174340.GB11239@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
 <20200714180502.GB7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714180502.GB7606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 11:05:02AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> > On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > > dquot.  Break the type field out from the dq_flags field of the incore
> > > dquot.
> > 
> > I don't understand why we need separate in-core vs on-disk values for
> > the type.  Why not something like this on top of the whole series:
> 
> I want to keep the ondisk d_type values separate from the incore q_type
> values because they don't describe exactly the same concepts:
> 
> First, the incore qtype has a NONE value that we can pass to the dquot
> core verifier when we don't actually know if this is a user, group, or
> project dquot.  This should never end up on disk.

Which we can trivially verify.  Or just get rid of NONE, which actually
cleans things up a fair bit (patch on top of my previous one below)

> Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
> callers to tell us that they want to perform an action on behalf of
> user, group, or project quotas.  The incore q_flags and the ondisk
> d_type contain internal state that should not be exposed to quota
> callers.

I don't think that is an argument, as we do the same elsewhere.

> 
> I feel a need to reiterate that I'm about to start adding more flags to
> d_type (for y2038+ time support), for which it will be very important to
> keep d_type and q_{type,flags} separate.

Why?  We'll just OR the bigtime flag in before writing to disk.


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index ef9b8559ff6197..c48b77c223073e 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -37,11 +37,8 @@ xfs_failaddr_t
 xfs_dquot_verify(
 	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*ddq,
-	xfs_dqid_t		id,
-	xfs_dqtype_t		type)	/* used only during quotacheck */
+	xfs_dqid_t		id)
 {
-	uint8_t			ddq_type;
-
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -64,13 +61,14 @@ xfs_dquot_verify(
 
 	if (ddq->d_type & ~XFS_DQTYPE_ANY)
 		return __this_address;
-	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
-	if (type != XFS_DQTYPE_NONE && ddq_type != type)
-		return __this_address;
-	if (ddq_type != XFS_DQTYPE_USER &&
-	    ddq_type != XFS_DQTYPE_PROJ &&
-	    ddq_type != XFS_DQTYPE_GROUP)
+	switch (ddq->d_type & XFS_DQTYPE_REC_MASK) {
+	case XFS_DQTYPE_USER:
+	case XFS_DQTYPE_PROJ:
+	case XFS_DQTYPE_GROUP:
+		break;
+	default:
 		return __this_address;
+	}
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
 		return __this_address;
@@ -100,14 +98,12 @@ xfs_failaddr_t
 xfs_dqblk_verify(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
-	xfs_dqid_t		id,
-	xfs_dqtype_t		type)	/* used only during quotacheck */
+	xfs_dqid_t		id)
 {
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
-
-	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id, type);
+	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id);
 }
 
 /*
@@ -210,7 +206,7 @@ xfs_dquot_buf_verify(
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, XFS_DQTYPE_NONE);
+		fa = xfs_dqblk_verify(mp, &dqb[i], id + i);
 		if (fa) {
 			if (!readahead)
 				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e4178c804abf06..ec472131ea4b15 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1150,13 +1150,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
-#define XFS_DQTYPE_NONE		0
 #define XFS_DQTYPE_USER		0x01		/* user dquot record */
 #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
 #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
 
 #define XFS_DQTYPE_STRINGS \
-	{ XFS_DQTYPE_NONE,	"NONE" }, \
 	{ XFS_DQTYPE_USER,	"USER" }, \
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
 	{ XFS_DQTYPE_GROUP,	"GROUP" }
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 6edd249fdef4ea..5e3d6b49981707 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -129,9 +129,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
-		struct xfs_disk_dquot *ddq, xfs_dqid_t id, xfs_dqtype_t type);
+		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
-		struct xfs_dqblk *dqb, xfs_dqid_t id, xfs_dqtype_t type);
+		struct xfs_dqblk *dqb, xfs_dqid_t id);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index f045895f28ffb1..a8eace16fdae74 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -31,7 +31,7 @@ xchk_quota_to_dqtype(
 		return XFS_DQTYPE_PROJ;
 	default:
 		ASSERT(0);
-		return XFS_DQTYPE_NONE;
+		return 0;
 	}
 }
 
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index c2f19d35e05dbd..e4f37c064497aa 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -494,8 +494,7 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
-					       -1, XFS_DQTYPE_NONE);
+			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
 			if (fa) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index b5afb9fb8cd4fd..2df6238ed19abc 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -108,7 +108,7 @@ xlog_recover_dquot_commit_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, XFS_DQTYPE_NONE);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 96171f4406e978..716b91b582ff56 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -828,7 +828,6 @@ xfs_qm_reset_dqcounts(
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
-	xfs_failaddr_t		fa;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -853,8 +852,8 @@ xfs_qm_reset_dqcounts(
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dqblk_verify(mp, &dqb[j], id + j, type);
-		if (fa)
+		if (xfs_dqblk_verify(mp, &dqb[j], id + j, type) ||
+		    dqb[j].d_type != type)
 			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*
