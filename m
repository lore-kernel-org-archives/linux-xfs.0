Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A495C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 12:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344900AbiC3MRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346521AbiC3MQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 08:16:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9652E4EA0F
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 05:07:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h4so28943842wrc.13
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 05:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ycSjWjKJJKABctxiaczwIlAkhOAz1JUWyd7MSKGp/lc=;
        b=vBiJkmP/tCEZCLAZEXtn/RHkhJ4+FNXeF7oRyU1Eh2h90BlmtKn/k/J7JfGRzJ6HHf
         lmBYmahL4nBGXTbqp+bfB14lvmffOAmnN683ZvzyDO6o8Zia9To4/jZ4r7mZeuADO84H
         1hwcVEwpLuEcdhOv1pNHNHaJm/VmE+HA9wABE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ycSjWjKJJKABctxiaczwIlAkhOAz1JUWyd7MSKGp/lc=;
        b=QkGMBQXJv5h/4g4J57fJg1lD0GMXAODdQz5bRvxsIwJUScZHo1Q8FO4g/T/1x1q72S
         I+Nln2aceZOoEcIzO+igqLLili5uf+CuduMLv/PQm6QSP5d47ab90L2RKoAFggLLkEaL
         y33FYSuOlQ28s1vB6JeiqbYvvwVAX4wNgUTBdYmxkuuS4WkmAylZy4YEkaLSZDtndbkU
         aGsXLjDmFAQXOVu5Q235EWNOCFbAWhuT653U69MuKMkCMCpmSwe00wGv0+9vTIB+N/1V
         7M7Gh7JK6sLt4MBqB3YBI7oddIDyDeEk46DEwq6BA1XokidUMoHGnOH+i9aEn66m1BQt
         TJFw==
X-Gm-Message-State: AOAM532Cu23NiLRWmiNfIsbnTmjbJyCYwAl8T5zOcIPN06wp1U26/bb3
        UN9uPYX1eILRSR3gAePWHP+jWQ==
X-Google-Smtp-Source: ABdhPJzQvNjzsW1HCgaAb9B7pVtUkhFMe9hhECwT9YzA+BROVmQxrGGuKMrr5RIZfhk+mGxCk1rM8g==
X-Received: by 2002:adf:e7cd:0:b0:204:ba2:b106 with SMTP id e13-20020adfe7cd000000b002040ba2b106mr36003700wrn.679.1648642056020;
        Wed, 30 Mar 2022 05:07:36 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:5ee4:2aff:fe50:f48d])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c4f9600b0038c6ec42c38sm4614479wmq.6.2022.03.30.05.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 05:07:35 -0700 (PDT)
Date:   Wed, 30 Mar 2022 13:07:34 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkRIBtx2qMtu9wPG@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Jonathan Lassoff writes:
>In order for end users to quickly react to new issues that come up in
>production, it is proving useful to leverage the printk indexing system.
>This printk index enables kernel developers to use calls to printk()
>with changeable ad-hoc format strings, while still enabling end users
>to detect changes from release to release.
>
>So that detailed XFS messages are captures by this printk index, this
>patch wraps the xfs_<level> and xfs_alert_tag functions.
>
>Signed-off-by: Jonathan Lassoff <jof@thejof.com>

After Dave's suggested whitespace/ordering fixup, feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks!

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
> fs/xfs/xfs_message.c |  2 +-
> fs/xfs/xfs_message.h | 29 ++++++++++++++++++++---------
> 2 files changed, 21 insertions(+), 10 deletions(-)
>
>diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
>index ede8a4f2f676..f01efad20420 100644
>--- a/fs/xfs/xfs_message.c
>+++ b/fs/xfs/xfs_message.c
>@@ -51,7 +51,7 @@ void xfs_printk_level(
> }
>
> void
>-xfs_alert_tag(
>+_xfs_alert_tag(
> 	const struct xfs_mount	*mp,
> 	int			panic_tag,
> 	const char		*fmt, ...)
>diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
>index 2f609800e806..6f9a1b67c4d7 100644
>--- a/fs/xfs/xfs_message.h
>+++ b/fs/xfs/xfs_message.h
>@@ -6,34 +6,45 @@
>
> struct xfs_mount;
>
>+#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
>+({								\
>+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
>+	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
>+})
> extern __printf(3, 4)
> void xfs_printk_level(
> 	const char *kern_level,
> 	const struct xfs_mount *mp,
> 	const char *fmt, ...);
> #define xfs_emerg(mp, fmt, ...) \
>-	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> #define xfs_alert(mp, fmt, ...) \
>-	xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> #define xfs_crit(mp, fmt, ...) \
>-	xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> #define xfs_err(mp, fmt, ...) \
>-	xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> #define xfs_warn(mp, fmt, ...) \
>-	xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> #define xfs_notice(mp, fmt, ...) \
>-	xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> #define xfs_info(mp, fmt, ...) \
>-	xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_INFO, mp, fmt, ##__VA_ARGS__)
> #ifdef DEBUG
> #define xfs_debug(mp, fmt, ...) \
>-	xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
>+	xfs_printk_index_wrap(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> #else
> #define xfs_debug(mp, fmt, ...) do {} while (0)
> #endif
>
>+#define xfs_alert_tag(mp, tag, fmt, ...)			\
>+({								\
>+	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt);	\
>+	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);		\
>+})
>+
> extern __printf(3, 4)
>-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
>+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
>
>
> #define xfs_printk_ratelimited(func, dev, fmt, ...)			\
>-- 
>2.35.1
>
