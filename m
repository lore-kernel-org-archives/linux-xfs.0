Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D20C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 17:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiCYRcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiCYRco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 13:32:44 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FDE10661A
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 10:31:01 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id o64so8861362oib.7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmnY4UKODPvGT0h8O/j5MRMKTjVVz8tCwP4rsRqPqi0=;
        b=y5VbOklkLOPQX+5sgIjKCHQbp6c6e9YV8b2be9TDS8qScdrILv21Xw1DcadJzWDxTK
         MKeZEkgrHFbioX6Nsk4StP1b/55D99muVy+ehw8psm6gC6rE9gqPhE+lAT20MKobGCTE
         IERVixpIff9A90jV9TDnIh6tGnTzJKfD/RwWQ/mbu1lddU4TBZmK0q95SWzE4MgD2gaE
         HZGgTSPMNX8AF/WW+W10+ukptuwQR71bm4FBB9IUMHGeZ+ytz3351XsAThutCl6BP4vu
         6jiOTOgdfhTrOkwgQJ3pYWApAcRkU/QN954mTwIbLskW3bbm0ZuL6gJs6gErxw6858Jo
         d9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmnY4UKODPvGT0h8O/j5MRMKTjVVz8tCwP4rsRqPqi0=;
        b=bNVDpmBMaiSAbK2yyy1TLKpWJCkDwsoDKCn+MFUOd6TOwe8/rSrtWPQy8qmnpV1sUj
         HNIQaJIFiM932sBrBc3MrcTlAgClnkKCs26FCvhj0VXCURPB1cY39kjNo62DQBS7lirc
         Y1ceH85HDIymUQbPChH7gC31ETGn/7uE9k4k0FeW8rGlj/sYe1cppwkPBxs/wbIQf1ST
         c5Dmp6AppzbMWvcocT3vi+zqdJXvD/rs6LY+hpHFCft1Cpzd6ts86Tv82kCBMpJYUqGK
         kwNqGNEA+TgIyzGHYHJTlYHZCp22TlLPf7Z73Ga/sJ7EIJAimcWTuwqTGEkB7UpnJOEM
         CGnA==
X-Gm-Message-State: AOAM532Ps8J/sgzCcapbd19F4HrQ8wBK2BGrM5utiyZpA5k6MIsMg/01
        6/PgM3vCCovewl1K/58beEhRdZojhUyFWQUOUlc=
X-Google-Smtp-Source: ABdhPJzyq+QxwRRonUdkD0Mcqxk17BJq+BcSWGvzIRg235rStvcH+B0UbOingrnTP/+XDpHuNx0XoA==
X-Received: by 2002:a17:90a:1197:b0:1bf:65ff:f542 with SMTP id e23-20020a17090a119700b001bf65fff542mr25676898pja.5.1648228794342;
        Fri, 25 Mar 2022 10:19:54 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id pc13-20020a17090b3b8d00b001c775679f58sm11175961pjb.37.2022.03.25.10.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 10:19:53 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v3 1/2] Simplify XFS logging methods.
Date:   Fri, 25 Mar 2022 10:19:45 -0700
Message-Id: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
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
    [PATCH v3]
      * Fix some whitespace and semicolon. *facepalm*

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
index bb9860ec9a93..2f609800e806 100644
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
+	const char *fmt, ...);
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

