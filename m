Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82003C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 01:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiCaBkG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiCaBkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 21:40:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E9148397
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so1286214pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xw7RLQ8jPr9pDvggZI8sJKLCi+qPLFlZH0oZobFefqw=;
        b=V7gptV+GtHXrbrTHm84Ir4WaWeOAYnNUileySq5mYmvepeFbLmCoYHISEyUYvOOhKu
         Jib3JZjyOu4aha1Z2h8j5xyC7Au66jMj/fy8x7E/opdvX239KHqthbi307uaBZcgAXch
         PlLrvBQTKOYdSQjkeHCJEi0CoNWBaOExuJVcEVaQ3PFbnKscQ1/owBLiN8/f1w2GCvlM
         iONiLiBgzb0vBDnICR2ttKDFo3kWNsfyJQtpihUrqb7tlY3wE42sPLFZbCIPpSE1otmc
         yE5ycK4m5ckZQaJamGK+TSbFK4JVcG5pNvEH15j71zZnxd2IlrXHykVIERzSZiT9LJxA
         RIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xw7RLQ8jPr9pDvggZI8sJKLCi+qPLFlZH0oZobFefqw=;
        b=1m9AensgDedKezhkWhoHlHoJWn0guD9zpoSFiFP9J5bv2utAMByekM9BGKmfJfoT8Q
         biIc1KgoZlAwcVXErWI9VwtRuqPNYOTj3DcR6g9GOGB+XZpG4G3aPiOSvZfvfIoOg7Qm
         ti5rttfEi7kVWg6GRGSZNybSFTl18TYYD304jQzIEh0orfgN4nABipm6F3+TmkC8D436
         qCQRX9jRvDulMN3SaJcyBbJ6cIw4iw3V5MNdtfaTPsVre3GDyoo2ClMMGrh3mskv60ng
         8IAyMiKRu0w6fHYTbs0F5Py6hdRV/U8+8uJewjkzNv6NEJSPl4cvcIbqrU6eVhYGFX9i
         h8eA==
X-Gm-Message-State: AOAM531OJkuD0OdndXabouS2RFU5gg1bJ3QCY2bL/TIJC6WyPTnuUMB+
        AQ612vQEluHDgWNN0Bh5wEeHZKv6FATIjrnoPWbRNQ==
X-Google-Smtp-Source: ABdhPJxPXmxDhDcpG/xr00G64nc2LvXbICU1R/w7Fpq8ypWjBl9rRkmPWUVy5xa0aUDK6+qGz35xVg==
X-Received: by 2002:a17:90a:8d85:b0:1b8:a215:e3e4 with SMTP id d5-20020a17090a8d8500b001b8a215e3e4mr3128655pjo.175.1648690698193;
        Wed, 30 Mar 2022 18:38:18 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7920d000000b004fa94f26b48sm24102882pfo.118.2022.03.30.18.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 18:38:17 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v4 1/2] Simplify XFS logging methods.
Date:   Wed, 30 Mar 2022 18:38:05 -0700
Message-Id: <d51e0e0ffc7709010f601ab3c910056379479143.1648690634.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rather than have a constructor to define many nearly-identical
functions, use preprocessor macros to pass down a kernel logging level
to a common function.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
---

Notes:
    [PATCH v1]
      * De-duplicate kernel logging levels and tidy whitespace.
    [PATCH v2]
      * Split changes into two patches:
         - function and prototype de-duplication.
         - Adding printk indexing
    [PATCH v3]
      * Add a missing semicolon. *facepalm*
    [PATCH v4]
      * Fixup formatting, whitespace, and grouping.
      * Update commit message to clarify intended usage.

 fs/xfs/xfs_message.c | 54 +++++++++++++++++++-------------------------
 fs/xfs/xfs_message.h | 43 ++++++++++++++++++-----------------
 2 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bc66d95c8d4c..9ceebd4c9ff1 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -27,37 +27,29 @@ __xfs_printk(
 	printk("%sXFS: %pV\n", level, vaf);
 }
 
-#define define_xfs_printk_level(func, kern_level)		\
-void func(const struct xfs_mount *mp, const char *fmt, ...)	\
-{								\
-	struct va_format	vaf;				\
-	va_list			args;				\
-	int			level;				\
-								\
-	va_start(args, fmt);					\
-								\
-	vaf.fmt = fmt;						\
-	vaf.va = &args;						\
-								\
-	__xfs_printk(kern_level, mp, &vaf);			\
-	va_end(args);						\
-								\
-	if (!kstrtoint(kern_level, 0, &level) &&		\
-	    level <= LOGLEVEL_ERR &&				\
-	    xfs_error_level >= XFS_ERRLEVEL_HIGH)		\
-		xfs_stack_trace();				\
-}								\
-
-define_xfs_printk_level(xfs_emerg, KERN_EMERG);
-define_xfs_printk_level(xfs_alert, KERN_ALERT);
-define_xfs_printk_level(xfs_crit, KERN_CRIT);
-define_xfs_printk_level(xfs_err, KERN_ERR);
-define_xfs_printk_level(xfs_warn, KERN_WARNING);
-define_xfs_printk_level(xfs_notice, KERN_NOTICE);
-define_xfs_printk_level(xfs_info, KERN_INFO);
-#ifdef DEBUG
-define_xfs_printk_level(xfs_debug, KERN_DEBUG);
-#endif
+void
+xfs_printk_level(
+	const char *kern_level,
+	const struct xfs_mount *mp,
+	const char *fmt, ...)
+{
+	struct va_format	vaf;
+	va_list			args;
+	int			level;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	__xfs_printk(kern_level, mp, &vaf);
+
+	va_end(args);
+
+	if (!kstrtoint(kern_level, 0, &level) &&
+	    level <= LOGLEVEL_ERR &&
+	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
 
 void
 xfs_alert_tag(
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bb9860ec9a93..a281b1cc13d5 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,33 +6,34 @@
 
 struct xfs_mount;
 
-extern __printf(2, 3)
-void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(3, 4)
-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
+void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
+			const char *fmt, ...);
 
+#define xfs_emerg(mp, fmt, ...) \
+	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
+#define xfs_alert(mp, fmt, ...) \
+	xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
+#define xfs_crit(mp, fmt, ...) \
+	xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
+#define xfs_err(mp, fmt, ...) \
+	xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
+#define xfs_warn(mp, fmt, ...) \
+	xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
+#define xfs_notice(mp, fmt, ...) \
+	xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
+#define xfs_info(mp, fmt, ...) \
+	xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
 #ifdef DEBUG
-extern __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
+#define xfs_debug(mp, fmt, ...) \
+	xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
 #else
-static inline __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
-{
-}
+#define xfs_debug(mp, fmt, ...) do {} while (0)
 #endif
 
+extern __printf(3, 4)
+void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+
 #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\

base-commit: 787af64d05cd528aac9ad16752d11bb1c6061bb9
-- 
2.35.1

