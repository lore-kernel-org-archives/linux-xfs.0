Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18C9C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87757206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eb1lhUm7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgIQLkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgIQLjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:39:08 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E0C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so1095238pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zpg6Mldh85rUePceqkOwiS8YEw2R/XkJO/lJq6H8TsQ=;
        b=Eb1lhUm7Vs/gRttZeSAhbfaLj8DwvA9cac9ot9VoNMN+d4W+SSrGdL6Db96rLdoYCE
         jOKgDCL7eFNtOWBVimzDhT2zw3K/AmGquNBHx1/KaHiC4GOhvZss5v+wxK7cagnF9C4g
         VBeL5vYuRb+Str6JSkTxG3SU/wrnmtCq0oPnYUxtgtaEv6HFVjp6MDN77HUhu9ThcSW8
         J/MUD0omXvqKErZa+40VmHvqQHfGpkz4p56T84OVOXbW5kLj+xbrxDr4U1ATzAvMi+ZO
         oCppTf6ppd72tsZ8oiFwJ13MJXHzurszmqwPWXqYqbn18lYubLv5UMzyWE5EqR8QDEzE
         Pklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zpg6Mldh85rUePceqkOwiS8YEw2R/XkJO/lJq6H8TsQ=;
        b=RI+3YIqN1dmVnpoYYlAo++b2/EWE6IQ47ty+iAg0/2z7a1UrQlmGv3b/srgNaizGCC
         Gn9EICnG7AkClT++FezF788IvoBjsCbMI5MMAIdO+2/XaQN0oGihMAzjElsNYZFv8W48
         LwhQwhHCgTEYSgR4ylunaKFH9kNPeaOvV4tCJ4FTgANSXFbYygv2RwuOZ7UsTLdgJsz7
         FsO3ko7wMCiZqtI2M8fWJtVabPdUsgZ1V2gSLr8KmxlnQmXds/cXlzOHxP2bkQKTmzQt
         bzy2ktClP7KsX0J7vV9IgIvfO38YxXAiJ0ahfxdTFG3mhaQF4pQ8DndMY7IdY7hFb3LJ
         q73A==
X-Gm-Message-State: AOAM530fnB8oJ4cEcJY2rEOGbv6fCV9ZsXFMOJP3rXBE5FF4fob7ugQo
        FnWXxJmEPrA0jHSZ95UMPPOGOsRS3eFz
X-Google-Smtp-Source: ABdhPJxER8dKOtWN3PmsiZZssi3k3smlkAn9HkCh5XX870WYMGee5x7MhfkaBeAyNNVOEbIJlagBAg==
X-Received: by 2002:a17:90a:6e45:: with SMTP id s5mr7946794pjm.12.1600342741243;
        Thu, 17 Sep 2020 04:39:01 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.39.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:39:00 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 6/7] xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
Date:   Thu, 17 Sep 2020 19:38:47 +0800
Message-Id: <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Cleanup the typedef usage, the unnecessary parentheses, the unnecessary
backslash and use the open-coded round_up call in
xfs_attr_leaf_entsize_{remote,local}.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b40a4e80f5ee..09f0f5d42728 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -746,14 +746,14 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 + nlen,
+			XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 + nlen + vlen,
+			XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
-- 
2.20.0

