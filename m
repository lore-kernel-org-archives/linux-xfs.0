Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33718C433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D687619F8
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCXBHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234223AbhCXBHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RDCUbE9ayuguhvHZLdqXgCCucvyzxuogayKdE4uOcvU=;
        b=J7a2BbSRi85+leazkmNY1Y0samrcwQDxVf34kO48lABWHkiyBHNMfpw5ih7R9tb80ZVwl/
        XhxYSuV6l4+m+S7hhYsO7/nRRHZI72p/CgczN4F3OnJoZHiBMPFsvbQLyEtJR/xamm1zJJ
        gjfucMstTg8RqcmnC9BnnGuGf3urcHc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-m8JwEcQBOmeb2C_HwHJiGQ-1; Tue, 23 Mar 2021 21:07:24 -0400
X-MC-Unique: m8JwEcQBOmeb2C_HwHJiGQ-1
Received: by mail-pg1-f197.google.com with SMTP id j4so537206pgs.18
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RDCUbE9ayuguhvHZLdqXgCCucvyzxuogayKdE4uOcvU=;
        b=Ett+JODqzyr+gy6Jm+BAz5/cLYyvQzPvNn3JvjAwonwonHVWj0n6harbHd8PyGlLNQ
         pQVvIyG4Of/Wv0SbUeGDm+PmoIdmo/5wYOFBKSsfR96BIlGT75Up58J+mRpubj2Jqufi
         d1/1PxjmceldU/0v74US3pa7qu+9Dl2+l7ntKJESLSCIwO4c14pPDKpw3boXoQOt3wXW
         oz8StyF8n448dE8JiMCK5HCTy+KAlfVVriqJvQ7RFooVbPwtfoaYvQAe9BsnNA9w/OOU
         StFZs0vuCF8IOFBQklyAahIc8C3AhfOUfMdFZ3Zlnfuxrx7e1PMIFHOmr7+SUNMhOhob
         kyBQ==
X-Gm-Message-State: AOAM531k1rvzgMpaUFBvopb5T52R5XcG08jKzDPF2HRlbYuAzXt2k7ij
        jIjI9p5wTwrvHPhO7SnHY1vnWanNhi97rdsr0sHF3YhxYPpTQsBQG/CFkzjWMYPIswkBcEB0X9l
        jPZl74EM1jMzJPopmfMoJAGIedO1oVXTZ/WtfvUZNrvW/GzrhjWnCa2bzehM+bZmr7w1EUKBxHw
        ==
X-Received: by 2002:a17:902:7444:b029:e4:30bf:8184 with SMTP id e4-20020a1709027444b02900e430bf8184mr976802plt.45.1616548042844;
        Tue, 23 Mar 2021 18:07:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGM8Gae0NGOz2nm+5XkKsZ/mlmlbd46KK/4ndvdelYIab5eCWcSRJm3lDCp01LG+BxTyaUtw==
X-Received: by 2002:a17:902:7444:b029:e4:30bf:8184 with SMTP id e4-20020a1709027444b02900e430bf8184mr976777plt.45.1616548042556;
        Tue, 23 Mar 2021 18:07:22 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:07:22 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 5/5] xfs: add error injection for per-AG resv failure
Date:   Wed, 24 Mar 2021 09:06:21 +0800
Message-Id: <20210324010621.2244671-6-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324010621.2244671-1-hsiangkao@redhat.com>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
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

