Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F2CC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF3164DB2
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBLVWs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:22:48 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:49875 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBLVWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 16:22:42 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id EB758104FBB;
        Sat, 13 Feb 2021 08:21:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lAfsp-001kpu-LK; Sat, 13 Feb 2021 08:21:47 +1100
Date:   Sat, 13 Feb 2021 08:21:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: restore speculative_cow_prealloc_lifetime sysctl
Message-ID: <20210212212147.GZ4662@dread.disaster.area>
References: <20210212172436.GK7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212172436.GK7193@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=mWhT8ef26O-U7AFPTWMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:24:36AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 9669f51de5c0 I tried to get rid of the undocumented cow gc
> lifetime knob.  The knob's function was never documented and it now
> doesn't really have a function since eof and cow gc have been
> consolidated.
> 
> Regrettably, xfs/231 relies on it and regresses on for-next.  I did not
> succeed at getting far enough through fstests patch review for the fixup
> to land in time.
> 
> Restore the sysctl knob, document what it did (does?), put it on the
> deprecation schedule, and rip out a redundant function.
> 
> Fixes: 9669f51de5c0 ("xfs: consolidate the eofblocks and cowblocks workers")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thnanks for doing this, Darrick!

>  STATIC int
> -xfs_deprecate_irix_sgid_inherit_proc_handler(
> +xfs_deprecated_dointvec_minmax(
>  	struct ctl_table	*ctl,
>  	int			write,
>  	void			*buffer,
> @@ -60,23 +60,7 @@ xfs_deprecate_irix_sgid_inherit_proc_handler(
>  {
>  	if (write) {
>  		printk_once(KERN_WARNING
> -				"XFS: " "%s sysctl option is deprecated.\n",
> -				ctl->procname);
> -	}
> -	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> -}
> -
> -STATIC int
> -xfs_deprecate_irix_symlink_mode_proc_handler(
> -	struct ctl_table	*ctl,
> -	int			write,
> -	void			*buffer,
> -	size_t			*lenp,
> -	loff_t			*ppos)
> -{
> -	if (write) {
> -		printk_once(KERN_WARNING
> -				"XFS: " "%s sysctl option is deprecated.\n",
> +				"XFS: %s sysctl option is deprecated.\n",
>  				ctl->procname);
>  	}

The use of printk_once means it will only warn on the first
deprecated sysctl written to, not the first write to each of the
deprecated sysctls.

Is there any evidence that anyone is writing these with any regualr
frequency, and if not, maybe just a ratelimited warning is
sufficient here?

Otherwise looks fine.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
