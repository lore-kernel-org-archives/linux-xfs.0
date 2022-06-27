Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4704DCCA47E
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiF0HdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiF0HdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D49D5FE1;
        Mon, 27 Jun 2022 00:33:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n1so11666386wrg.12;
        Mon, 27 Jun 2022 00:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CA92df9BhmtGbPL/verbNBeKPY+zGVKKjMeB6o3F8F4=;
        b=OdBhuaXo+iL7/MFfOvdeSBWB4S/2nDTmNLmCeav5I2IfKRSs8O92900Fotj4aaE+56
         7p+zVnyBXUuR3Ay5582bOFiwzdzs04GuY9z1MuD2zgm+yMkqJQzhEUZZueuBI2A7fDeQ
         RxkMjPIJPc3WfwM/YqvWJrX6nFnkvgsPs3RYfPdgELuNIMuR3zE0sqoQTWVJvqaq3ofn
         YN94T4SxFUlORsv0avrf5JEfLb1r9fIE6V2866RLkPkOUJGd6iZa2ggP0UiSXZm9BHUa
         s0wsA1msQiKAuleOogihtUBFPlJiuM7uDPgOStg59Kl9AgVY5qNa5NQANctiDTCKWzfP
         9RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CA92df9BhmtGbPL/verbNBeKPY+zGVKKjMeB6o3F8F4=;
        b=CD84RHgEIAcW+a93mVWgZpDfDo/Ig86ip0CQPxkhssgGzqRB4cZsmXG87OJEZnfNSs
         bsMoXIs4X7xjzd8JTJYCe+atVDwHO2FmoaWLjRFzlSe9bWN2Etp6BXvZY9J+CCSW29/n
         oSKVPUIQvEbbo8YaEcyMJ38u2cqfofdoYIId4VBKaeqI21TaWcR44gQBUiUSjLY7q6Sb
         eP+3xjjm0gGqx2tiEAYcHhnauGd3gm8cr+LEBENDIGNhRLvhVmS99Iu6/WDHdMln8U0i
         gywC7dd3jwN8582KvyUy1qyHtAlOH/1/v1FEPkwlLm2UTb9ZqldGfLuH56OIRf1ZI00O
         hgNQ==
X-Gm-Message-State: AJIora9uQAlnGw29pNdPV57gfbllpsCgUZeTL3JT3Ber7YG2fUhkIKL+
        rpOyNwu9Cqf5orcur3NPU5w=
X-Google-Smtp-Source: AGRyM1vIRiNhcxgNgdyKU1+K0gejdYLF4Di1cv8QmDF7SjwUJIRBVsp2aHmjpAI5HPs81be+sKGdZQ==
X-Received: by 2002:a5d:6b06:0:b0:21b:902e:5727 with SMTP id v6-20020a5d6b06000000b0021b902e5727mr11082489wrw.86.1656315200574;
        Mon, 27 Jun 2022 00:33:20 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5.10 CANDIDATE v2 3/7] xfs: Skip repetitive warnings about mount options
Date:   Mon, 27 Jun 2022 10:33:07 +0300
Message-Id: <20220627073311.2800330-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
References: <20220627073311.2800330-1-amir73il@gmail.com>
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
index cba47adbbfdc..04af5d17abc7 100644
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

