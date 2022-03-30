Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0EEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 11:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiC3L7z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245007AbiC3L66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 07:58:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41FA31DF3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 04:55:10 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso719815wma.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 04:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yRNKKZrjiFyv0nO64y6UbJpPMETtbvgDGcPJuQWbLZ8=;
        b=Rt1NOBTx5c7rxZkLo2QUKVylU7tqfY5Pit24Otg/TdkwftMFYm4If/H1g7JXeWb4CP
         fwSo1UsG4qaEAlbVxpBrB3fk4faFNIfgJiAAJz4pgwHdus1cFvmnw0/ADLXEaa1Fw57G
         BJK+I8JIa/uGSPa0zNsjPNprYLUNHRDHMFa4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yRNKKZrjiFyv0nO64y6UbJpPMETtbvgDGcPJuQWbLZ8=;
        b=ZF/VaGDz10CWZAB7BwCC2KU+b8P10nZ4GEegP70pfMDn5ZLAsjfZ718Aoog/8Abf29
         sd9T6IOQNjnTk8ixpWCTBcVgEMz2J65zYrVzecEFKLtHD6cJ1sFXNe5ug0nBvTf1MdD/
         XWdJfKSbrFo5ddRmuIcXojrJZUiSo0Ro/qWoFWAHEnWraeXW4BXApjBI6gNzaOFAkdrP
         D20GF8at3cscy2Fq/xzahQ3hVyM0RgtpqJ9VnMNsP/aHkECh2OLmwVX/xaKTcWTvy2TL
         VXpay/XV5YbbP4J5iPnaP81y7FSaJoaGI6qbo68BlZi/AZRv2Km0RDph9UqF7ImBV7zs
         Nqmw==
X-Gm-Message-State: AOAM530h/hbct0Bvm9vhEOVZP9Memthrl9mZjx1gxvBh8GMlN8hTYnco
        1PcWtYxxdknzFnuDLWXuS09F8A==
X-Google-Smtp-Source: ABdhPJxTP5bmSch8HMM3Jsi7cYrUQHGvTn7S5pzQ7EdvZY4RKu7jW19f7EY4BohpWpmAIdIDjSXwMQ==
X-Received: by 2002:a05:600c:1c20:b0:38c:ae37:c1ae with SMTP id j32-20020a05600c1c2000b0038cae37c1aemr3961236wms.203.1648641309200;
        Wed, 30 Mar 2022 04:55:09 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:5ee4:2aff:fe50:f48d])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c1d0f00b0038c8ff8e708sm4606448wms.13.2022.03.30.04.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:55:08 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:55:08 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 1/2] Simplify XFS logging methods.
Message-ID: <YkRFHNhFcfOAeOFV@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Jonathan Lassoff writes:
>Rather than have a constructor to define many nearly-identical
>functions, use preprocessor macros to pass down a kernel logging level
>to a common function.
>
>Signed-off-by: Jonathan Lassoff <jof@thejof.com>

This is a good simplification, thanks.

Reviewed-by: Chris Down <chris@chrisdown.name>

>---
>
>Notes:
>    [PATCH v1]
>      * De-duplicate kernel logging levels and tidy whitespace.
>    [PATCH v2]
>      * Split changes into two patches:
>         - function and prototype de-duplication.
>         - Adding printk indexing
>    [PATCH v3]
>      * Fix some whitespace and semicolon. *facepalm*
>
> fs/xfs/xfs_message.c | 53 ++++++++++++++++++--------------------------
> fs/xfs/xfs_message.h | 47 +++++++++++++++++++++------------------
> 2 files changed, 47 insertions(+), 53 deletions(-)
>
>diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
>index bc66d95c8d4c..ede8a4f2f676 100644
>--- a/fs/xfs/xfs_message.c
>+++ b/fs/xfs/xfs_message.c
>@@ -27,37 +27,28 @@ __xfs_printk(
> 	printk("%sXFS: %pV\n", level, vaf);
> }
>
>-#define define_xfs_printk_level(func, kern_level)		\
>-void func(const struct xfs_mount *mp, const char *fmt, ...)	\
>-{								\
>-	struct va_format	vaf;				\
>-	va_list			args;				\
>-	int			level;				\
>-								\
>-	va_start(args, fmt);					\
>-								\
>-	vaf.fmt = fmt;						\
>-	vaf.va = &args;						\
>-								\
>-	__xfs_printk(kern_level, mp, &vaf);			\
>-	va_end(args);						\
>-								\
>-	if (!kstrtoint(kern_level, 0, &level) &&		\
>-	    level <= LOGLEVEL_ERR &&				\
>-	    xfs_error_level >= XFS_ERRLEVEL_HIGH)		\
>-		xfs_stack_trace();				\
>-}								\
>-
>-define_xfs_printk_level(xfs_emerg, KERN_EMERG);
>-define_xfs_printk_level(xfs_alert, KERN_ALERT);
>-define_xfs_printk_level(xfs_crit, KERN_CRIT);
>-define_xfs_printk_level(xfs_err, KERN_ERR);
>-define_xfs_printk_level(xfs_warn, KERN_WARNING);
>-define_xfs_printk_level(xfs_notice, KERN_NOTICE);
>-define_xfs_printk_level(xfs_info, KERN_INFO);
>-#ifdef DEBUG
>-define_xfs_printk_level(xfs_debug, KERN_DEBUG);
>-#endif
>+void xfs_printk_level(
>+	const char *kern_level,
>+	const struct xfs_mount *mp,
>+	const char *fmt, ...)
>+{
>+	struct va_format	vaf;
>+	va_list			args;
>+	int			level;
>+
>+	va_start(args, fmt);
>+	vaf.fmt = fmt;
>+	vaf.va = &args;
>+
>+	__xfs_printk(kern_level, mp, &vaf);
>+
>+	va_end(args);
>+
>+	if (!kstrtoint(kern_level, 0, &level) &&
>+	    level <= LOGLEVEL_ERR &&
>+	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
>+		xfs_stack_trace();
>+}
>
> void
> xfs_alert_tag(
>diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
>index bb9860ec9a93..2f609800e806 100644
>--- a/fs/xfs/xfs_message.h
>+++ b/fs/xfs/xfs_message.h
>@@ -6,33 +6,36 @@
>
> struct xfs_mount;
>
>-extern __printf(2, 3)
>-void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
> extern __printf(3, 4)
>-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
>-extern __printf(2, 3)
>-void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
>-
>+void xfs_printk_level(
>+	const char *kern_level,
>+	const struct xfs_mount *mp,
>+	const char *fmt, ...);
>+#define xfs_emerg(mp, fmt, ...) \
>+	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
>+#define xfs_alert(mp, fmt, ...) \
>+	xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
>+#define xfs_crit(mp, fmt, ...) \
>+	xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
>+#define xfs_err(mp, fmt, ...) \
>+	xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
>+#define xfs_warn(mp, fmt, ...) \
>+	xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
>+#define xfs_notice(mp, fmt, ...) \
>+	xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
>+#define xfs_info(mp, fmt, ...) \
>+	xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
> #ifdef DEBUG
>-extern __printf(2, 3)
>-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
>+#define xfs_debug(mp, fmt, ...) \
>+	xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> #else
>-static inline __printf(2, 3)
>-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>-{
>-}
>+#define xfs_debug(mp, fmt, ...) do {} while (0)
> #endif
>
>+extern __printf(3, 4)
>+void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
>+
>+
> #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
> do {									\
> 	static DEFINE_RATELIMIT_STATE(_rs,				\
>
>base-commit: 34af78c4e616c359ed428d79fe4758a35d2c5473
>-- 
>2.35.1
>
