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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A98C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B7261951
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCSPeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:34:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbhCSPeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 11:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616168039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//iAscT7QZKGpEOB6SsAN5ms5ixLV6eqvoKlQIKzpwE=;
        b=bCNNd/VHYAsJK5J1JMSbbF2rZhWiSqMyMNg931YI9q9WG7M//S1zgcRRdyVg9oBluDDUol
        z8pX2Y85Y/B3KM4r/qBLo7Sc2MWx9MEguD6jq6qjxkee8Mh54HNaHE1/sK1rBJKy9OZBNp
        13PAu+c1GiLOrYvgoI+qbjeO98z/PO4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-ylS_TNMQNfW0O01geIbCog-1; Fri, 19 Mar 2021 11:33:57 -0400
X-MC-Unique: ylS_TNMQNfW0O01geIbCog-1
Received: by mail-wr1-f71.google.com with SMTP id x9so21806327wro.9
        for <linux-xfs@vger.kernel.org>; Fri, 19 Mar 2021 08:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//iAscT7QZKGpEOB6SsAN5ms5ixLV6eqvoKlQIKzpwE=;
        b=OrkBSsHpXNTcLN+ybKuSGKsBRYYcZgwdtmfyHI4qiQclrdCBoKEXD3rK3IqHpWT3ZM
         yixjfiQLKzGeLCd0ibSuywJtlSCvRl3PLGKBnWE9pJJmCN+LY3m62OW5s4hGM4kVONrQ
         oGx2vVErow8TL9wJsrgiomQs5+5burZu+Fbg0ejJaks8A1oR6J3DlxzZANFC3vb8q9gO
         eJ2GjDxWPZGv1UUsIRy7F2BsUKrara8H0fEgkW7GKNxS4nUV8fzvTDLl89RPNmWJjgxZ
         5i+UpMXkQLSIrhjH0s1bguBDVdVh+1sPpyjEHvp71E3AaRt24mjK1hdqTEJfREBqdO8o
         Dy8g==
X-Gm-Message-State: AOAM530NdLzi0/8/Xyerxol2S02wYSzf/y+e5p0jOKmYVXwoan+H2Q7u
        Ax0a5jG7q8YK8+k3op+xkt/zXk0dYZR0oOtsHM25kUYzzi4K4TKyx2IrMq81zvvrdFQuLOpF+2s
        6ZOdeD34/RzURK35S3SNoT0D0Q0MF/OE4pfkd0bDdVnHKFZ58qGZbtteVUJ1dhzSXyq3P4lM=
X-Received: by 2002:a1c:7407:: with SMTP id p7mr4289488wmc.51.1616168036416;
        Fri, 19 Mar 2021 08:33:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo+8Gy601HWQeHX+helQCMbwnqu8NpGaGyEANop8wLGhbhBk8qfCFB8UxxrLnTPu9/Rk0Qtg==
X-Received: by 2002:a1c:7407:: with SMTP id p7mr4289472wmc.51.1616168036210;
        Fri, 19 Mar 2021 08:33:56 -0700 (PDT)
Received: from localhost.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id g9sm8842791wrp.14.2021.03.19.08.33.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:33:55 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: Skip repetitive warnings about mount options
Date:   Fri, 19 Mar 2021 16:32:51 +0100
Message-Id: <20210319153251.476606-3-preichl@redhat.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319153251.476606-1-preichl@redhat.com>
References: <20210319153251.476606-1-preichl@redhat.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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
2.30.2

