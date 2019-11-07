Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FF9C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DCBD21882
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfKGLgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:36:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLgB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:36:01 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61C647C0B8
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:36:00 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id p6so816718wrs.5
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:36:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3GfrHT7TlOokGQMvFguJthOVEzd5yMULv9DjNxlPPSI=;
        b=riR0Lve8QJgkZZpk3PY5q2MuJyt+zlSuPmtfAk3QR7l76zpfOLAhY6xvE+Q5bFFLPz
         GWHqIs2yduqRgPG56Hqk76fzsptTqAHajOHrpxE1A4PKZzYYF6wKH3kfGAEgud8Qxm0O
         CEZ8A+8+9o26mr+qiQkr0MGa3nuWatgF8RE2PtPGMf+U+WeVUNhSjU9X+YV+oq6zUzoY
         KsYs9al1Q1np4k8FPW4i69WQKtnyWdD5yHUyv1WPavA+ih8LKC5DH6j9ZXTspY9rboHD
         ZTtv/RarjnMWlO2xV/1SIHSPDyuvBlnfRSvWNvoIftHW2ILMK04NCPUAbc/90IIsWwwV
         25OA==
X-Gm-Message-State: APjAAAUNGYKojrc/fbVeD1FvYk3n/ocOYKPWLHuSpUU164un3XxZcgXa
        U5OIB4wOUNk9rUyu5StuLkGhzSm+7JjrGS1Gw0qSIIbyP+IZzJ4Pokgrk3h4ciDRPzpCNCxAy/a
        twsDJ8jZeZtwIZw24uRJM
X-Received: by 2002:a1c:7d95:: with SMTP id y143mr2514416wmc.143.1573126558866;
        Thu, 07 Nov 2019 03:35:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqx16+7aUVtYCYfy4xze+4xKHwYphedMHXr3RDM6MUgAvifEYB850ivSiIhDvfFHRp9vVs8zIg==
X-Received: by 2002:a1c:7d95:: with SMTP id y143mr2514399wmc.143.1573126558654;
        Thu, 07 Nov 2019 03:35:58 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:58 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 5/5] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Thu,  7 Nov 2019 12:35:49 +0100
Message-Id: <20191107113549.110129-6-preichl@redhat.com>
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
 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_dquot_item.h        | 14 ++++++++------
 fs/xfs/xfs_qm_syscalls.c       | 20 ++++++++++----------
 fs/xfs/xfs_trans_dquot.c       |  8 ++++----
 4 files changed, 24 insertions(+), 22 deletions(-)

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
index da7ad0383037..72b476e80ab2 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,9 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int xfs_qm_log_quotaoff(xfs_mount_t *, struct xfs_qoff_logitem **, uint);
+STATIC int xfs_qm_log_quotaoff_end(xfs_mount_t *, struct xfs_qoff_logitem *,
+				   uint);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +40,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -541,12 +541,12 @@ xfs_qm_scall_setqlim(
 STATIC int
 xfs_qm_log_quotaoff_end(
 	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
 	xfs_trans_t		*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -569,12 +569,12 @@ xfs_qm_log_quotaoff_end(
 STATIC int
 xfs_qm_log_quotaoff(
 	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
+	struct xfs_qoff_logitem **qoffstartp,
 	uint		       flags)
 {
-	xfs_trans_t	       *tp;
-	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	xfs_trans_t			*tp;
+	int				error;
+	struct xfs_qoff_logitem		*qoffi;
 
 	*qoffstartp = NULL;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4789f7e11f53..8b6f328f83d5 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
 	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_qoff_logitem_t	*q;
+	struct xfs_qoff_logitem	*q;
 
 	ASSERT(tp != NULL);
 
@@ -853,7 +853,7 @@ xfs_trans_get_qoff_item(
 void
 xfs_trans_log_quotaoff_item(
 	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*qlp)
+	struct xfs_qoff_logitem	*qlp)
 {
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
-- 
2.23.0

