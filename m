Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F271BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 01:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiCaBkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaBkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 21:40:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DDA13FAA
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h19so19532895pfv.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kA66vukS9VAEicg9fn9XAr7dPAMS7NdsRB1eYEHKYnY=;
        b=xos1tGABHRL8UcXpfb7bS5fkbDh35dA40zz9HNop5dE6g9ParLLRFB3CHd1GPxjqyX
         I5fK7r9+vPAEVfd+s2FS+FRpnrDI3i+cnTexoKosIwQb/4MoJ1fXwIhiQcbrP2KZXBDz
         VvM1IdCf+4nLCcFpPhRY9on42riEH/ecQY0Z50IW3TWwKxHcwBR9nY73/2j7jI+CfFl7
         3br5ReU5yS0ahdU0Jk84d20CqNLVWzWb91hViC2n0RxEj4MVG2L8doZgphSR0LFhvWMx
         kqGyOGmG27RfxYWGSGJvf9zVAsNszkmx9ov0WkZMnqXtP1nENpESGIsCZZZLDVWH93RI
         iVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kA66vukS9VAEicg9fn9XAr7dPAMS7NdsRB1eYEHKYnY=;
        b=X6um1Ox6Ia5O2kjtHhLddZyJmTVCbCpxrXzlkPpu4/hp8hF4ZZNmw0ZMukq0D3yMF0
         oUSz+2U31sMQvi/cuhGRru+kEMKJgi5gKM3eTbnm2DN2qXQDzq6QL/v+f4bETmDXkO4g
         RwMt2pIS6k+yDqqBFe4LGekvyScCDMgzhXVeW1jGvZh3X7v4UxtFahpxMb+KmNBwZzKj
         Abf2dI5iYCgsqoizXzm7tnmhreXIJg/B81q/5GbQDSSxHqKWH0nrY8uzNsw7Shjl5GIF
         aM1h4mfgZatoN5H4O7BknjqAm2v1omj8gesyYcue5QVgOZhocBYrR7aW9PtO1A7GIWIG
         IQ2A==
X-Gm-Message-State: AOAM532uArnJm9SOBMnNLGXOb2AtGC9UTIjMI7/s091rMdnG7TZuPDEH
        uDQilfchlVQkuYpOVZcoiSyfWhMBYcl6K/ZpbReRVw==
X-Google-Smtp-Source: ABdhPJxpP3XIjwOYYDvKoxezgM7qGszKlWc2CyVRA1MWgcQEp1Y5+e6adNlr2eYtWODzNwiBRBb4ZQ==
X-Received: by 2002:a05:6a00:2990:b0:4fa:dacf:2e3 with SMTP id cj16-20020a056a00299000b004fadacf02e3mr2691339pfb.67.1648690701471;
        Wed, 30 Mar 2022 18:38:21 -0700 (PDT)
Received: from banyan.flat.jof.io (192-184-176-137.fiber.dynamic.sonic.net. [192.184.176.137])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7920d000000b004fa94f26b48sm24102882pfo.118.2022.03.30.18.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 18:38:20 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v4 2/2] Add XFS messages to printk index
Date:   Wed, 30 Mar 2022 18:38:06 -0700
Message-Id: <331dd6ef9d04ad836588d8ec417b5d5d6fc35393.1648690634.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <d51e0e0ffc7709010f601ab3c910056379479143.1648690634.git.jof@thejof.com>
References: <d51e0e0ffc7709010f601ab3c910056379479143.1648690634.git.jof@thejof.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system.

This printk index enables kernel developers to use calls to printk()
with changeable format strings (as they always have; no change of
expectations), while enabling end users to examine format strings to
detect changes.
Since end users are using regular expressions to match messages printed
through printk(), being able to detect changes in chosen format strings
from release to release provides a useful signal to review
printk()-matching regular expressions for any necessary updates.

So that detailed XFS messages are captures by this printk index, this
patch wraps the xfs_<level> and xfs_alert_tag functions.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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
      * Fixup formatting in XFS printk simplification.

 fs/xfs/xfs_message.c |  2 +-
 fs/xfs/xfs_message.h | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9ceebd4c9ff1..22c2adff1260 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -52,7 +52,7 @@ xfs_printk_level(
 }
 
 void
-xfs_alert_tag(
+_xfs_alert_tag(
 	const struct xfs_mount	*mp,
 	int			panic_tag,
 	const char		*fmt, ...)
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index a281b1cc13d5..035ee3d244ac 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -10,29 +10,40 @@ extern __printf(3, 4)
 void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
 			const char *fmt, ...);
 
+#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
+({								\
+	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
+	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
+})
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
 do {									\
-- 
2.35.1

