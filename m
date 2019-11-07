Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E388AFA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE7EA21882
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbfKGLf7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLf7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:35:59 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5394037F73
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:35:58 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id h7so548898wrb.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:35:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMrfjalxiqkp1kash2pQ4+SMoMBoia6R7Bf7sfGudqI=;
        b=A91zJs3+X3A70hUSTFnFx+mG9aPxUn+SLSFLn/ngHd6bYGOdGHOzG9tzkAqibNeU9J
         rX4koVTyqh7vhPDoC1MxTu55aM+VTXSTsORs6MIeGczUHEt6BOGS13WyeOSTvDmNmTiu
         gPiYhg6YgLvEeEpm0GfiSzyjWg/6oppYfllOORLcrcbxuXPK2jg70ISTWhodzECZ0XLW
         xcUNB0dAVZqKl1ll8uzfMNGLxg45QhGiXMHpOgNRxVQKb3UdJImKD835DcLIku5nh8+k
         1qLdfCWVKRXnV3hcpjiRdDla+huKbEV0H4yP6qv2s9z2pVM1B0hV6S610fOD4HfhCUo6
         6DXA==
X-Gm-Message-State: APjAAAVXjFCN04xg2FpB331lhqYpxQNLRctG7nv1R2qyhphiCemin2QZ
        KZxx1fCvUvkAdv3+c6YJxoB44ZIvGCPERikHmpvcBNIDbXhKaXzCQEiFc8fFNxvDfzgYsHWqgMW
        6nHRfyZntDoIGQbq90er1
X-Received: by 2002:a1c:a751:: with SMTP id q78mr2546245wme.129.1573126556870;
        Thu, 07 Nov 2019 03:35:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwpub+0ePgzfoGf430K/jLCBPp6QSQ4UkJpp3k/uX7V/Fn6w6oWFkkf2WHJkUUztuurgOv6gA==
X-Received: by 2002:a1c:a751:: with SMTP id q78mr2546222wme.129.1573126556680;
        Thu, 07 Nov 2019 03:35:56 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:56 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 3/5] xfs: remove the xfs_quotainfo_t typedef
Date:   Thu,  7 Nov 2019 12:35:47 +0100
Message-Id: <20191107113549.110129-4-preichl@redhat.com>
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
 fs/xfs/xfs_qm.c          | 14 +++++++-------
 fs/xfs/xfs_qm.h          |  4 ++--
 fs/xfs/xfs_trans_dquot.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a8b278348f5a..4088273adb11 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -32,7 +32,7 @@
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 
-STATIC void	xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
+STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -539,9 +539,9 @@ xfs_qm_shrink_count(
 
 STATIC void
 xfs_qm_set_defquota(
-	xfs_mount_t	*mp,
-	uint		type,
-	xfs_quotainfo_t	*qinf)
+	xfs_mount_t		*mp,
+	uint			type,
+	struct xfs_quotainfo	*qinf)
 {
 	struct xfs_dquot	*dqp;
 	struct xfs_def_quota    *defq;
@@ -642,7 +642,7 @@ xfs_qm_init_quotainfo(
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
+	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
 
 	error = list_lru_init(&qinf->qi_lru);
 	if (error)
@@ -711,7 +711,7 @@ void
 xfs_qm_destroy_quotainfo(
 	xfs_mount_t	*mp)
 {
-	xfs_quotainfo_t *qi;
+	struct xfs_quotainfo *qi;
 
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
@@ -1559,7 +1559,7 @@ xfs_qm_init_quotainos(
 
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

