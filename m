Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1842EC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB35221D7D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sY2/6I85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgIPU63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIPQdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 12:33:14 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3322CC061BD1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id jw11so1379076pjb.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cDkNG7qGEFEdGfIX86bLfEQSrd/OICaC75I6vXNRaN8=;
        b=sY2/6I85jaAKkWq7JtlRlnmjvgOI+XDC8Kz6OZrzFzIjqC5i2a1MRs2QlV4u0SdkbE
         0RGYYStNmxQpqbm7sMSVZn+Qx0eOC6m1TsuYci2HVTQdQTppSrlFRQJzhl6oOUtp9GFL
         YJw5mUmU68yhnDflCewrKWHkKkjprJViN6TFIrPFdEkWWMXmzEozR8IpcZKJJnfUHV+6
         ua8zFUjQzwXuSF4hFVAjr1L0rUhJInT/D0fqCNAlAD2QO41lgzOxuLzVnZNqFz+LZOhX
         a7MPpadubfBoQ5a+zVR8Q/gjudWNry0UKNOO7NuyFgwK77C93WAexPt2v/07iiIYUXqx
         wVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cDkNG7qGEFEdGfIX86bLfEQSrd/OICaC75I6vXNRaN8=;
        b=K+GjnFjSiKObNBA+wOOtTn4D91Qp0WfkyT3mpDW42BdcB1HRGK/J+ZZkFwTLLbIiAa
         uE5+hz2pLs4gySvAMiMmR552TVz95FSUGpsNbmVYcJ5DrohUcpEmn8PqJlHkcbc7+ch4
         nl2AGPjB9jlkB7Gu07lAcIcB43kF8Usw+FQzhY8ZDVc5A6caHxc2o4HjB8j0yR2tlTAg
         iq39FX4fKKsKq8MRVo9j5dX8OqnAOe4jKCTZqWweG3q5i8xHk7BxBFTq3VeF0gFsQXAd
         lnxxPXFM2Xu1DoD33L18B3i0ogYlO1IEQ0c6XssGfFUE4ioWXXMngVb0eCnLB8SV2zpD
         VgTQ==
X-Gm-Message-State: AOAM530D+wUojmCdAfDH9k6UHGksbD3PN45KuEw8Yox9iJLfS/dnA0hP
        hBCbBgCNkDAPiJBeYTjMabxuH8LQFQ==
X-Google-Smtp-Source: ABdhPJxCDy/38KD2UbScMR4Ww4uvQJizkv3DJz4mCr9Is4wSza1J8KyuwDVirzuYKMBYl5hJRDYvBA==
X-Received: by 2002:a17:902:c1d5:b029:d1:f2ab:cf6e with SMTP id c21-20020a170902c1d5b02900d1f2abcf6emr1214960plc.67.1600255159388;
        Wed, 16 Sep 2020 04:19:19 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:18 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the unused SYNCHRONIZE macro
Date:   Wed, 16 Sep 2020 19:19:04 +0800
Message-Id: <1600255152-16086-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are no callers of the SYNCHRONIZE() macro, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_linux.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ab737fed7b12..ad1009778d33 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -123,7 +123,6 @@ typedef __u32			xfs_nlink_t;
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 
-#define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
 
 /*
-- 
2.20.0

