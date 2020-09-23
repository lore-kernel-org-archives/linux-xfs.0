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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97AEC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0442223E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sm7+e6yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIWG71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWG71 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9410EC061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:27 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bb1so612146plb.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3M8M1GZG79EClznVjdpZihDccBwlRdgGQ8JMk2EzCPY=;
        b=sm7+e6yy4voPNSMZ6h8N8InAd9aZJWbIwvyktZd77sPfuq3SOKcStQqoW9KSyGVQKw
         Y4dyoQoRTR0K/OXjJg74YlKsbyL/Pdh7GKvgD19wQXcjRTOLRxdm5bDKWfLzteoFYhjS
         1VNEUIm7Gm53lm4vfG3QuU4TzKSTF1E5t3dv4CQVmuSikNfHvJCB42P+OhFHvQSP2DOK
         5kp661IeyNnhDaIm9CB04VHwDEIl43a3DvVlyJoEMizr4EboitoZxAeVTqIxmRSvX+os
         mQ1uOlzyn1JURsF0gZ5AqI7ysdlxi6TGyyBvBZHL+tFK0RvO3xnLTaxhg/w0uf8fGRzf
         Wrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3M8M1GZG79EClznVjdpZihDccBwlRdgGQ8JMk2EzCPY=;
        b=Fhdfh2nduDV8pDFkMTVOzb/kaO856QdhUX5P7oVSuY5G8hZAZPIqIofHlle5vYEwVo
         R0D5VUJXSxpXypcL75/KdSg7JpJNLfXC62eiedYlDM8Bdddmp6XnYxF84L3q65xERi4A
         Z0DYW9HHpai7IIVJ48St9z6Pbwa7wfhzjdaHlU9PxLK+izD+15H1lQqTHTtqB0VmBn71
         MMynx0mMYbuRDNfjs3+jmR88i0pYzWg3D1BhRCI9B9k7GtKdL6OmBZCLvEw7cIjkQ2Ab
         8OzWccxGeoG2dlS2oxfGG0OfS36NLly4dwHV0mJGRKALyRQvye8uVkPrZ021/ZE2+F7W
         N+sQ==
X-Gm-Message-State: AOAM531tMf896ncYvEKGwa3dW+nAnN8kWRlHCfyNa+YZiWE6AWGMggQ/
        mBY9lCJeq54MnkBwbfm1dJwwftBmFf6c
X-Google-Smtp-Source: ABdhPJzbfyN7OocU9gnQnkB6N0yTFjKpj8C3lPi5gYSxRUDg+yPPtl9B6JJwg9IKcQiCFUiYlhyCfQ==
X-Received: by 2002:a17:902:6b05:b029:d0:a100:8365 with SMTP id o5-20020a1709026b05b02900d0a1008365mr8282863plk.11.1600844366857;
        Tue, 22 Sep 2020 23:59:26 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 1/7] xfs: remove the unused SYNCHRONIZE macro
Date:   Wed, 23 Sep 2020 14:59:12 +0800
Message-Id: <1600844358-16601-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are no callers of the SYNCHRONIZE() macro, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

