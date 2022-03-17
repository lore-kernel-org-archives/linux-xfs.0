Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E28C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 06:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiCQGCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCQGCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 02:02:23 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9B013986B
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:32:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h5so3587556plf.7
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KrWTKmwhYs7mcKJJMXSHq0x6pM/ciOZGa/MjvFHWAfI=;
        b=yRZmmxSjdrcOzehKxnjSTQpIwMx9Y+pHK5R2gd3z0MmtvjwtHwnDCL93qkjNR2mleo
         y9emXAFpDLGBbGR5UKGuculfZ+qg44eYquaBfPvQErUr2qkshD8areTf0ZlT+FuUS8vJ
         14l9skVW5u45LK9leLY0Zx+BFSksrX2j4g/AnxpjgjNxC6eazkPWyra9Y6vnYpI4HY4g
         H5zZafJ+5/s8Wt36MUFqOrdAszNnVgYzsV40boals27lERzjT60KojVPvj9sDYKJCfLI
         sZiN4rdgTyqxU6OaCxFopp7cjYtC7vNFUgCsKDEUvWML6My7BjkWvqm3FYtEK/1I1YM8
         oUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KrWTKmwhYs7mcKJJMXSHq0x6pM/ciOZGa/MjvFHWAfI=;
        b=J7l06VOBZanm8eZHQ2iM/7Arn0Hc4wV2e+AoPFAg2GXZQ/5Lyj+AxS7b5xkahuql8M
         tgZgSS90umG29IZaDQK99fUFpgSZ8HwJGsonD40AY01a421D07FHexYDjH3TeGi5QE0q
         EHjKC8ow/FHA3FrV47VMewhUkC6xGWxejqmuYmqu4shuBFk8KwXbEwUxwyFwXtZyMh6y
         pdct7VT3nqLneI2QUZxskDBeXvu+MDG4a2mthsBvIXdf1J4cLzJLAVHa51Bw7AA6Ix87
         vputHufd653EccTp6kio5Snihy6auMqRElZM4B8T54Mc25AZrrVVp1IMq8WkhyoUk1HF
         6OvQ==
X-Gm-Message-State: AOAM532oSwttlV7fn9+NpNjhR5QCz/NE/TUptBTDmr4PR5TZsGdlDY4s
        1xXszTKqT7N/Rhkh/wAhJU5hzcrLzQVHo7MY1vc=
X-Google-Smtp-Source: ABdhPJzN13teF9B6P55zWBS3loVj3J4jNOnomX2A9bFh/2b85st9sMFP4otgjuzJcZBMpj8wm46VAg==
X-Received: by 2002:a17:90a:1b4a:b0:1bf:1112:5ef with SMTP id q68-20020a17090a1b4a00b001bf111205efmr13703679pjq.143.1647495134137;
        Wed, 16 Mar 2022 22:32:14 -0700 (PDT)
Received: from banyan.jof.github.beta.tailscale.net ([2600:1700:2f74:11f:a6ae:11ff:fe14:a442])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm5416537pfj.146.2022.03.16.22.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 22:32:13 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v0 1/2] Add XFS messages to printk index
Date:   Wed, 16 Mar 2022 22:32:07 -0700
Message-Id: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system.
This printk index enables kernel developers to use calls to printk()
with changable ad-hoc format strings, while still enabling end users to
detect changes and develop a semi-stable interface for detecting and
parsing these messages.

So that detailed XFS messages are captures by this printk index, this
patch wraps the xfs_<level> and xfs_alert_tag functions.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
---
 fs/xfs/xfs_message.c | 22 +++++++++----------
 fs/xfs/xfs_message.h | 52 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bc66d95c8d4c..cf86d5dd7ba8 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -21,10 +21,10 @@ __xfs_printk(
 	struct va_format	*vaf)
 {
 	if (mp && mp->m_super) {
-		printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
+		_printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
 		return;
 	}
-	printk("%sXFS: %pV\n", level, vaf);
+	_printk("%sXFS: %pV\n", level, vaf);
 }
 
 #define define_xfs_printk_level(func, kern_level)		\
@@ -48,19 +48,19 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
 		xfs_stack_trace();				\
 }								\
 
-define_xfs_printk_level(xfs_emerg, KERN_EMERG);
-define_xfs_printk_level(xfs_alert, KERN_ALERT);
-define_xfs_printk_level(xfs_crit, KERN_CRIT);
-define_xfs_printk_level(xfs_err, KERN_ERR);
-define_xfs_printk_level(xfs_warn, KERN_WARNING);
-define_xfs_printk_level(xfs_notice, KERN_NOTICE);
-define_xfs_printk_level(xfs_info, KERN_INFO);
+define_xfs_printk_level(_xfs_emerg, KERN_EMERG);
+define_xfs_printk_level(_xfs_alert, KERN_ALERT);
+define_xfs_printk_level(_xfs_crit, KERN_CRIT);
+define_xfs_printk_level(_xfs_err, KERN_ERR);
+define_xfs_printk_level(_xfs_warn, KERN_WARNING);
+define_xfs_printk_level(_xfs_notice, KERN_NOTICE);
+define_xfs_printk_level(_xfs_info, KERN_INFO);
 #ifdef DEBUG
-define_xfs_printk_level(xfs_debug, KERN_DEBUG);
+define_xfs_printk_level(_xfs_debug, KERN_DEBUG);
 #endif
 
 void
-xfs_alert_tag(
+_xfs_alert_tag(
 	const struct xfs_mount	*mp,
 	int			panic_tag,
 	const char		*fmt, ...)
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bb9860ec9a93..2d90daf96946 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,29 +6,61 @@
 
 struct xfs_mount;
 
+#define xfs_printk_index_wrap(_p_func, kern_level, mp, fmt, ...) \
+({\
+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt, ##__VA_ARGS__);\
+	_p_func(mp, fmt, ##__VA_ARGS__);\
+})
+#define xfs_alert_tag(mp, tag, fmt, ...) \
+({\
+	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt, ##__VA_ARGS__);\
+	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);\
+})
+#define xfs_emerg(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_emerg, KERN_EMERG, mp, fmt, ##__VA_ARGS__)
+#define xfs_alert(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_alert, KERN_ALERT, mp, fmt, ##__VA_ARGS__)
+#define xfs_crit(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_crit, KERN_CRIT, mp, fmt, ##__VA_ARGS__)
+#define xfs_err(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_err, KERN_ERR, mp, fmt, ##__VA_ARGS__)
+#define xfs_warn(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_warn, KERN_WARNING, mp, fmt, ##__VA_ARGS__)
+#define xfs_notice(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_notice, KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
+#define xfs_info(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_info, KERN_INFO, mp, fmt, ##__VA_ARGS__)
+#ifdef DEBUG
+#define xfs_debug(mp, fmt, ...)\
+	xfs_printk_index_wrap(_xfs_debug, KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
+#else
+#define xfs_debug(mp, fmt, ...) do {} while (0)
+#endif
+
+
 extern __printf(2, 3)
-void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(3, 4)
-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
 
 #ifdef DEBUG
 extern __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
+void _xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
 #else
 static inline __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+void _xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 {
 }
 #endif
-- 
2.35.1

