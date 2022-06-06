Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D273DCCA482
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbiFFQFz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiFFQFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:53 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14D518F2EC;
        Mon,  6 Jun 2022 09:05:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z9so1133392wmf.3;
        Mon, 06 Jun 2022 09:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SjunFKBhrKFJ/HQv/88WssDIELUD5Mh1teOcnQSIQqw=;
        b=DEaVT/QusonOGR7Pk3H7c7Hf2d/Qoq/o9e9Cr739AWVAtgqG30bWY+RGPjdQCc/8UR
         Fgfs60I+SBPCk10wBebBP4eeI7Vdfkrvog6zeGIs2sh0ujhjlu9prNAq16Mvs25Y0zU0
         M45JQ+qKDyp5zqkvk8y+1vIDdSCX+OhuvD0n7/nE2ATxDv+n491LCK1cH8ZhNZY62nFF
         iOBFUQUmi07XyX7CeQcT0d6sQf5pe61vk3lqWWcd8xTVhkUM18CQmPnwRsbS7uzQkveB
         UbBZUJ3drwvppG7gmDJW8ePNA3NnNw74p2UKE2oC6YzGYJK+Ami0GIGHTvkYbQ+bnO0n
         aisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SjunFKBhrKFJ/HQv/88WssDIELUD5Mh1teOcnQSIQqw=;
        b=zbGWQt4Oi3UqA+rlIHE24eeoV5lLO4iJf4D8SnVdXZ4hoo6H7DLM7TniLjHiyZNHaJ
         pc7AxBAMPPOgkDPzRcD1SZH3VP5Yms+pF+sIYxMApSqR5S7WKbDEnOwgytM39oHn5g76
         wxkNmbzNXbMxKcjmvvRyrf+eCoYm00JQtM0cnA51A0fhSlLy1h7wJfsp1Ts1Ey1M510O
         wp0sfs3S91dCiibLjGoONoWEG5w9WhhouqeE0ZP5xGQt+0+fJLoaIeRpQUhupVhzbi4A
         G4CrYP+l3rJFvcBbyuDZCAhQMm1eF5tCww5FT5qR1o3uz3fJjes9hRf6e2fmqrfCoHOg
         hQZg==
X-Gm-Message-State: AOAM531hLhJZqxGBXJPrLqyWkDD78xRneXwNF1qRE4RURBxRDnaf4JlN
        ji/ALmn2mUoWmPdCa6jloj8=
X-Google-Smtp-Source: ABdhPJx7rnZ6nAjVlZL/lfs6cNXzm+cLv5NKvLemgQwWxdf4cfMcvMhB5cU/3TjLz1LFI30emHh1mg==
X-Received: by 2002:a05:600c:511a:b0:397:50b9:f5be with SMTP id o26-20020a05600c511a00b0039750b9f5bemr54536380wms.188.1654531551185;
        Mon, 06 Jun 2022 09:05:51 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:50 -0700 (PDT)
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
Subject: [PATCH 5.10 CANDIDATE 3/7] xfs: Skip repetitive warnings about mount options
Date:   Mon,  6 Jun 2022 19:05:33 +0300
Message-Id: <20220606160537.689915-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit 92cf7d36384b99d5a57bf4422904a3c16dc4527a upstream.

Skip the warnings about mount option being deprecated if we are
remounting and deprecated option state is not changing.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f667be85f454..b4a3a71bd667 100644
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
@@ -1294,19 +1310,19 @@ xfs_fc_parse_param(
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
2.25.1

