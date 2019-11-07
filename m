Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83B0C5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7144F214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfKGLf7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387779AbfKGLf6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:35:58 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEE22368E4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:35:57 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m68so901372wme.7
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMrWGgF+NrMpVQT/r8dUBP90Qpu/5+EIQhG0YlfSB/Y=;
        b=BtdfDFe/SP/KOnSdmPtW7NHaHQEPScZKUs0XQLchi2LyfWrjCHXYIfz5dLoqkjiLcA
         pT4w/t7XN5cB4mOBEDnVpV0Lbi77u+NJs8PfIhhx5dtArKhILtefUBUsuieGYpd7IFUS
         ClpQIr4zV9hTxCqfgNQ0fjmPfS7rYYD84JlY2Ao8oQghf9QzXe5Qfy6UXTfTcvq063KU
         iBgucURk4WCzOJsDWj65wkvGaJ0PQtj6sd2r1uGbiDl82WrGtVxD8UEnIY0uDpkItH0L
         FHjZBY1XFpwt9HBUCS7F/WbdAYAtl4a5UtRw+Svxz36+1tyIOphjKqwcMErzCVGPxQ+c
         X15w==
X-Gm-Message-State: APjAAAVMkf1me7Nk+yPUOQ2R3mJ9IQi+sGiIU37IKCVo2GaQTOyWdyKy
        QfybraiQfMYIfTQynOGaZ1K+0Ap5zVj1fj3mtjhkgGp/GdaIbN+cJNI1KXFwYpxTHwrX9fAIk45
        NC7aMHAZrfGFnK2Q6xAPP
X-Received: by 2002:a7b:c408:: with SMTP id k8mr2543776wmi.67.1573126556157;
        Thu, 07 Nov 2019 03:35:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqw8Q7e7NSLrqp/eEm3VIej5USXQ6z6ZS6cvCPNXZEZAt05URdtnpfovlA2/E/N5+RhdiUmRJA==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr2543748wmi.67.1573126555849;
        Thu, 07 Nov 2019 03:35:55 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:55 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 2/5] xfs: remove the xfs_dquot_t typedef
Date:   Thu,  7 Nov 2019 12:35:46 +0100
Message-Id: <20191107113549.110129-3-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107113549.110129-1-preichl@redhat.com>
References: <20191107113549.110129-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/xfs_dquot.c       |  6 +++---
 fs/xfs/xfs_dquot.h       | 21 +++++++++++----------
 fs/xfs/xfs_qm.c          | 28 ++++++++++++++--------------
 fs/xfs/xfs_qm_bhv.c      |  2 +-
 fs/xfs/xfs_trans_dquot.c | 38 +++++++++++++++++++-------------------
 5 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index edf0e81b3a10..04e38ed97f5f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
 	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
-	xfs_dquot_t		*dqp = qip->qli_dquot;
+	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
 	/*
@@ -1188,8 +1188,8 @@ xfs_qm_dqflush(
  */
 void
 xfs_dqlock2(
-	xfs_dquot_t	*d1,
-	xfs_dquot_t	*d2)
+	struct xfs_dquot	*d1,
+	struct xfs_dquot	*d2)
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 7a580dd09a76..330ba888e74a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,7 +30,7 @@ enum {
 /*
  * The incore dquot structure
  */
-typedef struct xfs_dquot {
+struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
@@ -51,7 +51,7 @@ typedef struct xfs_dquot {
 	struct completion q_flush;	/* flush completion queue */
 	atomic_t	  q_pincount;	/* dquot pin count */
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
-} xfs_dquot_t;
+};
 
 /*
  * Lock hierarchy for q_qlock:
@@ -68,17 +68,17 @@ enum {
  * queue synchronizes processes attempting to flush the in-core dquot back to
  * disk.
  */
-static inline void xfs_dqflock(xfs_dquot_t *dqp)
+static inline void xfs_dqflock(struct xfs_dquot *dqp)
 {
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
 
-static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 {
 	complete(&dqp->q_flush);
 }
@@ -112,7 +112,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	}
 }
 
-static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
 	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
@@ -147,9 +147,10 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
-extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
+extern void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
+extern int		xfs_qm_dqflush(struct xfs_dquot *dqp,
+					struct xfs_buf **bpp);
+extern void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					struct xfs_disk_dquot *);
 extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
@@ -167,7 +168,7 @@ extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 					xfs_dqid_t id, uint type,
 					struct xfs_dquot **dqpp);
-extern void		xfs_qm_dqput(xfs_dquot_t *);
+extern void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ecd8ce152ab1..a8b278348f5a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -243,14 +243,14 @@ xfs_qm_unmount_quotas(
 
 STATIC int
 xfs_qm_dqattach_one(
-	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
-	bool		doalloc,
-	xfs_dquot_t	**IO_idqpp)
+	xfs_inode_t		*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	bool			doalloc,
+	struct xfs_dquot	**IO_idqpp)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
@@ -543,7 +543,7 @@ xfs_qm_set_defquota(
 	uint		type,
 	xfs_quotainfo_t	*qinf)
 {
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 	struct xfs_def_quota    *defq;
 	struct xfs_disk_dquot	*ddqp;
 	int			error;
@@ -1737,14 +1737,14 @@ xfs_qm_vop_dqalloc(
  * Actually transfer ownership, and do dquot modifications.
  * These were already reserved.
  */
-xfs_dquot_t *
+struct xfs_dquot *
 xfs_qm_vop_chown(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dquot_t	**IO_olddq,
-	xfs_dquot_t	*newdq)
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	struct xfs_dquot	**IO_olddq,
+	struct xfs_dquot	*newdq)
 {
-	xfs_dquot_t	*prevdq;
+	struct xfs_dquot	*prevdq;
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 5d72e88598b4..1830f52d5975 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -58,7 +58,7 @@ xfs_qm_statvfs(
 	struct kstatfs		*statp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 16457465833b..ceb25d1cfdb1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -25,8 +25,8 @@ STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
  */
 void
 xfs_trans_dqjoin(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	xfs_trans_t		*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(dqp->q_logitem.qli_dquot == dqp);
@@ -49,8 +49,8 @@ xfs_trans_dqjoin(
  */
 void
 xfs_trans_log_dquot(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	xfs_trans_t		*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -489,7 +489,7 @@ xfs_trans_unreserve_and_mod_dquots(
 	xfs_trans_t		*tp)
 {
 	int			i, j;
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
 	bool                    locked;
 
@@ -571,21 +571,21 @@ xfs_quota_warn(
  */
 STATIC int
 xfs_trans_dqresv(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*dqp,
-	int64_t		nblks,
-	long		ninos,
-	uint		flags)
+	xfs_trans_t		*tp,
+	xfs_mount_t		*mp,
+	struct xfs_dquot	*dqp,
+	int64_t			nblks,
+	long			ninos,
+	uint			flags)
 {
-	xfs_qcnt_t	hardlimit;
-	xfs_qcnt_t	softlimit;
-	time_t		timer;
-	xfs_qwarncnt_t	warns;
-	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	total_count;
-	xfs_qcnt_t	*resbcountp;
-	xfs_quotainfo_t	*q = mp->m_quotainfo;
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
+	time_t			timer;
+	xfs_qwarncnt_t		warns;
+	xfs_qwarncnt_t		warnlimit;
+	xfs_qcnt_t		total_count;
+	xfs_qcnt_t		*resbcountp;
+	xfs_quotainfo_t		*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 
-- 
2.23.0

