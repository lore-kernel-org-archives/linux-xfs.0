Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D116C47095
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 068192168B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADAFFUDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgJHETT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgJHETT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:19:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4956BC061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 21:19:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so2906388pfc.7
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 21:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YiuD8JsU04ijWFVn2RyixcqZtin1Nao1OsnkXQIBYVE=;
        b=ADAFFUDepqmaSts5OMfynDxdQ2Wi3jmu7TCLzNzcD5gK4INVeYw48LF4UX9aIDjy5W
         FCIS0Eq9xcyh9DKSF0bMQ6VERsRhwccHKzcB2klb1UuIKZDPRWAJW2l4+yQBg7FxrM+y
         scwKn2Xm8RNqQ4ykz1pS//nC1Xporj098IlCY9HaCdgzobTq3UitSpeXdlymMfnhVe8o
         uDgJnoVozX0TH5z3oD7T8Voyrel1620VjqdX0FIEHRLWsNzMWgoypKB3ZpmK7kDAHrf1
         W8gkdukeeG07DQmG43X44jIvB+mpG4nNCcSrdIqPMfu6eqnRrNS2n6ZLd2XxfwiWTWEC
         V8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YiuD8JsU04ijWFVn2RyixcqZtin1Nao1OsnkXQIBYVE=;
        b=t3ca/PHroSZH+dJa9UtCvzKOvlfeBg+wcHrBiwk3e0Y7/G1JAI58YqYPXnRy+geue5
         gatkVQPuJrV5Y66nYNcG6Dbyo4ZyIfwj4J1x2kzAX9v7krC1LfWXd0DgnP4n6JAMAflX
         XsW5Ws1oD0YeDR8eCJQoh3pBAwl+4FfFHodniuIsbc9j6h6P/xGebVLrDhsDjnC0pg9A
         y+xcxjVvrx8kmphRoOu0Xb27rgOqiixc23ka6z1IkSzja1rvnzzFb3Su57+o4l+Y0/+b
         TDQ13onZ6ENzBHtYeIQXgo0goq+YyP+o29frW8GCNkxlZ47y1CW4kb5yauz+ZmmBGKU6
         D++w==
X-Gm-Message-State: AOAM533SC17Ltlz6qr8pQC+aRIBErDpENMGwfaPQyfkQrS1Mfumkn2iQ
        BCZXFhTieG58qy8+2gOUEBLEe9qAtUcy
X-Google-Smtp-Source: ABdhPJzQAmG5bSZ+bkxELJk88TpLpmG37N0IDuvtLQqix0ZSzRdSBOD8YalLJnWgsvjIbbb4I4mFyQ==
X-Received: by 2002:a63:ff01:: with SMTP id k1mr6011889pgi.141.1602130758450;
        Wed, 07 Oct 2020 21:19:18 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id q8sm5299970pff.18.2020.10.07.21.19.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 21:19:17 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v4 2/3] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
Date:   Thu,  8 Oct 2020 12:19:08 +0800
Message-Id: <1602130749-23093-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
is to say, we allocate the new tp->t_dqinfo only when the qtrx values
changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
flag is set, we only need to check if tp->t_dqinfo == NULL in
xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
whether lock all of the dquots and join them to the transaction.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +-------
 fs/xfs/xfs_trans_dquot.c   | 13 ++-----------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c795ae47b3c9..8c61a461bf7b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
 #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
 #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..4d2cebaa3637 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -959,7 +959,6 @@ xfs_dir_ialloc(
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1018,12 +1017,9 @@ xfs_dir_ialloc(
 		 * and attach it to the next transaction.
 		 */
 		dqinfo = NULL;
-		tflags = 0;
 		if (tp->t_dqinfo) {
 			dqinfo = (void *)tp->t_dqinfo;
 			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
 		code = xfs_trans_roll(&tp);
@@ -1031,10 +1027,8 @@ xfs_dir_ialloc(
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
 		 */
-		if (dqinfo) {
+		if (dqinfo)
 			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
 
 		if (code) {
 			xfs_buf_relse(ialloc_context);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 67f1e275b34d..0ebfd7930382 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
 
 	xfs_trans_alloc_dqinfo(ntp);
 
-	/*
-	 * Because the quota blk reservation is carried forward,
-	 * it is also necessary to carry forward the DQ_DIRTY flag.
-	 */
-	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
-		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
-
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
 		oqa = otp->t_dqinfo->dqs[j];
 		nqa = ntp->t_dqinfo->dqs[j];
@@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
 
 	if (delta)
 		trace_xfs_trans_mod_dquot_after(qtrx);
-
-	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
 
 
@@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
 	int64_t			totalbdelta;
 	int64_t			totalrtbdelta;
 
-	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	ASSERT(tp->t_dqinfo);
@@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
 	struct xfs_dqtrx	*qtrx, *qa;
 	bool			locked;
 
-	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
-- 
2.20.0

