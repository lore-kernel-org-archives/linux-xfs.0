Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2EFC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C47F23128
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391194AbhAZNFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392492AbhAZM7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTmI/iJHg+iWRF7uhfiVy+in9fQkKOO9n6nRdiWg7Pk=;
        b=KBZZe7BClAe5Exrw3+vSQi8XFd6OGbBroJHSx29NVz9yPuD7F7Mxw3KcJQUV5pLJuOgOQ4
        ydjnAq/SiB1wGfZd9A14Nr4MM8T3V5eBuOgkzc7I/2+PsJ/X0lLp/jiKwBdubSNejHsDan
        Vg0P7vYse0/aLvOLwWX7rRwPDpk6/LI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-s81tXfhmNQu8abDwwPHQCg-1; Tue, 26 Jan 2021 07:57:35 -0500
X-MC-Unique: s81tXfhmNQu8abDwwPHQCg-1
Received: by mail-pf1-f200.google.com with SMTP id 143so5722900pfx.5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTmI/iJHg+iWRF7uhfiVy+in9fQkKOO9n6nRdiWg7Pk=;
        b=Wu/+r8GpgvEoq6OYuI+akk1OnbqGlcNOU5WLRnk6ZYsuDTPUXR/Lm1xkMAxChsLAUy
         I+LjJYF9BCMXUaaog9wX1Gst5ldqzjsll2hF6mo0zygfs+fGMj+PKAar+ACAjRxoSp1Y
         mLUwrjhvEjNuuD1rWoPaJ85iRQmhRfoqmfmSWRJNJzcU+/jVusyYetkZCXso/ZzpuQ7h
         /63TVdwv0DxgOED1eiFs++37l3CHotOsaKHQ6Tp0flspShIb7vRaHXVEhJZpGuCCgmhC
         XgpCMvNoOSqseKTU9oWy3Buhv6WS7a7TlIw03hWODiDPb4P85XYeUibcRL0Yb0817SzT
         6EOw==
X-Gm-Message-State: AOAM532pHpcZDsAFptd6Sa1B6tqdQVycfppjBLV7vZFIb09fy0xbQU10
        Ght+TVUqIVHqC3GvjrOk6zlNgfGpWrKwiVvF8WBZQ6JTqQVMEZGVvvtapW0U4sHNt8N6Zaqckxh
        y+DmM3BWS0ZIBSM4Kap9xS2rX1YawehU2S6pKRCfUdszBfCPn100SUmwc6b0wm/wcJWhv9mn0lw
        ==
X-Received: by 2002:a63:db03:: with SMTP id e3mr5541517pgg.225.1611665853906;
        Tue, 26 Jan 2021 04:57:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEFIGFLyOlTtDIGNiSHy3ps4wWI7VXYA0wsgmv7GJ7ojU0DGZl8PVbSmv0wUdN9l7YVb16Tg==
X-Received: by 2002:a63:db03:: with SMTP id e3mr5541492pgg.225.1611665853533;
        Tue, 26 Jan 2021 04:57:33 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:33 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v6 7/7] xfs: add error injection for per-AG resv failure when shrinkfs
Date:   Tue, 26 Jan 2021 20:56:21 +0800
Message-Id: <20210126125621.3846735-8-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

per-AG resv failure after fixing up freespace is hard to test in an
effective way, so directly add an error injection path to observe
such error handling path works as expected.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c       | 5 +++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c6e68e265269..5076913c153f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -23,6 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
 #include "xfs_error.h"
+#include "xfs_errortag.h"
 #include "xfs_bmap.h"
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
@@ -559,6 +560,10 @@ xfs_ag_shrink_space(
 	be32_add_cpu(&agf->agf_length, -len);
 
 	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
+		err2 = -ENOSPC;
+
 	if (err2) {
 		be32_add_cpu(&agi->agi_length, len);
 		be32_add_cpu(&agf->agf_length, len);
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6ca9084b6934..5fd71a930b68 100644
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
+#define XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL		38
+#define XFS_ERRTAG_MAX					39
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 185b4915b7bf..7bae34bfddd2 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -168,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
+XFS_ERRORTAG_ATTR_RW(shrinkfs_ag_resv_fail, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -208,6 +209,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
+	XFS_ERRORTAG_ATTR_LIST(shrinkfs_ag_resv_fail),
 	NULL,
 };
 
-- 
2.27.0

