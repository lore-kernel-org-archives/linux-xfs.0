Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B79C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiC3LmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiC3LmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 07:42:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D303025CBBE
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 04:40:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7187A218FC;
        Wed, 30 Mar 2022 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648640421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nVNckD3sJGBk3k5Xtqq84q1429ptCcLbogDHCYhMvag=;
        b=s1aV8RiEeFQ2AR7hz4ylQNgl/qptMhON1B4N317biklRNmea90GoycA/evSVYEwhSFtUKj
        4e5Sl4z1dsHSRXm5k06oUIiLMEcbRMT5gIPhx9Koc8iWLidz7lecbAEP9ftn5AxN3SBpV2
        nyPzTnZhtYWJym5ey2Zw6QWuleqRbXo=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0C266A3B92;
        Wed, 30 Mar 2022 11:40:21 +0000 (UTC)
Date:   Wed, 30 Mar 2022 13:40:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 1/2] Simplify XFS logging methods.
Message-ID: <20220330114020.GA4384@pathway.suse.cz>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <20220329235441.GZ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329235441.GZ1544202@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 2022-03-30 10:54:41, Dave Chinner wrote:
> On Fri, Mar 25, 2022 at 10:19:45AM -0700, Jonathan Lassoff wrote:
> > Rather than have a constructor to define many nearly-identical
> > functions, use preprocessor macros to pass down a kernel logging level
> > to a common function.
> > 
> > Signed-off-by: Jonathan Lassoff <jof@thejof.com>
> 
> Mostly looks good, mainly just whitespace/formatting consistency
> issues now.
> 
> ....
> > -define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> > -define_xfs_printk_level(xfs_alert, KERN_ALERT);
> > -define_xfs_printk_level(xfs_crit, KERN_CRIT);
> > -define_xfs_printk_level(xfs_err, KERN_ERR);
> > -define_xfs_printk_level(xfs_warn, KERN_WARNING);
> > -define_xfs_printk_level(xfs_notice, KERN_NOTICE);
> > -define_xfs_printk_level(xfs_info, KERN_INFO);
> > -#ifdef DEBUG
> > -define_xfs_printk_level(xfs_debug, KERN_DEBUG);
> > -#endif
> > +void xfs_printk_level(
> > +	const char *kern_level,
> > +	const struct xfs_mount *mp,
> > +	const char *fmt, ...)
> 
> Use the same format as __xfs_printk() and xfs_alert_tag():
> 
> void
> xfs_printk_level(
> 	const char		*kern_level,
> 	const struct xfs_mount	*mp,
> 	const char		*fmt, ...)
> 
> > +{
> > +	struct va_format	vaf;
> > +	va_list			args;
> > +	int			level;
> > +
> > +	va_start(args, fmt);
> > +	vaf.fmt = fmt;
> > +	vaf.va = &args;
> > +
> > +	__xfs_printk(kern_level, mp, &vaf);
> > +
> > +	va_end(args);
> > +
> > +	if (!kstrtoint(kern_level, 0, &level) &&
> > +	    level <= LOGLEVEL_ERR &&
> > +	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
> > +		xfs_stack_trace();
> > +}
> >  
> >  void
> >  xfs_alert_tag(
> > diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> > index bb9860ec9a93..2f609800e806 100644
> > --- a/fs/xfs/xfs_message.h
> > +++ b/fs/xfs/xfs_message.h
> > @@ -6,33 +6,36 @@
> >  
> >  struct xfs_mount;
> >  
> > -extern __printf(2, 3)
> > -void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
> >  extern __printf(3, 4)

^^^^^^^

> > -void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
> > -extern __printf(2, 3)
> > -void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
> > -
> > +void xfs_printk_level(
> > +	const char *kern_level,
> > +	const struct xfs_mount *mp,
> > +	const char *fmt, ...);
> 
> This still needs the __printf() attribute because we still want the
> compiler to check the printf format string for issues. Also the
> format for function prototypes should follow the ones that got
> removed:

It is actually there. But it is hidden in many removed lines.

BTW: I missed it when reading the patch as well. I was surprised
     when I saw it after applying the patch ;-)

Best Regards,
Petr
