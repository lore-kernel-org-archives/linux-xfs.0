Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F159C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 01:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346095AbiCYBSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349657AbiCYBSe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 21:18:34 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3AD6BD88E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 18:17:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 89421533EAA;
        Fri, 25 Mar 2022 12:16:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXYZU-009WHo-Bb; Fri, 25 Mar 2022 12:16:56 +1100
Date:   Fri, 25 Mar 2022 12:16:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v1] Add XFS messages to printk index
Message-ID: <20220325011656.GP1544202@dread.disaster.area>
References: <20220321231123.73487-1-jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321231123.73487-1-jof@thejof.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623d180c
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=PZ1i06vDnuOzAg71Rj4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 11:11:23PM +0000, Jonathan Lassoff wrote:
> In order for end users to quickly react to new issues that come up in
> production, it is proving useful to leverage the printk indexing system.
> This printk index enables kernel developers to use calls to printk()
> with changable ad-hoc format strings, while still enabling end users to
> detect changes and develop a semi-stable interface for detecting and
> parsing these messages.

Hmmmm.  This is still missing a description of what "semi-stable"
implies in terms of kernel/userspace ABI guarantees/constraints for
the XFS codebase and developers.

I've cc'd the printk maintainers so they can be berated directly for
failing to provide any useful documentation for what appears to be a
shiny new userspace ABI.  Then they can answer our questions about
the implications of exposing source code directly to userspace have
for us kernel developers....

> So that detailed XFS messages are captures by this printk index, this
> patch wraps the xfs_<level> and xfs_alert_tag functions.
> 
> [PATCH v1] -- De-duplicate kernel logging levels and tidy whitespace.

Good!

But this is only the first step - there's a heap of improvements
that lead directly from lifting this definition.

However, change logs should not be part of the commit message - they
go either in the cover message or below the "---" line as we don't
record them in the git history when the code is merged.

Most importantly, the patch is missing a Signed-off-by line.

