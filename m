Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A30C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D42C60238
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhGZLFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhGZLFp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180FEC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:13 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ca5so135015pjb.5
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LtzGqbqNtf2wpW85/3/glrq9hlOpReMPhax778/j8KQ=;
        b=nXBXt8AbKV3HS2fxmCpFDm+QK4KwxvdnH0a6ldzgK8z6y+pFx8czQwoC2nsvGXqsKd
         5wkGySfYhEpLNcV6n+JHo2ai76pnVKHmgjA6a9T4yeyk1BDNRSUjfw2HEuG/lsjh64NU
         Lj+lkWlFz9zIogngCU8EJP12bDRfsGnKFTls8CuJnqRzSPDjnxzIBkhLbleckiASZxi9
         SukrdDPtv0mwX1K7NBHa4L1hRL0EHcfOAp8kWFXL11G6XRSNkiNg4woI2H+U34jWiMzL
         pf6cOWAVLPEZ3MW/sEbnVcPVyMbMQ3ZDif/wlwYEXDcE62Fy8BWnlRzRMr3X9n4BpCSE
         u3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LtzGqbqNtf2wpW85/3/glrq9hlOpReMPhax778/j8KQ=;
        b=LXf+BksVInutMtQCDLM/e04nPczMt5cKTVMpBucIADSYHM36MRmqX1GZROTfWrGaTt
         JZZeExlrSx1SEDctWO+h1WSVt/FI7XSUwrqGDhzRE08vmeIbMQ6I6DTx27YUHbMw1SS4
         ZC4GzcmtlojHTQlFdLpLVZN2edW38+LGITAFTnchF3lsPqGt1oiqVsXTNJGvbRlWEPsG
         ty/ndyPbM+e5KjBNRx8Y7mrOVMzoxI7NJji7XOR31kMM2ya0iwSK8K++gQclR8aIkUbl
         8GWK+gH/kx21V4H9p1x7xe6v1/Hf1mYRCOOmDOl+KDwYuAhPWtDxysbr1cjng8RmhfGs
         4h9w==
X-Gm-Message-State: AOAM530s822NtmkaHnMAYo/ytrnw6/zGVSy8buLlOmXn6kgO8dJc3eRc
        PTIJv5jgsZcsEvfJVppyxwuIHwDxWXU=
X-Google-Smtp-Source: ABdhPJxNG103/QEc3socKjgpeGOTKTWE6QW83QXC38b70mwPkCSJ2ouzOxsCEfW8s48WK30NCgwrsg==
X-Received: by 2002:aa7:8812:0:b029:32d:8252:fd0 with SMTP id c18-20020aa788120000b029032d82520fd0mr17900518pfo.48.1627299972531;
        Mon, 26 Jul 2021 04:46:12 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:12 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 12/12] xfs: Error tag to test if v5 bulkstat skips inodes with large extent count
Date:   Mon, 26 Jul 2021 17:15:41 +0530
Message-Id: <20210726114541.24898-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new error tag to allow user space tests to check if V5
bulkstat ioctl skips reporting inodes with large extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 fs/xfs/xfs_itable.c          | 9 ++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index f5fa2151e05d..b2c533153737 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_SWAPEXT_FINISH_ONE			39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS		40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_SWAPEXT_FINISH_ONE			1
+#define XFS_RANDOM_BULKSTAT_REDUCE_MAX_IEXTENTS		1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index e25b440cbfd3..e2a9446fb025 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_SWAPEXT_FINISH_ONE,
+	XFS_RANDOM_BULKSTAT_REDUCE_MAX_IEXTENTS,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(swapext_finish_one, XFS_RANDOM_SWAPEXT_FINISH_ONE);
+XFS_ERRORTAG_ATTR_RW(bulkstat_reduce_max_iextents, XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(swapext_finish_one),
+	XFS_ERRORTAG_ATTR_LIST(bulkstat_reduce_max_iextents),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8493870a0a87..1b252d1cda9d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -143,7 +144,13 @@ xfs_bulkstat_one_int(
 
 	nextents = xfs_ifork_nextents(&ip->i_df);
 	if (bc->breq->version != XFS_BULKSTAT_VERSION_V6) {
-		if (nextents > XFS_IFORK_EXTCNT_MAXS32) {
+		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			xfs_irele(ip);
 			error = -EINVAL;
-- 
2.30.2

