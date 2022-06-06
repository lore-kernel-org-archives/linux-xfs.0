Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F422C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbiFFQFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiFFQFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C2D18E448;
        Mon,  6 Jun 2022 09:05:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i17-20020a7bc951000000b0039c4760ec3fso2026361wml.0;
        Mon, 06 Jun 2022 09:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRhtSMfP7nSm/2tSi5M5oC7ypK4we5cxq3/aNo6/e8Y=;
        b=XPB5PmaUDXmMT32mD1/2VkZV79VL9YJssT0/k8rVfz7YkGbiOFY8M7HqTJEU/FXods
         4vVTvSwZsgefZF4qYxgGfTSbV/EGeQ4uIB5CGlau/tOjkj0hcwLON5ydpSgH2KRwmiNe
         dzJBudjlclOuEvUHsRPRc7gNYGQI30WPJfmgnpss08JhC1eN6XfpP+C9jhustQ4aHjDZ
         fdWrk48mV0gwVSTDuAFImN5SyhSDBRTv9zQY1R52xA7osTuvZdLGv39moxf2G/5MFxFl
         NhDKm1OfJbRRuqA4l9QiftTp9+YNw7wajlzXmWEjYCLc7KzTmOG4DDFIozUML8/rA2X9
         oCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRhtSMfP7nSm/2tSi5M5oC7ypK4we5cxq3/aNo6/e8Y=;
        b=55zK7RpuCA2SdOCGiALxHqmHtfXeQ/kkxzsZlL0ORvU60rE+IvD9fre/gBPfjFSdqg
         6PxsnLvTNH6VWJhg+msGqJR8KTVAGVD+jq5QejvWLn8PsltAFhB14b+ySrYtKPdvZnJm
         ggT1SkfHGmDHNwJf1t2CpJUSjW2tV5ZoYKvtdZfSAraFvYNSR+49HIKEJGbdLqMSXAhy
         M/DQZCoVxlPZUBtkBjJrby7sqnttAV2fCliTYBUBljS8KRcyPu4ZBo1G53Pivp16SiBi
         wbIroLbYhjzwW0BhaLrDT/bj5eHQRLNAw05wCUbAjkuTMuktNrFCQvy+5NfPLGO5J7jo
         mexw==
X-Gm-Message-State: AOAM533OxGmpVlT7XDX7OA2p6/keUO/JNAhmXaubnaIuSTRocWUwfjDG
        GVEgDrTjQaaJ2JGfhwhvDRU=
X-Google-Smtp-Source: ABdhPJwaVjQHlc1pZA+yk4W0HRH3ZQ3TsRf/yKmXpD75EIt11ueNm6DG3L/H4GgH6mdfePuG/sv1QQ==
X-Received: by 2002:a05:600c:35d4:b0:39c:2541:7571 with SMTP id r20-20020a05600c35d400b0039c25417571mr24057171wmq.33.1654531549764;
        Mon, 06 Jun 2022 09:05:49 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 2/7] xfs: rename variable mp to parsing_mp
Date:   Mon,  6 Jun 2022 19:05:32 +0300
Message-Id: <20220606160537.689915-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit 0f98b4ece18da9d8287bb4cc4e8f78b8760ea0d0 upstream.

Rename mp variable to parsisng_mp so it is easy to distinguish
between current mount point handle and handle for mount point
which mount options are being parsed.

Suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5ebd6cdc44a7..f667be85f454 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1165,7 +1165,7 @@ xfs_fc_parse_param(
 	struct fs_context	*fc,
 	struct fs_parameter	*param)
 {
-	struct xfs_mount	*mp = fc->s_fs_info;
+	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
 	int			size = 0;
 	int			opt;
@@ -1176,142 +1176,142 @@ xfs_fc_parse_param(
 
 	switch (opt) {
 	case Opt_logbufs:
-		mp->m_logbufs = result.uint_32;
+		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
+		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
 			return -EINVAL;
 		return 0;
 	case Opt_logdev:
-		kfree(mp->m_logname);
-		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_logname)
+		kfree(parsing_mp->m_logname);
+		parsing_mp->m_logname = kstrdup(param->string, GFP_KERNEL);
+		if (!parsing_mp->m_logname)
 			return -ENOMEM;
 		return 0;
 	case Opt_rtdev:
-		kfree(mp->m_rtname);
-		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_rtname)
+		kfree(parsing_mp->m_rtname);
+		parsing_mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
+		if (!parsing_mp->m_rtname)
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
 		if (suffix_kstrtoint(param->string, 10, &size))
 			return -EINVAL;
-		mp->m_allocsize_log = ffs(size) - 1;
-		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
+		parsing_mp->m_allocsize_log = ffs(size) - 1;
+		parsing_mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
 		return 0;
 	case Opt_grpid:
 	case Opt_bsdgroups:
-		mp->m_flags |= XFS_MOUNT_GRPID;
+		parsing_mp->m_flags |= XFS_MOUNT_GRPID;
 		return 0;
 	case Opt_nogrpid:
 	case Opt_sysvgroups:
-		mp->m_flags &= ~XFS_MOUNT_GRPID;
+		parsing_mp->m_flags &= ~XFS_MOUNT_GRPID;
 		return 0;
 	case Opt_wsync:
-		mp->m_flags |= XFS_MOUNT_WSYNC;
+		parsing_mp->m_flags |= XFS_MOUNT_WSYNC;
 		return 0;
 	case Opt_norecovery:
-		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		parsing_mp->m_flags |= XFS_MOUNT_NORECOVERY;
 		return 0;
 	case Opt_noalign:
-		mp->m_flags |= XFS_MOUNT_NOALIGN;
+		parsing_mp->m_flags |= XFS_MOUNT_NOALIGN;
 		return 0;
 	case Opt_swalloc:
-		mp->m_flags |= XFS_MOUNT_SWALLOC;
+		parsing_mp->m_flags |= XFS_MOUNT_SWALLOC;
 		return 0;
 	case Opt_sunit:
-		mp->m_dalign = result.uint_32;
+		parsing_mp->m_dalign = result.uint_32;
 		return 0;
 	case Opt_swidth:
-		mp->m_swidth = result.uint_32;
+		parsing_mp->m_swidth = result.uint_32;
 		return 0;
 	case Opt_inode32:
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		return 0;
 	case Opt_inode64:
-		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 		return 0;
 	case Opt_nouuid:
-		mp->m_flags |= XFS_MOUNT_NOUUID;
+		parsing_mp->m_flags |= XFS_MOUNT_NOUUID;
 		return 0;
 	case Opt_largeio:
-		mp->m_flags |= XFS_MOUNT_LARGEIO;
+		parsing_mp->m_flags |= XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_nolargeio:
-		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
+		parsing_mp->m_flags &= ~XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_filestreams:
-		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		parsing_mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		return 0;
 	case Opt_noquota:
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
 		return 0;
 	case Opt_quota:
 	case Opt_uquota:
 	case Opt_usrquota:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
 				 XFS_UQUOTA_ENFD);
 		return 0;
 	case Opt_qnoenforce:
 	case Opt_uqnoenforce:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_UQUOTA_ENFD;
 		return 0;
 	case Opt_pquota:
 	case Opt_prjquota:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
 				 XFS_PQUOTA_ENFD);
 		return 0;
 	case Opt_pqnoenforce:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_PQUOTA_ENFD;
 		return 0;
 	case Opt_gquota:
 	case Opt_grpquota:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
 				 XFS_GQUOTA_ENFD);
 		return 0;
 	case Opt_gqnoenforce:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		return 0;
 	case Opt_discard:
-		mp->m_flags |= XFS_MOUNT_DISCARD;
+		parsing_mp->m_flags |= XFS_MOUNT_DISCARD;
 		return 0;
 	case Opt_nodiscard:
-		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		parsing_mp->m_flags &= ~XFS_MOUNT_DISCARD;
 		return 0;
 #ifdef CONFIG_FS_DAX
 	case Opt_dax:
-		xfs_mount_set_dax_mode(mp, XFS_DAX_ALWAYS);
+		xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
 		return 0;
 	case Opt_dax_enum:
-		xfs_mount_set_dax_mode(mp, result.uint_32);
+		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags |= XFS_MOUNT_IKEEP;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags |= XFS_MOUNT_ATTR2;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", param->key);
+		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
-- 
2.25.1

