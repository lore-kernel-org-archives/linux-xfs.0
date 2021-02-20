Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB4DC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EFD864EB8
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhBTWRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 17:17:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhBTWRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 17:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613859355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADR/TCdDD1QP3os65dvP9xilkbophNhLxE1UZqNJG2I=;
        b=gbwwvLMnmALCcfHPcXWT7r/02ZP/NHntXHjUH7MeT3c6cVITCg6Nnpvg5T/d3xyCICQVeO
        1rsFzKiBc959n+jyKhaZKCqDoDFYkpynGQIQaYAYASyaAhTAooqyDMHGDzjldzZ715/LIG
        98knupIBUSviK1UfBA6OTWAcXzwdPUs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-6fg1JlXWM9SllAETmEw0xQ-1; Sat, 20 Feb 2021 17:15:54 -0500
X-MC-Unique: 6fg1JlXWM9SllAETmEw0xQ-1
Received: by mail-ed1-f71.google.com with SMTP id c14so2990061eds.4
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 14:15:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ADR/TCdDD1QP3os65dvP9xilkbophNhLxE1UZqNJG2I=;
        b=t1B53kwKn5rff1z+w62fwu/7Ao35HAyrYxa006WzTpalWDybCIBHvv4d6tGy6ac5LP
         ghvpsQGHLC+O60xltWZZC68+/dfI5TA2kljoiHzDI1Zs84Z6MhdHVDepK/tSQjXtHJb8
         yNV2IjYctcVUWgcE4FLw9azz2tw8tdao5rlEXFrPCrDMmlEOCgDogEajs6qsRLIGxcRn
         kzMQkw2jlRJ9aMndaNgXhbmmzrpsu8fbvdLQXTlLY75Pwot8kv1N39OmVwSTzRKDN/6e
         xTEEoUl9SS4KSyLtXJGZLrk08rSh2WmQq9jgyPxsSMt7vPoFoMoSi4SIPEGLIfW4zoSG
         aORg==
X-Gm-Message-State: AOAM5306TE8LcoPnLSDTkEGWTNJYJceZN1bfwq79glPKsfAA4vrGYy+E
        uJeVZQAesgzmN2H1uUOpLI8Ao8ACRY1gWC9/EtlHkq89zRnUIWoPuiiyHcNWv8EKfprrhra05Pg
        vbujfUMSNJd4y+m+RJOLpp0Z0d/hL7RRWxQNB0csRK9yBiyNMyJIopdjOPUhrzybhm/KiZP4=
X-Received: by 2002:a50:cc0c:: with SMTP id m12mr14184555edi.154.1613859352723;
        Sat, 20 Feb 2021 14:15:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyv/o4S98vSnXkumtWP6RZZxYd3+PKJbwOOd725gdc8YI+WOga45mCzJAelu7LLq09Kt65BAg==
X-Received: by 2002:a50:cc0c:: with SMTP id m12mr14184544edi.154.1613859352571;
        Sat, 20 Feb 2021 14:15:52 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id k6sm7020286ejb.84.2021.02.20.14.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 14:15:51 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Date:   Sat, 20 Feb 2021 23:15:49 +0100
Message-Id: <20210220221549.290538-3-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210220221549.290538-1-preichl@redhat.com>
References: <20210220221549.290538-1-preichl@redhat.com>
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
 fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 813be879a5e5..6724a7018d1f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
 	struct fs_parse_result	result;
 	int			size = 0;
 	int			opt;
+	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
+	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
+
+	/* if reconfiguring then get mount flags of previous flags */
+	if (remounting) {
+		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
+	}
 
 	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
 	if (opt < 0)
@@ -1294,19 +1301,27 @@ xfs_fs_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		if (!remounting ||  !(prev_m_flags & XFS_MOUNT_IKEEP)) {
+			xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		}
 		mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		if (!remounting || prev_m_flags & XFS_MOUNT_IKEEP) {
+			xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		}
 		mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		if (!remounting || !(prev_m_flags & XFS_MOUNT_ATTR2)) {
+			xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		}
 		mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		if (!remounting || !(prev_m_flags & XFS_MOUNT_NOATTR2)) {
+			xfs_warn(mp, "%s mount option is deprecated.", param->key);
+		}
 		mp->m_flags &= ~XFS_MOUNT_ATTR2;
 		mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;
-- 
2.29.2

