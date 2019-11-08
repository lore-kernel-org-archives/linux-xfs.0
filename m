Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553EFFC6199
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327A8206C3
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfKHVGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:06:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfKHVGW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:06:22 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E46B7368E7
        for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2019 21:06:21 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id i23so2999988wmb.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 13:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79CLGeGRq5tqCWKf7FfMLmKw0dTqjXIRIOabMuIaGa8=;
        b=tG4sGDqDJmvc3XF2FsfKdGXjSh2uyD/PIb8C6PfhuTB13BPRGAses6RZphnKU8v+JC
         Z09QLMB+kpRf61rUlB95OaFHzzV1HXtiSmusR3s4KcstoYgc2fcQ6zUeTqr1jY7nh9BE
         z+X/MV/JwITaU7AL/5rvM0x8UcAKYC8YQyHPL2OdSTdq/Rp9+d531+JqHLCCHB6/FB7S
         4vdWDjvOOn1WzSRB0n/oraleVM5JMrr+1HVbZ7R+ydZzlm53mxrLEpEM2jvKimB5VvL2
         O550TGx2YhPZK4lQc3BZQWg5jjODdgwu6e7yZFi0BtVIM7/PbZLixIIikErxCnUhKZKR
         yMvg==
X-Gm-Message-State: APjAAAXEaktYSQc6/Zlo0ymznNHVblItuXbaFbTk2pEq+73h4vT8TplD
        DU6E7Qbi1hwv8sGJUExauEWQMJdwP+YAm87RyiqhLNPB46aZRqJMzExGHM9GsBg4C4LeCBbpNV4
        6E78xuvoqkILBk5MOLHH8
X-Received: by 2002:a1c:6854:: with SMTP id d81mr10603599wmc.75.1573247180288;
        Fri, 08 Nov 2019 13:06:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwT5ot4ZjVZjZL+YhWNwgAisWwItzYXyL0JWvDetZdPuLdQM55RUq/ulkfv8lMyZQqmbdJFag==
X-Received: by 2002:a1c:6854:: with SMTP id d81mr10603585wmc.75.1573247180106;
        Fri, 08 Nov 2019 13:06:20 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id n23sm6489086wmc.18.2019.11.08.13.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:06:19 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 3/4] xfs: remove the xfs_dq_logitem_t typedef
Date:   Fri,  8 Nov 2019 22:06:11 +0100
Message-Id: <20191108210612.423439-4-preichl@redhat.com>
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
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot.h      | 18 +++++++++---------
 fs/xfs/xfs_dquot_item.h |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5b089afd7087..4df8ffb9906f 100644
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
index a6bb264d71ce..1defab19d550 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -39,15 +39,15 @@ struct xfs_dquot {
 	int		  q_bufoffset;	/* off of dq in buffer (# dquots) */
 	xfs_fileoff_t	  q_fileoffset;	/* offset in quotas file */
 
-	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t  q_logitem;	/* dquot log item */
-	xfs_qcnt_t	  q_res_bcount;	/* total regular nblks used+reserved */
-	xfs_qcnt_t	  q_res_icount;	/* total inos allocd+reserved */
-	xfs_qcnt_t	  q_res_rtbcount;/* total realtime blks used+reserved */
-	xfs_qcnt_t	  q_prealloc_lo_wmark;/* prealloc throttle wmark */
-	xfs_qcnt_t	  q_prealloc_hi_wmark;/* prealloc disabled wmark */
-	int64_t		  q_low_space[XFS_QLOWSP_MAX];
-	struct mutex	  q_qlock;	/* quota lock */
+	struct xfs_disk_dquot	 q_core;	/* actual usage & quotas */
+	struct xfs_dq_logitem	 q_logitem;	/* dquot log item */
+	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
+	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
+	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
+	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
+	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
+	int64_t		 q_low_space[XFS_QLOWSP_MAX];
+	struct mutex	 q_qlock;	/* quota lock */
 	struct completion q_flush;	/* flush completion queue */
 	atomic_t	  q_pincount;	/* dquot pin count */
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
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

