Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F240C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336E064E05
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhBLV25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:28:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhBLV24 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 16:28:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FBFE64E26;
        Fri, 12 Feb 2021 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613165296;
        bh=MZRKcrJ3AFgHNFsG0Ha+6qcPmuEFo1Q4UrL9zTScTtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tuy+DlaQoYliGeAeVWrcnQbj62SfvrpYznE2mapQDLpPIBSwCDWXI9VTDIXrvib2w
         3En86nGCdDNQmlR5EbrPlLM7PVGY05whONT5PZ06ahEuKurdMjIAXAtk+UnnHVPu5K
         7hRmhLGLDbCk3Bif0HXUZ8Wq/Bo/V8RWTP1Wr1tTQY+xRMbK2xosv31UzSPxS0eXJ/
         QHz85p/IVFfkiKLoCjBJtPsgjb19ToeBlLfRdSW8ElK+fTBps1ClQXjmoiI5lU879/
         36xFPhAsJwlxv8a/zPYjfA8H5uPTZUlEzqD78CSAupoK8tZvrBthNahoBSB28LvA3Q
         u/k3yxwBJKuEg==
Date:   Fri, 12 Feb 2021 13:28:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: restore speculative_cow_prealloc_lifetime sysctl
Message-ID: <20210212212815.GM7193@magnolia>
References: <20210212172436.GK7193@magnolia>
 <20210212212147.GZ4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212212147.GZ4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 13, 2021 at 08:21:47AM +1100, Dave Chinner wrote:
> On Fri, Feb 12, 2021 at 09:24:36AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit 9669f51de5c0 I tried to get rid of the undocumented cow gc
> > lifetime knob.  The knob's function was never documented and it now
> > doesn't really have a function since eof and cow gc have been
> > consolidated.
> > 
> > Regrettably, xfs/231 relies on it and regresses on for-next.  I did not
> > succeed at getting far enough through fstests patch review for the fixup
> > to land in time.
> > 
> > Restore the sysctl knob, document what it did (does?), put it on the
> > deprecation schedule, and rip out a redundant function.
> > 
> > Fixes: 9669f51de5c0 ("xfs: consolidate the eofblocks and cowblocks workers")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thnanks for doing this, Darrick!
> 
> >  STATIC int
> > -xfs_deprecate_irix_sgid_inherit_proc_handler(
> > +xfs_deprecated_dointvec_minmax(
> >  	struct ctl_table	*ctl,
> >  	int			write,
> >  	void			*buffer,
> > @@ -60,23 +60,7 @@ xfs_deprecate_irix_sgid_inherit_proc_handler(
> >  {
> >  	if (write) {
> >  		printk_once(KERN_WARNING
> > -				"XFS: " "%s sysctl option is deprecated.\n",
> > -				ctl->procname);
> > -	}
> > -	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> > -}
> > -
> > -STATIC int
> > -xfs_deprecate_irix_symlink_mode_proc_handler(
> > -	struct ctl_table	*ctl,
> > -	int			write,
> > -	void			*buffer,
> > -	size_t			*lenp,
> > -	loff_t			*ppos)
> > -{
> > -	if (write) {
> > -		printk_once(KERN_WARNING
> > -				"XFS: " "%s sysctl option is deprecated.\n",
> > +				"XFS: %s sysctl option is deprecated.\n",
> >  				ctl->procname);
> >  	}
> 
> The use of printk_once means it will only warn on the first
> deprecated sysctl written to, not the first write to each of the
> deprecated sysctls.
> 
> Is there any evidence that anyone is writing these with any regualr
> frequency, and if not, maybe just a ratelimited warning is
> sufficient here?

I've never seen any evidence that people hammer on sysctls with great
frequency.  Will change to printk_ratelimited.

--D

> Otherwise looks fine.
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