> ---
>  fs/xfs/xfs_message.c | 68 +++++++++++++++++++-----------------
>  fs/xfs/xfs_message.h | 82 ++++++++++++++++++++++++++++++++------------
>  2 files changed, 97 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index bc66d95c8d4c..8f29d8e86482 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -21,46 +21,50 @@ __xfs_printk(
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
> -#define define_xfs_printk_level(func, kern_level)		\
> -void func(const struct xfs_mount *mp, const char *fmt, ...)	\
> -{								\
> -	struct va_format	vaf;				\
> -	va_list			args;				\
> -	int			level;				\
> -								\
> -	va_start(args, fmt);					\
> -								\
> -	vaf.fmt = fmt;						\
> -	vaf.va = &args;						\
> -								\
> -	__xfs_printk(kern_level, mp, &vaf);			\
> -	va_end(args);						\
> -								\
> -	if (!kstrtoint(kern_level, 0, &level) &&		\
> -	    level <= LOGLEVEL_ERR &&				\
> -	    xfs_error_level >= XFS_ERRLEVEL_HIGH)		\
> -		xfs_stack_trace();				\
> -}								\
> -
> -define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> -define_xfs_printk_level(xfs_alert, KERN_ALERT);
> -define_xfs_printk_level(xfs_crit, KERN_CRIT);
> -define_xfs_printk_level(xfs_err, KERN_ERR);
> -define_xfs_printk_level(xfs_warn, KERN_WARNING);
> -define_xfs_printk_level(xfs_notice, KERN_NOTICE);
> -define_xfs_printk_level(xfs_info, KERN_INFO);
> +#define define_xfs_printk_level(func)			\
> +void func(						\
> +	const char *kern_level,				\
> +	const struct xfs_mount *mp,			\
> +	const char *fmt,				\
> +	...)						\
> +{							\
> +	struct va_format	vaf;			\
> +	va_list			args;			\
> +	int			level;			\
> +							\
> +	va_start(args, fmt);				\
> +							\
> +	vaf.fmt = fmt;					\
> +	vaf.va = &args;					\
> +							\
> +	__xfs_printk(kern_level, mp, &vaf);		\
> +	va_end(args);					\
> +							\
> +	if (!kstrtoint(kern_level, 0, &level) &&	\
> +	    level <= LOGLEVEL_ERR &&			\
> +	    xfs_error_level >= XFS_ERRLEVEL_HIGH)	\
> +		xfs_stack_trace();			\
> +}							\
> +
> +define_xfs_printk_level(_xfs_emerg);
> +define_xfs_printk_level(_xfs_alert);
> +define_xfs_printk_level(_xfs_crit);
> +define_xfs_printk_level(_xfs_err);
> +define_xfs_printk_level(_xfs_warn);
> +define_xfs_printk_level(_xfs_notice);
> +define_xfs_printk_level(_xfs_info);
>  #ifdef DEBUG
> -define_xfs_printk_level(xfs_debug, KERN_DEBUG);
> +define_xfs_printk_level(_xfs_debug);
>  #endif

Now the kern_level comes from the high level macros, we don't need
these constructors any more. This just results in identical functions
that differ only by name. i.e. this constructor macro and the
functions it builds can be replaced with a single function such as:

void
xfs_printk_level(
	const char		*kern_level,
	const struct xfs_mount	*mp,
	const char		*fmt,
	...)
{
	struct va_format	vaf;
	va_list			args;
	int			level;

	va_start(args, fmt);

	vaf.fmt = fmt;
	vaf.va = &args;

	__xfs_printk(kern_level, mp, &vaf);
	va_end(args);

	if (!kstrtoint(kern_level, 0, &level) &&
	    level <= LOGLEVEL_ERR &&
	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
		xfs_stack_trace();
}

>  
>  void
> -xfs_alert_tag(
> +_xfs_alert_tag(
>  	const struct xfs_mount	*mp,
>  	int			panic_tag,
>  	const char		*fmt, ...)
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bb9860ec9a93..6f9d4a3553de 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,31 +6,71 @@
>  
>  struct xfs_mount;
>  
> -extern __printf(2, 3)
> -void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
> -extern __printf(2, 3)
> -void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
> +#define xfs_printk_index_wrap(_p_func, kern_level, mp, fmt, ...)		\
> +({										\
> +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt, ##__VA_ARGS__);	\
> +	_p_func(kern_level, mp, fmt, ##__VA_ARGS__);				\
> +})

Over 80 columns wide.

> +#define xfs_alert_tag(mp, tag, fmt, ...)					\
> +({										\
> +	printk_index_subsys_emit("%sXFS%s: ", KERN_ALERT, fmt, ##__VA_ARGS__);	\
> +	_xfs_alert_tag(mp, tag, fmt, ##__VA_ARGS__);				\
> +})
> +#define xfs_emerg(mp, fmt, ...)\
                                ^^^^   whitespace needed.

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

So with xfs_printk_level() now present, all these macros now simply
call xfs_printk_level() and pass the level to it. e.g.

#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
({								\
	printk_index_subsys_emit("%sXFS%s: ",			\
			kern_level, fmt, ##__VA_ARGS__);	\
	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
})

#define xfs_emerg(mp, fmt, ...)	\
	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
.....

And then all this mass of grotty printf prototype cruft can go away:

> +
> +
> +extern __printf(3, 4)
> +void _xfs_emerg(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_alert(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
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
> +void _xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_crit(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_err(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_warn(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_notice(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_info(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
>  
>  #ifdef DEBUG
> -extern __printf(2, 3)
> -void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
> +extern __printf(3, 4)
> +void _xfs_debug(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...);
>  #else
> -static inline __printf(2, 3)
> -void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> -{
> -}
> +extern __printf(3, 4)
> +void _xfs_debug(
> +	const char *kern_level, const struct xfs_mount *mp, const char *fmt, ...)
> +{}
>  #endif

And be replaced with a single declaration:

extern __printf(3, 4)
void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
		const char *fmt, ...);

And in doing this, we gain the new functionality, clean up a bunch
of messy code, reduce the number of lines of code to implement the
XFS printk wrappers, and we reduce the code size of the XFS printk
module, too.  That's wins all around.

And then if you split this patch into two - the first patch
reorganises the printf code, the second introduces the new printk
functionality (i.e xfs_printk_index_wrap() macro) - then we can
review and merge the cleanup patch independently of the fate of the
second patch that may introduce ABI contraints....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
