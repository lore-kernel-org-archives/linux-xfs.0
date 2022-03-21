Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16780C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 23:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiCUXVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiCUXVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 19:21:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA573C9551
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 16:11:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so769883pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 16:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hdNb4cyN2SFrIShZ7CyvQHQAmOXhKX04Oyezl8DjWg=;
        b=N4TRSkaP8XIGBwA/YFFOdkt+Qn4G0EbuwPPq/MvoXsOWT21FQxwYKgVYzPLdcOsPFm
         AkxCjmuJ9k8AFPMmnAFh3YuHbdwmiM6NFr2+c6avwlCSuj5bptH+k2s04/mmws5iQGBc
         WMYuBLLCRdMkua4cUR8HxRuRmSUL4k88dhmdJUeuqGu7WXb9YWg+KQXIrwk5NmGCX/Ix
         alKbQX22bKneqvmVpTVLvZis3igKvRctD0mYtAWSwtRz0asVg0AG/yeb61tCg3tMJ+iU
         nf4tEJ3JsTACPXTCyLmouIy/B5DRawXQz0blxVBt+VkFGgVntoZZ1SQaoyMKgYDowaR9
         nedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hdNb4cyN2SFrIShZ7CyvQHQAmOXhKX04Oyezl8DjWg=;
        b=UVJMvoawryM2uj16rQo49z6a2jakOKGFU6fpEkrlaVk2ZcsE0gTksDcS56E8Uc53YN
         oYhk5szSVVw0He5Ak5MXz53MR2ZF5gdxJnd12W2f5gKLIPiD1eiHHSct5eLYcslBD7lx
         ZlbSX4nboyfqQiZJOM/skhyH03Xm4qFdqHIwJl5ePaHd8hplasvrIrEQmwoG+our64f4
         Y1SrVWJDGPt+wYHnNA6C4xt2XVm+a0OXolHoI7RSlGH5Q+njvD/7jnccN0wv8N1yaYVb
         2GrOn7DFeWdWhF6xt0W0j6yCy/kCaC0Y/gcZUO5sV+3PibjssPiffAaz+PxPvebUeFMK
         FwNw==
X-Gm-Message-State: AOAM530n+dQPakosR0YZBlUkI0zWZlJMHReoCFoP6AxIWg9A6bC8OpJB
        0EIke2wgY6S2y4VDRvdZY3rHZ4gaHZ2YCpfSVAQ=
X-Google-Smtp-Source: ABdhPJyABz0I1sHUONA2PIaL6KPZADWK80AhavsjU+d3dsRj2qfwDskILqNSE7Cv8ItaO55Nu4boHw==
X-Received: by 2002:a17:90b:46d3:b0:1c6:ac97:71d with SMTP id jx19-20020a17090b46d300b001c6ac97071dmr1598289pjb.104.1647904312534;
        Mon, 21 Mar 2022 16:11:52 -0700 (PDT)
Received: from oak.jof.github.beta.tailscale.net ([2601:645:8780:7d20::7119])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a005000b001c7511dc31esm452355pjb.41.2022.03.21.16.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:11:51 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v1] Add XFS messages to printk index
Date:   Mon, 21 Mar 2022 23:11:23 +0000
Message-Id: <20220321231123.73487-1-jof@thejof.com>
X-Mailer: git-send-email 2.30.2
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

[PATCH v1] -- De-duplicate kernel logging levels and tidy whitespace.
---
 fs/xfs/xfs_message.c | 68 +++++++++++++++++++-----------------
 fs/xfs/xfs_message.h | 82 ++++++++++++++++++++++++++++++++------------
 2 files changed, 97 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bc66d95c8d4c..8f29d8e86482 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -21,46 +21,50 @@ __xfs_printk(
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
+#define define_xfs_printk_level(func)			\
+void func(						\
+	const char *kern_level,				\
+	const struct xfs_mount *mp,			\
+	const char *fmt,				\
+	...)						\
+{							\
+	struct va_format	vaf;			\
+	va_list			args;			\
+	int			level;			\
+							\
+	va_start(args, fmt);				\
+							\
+	vaf.fmt = fmt;					\
+	vaf.va = &args;					\
+							\
+	__xfs_printk(kern_level, mp, &vaf);		\
+	va_end(args);					\
+							\
+	if (!kstrtoint(kern_level, 0, &level) &&	\
+	    level <= LOGLEVEL_ERR &&			\
+	    xfs_error_level >= XFS_ERRLEVEL_HIGH)	\
+		xfs_stack_trace();			\
+}							\
+
+define_xfs_printk_level(_xfs_emerg);
+define_xfs_printk_level(_xfs_alert);
+define_xfs_printk_level(_xfs_crit);
+define_xfs_printk_level(_xfs_err);
+define_xfs_printk_level(_xfs_warn);
+define_xfs_printk_level(_xfs_notice);
+define_xfs_printk_level(_xfs_info);
 #ifdef DEBUG
-define_xfs_printk_level(xfs_debug, KERN_DEBUG);
+define_xfs_printk_level(_xfs_debug);
 #endif
 
 void
-xfs_alert_tag(
+_xfs_alert_tag(
 	const struct xfs_mount	*mp,
 	int			panic_tag,
 	const char		*fmt, ...)
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bb9860ec9a93..6f9d4a3553de 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,31 +6,71 @@
 
 struct xfs_mount;
 
-extern __printf(2, 3)
-void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
-extern __printf(2, 3)
-void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
+#define xfs_printk_index_wrap(_p_func, kern_level, mp, fmt, ...)		\
+({										\
+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt, ##__VA_ARGS__);	\
+	_p_func(kern_level, mp, fmt, ##__VA_ARGS__);				\
+})
+#define xfs_alert_tag(mp, tag, fmt, ...)					\
+({										\
+	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt, ##__VA_ARGS__);	\
+	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);				\
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
+extern __printf(3, 4)
+void _xfs_emerg(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_alert(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
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
+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_crit(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_err(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_warn(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_notice(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_info(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
 
 #ifdef DEBUG
-extern __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void _xfs_debug(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
 #else
-static inline __printf(2, 3)
-void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
-{
-}
+extern __printf(3, 4)
+void _xfs_debug(
+	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...)
+{}
 #endif
 
 #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
-- 
2.30.2

