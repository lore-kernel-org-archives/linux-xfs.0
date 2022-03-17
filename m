Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B6EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 23:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiCQXRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCQXRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 19:17:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E126719EC4D
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 16:16:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 09DEE533C53;
        Fri, 18 Mar 2022 10:16:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUzLw-006irE-28; Fri, 18 Mar 2022 10:16:20 +1100
Date:   Fri, 18 Mar 2022 10:16:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v0 1/2] Add XFS messages to printk index
Message-ID: <20220317231620.GC1544202@dread.disaster.area>
References: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6233c146
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=Ot3N2O21AAAA:8 a=7-415B0cAAAA:8
        a=aGOAcfblpISUKGN0hKUA:9 a=CjuIK1q_8ugA:10 a=-F6LaNPAekqF0pxxGpLN:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 10:32:07PM -0700, Jonathan Lassoff wrote:
> In order for end users to quickly react to new issues that come up in
> production, it is proving useful to leverage the printk indexing system.
> This printk index enables kernel developers to use calls to printk()
> with changable ad-hoc format strings, while still enabling end users to
> detect changes and develop a semi-stable interface for detecting and
> parsing these messages.
> 
> So that detailed XFS messages are captures by this printk index, this
> patch wraps the xfs_<level> and xfs_alert_tag functions.
> 
> Signed-off-by: Jonathan Lassoff <jof@thejof.com>
> ---
>  fs/xfs/xfs_message.c | 22 +++++++++----------
>  fs/xfs/xfs_message.h | 52 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 53 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index bc66d95c8d4c..cf86d5dd7ba8 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -21,10 +21,10 @@ __xfs_printk(
>  	struct va_format	*vaf)
>  {
>  	if (mp && mp->m_super) {
> -		printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
> +		_printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
>  		return;
>  	}
> -	printk("%sXFS: %pV\n", level, vaf);
> +	_printk("%sXFS: %pV\n", level, vaf);
>  }
>  
>  #define define_xfs_printk_level(func, kern_level)		\
> @@ -48,19 +48,19 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
>  		xfs_stack_trace();				\
>  }								\
>  
> -define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> -define_xfs_printk_level(xfs_alert, KERN_ALERT);
> -define_xfs_printk_level(xfs_crit, KERN_CRIT);
> -define_xfs_printk_level(xfs_err, KERN_ERR);
> -define_xfs_printk_level(xfs_warn, KERN_WARNING);
> -define_xfs_printk_level(xfs_notice, KERN_NOTICE);
> -define_xfs_printk_level(xfs_info, KERN_INFO);
> +define_xfs_printk_level(_xfs_emerg, KERN_EMERG);
> +define_xfs_printk_level(_xfs_alert, KERN_ALERT);
> +define_xfs_printk_level(_xfs_crit, KERN_CRIT);
> +define_xfs_printk_level(_xfs_err, KERN_ERR);
> +define_xfs_printk_level(_xfs_warn, KERN_WARNING);
> +define_xfs_printk_level(_xfs_notice, KERN_NOTICE);
> +define_xfs_printk_level(_xfs_info, KERN_INFO);
>  #ifdef DEBUG
> -define_xfs_printk_level(xfs_debug, KERN_DEBUG);
> +define_xfs_printk_level(_xfs_debug, KERN_DEBUG);
>  #endif
>  
>  void
> -xfs_alert_tag(
> +_xfs_alert_tag(
>  	const struct xfs_mount	*mp,
>  	int			panic_tag,
>  	const char		*fmt, ...)
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bb9860ec9a93..2d90daf96946 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,29 +6,61 @@
>  
>  struct xfs_mount;
>  
> +#define xfs_printk_index_wrap(_p_func, kern_level, mp, fmt, ...) \
> +({\
> +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt, ##__VA_ARGS__);\
> +	_p_func(mp, fmt, ##__VA_ARGS__);\
> +})
> +#define xfs_alert_tag(mp, tag, fmt, ...) \
> +({\
> +	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt, ##__VA_ARGS__);\
> +	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);\
> +})
> +#define xfs_emerg(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_emerg, KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> +#define xfs_alert(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_alert, KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> +#define xfs_crit(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_crit, KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> +#define xfs_err(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_err, KERN_ERR, mp, fmt, ##__VA_ARGS__)
> +#define xfs_warn(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_warn, KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> +#define xfs_notice(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_notice, KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> +#define xfs_info(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_info, KERN_INFO, mp, fmt, ##__VA_ARGS__)
> +#ifdef DEBUG
> +#define xfs_debug(mp, fmt, ...)\
> +	xfs_printk_index_wrap(_xfs_debug, KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> +#else
> +#define xfs_debug(mp, fmt, ...) do {} while (0)
> +#endif

That's a nasty mess. To begin with, we most definitely do not want
to have to define log level translations in multiple places so this
needs to be reworked so the front end macros define everything and
pass things down to the lower level functions.

And, anyway, why can't you just drop printk_index_subsys_emit() into
the define_xfs_printk_level() macro? The kern_level, the fmt string
and the varargs are all available there...

Anyway, there's more important high level stuff that needs
explaining first.

This is competely undocumented functionality and it's the first I've
ever heard about it. There's nothing I can easily find to learn how
this information being exposed to userspace is supposed to be used.
The commit message is pretty much information free, but this is a
new userspace ABI. What ABI constraints are we now subject to by
exporting XFS log message formats to userspace places?

i.e. Where's the documentation defining the contract this new
userspace ABI forms between the kernel log messages and userspace?
How do users know what we guarantee won't or will break, and how do
we kernel developers know what we're allowed to do once these very
specific internal subsystem implementation details are exposed to
userspace?

Hell, how did this stuff even get merged without any supporting
documentation?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
