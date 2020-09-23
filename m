Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC19C4741F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D9E221E8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oA3Ic24L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgIWG7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgIWG7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:32 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59528C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u4so612522plr.4
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DoM58cBMly95vRrXSg4Nl9xCCYlU0fMPXEfNgDsWH5U=;
        b=oA3Ic24LC8T2+ARPoZRjerz6LqW+hmeUjP5ML4+MDKDVHOtLcX0XMpblWZnuvf7F5P
         ZX54dpluI7JjXkbxedrRoDXs6GXEdzlP0EGUV6SZie0ciH5EjXmSle3RrP8KjGNCSt2q
         01RmBwtrhN/olv1ONVPcf+TMOtqMxcIlny36PY/rErd9Z9D+TeofUtD+Cdcku8nKe/KE
         bEU/LHOSZGj0xRTKrqUhb2MInC20ZA+1FieQ5qKoti8Z5zlBVRWNDAHaKThFL2QbjLnz
         3+PywaF89fPh+NrrJs++3uLO3Mr8cvOzZv8PT8FPyhuUJfMDhssBRNFFTq9zVUTHk2c0
         EHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DoM58cBMly95vRrXSg4Nl9xCCYlU0fMPXEfNgDsWH5U=;
        b=S6KoXgVjBybd+otdht+pNPefFTeZ1oU3cJ6liEwhSCS+5W5dxO1fD8fDALyYpxAS4n
         dyJZiSa5Qp3O8rct4iPJYzzCZERWZy0v64BZ2VlJvWNrI05Wq6F5pjh41ioSIeidaGxe
         jsFkb8ZIJCZCvGbEEPbOkkXvVp8gViKQfFTbC8FVuDvY6+IjbaBbYGiQvXe9kBMiesd+
         h1JX4i5hHebEGbYjCvfshIAqKZuAxoA/8+AkzKWNDWOpPk935W/kBfQhIzh+iWm7wxQm
         5bR2akgUHYGEG8c6n1RlobkHjezY+8gQ+gaeYvvPvq7R1a4iTFd+24lpiGGLfvH2cXRx
         jpKg==
X-Gm-Message-State: AOAM530UvV9ibKbbRb5itcX7akd8blMnXXTnJGiF3cZ61yARZP2gHBgL
        WjFr4abQfIKfJQfpvCeepLICGPgymwvz
X-Google-Smtp-Source: ABdhPJzAnv+x/aNWUHjoQGOzRkuBahJDGK81B34zjrWvhOdlb1hud2c8cbVbceAKqkOYbhnHq7CqlA==
X-Received: by 2002:a17:90b:46c4:: with SMTP id jx4mr2262513pjb.190.1600844371620;
        Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 5/7] xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
Date:   Wed, 23 Sep 2020 14:59:16 +0800
Message-Id: <1600844358-16601-6-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We already check whether the crc feature is enabled before calling
xfs_attr3_rmt_verify(), so remove the redundant feature check in that
function.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3f80cede7406..48d8e9caf86f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -96,8 +96,6 @@ xfs_attr3_rmt_verify(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
 	if (!xfs_verify_magic(bp, rmt->rm_magic))
 		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
-- 
2.20.0

