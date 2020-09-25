Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7A2C4727D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14ED021D7A
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:50:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZujPbt6E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYQuN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgIYQuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 12:50:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601052611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/W5MFzsu/E6yx2reBEVqNzxD0eCD918CcsHQZ62YTIM=;
        b=ZujPbt6E42allNx8qijAjtzSbOFyHPWmJaGMDPYXsMRoS257UZUWiK2zLsM4BAsTxlfiHT
        jclJOO6EsW4wwFECuh2hv8zP1hoQmj6T9eaZrf32z4xr/VNBQ+bfklc0J4bBVRMW/7j3xH
        6+dSEBIVqE04v/b3dGyv6bwfTzbEKGU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-yoQ0AOMWNA6RaYLQc1f39g-1; Fri, 25 Sep 2020 12:50:09 -0400
X-MC-Unique: yoQ0AOMWNA6RaYLQc1f39g-1
Received: by mail-wm1-f71.google.com with SMTP id a7so1315628wmc.2
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2020 09:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/W5MFzsu/E6yx2reBEVqNzxD0eCD918CcsHQZ62YTIM=;
        b=hWwInCF5CbVMIoqV9MHFSGJqw79eFDN9iVtdXzUXXqmh2kP4rjfS4rgUPY6gjbE44L
         3sM1urCUK4eYiROxGzwp/an0Mp9s7X7pfX1UZ+N0x7Mf1QAbm+yfH3lsT1J8YUlwqwNd
         tEvXUXESJV5SEqtktN47hclfOUYZBBVuA7e4Q+rwkENVFk/i5nNsJPlopzZc1ioT5XeF
         kXGdmjDrH8QLpsJoIuo92thPhGLrvwiFiu/GFtbCXHEEXHmxfh/x+SVESfIMBWbmt2+A
         Ebhzh/cZwiWf16S2z2cBRYRv+Z+f2OstbwFpr0wkgZBvWv/+tEJ90/ee2LX8AwCLdkK7
         V7xg==
X-Gm-Message-State: AOAM533YdBt94+Q6UrJyNB2WAri7omgwPf6Oz22l/ruYhf6hIvKQf+Se
        j6twWNfPRWXd8i1VvgKevU8T9USzz4ANwNOOKATknMB46wtfbYQnPy8k7KOj271164vAisIdlqX
        OteWQq9FqHfux+IsMGuyu
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr5556550wrw.34.1601052607922;
        Fri, 25 Sep 2020 09:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyim5OoKOZq4UxBXRSrZFil8/XknnAsIeS2s8kIa9Q4HC/YNf43AJ+CrmOg2iFeuHjRE9P8/w==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr5556535wrw.34.1601052607692;
        Fri, 25 Sep 2020 09:50:07 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id b64sm3181578wmh.13.2020.09.25.09.50.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 09:50:07 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: remove deprecated mount options
Date:   Fri, 25 Sep 2020 18:50:04 +0200
Message-Id: <20200925165005.48903-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925165005.48903-1-preichl@redhat.com>
References: <20200925165005.48903-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ikeep/noikeep was a workaround for old DMAPI code which is no longer
relevant.

attr2/noattr2 - is for controlling upgrade behaviour from fixed attribute
fork sizes in the inode (attr1) and dynamic attribute fork sizes (attr2).
mkfs has defaulted to setting attr2 since 2007, hence just about every
XFS filesystem out there in production right now uses attr2.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 Documentation/admin-guide/xfs.rst |  2 ++
 fs/xfs/xfs_super.c                | 31 ++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f461d6c33534..717f63a3607a 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -217,6 +217,8 @@ Deprecated Mount Options
 ===========================     ================
   Name				Removal Schedule
 ===========================     ================
+  ikeep/noikeep			September 2025
+  attr2/noattr2			September 2025
 ===========================     ================
 
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 71ac6c1cdc36..1a04a03213c8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1234,25 +1234,12 @@ xfs_fc_parse_param(
 	case Opt_nouuid:
 		mp->m_flags |= XFS_MOUNT_NOUUID;
 		return 0;
-	case Opt_ikeep:
-		mp->m_flags |= XFS_MOUNT_IKEEP;
-		return 0;
-	case Opt_noikeep:
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
-		return 0;
 	case Opt_largeio:
 		mp->m_flags |= XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_nolargeio:
 		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
 		return 0;
-	case Opt_attr2:
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-		return 0;
-	case Opt_noattr2:
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
-		return 0;
 	case Opt_filestreams:
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		return 0;
@@ -1304,6 +1291,24 @@ xfs_fc_parse_param(
 		xfs_mount_set_dax_mode(mp, result.uint_32);
 		return 0;
 #endif
+	/* Following mount options well be removed on September 2025 */
+	case Opt_ikeep:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_noikeep:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_attr2:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+		return 0;
+	case Opt_noattr2:
+		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		return 0;
 	default:
 		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
-- 
2.26.2

