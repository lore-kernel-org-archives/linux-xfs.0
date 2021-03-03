Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4392EC28CC5
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15CDA61477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351092AbhCCDQY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232923AbhCCAIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 19:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614729991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVzH1CR+X3uXyOGfkKyHmF++KDWON3pWY4FjDoen3Qo=;
        b=bNJ8Wu4/SqdxdHceAbvrp2dcFrIcUQYhi/VJ+/GZbiXNOVMA8+1NQnQDdWVYSlYEBw/hOB
        CXxakDxfzKHt4JXJm0lOkBrk3m1kfFcGvS5k1OLshvzhgW3CvAbrSrZ4muTrvcaiJ0o+Fq
        kcjkm2REjAbQgXTAA+5+jj/QGn+WQCc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-SsohlIwmM-WEeLerk7Y-Yw-1; Tue, 02 Mar 2021 19:02:37 -0500
X-MC-Unique: SsohlIwmM-WEeLerk7Y-Yw-1
Received: by mail-pj1-f70.google.com with SMTP id ga13so3289885pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Mar 2021 16:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RVzH1CR+X3uXyOGfkKyHmF++KDWON3pWY4FjDoen3Qo=;
        b=J5xQSaX5SijNf/e3csSIznNnfL8W0dUaCyutZuVwISqUhyhh5wv6xfIJtAU9ULiu54
         qRtFv9H69jtTkrcgY1fDH57QL0TaRUDX7WnbBWaT9OiID+FQNNp3zfOQ/lDgIzc4z6Kc
         u1qFbCc9h3IEcft8DwaUi2U55qHV/eA/ySKedSvJgDtBSi10HwisZOe6SUeHdEVGmcuM
         iPB5bHfRfHBI/ZlJahVLOY3Lmv5Yl+7dmhhfNKiniWocQrkePOzgOWJwrah1Rt0umeRF
         JVr4y84hVz1t9+eShui04pYSqBi6tKW3sD3p669n793ceFZHHNTgHcxG4NPrP5fj/yx3
         x8mg==
X-Gm-Message-State: AOAM5331nSG1D4xIZyb9ptWRr8mjRZCKZ0CQKm8TJ6TUdHT5gC+8xy5Z
        ZVLEn7ScJrZ4PoFqZCxyXHNzfT9xS6XqgBLSGSKHkkIloufYLcyE5GakOclCuYTSjQQ0PcBIheX
        Z9FHowNANh9Mx793kKBvkiqB91K1BH0ztUVoIXzdmcWolW1ruRov7H139BBOfuGiap95ecwofsw
        ==
X-Received: by 2002:a17:90a:c84:: with SMTP id v4mr6973062pja.228.1614729756093;
        Tue, 02 Mar 2021 16:02:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgXBMZbTST2qEDa7/USMrxGMVjzOXS9mImWs7RoVIQIK0dxXsgbcqiBKGvFPW4HoHaLNj/rQ==
X-Received: by 2002:a17:90a:c84:: with SMTP id v4mr6973030pja.228.1614729755792;
        Tue, 02 Mar 2021 16:02:35 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3sm20601723pgm.67.2021.03.02.16.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 16:02:35 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7.1 5/5] xfs: add error injection for per-AG resv failure
Date:   Wed,  3 Mar 2021 08:02:02 +0800
Message-Id: <20210303000202.2671220-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-6-hsiangkao@redhat.com>
References: <20210302024816.2525095-6-hsiangkao@redhat.com>
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
changes since v7:
 - add missing random errortag reported by 0day CI and smatch.

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

