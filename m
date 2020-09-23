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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F14C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52529221F0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FcrIzaJx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIWG7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgIWG7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8EFC061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:33 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d13so13803761pgl.6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uzrcqek5YpHotqjw8QpiA/JofXip5yx4HlGgtaw1CZY=;
        b=FcrIzaJx3wtzWeMaGtL474QpR9N1kOisp5z6/EYvMVKhmtXxfTP5EsDGq63VuLeW8y
         HjlpVzLUGxWb4PauPRstcwM6JykadFD4fve1dAF5meurXYdd7j1K+0xMfyYrHXVzEB8x
         JwJZlo7MrQH1JjRtpw2aiEHb/8QQzU07nqbRG2kUvsmIRFGYoM2u4/FWUKZj9SBhTG1h
         Im1bUAnv+YCb6DWaUtDeBD/wZUDY8fwrcuICAxNyyUudlBzaSPb11AlYN4623DM4i6x9
         0FOuD9pelq4utL04ekH0vXoW8wtm1V2HpsuykcyeQ4cgypedT/O+V2tB//H77Clqw5Oy
         uyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uzrcqek5YpHotqjw8QpiA/JofXip5yx4HlGgtaw1CZY=;
        b=ObxajvJ6orBxROe7bCdd9RyjYw87/XiG2ws2uBWovn7SvW/den1rfobwEyfa7a+qWS
         xj8zLAtxbbvIrrv61GoC3YmxTaqDgW4SEKiHzaq08MttYoz0zL9Z8dsUoZ6j4dOWwdgo
         aTD7U35GUiiQ22Ar9GPH/6rN94fKi0oWj3V0mQNmix97H1hy8FkU/42zJmuq3fXAX1Wa
         Ha8X2T8GAMyK+jSNSLUyXQGNu+ogmS4Ij5VJR0BzxpRS8kzZatVSKw+CpLB6qGbWfb+i
         DFp00OVE79FJg8InIDPk2Q5EDPyLeB+BefGRA7cjA89P8yQs5buXTBb0j0ze58S0U88D
         WHbA==
X-Gm-Message-State: AOAM53374ekNvGwCW3LNjbRV3ByCdCxYx2LRcDcfKoh+k40R5w8BP3mw
        Ut6r8Ls/erDi0bSORXIxzI9WRhPA2Xyr
X-Google-Smtp-Source: ABdhPJzk9Z8gnGCJNvYHa7AOkoxD4kNeXPjzd2uVLZGqkS15DW6nPjz5WBQBIhzuufCMHKvLrbftjQ==
X-Received: by 2002:a62:1902:0:b029:13e:d13d:a12e with SMTP id 2-20020a6219020000b029013ed13da12emr7603740pfz.22.1600844372890;
        Tue, 22 Sep 2020 23:59:32 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:32 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 6/7] xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
Date:   Wed, 23 Sep 2020 14:59:17 +0800
Message-Id: <1600844358-16601-7-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Cleanup the typedef usage, the unnecessary parentheses, the unnecessary
backslash and use the open-coded round_up call in
xfs_attr_leaf_entsize_{remote,local}.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b40a4e80f5ee..78225cc959d6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -746,14 +746,14 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 +
+			nlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 +
+			nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
-- 
2.20.0

