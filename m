Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF076FC6197
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFE320869
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbfKHVGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:06:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbfKHVGV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:06:21 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7526583F3B
        for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2019 21:06:20 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id a15so4057012wrr.0
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 13:06:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGsHEMiasWZwreJpBU/lb5n3CyMLmuJH4ZP+BK4jN+I=;
        b=T54qjLD2D1uERvHjF5T0s62FYk5Pk9r6D3u8ZWwPyHJ/gc5/jf3K5eIcCA1aZ04HdI
         qoTVj0I0KnHnbPxj0Z7GP7DqwxF1LiInMs/DbOcqM/JrZ45r6pN05huMdLr5WmCtpMiK
         TWtDu4cMQ74psOa8yRA8nfRPFwivX/PlakbU3oe+OFKazr0j7rYYPfNkISwhZkm5rznb
         vqWl8jiRY/maSL7Aely74yAmvmT/GncTWwsoLbfFHWQjAxOHZwFPtaB1WUhFg8LYS/Fy
         VEYQ7Xw0Tz4KvN68GXjM4e4QcgfEnLe9zwE+Ja8VyOAfjFoB4iaIRN4stdJnzeNkFfQw
         qllQ==
X-Gm-Message-State: APjAAAXRBZ/Brkx6AJkr1qoMRGVNDJyK/ZueIv8u0gqItHxUIQrWcakh
        WfMKNrHZguv8DjA3aDN1e+I3LMF4JkyeOQqdVmtUqg1a/jDoGKwgLrndYfo+zSIhahOnAPrDiyo
        zEUN7E8PLQyOU5c2h/mSy
X-Received: by 2002:adf:ef91:: with SMTP id d17mr1230555wro.145.1573247178995;
        Fri, 08 Nov 2019 13:06:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQpM45SxXCtQzfUVx7UvkA1BZia5ZkmPOuX6I1Cx1VGdkyvjVnRuCw3q/nQuKKfiyhXBmIDA==
X-Received: by 2002:adf:ef91:: with SMTP id d17mr1230548wro.145.1573247178814;
        Fri, 08 Nov 2019 13:06:18 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id n23sm6489086wmc.18.2019.11.08.13.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:06:18 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 2/4] xfs: remove the xfs_quotainfo_t typedef
Date:   Fri,  8 Nov 2019 22:06:10 +0100
Message-Id: <20191108210612.423439-3-preichl@redhat.com>
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
 fs/xfs/xfs_qm.c          | 20 ++++++++++----------
 fs/xfs/xfs_qm.h          |  4 ++--
 fs/xfs/xfs_trans_dquot.c |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c11b3b1af8e9..92d8756b628e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -30,10 +30,10 @@
  * quota functionality, including maintaining the freelist and hash
  * tables of dquots.
  */
-STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
-STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
+STATIC int	xfs_qm_init_quotainos(struct xfs_mount *mp);
+STATIC int	xfs_qm_init_quotainfo(struct xfs_mount *mp);
 
-STATIC void	xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
+STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -540,9 +540,9 @@ xfs_qm_shrink_count(
 
 STATIC void
 xfs_qm_set_defquota(
-	xfs_mount_t	*mp,
-	uint		type,
-	xfs_quotainfo_t	*qinf)
+	struct xfs_mount	*mp,
+	uint			type,
+	struct xfs_quotainfo	*qinf)
 {
 	struct xfs_dquot	*dqp;
 	struct xfs_def_quota    *defq;
@@ -643,7 +643,7 @@ xfs_qm_init_quotainfo(
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
+	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
 
 	error = list_lru_init(&qinf->qi_lru);
 	if (error)
@@ -710,9 +710,9 @@ xfs_qm_init_quotainfo(
  */
 void
 xfs_qm_destroy_quotainfo(
-	xfs_mount_t	*mp)
+	struct xfs_mount     *mp)
 {
-	xfs_quotainfo_t *qi;
+	struct xfs_quotainfo *qi;
 
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
@@ -1568,7 +1568,7 @@ xfs_qm_init_quotainos(
 
 STATIC void
 xfs_qm_destroy_quotainos(
-	xfs_quotainfo_t	*qi)
+	struct xfs_quotainfo	*qi)
 {
 	if (qi->qi_uquotaip) {
 		xfs_irele(qi->qi_uquotaip);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index b41b75089548..185c9d89a5cd 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -54,7 +54,7 @@ struct xfs_def_quota {
  * Various quota information for individual filesystems.
  * The mount structure keeps a pointer to this.
  */
-typedef struct xfs_quotainfo {
+struct xfs_quotainfo {
 	struct radix_tree_root qi_uquota_tree;
 	struct radix_tree_root qi_gquota_tree;
 	struct radix_tree_root qi_pquota_tree;
@@ -77,7 +77,7 @@ typedef struct xfs_quotainfo {
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
 	struct shrinker  qi_shrinker;
-} xfs_quotainfo_t;
+};
 
 static inline struct radix_tree_root *
 xfs_dquot_tree(
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ceb25d1cfdb1..4789f7e11f53 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -585,7 +585,7 @@ xfs_trans_dqresv(
 	xfs_qwarncnt_t		warnlimit;
 	xfs_qcnt_t		total_count;
 	xfs_qcnt_t		*resbcountp;
-	xfs_quotainfo_t		*q = mp->m_quotainfo;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 
-- 
2.23.0

