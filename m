Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAF4C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2AAA64FDB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhCEC6F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:58:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhCEC6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RDCUbE9ayuguhvHZLdqXgCCucvyzxuogayKdE4uOcvU=;
        b=iBhRLLMdvu1HSZMDSsEPAkqjPRtxXkjCEOsIFGoCMR1QGMBpPgRbt3o4j6WWnG/mAirprS
        +u2ouhRE2Q8I6XdPshn+B0V8+C/LIV56puVwNw1+mCe2MV6JHEDXgoVxCbLux2YmoAYSq2
        MxbFMHthe7zXOAV524gAFDuk6dMwK5s=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Fssbe66gOAawIdsgpMLr6w-1; Thu, 04 Mar 2021 21:58:03 -0500
X-MC-Unique: Fssbe66gOAawIdsgpMLr6w-1
Received: by mail-pg1-f199.google.com with SMTP id x36so312485pgl.8
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RDCUbE9ayuguhvHZLdqXgCCucvyzxuogayKdE4uOcvU=;
        b=B5VrbES4hqLmjAAy0l/WkjR6zQPVQOcn8KXqqstIHYOjobvgNQqNaZzelU4dYEBJjH
         KP6ZeHPLsqgvC7fSDHuzoH314LoYrqn4hFAHHh1ZP0nhJzLTZoL5e8+RgTrJYyWfCs1b
         ykD2kka9pQG1k5bE3Q+ChZ36uQRZi6k4MTCeY4nccXHEJEIFdCVUV6M6XBfLccDBORnT
         Ey5be1owDgi0/fIQKyNHng1sznO0p/i+lR4fnMh/Jbo5yOjHujhbFwhKsi3oM1LTi4TQ
         Ly7AyxcuO9CKoSm2ntD3c6AJor8sY3Z5PeyyuyPtfydHOPUkRReB93pdFPaKmcfrW4l9
         kySg==
X-Gm-Message-State: AOAM530n4uteXBDuak9H1uNx2bx5bHyaY8cpfT+JXlrMMBFNmDgq/TZC
        xKbvjx5fUJdRVfFv8Zwz3nFNZdgAhYt/qjJKbSnKwKJCM2sykgNy1czInopUq/u5AywKqfobAZa
        lTJtqnlRuXlyBrrrfkAcLCebBlkLXhX2NJ8x7RRAK9TtmgFc/VTkMO+fsMYA5ZDGt+EqaTKIDnQ
        ==
X-Received: by 2002:a17:90a:4586:: with SMTP id v6mr6480714pjg.129.1614913082368;
        Thu, 04 Mar 2021 18:58:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwczvjOaRpMGMoasA1x7+UJ9mMCUyMQs5t3UCWwipz6s/fD9hB0BFXDDW5NTJVfXC1TXdwFgQ==
X-Received: by 2002:a17:90a:4586:: with SMTP id v6mr6480678pjg.129.1614913081967;
        Thu, 04 Mar 2021 18:58:01 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:58:01 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v8 5/5] xfs: add error injection for per-AG resv failure
Date:   Fri,  5 Mar 2021 10:57:03 +0800
Message-Id: <20210305025703.3069469-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305025703.3069469-1-hsiangkao@redhat.com>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
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
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

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
index 6ca9084b6934..a23a52e643ad 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -58,7 +58,8 @@
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
-#define XFS_ERRTAG_MAX					38
+#define XFS_ERRTAG_AG_RESV_FAIL				38
+#define XFS_ERRTAG_MAX					39
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -101,5 +102,6 @@
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
+#define XFS_RANDOM_AG_RESV_FAIL				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 185b4915b7bf..f70984f3174d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -56,6 +56,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BUF_IOERROR,
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
+	XFS_RANDOM_AG_RESV_FAIL,
 };
 
 struct xfs_errortag_attr {
@@ -168,6 +169,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
+XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -208,6 +210,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
+	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	NULL,
 };
 
-- 
2.27.0

