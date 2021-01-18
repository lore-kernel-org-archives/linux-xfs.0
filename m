Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9094EC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5508E206F8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbhARIjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:39:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387863AbhARIjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+4ebVbzIC2903900vS2HKtvzDcl5o1uQkx3GT9HNAQ=;
        b=i7zgPOMru6zUAuciQmYumoX5SBgWOypDLWpFTm+Hp1P4AUjUuMs0j3156PZ5CY0m5gO+NU
        /AA+DLeTHIMPQ5zmShG4Lru7yIgM88+Ghm9lZiQmR6JczRJwkVSAPkgGESrSrYZTfmfSek
        CE8QMwiB2XFF/1JBiE4S/mPYWLeeEAo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-zJH998UqPSqBU2c5mZMayQ-1; Mon, 18 Jan 2021 03:38:11 -0500
X-MC-Unique: zJH998UqPSqBU2c5mZMayQ-1
Received: by mail-pg1-f199.google.com with SMTP id y2so12750996pgq.23
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:38:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+4ebVbzIC2903900vS2HKtvzDcl5o1uQkx3GT9HNAQ=;
        b=E2lET8XbAOyundH7yMxgyFhvTSsz73jO3cDNN/+t/NFSEoW/K3eB2YaTNdV/pFCiDv
         0/SH4muKHkItAmIXLcK4AGV0D8e6nRkru95Cpi8C+SQRQaU9uhS+ojMQDX5Jxe09NHiE
         ZvV0HU9nvdjQJWOA7RfvTozYUF6um7r1TOKx/PWp07XsbQlkMIi3lIyRAa/9w2AOSj+6
         Y+ajD3WEvzespqL8Jb6VwIPZhlqc/TNpIqs9VUZ3ITcCfFy+mgAAP/fsWkqmQgJk4pVg
         hVzczHFEGL396qyQRSfTzvD22cPi/0JwoRH+kWyHwGr7UGTBFyX5YVVf2p1cc1rgjdyb
         BekA==
X-Gm-Message-State: AOAM530dzcb0Xl6SSLRfwXBAZGH+R+HfopCdDYeuYqdrI8KBEZ/sCYVT
        hbLdZU0HKt4sMEKoRvv44uZvMoIrattQgnWUosfYw95oNVE66itD+OXQcIs2ektumGz1mcXzILZ
        dIvOizRlZyjDVVZ3lDPRpiL07g5E+vQEOB3fiV/EonWjp6puS5+vdp7dGs4TCXWRsU8w1cSNyNg
        ==
X-Received: by 2002:aa7:83c2:0:b029:1a5:daa9:f22f with SMTP id j2-20020aa783c20000b02901a5daa9f22fmr24666336pfn.48.1610959089846;
        Mon, 18 Jan 2021 00:38:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynbiHAjClSsa2FlQp1L/DAhNhJZyZUWSTTlKoyUg7WdYsJM7VUygLGW7dOWvgUb0txfeTQoQ==
X-Received: by 2002:aa7:83c2:0:b029:1a5:daa9:f22f with SMTP id j2-20020aa783c20000b02901a5daa9f22fmr24666296pfn.48.1610959089420;
        Mon, 18 Jan 2021 00:38:09 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:38:09 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 5/5] xfs: add error injection for per-AG resv failure when shrinkfs
Date:   Mon, 18 Jan 2021 16:37:00 +0800
Message-Id: <20210118083700.2384277-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210118083700.2384277-1-hsiangkao@redhat.com>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

per-AG resv failure after fixing up freespace is hard to test in an
effective way, so directly add an error injection path to observe
such error handling path works as expected.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c       | 5 +++++
 fs/xfs/libxfs/xfs_errortag.h | 2 ++
 fs/xfs/xfs_error.c           | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 04a7c9b20470..65e8e07f179b 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -23,6 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
 #include "xfs_error.h"
+#include "xfs_errortag.h"
 #include "xfs_bmap.h"
 
 static int
@@ -552,6 +553,10 @@ xfs_ag_shrink_space(
 	be32_add_cpu(&agf->agf_length, -len);
 
 	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
+		err2 = -ENOSPC;
+
 	if (err2) {
 		be32_add_cpu(&agi->agi_length, len);
 		be32_add_cpu(&agf->agf_length, len);
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 53b305dea381..89da08a451cf 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -40,6 +40,8 @@
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
+#define XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL		28
+
 /*
  * DEBUG mode instrumentation to test and/or trigger delayed allocation
  * block killing in the event of failed writes. When enabled, all
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..c864451ba7d0 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -164,6 +164,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
+XFS_ERRORTAG_ATTR_RW(shrinkfs_ag_resv_fail, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -202,6 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
+	XFS_ERRORTAG_ATTR_LIST(shrinkfs_ag_resv_fail),
 	NULL,
 };
 
-- 
2.27.0

