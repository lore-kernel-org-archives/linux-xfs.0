Return-Path: <SRS0=Ae7g=DD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A48C4727E
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BEF3206FC
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cbROmBjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgIZNOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Sep 2020 09:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZNOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Sep 2020 09:14:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7625FC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e18so1054447pgd.4
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KxcKg3VySvM8efbu+IA8UFaZWWcbttZAkakShYT41Uc=;
        b=cbROmBjQij0cQ2HXFAdbz33Bb3Ox0FwXuivkZ9IrVthSgaR77VxCagNG1UDgmvi6Kb
         metdYwMsZXDgB+6i4NiQy+jp7xH4tV7vZcTrwhwuqxKPOOWOmkja4otwumZs1/Ui/HpR
         XNs/t/3LyFCFEArIxq+x1TQr6C5qJSrOWLz/Y3apqCu/OTQBB2x9O3Mi+C3oA7qVmEvo
         ZGDU1zzR9T+isOhPNYxojLIdDEm7Z9Htc4In8BbwJ6Z7ZIkORHwnxv+ByejxAJg3Eoqu
         LrhmhlOL2z/SiBn6wmZPWyTIsEZSern5BUhwtRM8xfl3yXUvonxBocm4ZSH2zEq0fdWl
         idPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KxcKg3VySvM8efbu+IA8UFaZWWcbttZAkakShYT41Uc=;
        b=flr79U/06juyUR3mTiliwq/Col7OGbVHBVqgex0FhPwCkqP2JNbq0vT+PrtflfxNKV
         4KwXQYmqt5noQF4OveOhT2rSQS/tyB45JfB7UAlcHt7eW2s3Tth1/QfgUtR8OrsePjRR
         SmJs6TdkHqNLrTF+73Mw9vK/M60WLi6pWPN2y/A8gGgF1zfIZZ7MNyBLFn1q3gstb27Y
         Z22Jz0ioAq67vA+zuGH5aLI+2iH25XiCC90exyYXl3Vt6Qh51lpiQUYGeGLj7Yb3xPqi
         PJkgCQ4O7RV/isuwDrXaBaUELR1t/qQE08tlZStYCO4FFhRckpYJmEQeEUXKet+VuSZq
         qM+A==
X-Gm-Message-State: AOAM533SDr4nsmpZiMXMmlkFuH8aWoxUW0eMbK4muqxuoTa01xwC+DLf
        /mLXUiiFi/vgGZJ43+xccIYwBpuCyQ==
X-Google-Smtp-Source: ABdhPJxlbaN/g2g28p062ehbQfjGPq81ILV7ou9R45MLzTgm60gNVm7v6mRSfxmJrT6bjmi8KNsQHg==
X-Received: by 2002:a62:b40c:0:b029:142:6a8f:c2f8 with SMTP id h12-20020a62b40c0000b02901426a8fc2f8mr3021494pfn.32.1601126082649;
        Sat, 26 Sep 2020 06:14:42 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h12sm5623846pfo.68.2020.09.26.06.14.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 06:14:42 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 3/4] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
Date:   Sat, 26 Sep 2020 21:14:32 +0800
Message-Id: <1601126073-32453-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
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
 fs/xfs/xfs_trans_dquot.c   | 20 ++------------------
 3 files changed, 3 insertions(+), 26 deletions(-)

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
index 49624973eecc..9108eed0ea45 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -941,7 +941,6 @@ xfs_dir_ialloc(
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1000,12 +999,9 @@ xfs_dir_ialloc(
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
@@ -1013,10 +1009,8 @@ xfs_dir_ialloc(
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
index fe45b0c3970c..0ebfd7930382 100644
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
@@ -143,9 +136,6 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
-	if (tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
@@ -273,8 +263,6 @@ xfs_trans_mod_dquot(
 
 	if (delta)
 		trace_xfs_trans_mod_dquot_after(qtrx);
-
-	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
 
 
@@ -351,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
 	int64_t			totalbdelta;
 	int64_t			totalrtbdelta;
 
-	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	ASSERT(tp->t_dqinfo);
@@ -493,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
 	struct xfs_dqtrx	*qtrx, *qa;
 	bool			locked;
 
-	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
@@ -698,7 +686,6 @@ xfs_trans_dqresv(
 	 * because we don't have the luxury of a transaction envelope then.
 	 */
 	if (tp) {
-		ASSERT(tp->t_dqinfo);
 		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 		if (nblks != 0)
 			xfs_trans_mod_dquot(tp, dqp,
@@ -752,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	if (tp && tp->t_dqinfo == NULL)
-		xfs_trans_alloc_dqinfo(tp);
-
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-- 
2.20.0

