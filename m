Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E116BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 01:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiCaBkO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaBkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 21:40:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42C013FAA
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:25 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b24so26450150edu.10
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 18:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gAgRS/ShScj1cT+FPSiK6LTNDcAE+AwE8jKvwbqdpyY=;
        b=LfQ6N5ooCoZT66+7rFuHe/SJy/tqUrRrTSfxpP2M6YCAXEdB5J/Qc5iM8lFB1OnZG0
         7ioujkNeKR37d8Yin+sybUdHCb6AbHZBJS5QZ92Kmq0zZMWIYk8N8YH8lIHDQs277HhX
         GvU9+/mLdxiLt8EtciQ4xl7V9XcXNmzphjeNHCyk4RMcEFFFQkobnOqfF956cGMC716T
         J1XYK0oeS7/ZulGHiERnropTuZ1ATVfCZaYvmm8dmNbNQTTkSWBClMVTqtgyLAIUdIDV
         MzUqv41CNsI8iK3FZAsKA+o/KQYBz0R/WKNPOyGua4Mvu3NHVAqU2Bzd6O5RLXICIg79
         T4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gAgRS/ShScj1cT+FPSiK6LTNDcAE+AwE8jKvwbqdpyY=;
        b=Gj3YJY2uRiYlO+M8z0bbOcMdWWYMk8bLf444W+1r4V3oxweE5k51xxKVmhGUvBrg60
         B9BwAS9m2cYRagAoyK9/wCh+tVmaqEX0yfS6jFB9mTKzLArltmkxATdc65OCcOnBGH5Q
         mBHn8d+6B98kogcDtyv0ASbIbYcvvCiygrf1UlPa4fUirQO0YBw/Z2gBRNZDkwaNf7vz
         NLNJq9FxMCu+FAKJHjGjVHRilVSY+tBru2x12p5km/KCNSF5+bCVkLcVNsw2R2SUputU
         2bLQAtft3fU9ym54aK/ylfLLgDBJumWsBIInf2U4mdOenC7cLoqTK3X9jEtvTRlEm5in
         zvJw==
X-Gm-Message-State: AOAM532z/3MOiOdhjU/V74L81A4W2KpsXorXXohFXd0EY+kjCYFAirI6
        W+dow8JMJ3ouUMRtHoTLp4fBgPXN/Lz+Rtx5qycQrA==
X-Google-Smtp-Source: ABdhPJwBCWlYhyoiuImpTUNlab8CXn72EhWkk7+V5zC+tq3ch+5v+4uEd/TnDZ31R9wQpvmPHQJTptpQKvxlOm7YXTA=
X-Received: by 2002:a05:6402:1706:b0:419:1548:8119 with SMTP id
 y6-20020a056402170600b0041915488119mr14239618edu.126.1648690704322; Wed, 30
 Mar 2022 18:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com> <YkRIBtx2qMtu9wPG@chrisdown.name>
In-Reply-To: <YkRIBtx2qMtu9wPG@chrisdown.name>
From:   Jonathan Lassoff <jof@thejof.com>
Date:   Thu, 31 Mar 2022 01:38:13 +0000
Message-ID: <CAHsqw9sgryk2icrij2Vax-=jO8RRG_MkdeiopYc+b+G6h+A0Rg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
To:     Chris Down <chris@chrisdown.name>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks for the useful feedback from all. I've integrated the
formatting suggestions and will follow up with a [PATCH v4] set.

My initial commit message describing a "semi-stable interface" was a
poor choice of words on my part. My idea of "interface" was users
comparing the index entries from release to release and developing on
top of that; I didn't take into consideration the contextual meaning
of "interface" in Kernel development. This change doesn't create or
alter any interfaces, this just makes the backing store of information
for an existing interface more correct and complete.
It is my hope that once these changes are made, XFS maintainers will
hardly need to engage with or keep track of this printk indexing
effort. These are only needed because printk() isn't called directly.

-- jof

On Wed, 30 Mar 2022 at 12:07, Chris Down <chris@chrisdown.name> wrote:
>
> Jonathan Lassoff writes:
> >In order for end users to quickly react to new issues that come up in
> >production, it is proving useful to leverage the printk indexing system.
> >This printk index enables kernel developers to use calls to printk()
> >with changeable ad-hoc format strings, while still enabling end users
> >to detect changes from release to release.
> >
> >So that detailed XFS messages are captures by this printk index, this
> >patch wraps the xfs_<level> and xfs_alert_tag functions.
> >
> >Signed-off-by: Jonathan Lassoff <jof@thejof.com>
>
> After Dave's suggested whitespace/ordering fixup, feel free to add:
>
> Reviewed-by: Chris Down <chris@chrisdown.name>
>
> Thanks!
>
> >---
> >
> >Notes:
> >    [PATCH v1]
> >      * De-duplicate kernel logging levels and tidy whitespace.
> >    [PATCH v2]
> >      * Split changes into two patches:
> >         - function and prototype de-duplication.
> >         - Adding printk indexing
> >    [PATCH v3]
> >      * Fix some whitespace and semicolon. *facepalm*
> >
> > fs/xfs/xfs_message.c |  2 +-
> > fs/xfs/xfs_message.h | 29 ++++++++++++++++++++---------
> > 2 files changed, 21 insertions(+), 10 deletions(-)
> >
> >diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> >index ede8a4f2f676..f01efad20420 100644
> >--- a/fs/xfs/xfs_message.c
> >+++ b/fs/xfs/xfs_message.c
> >@@ -51,7 +51,7 @@ void xfs_printk_level(
> > }
> >
> > void
> >-xfs_alert_tag(
> >+_xfs_alert_tag(
> >       const struct xfs_mount  *mp,
> >       int                     panic_tag,
> >       const char              *fmt, ...)
> >diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> >index 2f609800e806..6f9a1b67c4d7 100644
> >--- a/fs/xfs/xfs_message.h
> >+++ b/fs/xfs/xfs_message.h
> >@@ -6,34 +6,45 @@
> >
> > struct xfs_mount;
> >
> >+#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)               \
> >+({                                                            \
> >+      printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
> >+      xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);   \
> >+})
> > extern __printf(3, 4)
> > void xfs_printk_level(
> >       const char *kern_level,
> >       const struct xfs_mount *mp,
> >       const char *fmt, ...);
> > #define xfs_emerg(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> > #define xfs_alert(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> > #define xfs_crit(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> > #define xfs_err(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> > #define xfs_warn(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> > #define xfs_notice(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> > #define xfs_info(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_INFO, mp, fmt, ##__VA_ARGS__)
> > #ifdef DEBUG
> > #define xfs_debug(mp, fmt, ...) \
> >-      xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> >+      xfs_printk_index_wrap(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> > #else
> > #define xfs_debug(mp, fmt, ...) do {} while (0)
> > #endif
> >
> >+#define xfs_alert_tag(mp, tag, fmt, ...)                      \
> >+({                                                            \
> >+      printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt); \
> >+      _xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);            \
> >+})
> >+
> > extern __printf(3, 4)
> >-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> >+void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> >
> >
> > #define xfs_printk_ratelimited(func, dev, fmt, ...)                   \
> >--
> >2.35.1
> >
