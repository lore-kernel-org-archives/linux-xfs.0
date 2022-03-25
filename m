Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FA4C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 19:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiCYTfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiCYTfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 15:35:02 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5411D41A7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 12:24:24 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id t5so7212866pfg.4
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 12:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qmzHr/L3U8nQoAweId1NuPG/HOGM0s0UlJm0MadNlLg=;
        b=RLGSbTq+7slcEvuU1tRhHJtwRS5zMEl2o6f6WPAROVLf6xoAIPlUgWHxbrpaxrFW2t
         5a1xJNLNLqwl8ZrAJJPLhG80+F/snBxCQTnBCtPPynOhJzNfLdQM+RdmghbJknMdQMvX
         rCxOFM2po5wZUHaDtjxn2y4HZXYavQY/fMdteYBmkNP/MYm1XV3HPosz1q6IRHjX6GSA
         P1lOWOd9SgMb7wxaPuWavGNl7EsNLlqFRun7RN/CDMuiszBmgOWn6iWdaS9m8DYNE4BS
         r3uLZWt6z+KuNSimGGCIBk4GculuULuBfFhpcoZtWK1wLeDe1Y85x6H/yq0RAzL7fkK3
         TUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmzHr/L3U8nQoAweId1NuPG/HOGM0s0UlJm0MadNlLg=;
        b=7TkmHDxRcLr+iuqCJsIDU0FxmbIVJpQR/D2eunwoD8n8KgH0g02K0Ysg7xaCSBFuqW
         EhI9ZZgrFgrDK9/xqcuCjvMxljoRRZIkVEbKp/QcvD47C5rPRn4VEdnO5CeuxwtVrczL
         Kfx5j+l04iaaluigCvGbMRASyGMP6RlLaI2zU0GuvCkasPfRFPI3mjlobktbCGX+reP5
         2FJGL31/5bTlM6Aie2gg+lp/FjdDR5oRpPsAEf/2ixprUn0oC7fnI9hpG8TgIGmvPfz2
         BCrwiautEVoPnXOHnp3tUIlgEHkPKWMWhZqpNnb+FtU1ymmmLPP2KMtBymBB1f6EgFwy
         MY4A==
X-Gm-Message-State: AOAM533BARL7/nWjio2jo8W0C6lSJQ620GWrPmBXgBYUQKyLC7kYDKIz
        z72deZfwDHeEW7zHQ9KeKXonDkIoGSmnhdnPwbs=
X-Google-Smtp-Source: ABdhPJw8X1GxW10a1NYqxzSnSO31BKYakcvqh+zLmsffxP8Y+U1PeMEhru4NuxC4r05XPEu4SEXp/Q==
X-Received: by 2002:a63:5a49:0:b0:382:1ced:330e with SMTP id k9-20020a635a49000000b003821ced330emr484146pgm.478.1648228798044;
        Fri, 25 Mar 2022 10:19:58 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id pc13-20020a17090b3b8d00b001c775679f58sm11175961pjb.37.2022.03.25.10.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 10:19:57 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v3 2/2] Add XFS messages to printk index
Date:   Fri, 25 Mar 2022 10:19:46 -0700
Message-Id: <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system.
This printk index enables kernel developers to use calls to printk()
with changeable ad-hoc format strings, while still enabling end users
to detect changes from release to release.

So that detailed XFS messages are captures by this printk index, this
patch wraps the xfs_<level> and xfs_alert_tag functions.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
---

Notes:
    [PATCH v1]
      * De-duplicate kernel logging levels and tidy whitespace.
    [PATCH v2]
      * Split changes into two patches:
         - function and prototype de-duplication.
         - Adding printk indexing
    [PATCH v3]
      * Fix some whitespace and semicolon. *facepalm*

 fs/xfs/xfs_message.c |  2 +-
 fs/xfs/xfs_message.h | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index ede8a4f2f676..f01efad20420 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -51,7 +51,7 @@ void xfs_printk_level(
 }
 
 void
-xfs_alert_tag(
+_xfs_alert_tag(
 	const struct xfs_mount	*mp,
 	int			panic_tag,
 	const char		*fmt, ...)
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 2f609800e806..6f9a1b67c4d7 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,34 +6,45 @@
 
 struct xfs_mount;
 
+#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
+({								\
+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
+	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
+})
 extern __printf(3, 4)
 void xfs_printk_level(
 	const char *kern_level,
 	const struct xfs_mount *mp,
 	const char *fmt, ...);
 #define xfs_emerg(mp, fmt, ...) \
-	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
 #define xfs_alert(mp, fmt, ...) \
-	xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
 #define xfs_crit(mp, fmt, ...) \
-	xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
 #define xfs_err(mp, fmt, ...) \
-	xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
 #define xfs_warn(mp, fmt, ...) \
-	xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
 #define xfs_notice(mp, fmt, ...) \
-	xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
 #define xfs_info(mp, fmt, ...) \
-	xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_INFO, mp, fmt, ##__VA_ARGS__)
 #ifdef DEBUG
 #define xfs_debug(mp, fmt, ...) \
-	xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
 #else
 #define xfs_debug(mp, fmt, ...) do {} while (0)
 #endif
 
+#define xfs_alert_tag(mp, tag, fmt, ...)			\
+({								\
+	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt);	\
+	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);		\
+})
+
 extern __printf(3, 4)
-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
 
 
 #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
-- 
2.35.1

