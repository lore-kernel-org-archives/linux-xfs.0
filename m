Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0760FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8727214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbfKHVGY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:06:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfKHVGY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:06:24 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B1DA7C0A7
        for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2019 21:06:23 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id e10so1580026wrt.16
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 13:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hWCiwtHk83UFg0ml07RMskaZekuFn5/b25vQeNA/TYQ=;
        b=EfTvnTNPSfQtXVe0eQCDjU1DHRM8d7YXIAXthgY938mbpkfIHSA6YRNjz9mkLufc+N
         yfFvjygOb3KBj1nQolta4DFiDvdgvombLUZWTs5ztXtzdnLbwJcZmwaMDT1vF6ogtV10
         Kh+DoMrZYnKbo1YLuNtHY+a74qceXPNXONnO3kh93w9AUdteRMzuHXIuhe4XsdAg2BF9
         FqCEafLxl8wrJqXzuMWWN1l+Dss+n8n2ukrwEfyFcTIBUs+17DQ/YHvsextd6+kYh5Ze
         Q/YHvUVBOim4gq5f2ubmf66PDLqt+8imSKnXP9F4naoiUOdhWTld7acTzL1LhFhNMPFc
         ngwQ==
X-Gm-Message-State: APjAAAVgFshmJrNi3Iu7zQgY2ZuPt1q9W4KbFODxKodXNQceTrRmEJCN
        yfnkB2pGHyObgg6BknRdbnWkrgR8jnWbu4tbQyd8fKzUTah55FYEme4NmDccWpPoB4GLk1pGXEO
        Fl39IsfhJB2YpvaKOzdUr
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr10362045wmj.125.1573247181799;
        Fri, 08 Nov 2019 13:06:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyakcLBAtf7A9t1zv/WkJzjAXoXtlDchAy2LQbAb5+aJSyFi7WvLRJ2Df+FUH6Z4t1tNz50SQ==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr10362024wmj.125.1573247181544;
        Fri, 08 Nov 2019 13:06:21 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id n23sm6489086wmc.18.2019.11.08.13.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:06:21 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 4/4] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Fri,  8 Nov 2019 22:06:12 +0100
Message-Id: <20191108210612.423439-5-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108210612.423439-1-preichl@redhat.com>
References: <20191108210612.423439-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_dquot_item.h        | 14 ++++++++------
 fs/xfs/xfs_qm_syscalls.c       | 35 ++++++++++++++++++----------------
 fs/xfs/xfs_trans_dquot.c       | 14 +++++++-------
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 271cca13565b..eb7fe42b1d61 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -741,7 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
 
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    sizeof(struct xfs_qoff_logitem) * 2
  *    the superblock for the quota flags: sector size
  */
 STATIC uint
@@ -754,7 +754,7 @@ xfs_calc_qm_quotaoff_reservation(
 
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index e0a24eb7a545..e2348a99fa1a 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -17,18 +17,20 @@ struct xfs_dq_logitem {
 	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
 };
 
-typedef struct xfs_qoff_logitem {
+struct xfs_qoff_logitem {
 	struct xfs_log_item	 qql_item;	/* common portion */
 	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
 	unsigned int		qql_flags;
-} xfs_qoff_logitem_t;
+};
 
 
 extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
-extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
-					struct xfs_qoff_logitem *, uint);
-extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *, uint);
+extern struct xfs_qoff_logitem *xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+					struct xfs_qoff_logitem *start,
+					uint flags);
+extern struct xfs_qoff_logitem *xfs_trans_get_qoff_item(struct xfs_trans *tp,
+					struct xfs_qoff_logitem *startqoff,
+					uint flags);
 extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
 					struct xfs_qoff_logitem *);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..52909cb00249 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,12 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
+			       struct xfs_qoff_logitem **qoffstartp,
+			       uint flags);
+STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
+				   struct xfs_qoff_logitem *startqoff,
+				   uint flags);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
-	uint			flags)
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	uint			 flags)
 {
-	xfs_trans_t		*tp;
-	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_trans	*tp;
+	int			 error;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	 *mp,
+	struct xfs_qoff_logitem **qoffstartp,
+	uint			  flags)
 {
-	xfs_trans_t	       *tp;
-	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_trans	 *tp;
+	int			  error;
+	struct xfs_qoff_logitem	 *qoffi;
 
 	*qoffstartp = NULL;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4789f7e11f53..0c4638c74f44 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*startqoff,
-	uint			flags)
+	struct xfs_trans		*tp,
+	struct xfs_qoff_logitem	*startqoff,
+	uint			 flags)
 {
-	xfs_qoff_logitem_t	*q;
+	struct xfs_qoff_logitem	*q;
 
 	ASSERT(tp != NULL);
 
@@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
  */
 void
 xfs_trans_log_quotaoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*qlp)
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*qlp)
 {
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
-- 
2.23.0

