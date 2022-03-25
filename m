Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC4BC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 07:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350618AbiCYHid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 03:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243279AbiCYHic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 03:38:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E26CA0C9
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:36:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p8so5805723pfh.8
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZx4uUr2dZ0glNGRaOG+LDN9ZvW+K2BzIKmLwXThl8E=;
        b=Ok2P6uz+RRdCNHLpBhVHUNc3ELux11Z+4ywZN0WQ0Mx8Lk6fz2WE6BTz/TIyOFtefH
         xdGreD5wf5kzqYF/ERS/mTAVQu2YHPKmGn84L6BDtfc/sUJwHH2vGxqSdTUboG2RHSH1
         Gp+91e7qCdlzPyqMhVauyf5hs+jsABp9IYlTrY1xmdrW0AAOC28VnjH9dw6EuBLh/OS4
         yH6B5sv/BsV/OPEsvjI5OQ0+UAI/cq6918rUEehGmmuhmkIr+892pzk7ebbaMPCkSwQO
         cuQro3WQ2l6IP03UcLd6PUg3wjXbwJtCc8FrddSsyeZzoipp/0QQqNOSFSuD7no+Xnqg
         zqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZx4uUr2dZ0glNGRaOG+LDN9ZvW+K2BzIKmLwXThl8E=;
        b=CBlfLKXhx6eXBwFuLR2ZNoMkSnD15FcZz4cK5xsBGOKWec1R6z9DhOpDcqqaPeC/uN
         V4aUhMvImn9M/EVm5phcD/mb50y1Fot310qBPm8O5g2zJ43xTrJbHdK2StdqnjWdB25p
         Xz9LYl0+wF3fqctm+QlekbWxRY4nFl/CWpAz1KF7ROCFPFf0DqIkAhi4PgvQZcuTDP9l
         KkJUJc3g9CtOg3sSwlHaN+OZuvwbfa/2mth1doRRBud5XRtqboYIe7GNtKiXfcAZBKXb
         Vm9qj+gDPBy6bh1nhhYqOGcGNfpprd/Zw8idfJ7Anu+veoesqszWjyqMbWRGhdaxAZZA
         icUw==
X-Gm-Message-State: AOAM533egbMbotuZiEEIiwDgzzsXH1bNKG2wSeMWsKHt8BShLoYkIMfH
        FbSh2LkcOE7WjJa6fX5B0fjfhYDbvuWw6zfdORA=
X-Google-Smtp-Source: ABdhPJznf+S0DABCbiCbpAbP87iuAi1jMLwt/fq77tSsJ30Mw1lAud5m3D3mmr0TdiLa8p+jF5CymA==
X-Received: by 2002:a63:111a:0:b0:382:3e2d:c237 with SMTP id g26-20020a63111a000000b003823e2dc237mr6938436pgl.22.1648193816968;
        Fri, 25 Mar 2022 00:36:56 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b004fb05c0f32bsm2099777pfv.185.2022.03.25.00.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 00:36:56 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v2 1/2] Simplify XFS logging methods.
Date:   Fri, 25 Mar 2022 00:36:33 -0700
Message-Id: <1db10d0c7c1d00dd4fd618f76997753784c91f36.1648193655.git.jof@thejof.com>
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
---

Notes:
    [PATCH v1]
      * De-duplicate kernel logging levels and tidy whitespace.
    [PATCH v2]
      * Split changes into two patches:
         - function and prototype de-duplication.
         - Adding printk indexing

 fs/xfs/xfs_message.c | 53 ++++++++++++++++++--------------------------
 fs/xfs/xfs_message.h | 47 +++++++++++++++++++++------------------
 2 files changed, 47 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bc66d95c8d4c..ede8a4f2f676 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -27,37 +27,28 @@ __xfs_printk(
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
+void xfs_printk_level(
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
index bb9860ec9a93..7c5a4d6e46f5 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,33 +6,36 @@
 
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
-
+void xfs_printk_level(
+	const char *kern_level,
+	const struct xfs_mount *mp,
+	const char *fmt, ...)
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
+
 #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\

base-commit: 34af78c4e616c359ed428d79fe4758a35d2c5473
-- 
2.35.1

