Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371D7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 15:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiCAPtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiCAPtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 10:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3C946B2C;
        Tue,  1 Mar 2022 07:48:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C297EB81A34;
        Tue,  1 Mar 2022 15:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464C2C340EE;
        Tue,  1 Mar 2022 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646149699;
        bh=BvH/kma4X2Q1HcMu+DaJwSYluHohQpfYsoAqECnlSZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ceHrGQ4nD1JtF+7SgfJgvbV+B1YUhEDCnyTsf902392MBtntKC20s8ORwqaOSa/4S
         S/W+MFaJ/ar5ikwVLaVfbm4mxfQPOPWMCzhvSY25UDeFkUZKh9S7IFvqvZVVpsbV+U
         oZ/UtOXXuImSaY9dT6PwpSoyBRG85uGvgIYe6OmBSYH/D3lGMNr8LfJaC1DEpgox7x
         WT/JlgZQF2woiNaDU0+WMmAsvb61GT0she1K3wniFhnnbLi1cLBfD/9/dJqJ0lnivO
         NCMGFQLjpwftpBrnGCoZLYd6OxLkYK9c6QBoeN9xOBfeQISkq7W3SfhOERZJMZNnJj
         qJ35gjyfXy79Q==
Date:   Tue, 1 Mar 2022 07:48:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        john.haxby@oracle.com
Subject: Re: [PATCH RESEND] xfs: don't generate selinux audit messages for
 capability testing
Message-ID: <20220301154818.GI117732@magnolia>
References: <20220301025052.GF117732@magnolia>
 <20220301151014.GA17144@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301151014.GA17144@mail.hallyn.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 09:10:14AM -0600, Serge E. Hallyn wrote:
> On Mon, Feb 28, 2022 at 06:50:52PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a few places where we test the current process' capability set
> > to decide if we're going to be more or less generous with resource
> > acquisition for a system call.  If the process doesn't have the
> > capability, we can continue the call, albeit in a degraded mode.
> > 
> > These are /not/ the actual security decisions, so it's not proper to use
> > capable(), which (in certain selinux setups) causes audit messages to
> > get logged.  Switch them to has_capability_noaudit.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Cc: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/xfs_fsmap.c  |    4 ++--
> >  fs/xfs/xfs_ioctl.c  |    2 +-
> >  fs/xfs/xfs_iops.c   |    2 +-
> >  kernel/capability.c |    1 +
> >  4 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 48287caad28b..10e1cb71439e 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -864,8 +864,8 @@ xfs_getfsmap(
> >  	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
> >  		return -EINVAL;
> >  
> > -	use_rmap = capable(CAP_SYS_ADMIN) &&
> > -		   xfs_has_rmapbt(mp);
> > +	use_rmap = xfs_has_rmapbt(mp) &&
> 
> Hm, I'm failing to find where xfs_has_rmapbt() is defined.  I just
> wanted to make sure it doesn't have any side effects that you'd want
> to avoid in the no-capability case.  (Seems very unlikely that it
> would, given the name)

fs/xfs/xfs_mount.h:495:__XFS_HAS_FEAT(rmapbt, RMAPBT)

To expand on that a little -- it's a convenience predicate that tells us
whether or not the mounted xfs filesystem supports the reverse mapping
btree feature.  The predicate itself has no side effects, of course, so
the rearranging of the two sides of the && operator so that we do the
cheaper check first (like this code probably should have done from the
start).

--D

> 
> > +		   has_capability_noaudit(current, CAP_SYS_ADMIN);
> >  	head->fmh_entries = 0;
> >  
> >  	/* Set up our device handlers. */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 2515fe8299e1..83481005317a 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1189,7 +1189,7 @@ xfs_ioctl_setattr_get_trans(
> >  		goto out_error;
> >  
> >  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> > -			capable(CAP_FOWNER), &tp);
> > +			has_capability_noaudit(current, CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_error;
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index b79b3846e71b..a65217f787cf 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -723,7 +723,7 @@ xfs_setattr_nonsize(
> >  	}
> >  
> >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > -			capable(CAP_FOWNER), &tp);
> > +			has_capability_noaudit(current, CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_dqrele;
> >  
> > diff --git a/kernel/capability.c b/kernel/capability.c
> > index 46a361dde042..765194f5d678 100644
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -360,6 +360,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
> >  {
> >  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
> >  }
> > +EXPORT_SYMBOL(has_capability_noaudit);
> >  
> >  static bool ns_capable_common(struct user_namespace *ns,
> >  			      int cap,
