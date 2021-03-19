Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NO_RDNS_DOTCOM_HELO,
	RCVD_FAKE_HELO_DOTCOM,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C653C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F06F61946
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCSPeE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:34:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230321AbhCSPd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 11:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616168039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73pfQ7lzTAUP/xkaZ2bXI9tmoYTCOqyXp+b14P20ha8=;
        b=WPRFtD8PTQMuI6RKezFN67xgvOlnvVlOgwqK2YmwgKjKMuZLednmlKBmccy4sFV4zuWaeQ
        wSKEoMsdZF4nfwmld75XWZ0i5KfVkn/2togSh6+DRyAlMUtrG5YeJaUcePpZcQaWwC3mP6
        rKiZeTTOcqKqJt7XywHy+7+mhd0UyDM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-yu25rZAOOzif4FuujgzB0A-1; Fri, 19 Mar 2021 11:33:56 -0400
X-MC-Unique: yu25rZAOOzif4FuujgzB0A-1
Received: by mail-wr1-f72.google.com with SMTP id i5so21991413wrp.8
        for <linux-xfs@vger.kernel.org>; Fri, 19 Mar 2021 08:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=73pfQ7lzTAUP/xkaZ2bXI9tmoYTCOqyXp+b14P20ha8=;
        b=bQMRun0HRNDRPVfmKC7dTP6BqaCJMADnHEIZ5mU+gWYSrknQ/ArNrQY5jzsNqrs2Pd
         UMpMr003DQ2as7LRlw+MkAxUTBtcFDjID+U6yUf3guTB4l8wM1Nn39p3YK97AYsQnW1o
         rk1fCIXKQUlj9b6vcBkErval1v8P2OzS4QOhtuht2Uu9L4o8p/nylig6/XbNmOiJjhtp
         Pi/lZVxyVe8pId7Me9RE1THS4BiP3ul2BZDqSqZeMRBht45e3nUdTF36JuJDEa57Ozc6
         O/0wGytx7CKsmv8JIWUzDRHiCLZmF4SnmMvjoN4FNP9y6Enudu5jT9p7GnwFwCjPSiZU
         5UZQ==
X-Gm-Message-State: AOAM530cuENhZmVu+sD6w3o6pvQu5jwK8xj9vybYGpfRvPFcEPntfjqf
        M7yP1OVFmQyPOhW2nxcfNi7Gk8afppdp7Iv/wRsifA8OQpci5crXZYTTXV6iIJry/BDo6JTZJvv
        jqBLcMg8hnenOg1df9cgmyhSV+enLGjpuUayPlhhhudPk6kC1tm6bJW624/J7/P0s5e+Nc00=
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr5055783wrv.329.1616168035467;
        Fri, 19 Mar 2021 08:33:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFTvWNru5Dndp1f7sWopWJ5x+lQiOX9a5+XMV2k2tZ6I+FoSN5LUebFGDP5Lp9KvH8ytS0xg==
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr5055765wrv.329.1616168035287;
        Fri, 19 Mar 2021 08:33:55 -0700 (PDT)
Received: from localhost.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id g9sm8842791wrp.14.2021.03.19.08.33.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:33:55 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: rename variable mp to parsing_mp
Date:   Fri, 19 Mar 2021 16:32:50 +0100
Message-Id: <20210319153251.476606-2-preichl@redhat.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319153251.476606-1-preichl@redhat.com>
References: <20210319153251.476606-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename mp variable to parsisng_mp so it is easy to distinguish
between current mount point handle and handle for mount point
which mount options are being parsed.

Suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 813be879a5e5..7e281d1139dc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1165,7 +1165,7 @@ xfs_fs_parse_param(
 	struct fs_context	*fc,
 	struct fs_parameter	*param)
 {
-	struct xfs_mount	*mp = fc->s_fs_info;
+	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
 	int			size = 0;
 	int			opt;
@@ -1176,142 +1176,142 @@ xfs_fs_parse_param(
 
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
2.30.2

