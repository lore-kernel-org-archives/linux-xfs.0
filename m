Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48711C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 23:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbiC2X4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 19:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbiC2X43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 19:56:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6BE455B7
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 16:54:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B6EBE10E536D;
        Wed, 30 Mar 2022 10:54:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZLfd-00BU2i-MY; Wed, 30 Mar 2022 10:54:41 +1100
Date:   Wed, 30 Mar 2022 10:54:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 1/2] Simplify XFS logging methods.
Message-ID: <20220329235441.GZ1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62439c44
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=Ot3N2O21AAAA:8 a=7-415B0cAAAA:8
        a=plmIhSBJIFYI42QW18UA:9 a=CjuIK1q_8ugA:10 a=-F6LaNPAekqF0pxxGpLN:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 25, 2022 at 10:19:45AM -0700, Jonathan Lassoff wrote:
> Rather than have a constructor to define many nearly-identical
> functions, use preprocessor macros to pass down a kernel logging level
> to a common function.
> 
> Signed-off-by: Jonathan Lassoff <jof@thejof.com>

Mostly looks good, mainly just whitespace/formatting consistency
issues now.

....
> -define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> -define_xfs_printk_level(xfs_alert, KERN_ALERT);
> -define_xfs_printk_level(xfs_crit, KERN_CRIT);
> -define_xfs_printk_level(xfs_err, KERN_ERR);
> -define_xfs_printk_level(xfs_warn, KERN_WARNING);
> -define_xfs_printk_level(xfs_notice, KERN_NOTICE);
> -define_xfs_printk_level(xfs_info, KERN_INFO);
> -#ifdef DEBUG
> -define_xfs_printk_level(xfs_debug, KERN_DEBUG);
> -#endif
> +void xfs_printk_level(
> +	const char *kern_level,
> +	const struct xfs_mount *mp,
> +	const char *fmt, ...)

Use the same format as __xfs_printk() and xfs_alert_tag():

void
xfs_printk_level(
	const char		*kern_level,
	const struct xfs_mount	*mp,
	const char		*fmt, ...)

> +{
> +	struct va_format	vaf;
> +	va_list			args;
> +	int			level;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	__xfs_printk(kern_level, mp, &vaf);
> +
> +	va_end(args);
> +
> +	if (!kstrtoint(kern_level, 0, &level) &&
> +	    level <= LOGLEVEL_ERR &&
> +	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
> +		xfs_stack_trace();
> +}
>  
>  void
>  xfs_alert_tag(
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bb9860ec9a93..2f609800e806 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,33 +6,36 @@
>  
>  struct xfs_mount;
>  
> -extern __printf(2, 3)
> -void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
>  extern __printf(3, 4)
> -void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
> -
> +void xfs_printk_level(
> +	const char *kern_level,
> +	const struct xfs_mount *mp,
> +	const char *fmt, ...);

This still needs the __printf() attribute because we still want the
compiler to check the printf format string for issues. Also the
format for function prototypes should follow the ones that got
removed:

extern __printf(3, 4)
void xfs_printk_level(const struct xfs_mount *mp, const char *fmt,
		const char *fmt, ...);

There also needs to be an empty line between the prototype and the
following defines - the empty line provides demarcation between
prototype and the macro definitions that then use it.

> +#define xfs_emerg(mp, fmt, ...) \
> +	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> +#define xfs_alert(mp, fmt, ...) \
> +	xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> +#define xfs_crit(mp, fmt, ...) \
> +	xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> +#define xfs_err(mp, fmt, ...) \
> +	xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> +#define xfs_warn(mp, fmt, ...) \
> +	xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> +#define xfs_notice(mp, fmt, ...) \
> +	xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> +#define xfs_info(mp, fmt, ...) \
> +	xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
>  #ifdef DEBUG
> -extern __printf(2, 3)
> -void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
> +#define xfs_debug(mp, fmt, ...) \
> +	xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
>  #else
> -static inline __printf(2, 3)
> -void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> -{
> -}
> +#define xfs_debug(mp, fmt, ...) do {} while (0)
>  #endif
>  
> +extern __printf(3, 4)
> +void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> +
> +

And one to many extra blank lines here :)

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
