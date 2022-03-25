Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E74C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 07:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351451AbiCYHij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 03:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243353AbiCYHij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 03:38:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB6CCA0CF
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:37:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so2748866pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 00:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ASXiAevM0anmghfKhcc+Vbul8W/03W5Olc2tKpCfI8=;
        b=6HIQWMBldqGp4h7Z5TumeIPxlHl7mx8an5Uq/HV9ms9HarSaUjZKojGpo0bp8TZv6w
         77zih/veZap3Wq6GKHkT7iPGkvK2swWqX6X1D1OsCdZ9mSvd9W3t1Wsh9tIH/gNWe2DW
         r03/HZXDA/jr//uk+3kgl5RzypXxaafJ2qf43Y6KpICrI8Ov22Bdgy0qkGwBQ/cdpv1o
         UXn1AdNT4wy8n/xHw/6Eyxs7RvtLT1LUdZzUA3QdpxMFViXDb1CGjpXqL6KzE+ZzwpNJ
         7VQZwtvqSvRcYJ38je4ZuOD3Ev4PPplVBEJTZppVnjYupuUYX2vpsWAFItU0BbRKa9I4
         JGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ASXiAevM0anmghfKhcc+Vbul8W/03W5Olc2tKpCfI8=;
        b=RWjlOcDg4RUxjsWEJ7qDnVkdOqkHVCPB7CFTOSoRfaVKasML3/c6PZ+FZirBLC9VtC
         LKr9Fws9x1/QCIIu4mnWJgBgNuE7Wl5RxnHvPlC1usT3nHIWE6Jo8+yUfWJNrweK5urO
         Q1nZa/mltK7cWy0Ea+W9M0npYFqbOoUzVpi882JlbLM0Qfl67zojzuFv1PpFOQRAC1dx
         0VqgMK/twgC2IM9EDLH1PEOGckYBTGuyz+Bmv9EaUb5sBfcm1XD0JwLnk55/xRzGyASl
         U7tn+ktzZfdcfrCKm5JRWZezyup1fNa6IAf4jY5tMmYFMUW4t7PodA+Cs6LUgrWFf/B8
         8ORw==
X-Gm-Message-State: AOAM5314FS70PimIIts5E8RKMyUrwRjJxn2eld1816f9TnRcfSIsY0Rk
        OWU0IwTETxNQnvPU1AfjYao6rxxj/kjaGNRN2WA=
X-Google-Smtp-Source: ABdhPJzI1zh3A5r/rZZYrOpphLAnHx6+4qTqlHSxhZJ+CSH8tJ9tYS9WlJRSUCrmtj3DA0jwMHOD3w==
X-Received: by 2002:a17:902:c3c5:b0:154:e07:275a with SMTP id j5-20020a170902c3c500b001540e07275amr10090641plj.106.1648193825015;
        Fri, 25 Mar 2022 00:37:05 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b004fb05c0f32bsm2099777pfv.185.2022.03.25.00.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 00:37:04 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v2 2/2] Add XFS messages to printk index
Date:   Fri, 25 Mar 2022 00:36:34 -0700
Message-Id: <eacb0b558128454dae753a8843e973db288ddd70.1648193655.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1db10d0c7c1d00dd4fd618f76997753784c91f36.1648193655.git.jof@thejof.com>
References: <1db10d0c7c1d00dd4fd618f76997753784c91f36.1648193655.git.jof@thejof.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system.
This printk index enables kernel developers to use calls to printk()
with changable ad-hoc format strings, while still enabling end users to
detect changes from release to release.

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
index 7c5a4d6e46f5..7a21b436b8d9 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,34 +6,45 @@
 
 struct xfs_mount;
 
+#define xfs_printk_index_wrap(kern_level, mp, fmt, ...) 	\
+({ 								\
+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
+	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
+})
 extern __printf(3, 4)
 void xfs_printk_level(
 	const char *kern_level,
 	const struct xfs_mount *mp,
 	const char *fmt, ...)
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
 
+#define xfs_alert_tag(mp, tag, fmt, ...) 			\
+({ 								\
+	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt); \
+	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__); 		\
+})
+
 extern __printf(3, 4)
-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
 
 
 #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
-- 
2.35.1

