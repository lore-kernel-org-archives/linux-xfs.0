Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2991FC6197
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D08214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbfKGLgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:36:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLgA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:36:00 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B0C13689E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:35:59 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id f8so814365wrq.6
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:35:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlhTO4wFtcDQFyqSwdDlkMHddM58AKU42FPrJcQ9wnY=;
        b=gbBf7tJQjdopL+Nn7OqdOPAzIx6p82/TBa/ZZydw5Pfx8C8XmSG15kv338MP/Lz9J9
         JgH7SBDRozlOkRQ2l//Y81k6Lsl2gPQJBJPYB4ifwA4GfVPZNXBRlL4QKLziU1bf7TS+
         YHvYUKIcKsui8IER+qbQvRqrUkyo5QoRMkHnHvsLacWxrd9e73PxKZlSlid8pZ7bbwqP
         D9Kbc/3+qBRHXD6PmbmW5yYcIRWupAU5p2pogCuGcsPVJQ7miswP4vShMKXUn8yhHOIx
         PI9Z0JKU3glN0zRnryXTg69kC/iO6XTWQK3Sf5lm+gotHb54YsnEQdYSPa386cdO8feJ
         bnuw==
X-Gm-Message-State: APjAAAVkfWOhcOp/b0I5ABJ1W3OHUXLqw7P50HGMAZ8wJsVYh//Di8Ar
        GqJyqouOWhI7G77A2gHecxjzggbWhypXuGQAnCxRdBt8QWRjugZVCM72KwL7nJE2LtuhB6R4KUX
        HuwCUlguiEFUcQ1K8V366
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr2625746wmj.150.1573126557863;
        Thu, 07 Nov 2019 03:35:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkFFmPegySQSCyIpWVfT1LUOnTrbuWENuQNNCGRloy4hy2mF7KetqE3QH7bduHNkqVGIp+7w==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr2625727wmj.150.1573126557679;
        Thu, 07 Nov 2019 03:35:57 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:57 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 4/5] xfs: remove the xfs_dq_logitem_t typedef
Date:   Thu,  7 Nov 2019 12:35:48 +0100
Message-Id: <20191107113549.110129-5-preichl@redhat.com>
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
 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_dquot.h      | 4 ++--
 fs/xfs/xfs_dquot_item.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 04e38ed97f5f..209d5e4b5850 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
+	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 330ba888e74a..f1e7cc6a383f 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -39,8 +39,8 @@ struct xfs_dquot {
 	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
-	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t q_logitem;	/* dquot log item */
+	struct xfs_disk_dquot	 q_core;	/* actual usage & quotas */
+	struct xfs_dq_logitem	 q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 1aed34ccdabc..e0a24eb7a545 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -11,11 +11,11 @@ struct xfs_trans;
 struct xfs_mount;
 struct xfs_qoff_logitem;
 
-typedef struct xfs_dq_logitem {
+struct xfs_dq_logitem {
 	struct xfs_log_item	 qli_item;	   /* common portion */
 	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
 	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-} xfs_dq_logitem_t;
+};
 
 typedef struct xfs_qoff_logitem {
 	struct xfs_log_item	 qql_item;	/* common portion */
-- 
2.23.0

