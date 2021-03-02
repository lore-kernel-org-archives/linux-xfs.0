Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B01CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C2164DE5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344166AbhCBGku (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:40:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347192AbhCBCyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7Z47e4dYU13+hS89bOI0ylg21RiN0vcx6FCQFX1Ooo=;
        b=if7a5F/ezPkbRrSzksBJnRFUavwKqi7/kSrXwtYhZm3J19nCsC3FAZiPaqJxaYok8pAS3b
        cQYfOvZahSEthXWlZios1+i0hAYcxz8CbTezIIiCYKzgM/SrtIrdd6Kr8kOgN+xX9Tbz5D
        P34xwh+MebqmUw1R12Loo69Tdau8pYo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-ZB59Ef9NPbuvmx3tAHATsQ-1; Mon, 01 Mar 2021 21:49:32 -0500
X-MC-Unique: ZB59Ef9NPbuvmx3tAHATsQ-1
Received: by mail-pf1-f200.google.com with SMTP id j125so3713888pfb.21
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7Z47e4dYU13+hS89bOI0ylg21RiN0vcx6FCQFX1Ooo=;
        b=ThEzuIPQxzriigxFM6caOg20koPVVaa2+zokijAog+oe3Fjb0WiHiHMA3rdIKvraKf
         wTIvJGuH4rS0B5Vu6JqhmzHrRk0yTi6oIiKc/0ebD2YU4gqJpzFugM+hwOuigeQiH3RD
         JTnFKjfT4qhjCXkbQfDwAmnP79vlk46/9oyUf3lYfMvg16Kjxzp9J5fKVMhBkCIbKio0
         8iRciE/C1RwmHCmR+XjRYIs3Oc7K1dEZPO0BlW/cUbBLV9d8SDJniwcRyHlchUwyLJoo
         KImfhbcuTevIrdK4JeeeWR2UPDSnoJNtMt82/QQR7hOw/m7H67n1cEvYbCfcYAJ/suJn
         0bgg==
X-Gm-Message-State: AOAM530ux31G4aBjfwt5Nn1c/khk4xhDZYJkvmLfjAHW2JkNaIgDMv/W
        m+7tivR66VU4q8IZFGXSWBO2lNJ1QV95tmjHn9ulIKpCIFwsBJmRmBt5RrNwfsylfUEXa2NqG4d
        jYRV390uJ4/uJuEHXYbZiFcQmVDr4XPx2oJ2wpC4Wq9eedU6pDKXknEKztpThZQJWZT3LJu/S5A
        ==
X-Received: by 2002:a17:903:31d1:b029:de:8361:739b with SMTP id v17-20020a17090331d1b02900de8361739bmr18356624ple.85.1614653370775;
        Mon, 01 Mar 2021 18:49:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyX783S1S2qJ65dwPPrKj6PwTbE+uAn3jhnxUFjbv39CNyWb50Eskme6QLJBNQjambP6LzW7A==
X-Received: by 2002:a17:903:31d1:b029:de:8361:739b with SMTP id v17-20020a17090331d1b02900de8361739bmr18356608ple.85.1614653370505;
        Mon, 01 Mar 2021 18:49:30 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:30 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7 5/5] xfs: add error injection for per-AG resv failure
Date:   Tue,  2 Mar 2021 10:48:16 +0800
Message-Id: <20210302024816.2525095-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-1-hsiangkao@redhat.com>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
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
 fs/xfs/libxfs/xfs_ag_resv.c  | 6 +++++-
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index fdfe6dc0d307..6c5f8d10589c 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -211,7 +211,11 @@ __xfs_ag_resv_init(
 		ASSERT(0);
 		return -EINVAL;
 	}
-	error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
+		error = -ENOSPC;
+	else
+		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
 	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6ca9084b6934..b433ef735217 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -40,6 +40,7 @@
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
+
 /*
  * DEBUG mode instrumentation to test and/or trigger delayed allocation
  * block killing in the event of failed writes. When enabled, all
@@ -58,7 +59,8 @@
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
-#define XFS_ERRTAG_MAX					38
+#define XFS_ERRTAG_AG_RESV_FAIL				38
+#define XFS_ERRTAG_MAX					39
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 185b4915b7bf..5192a7063d95 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -168,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
+XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -208,6 +209,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
+	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	NULL,
 };
 
-- 
2.27.0

