Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EA1C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C11864F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhBXVo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhBXVoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 16:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614203009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9E2w9Ae7LQxP8TZkaC9ADGsYZEtWSIuJE7kynqG2lI=;
        b=MPHJciNoZkA8fH8jwzQvmi2rqE2pKmoGvHx/ruE9YFagqMydItmPyb6DVROlt0PRs7fHXT
        Mx0GUvm54f+NqNwQE4GFN9tFO4/Pw7MAo6O09rZp83eh+W5f1IjvdqpRf6yFQzIufmDesy
        vRjaJIF7VRyz694KVtiuQqxTg/FA5kw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-385S2XrqNx2njj7mbf9Fdg-1; Wed, 24 Feb 2021 16:43:27 -0500
X-MC-Unique: 385S2XrqNx2njj7mbf9Fdg-1
Received: by mail-wr1-f70.google.com with SMTP id p15so1628422wro.11
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 13:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f9E2w9Ae7LQxP8TZkaC9ADGsYZEtWSIuJE7kynqG2lI=;
        b=Bgwd+jLxQmDPQu+EGO7a+WJIfwNQA5Xn2raU0tQhmn/D7hY/K3RXxBlFRnZ7LL4TEW
         5Gcqm0J/dHpMu+seZmX1t4xKU3A56ikEdPmcaTrcp5hme/MmeccFcFZylGRpTB1nzdOr
         E+o5ILuocXu78/okeCwej9u5peJ/CdzQRm11ez3UXcERVcnzClPHRAo/klTfZ45RUmZX
         OXI7VGspLxpyN+lN6X1PNfPWH6fOYmGc3FN0zA13ANJGK8f3xC0dpYgrta2NUwk5YKMI
         9Yol+JWMrPHICRhr2NxYnOBysVFBedbmIw82SBBXUm7Rwc0/NEnZRMTRRp2qhmYiyBgC
         7nWw==
X-Gm-Message-State: AOAM531WJkqYmPVZupGxS108+0twR+PclUmRSc1uT4pShi2wgvvWeTDx
        7ZiGr5sXJ6lz5bboH9XUy9EfSpdprefGgssjgZWVcwSHHsaeMFB0UCP4zYaF2LL2aCRWTJu0n0U
        A1pH5uO3COvtjMA4WXErVLhAYHHJUzVFmzOhgQof4upp1MSmXseiSdWK3vJZz3bmR1vJQlKI=
X-Received: by 2002:a5d:420d:: with SMTP id n13mr92266wrq.312.1614203006500;
        Wed, 24 Feb 2021 13:43:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMu0r8TouYFzq6fN4Qs6osGDp8h/1Fy8Ayv1dbg5Ra71bvlKWMdf0E1qQupcw1PNgqnyb17Q==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr92257wrq.312.1614203006363;
        Wed, 24 Feb 2021 13:43:26 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id x13sm4477251wrt.75.2021.02.24.13.43.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 13:43:26 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: Skip repetitive warnings about mount options
Date:   Wed, 24 Feb 2021 22:43:23 +0100
Message-Id: <20210224214323.394286-4-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210224214323.394286-1-preichl@redhat.com>
References: <20210224214323.394286-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Skip the warnings about mount option being deprecated if we are
remounting and deprecated option state is not changing.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/xfs_super.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7e281d1139dc..ba113a28b631 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1155,6 +1155,22 @@ suffix_kstrtoint(
 	return ret;
 }
 
+static inline void
+xfs_fs_warn_deprecated(
+	struct fs_context	*fc,
+	struct fs_parameter	*param,
+	uint64_t		flag,
+	bool			value)
+{
+	/* Don't print the warning if reconfiguring and current mount point
+	 * already had the flag set
+	 */
+	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
+			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
+		return;
+	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
+}
+
 /*
  * Set mount state from a mount option.
  *
@@ -1294,19 +1310,19 @@ xfs_fs_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
 		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
 		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
 		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
 		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
 		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;
-- 
2.29.2

