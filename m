Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A86A77F95
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 21:04:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 878388F80BB
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 19:04:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id biNBYuCtuld9xfu4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 19:04:20 -0800 (PST)
Date: Thu, 29 Jan 2015 22:04:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
Message-ID: <20150130030411.GA22916@bfoster.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-7-git-send-email-david@fromorbit.com>
	<20150129153515.GF17652@laptop.bfoster>
	<20150129235315.GG6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150129235315.GG6282@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Fri, Jan 30, 2015 at 10:53:15AM +1100, Dave Chinner wrote:
> On Thu, Jan 29, 2015 at 10:35:15AM -0500, Brian Foster wrote:
> > On Tue, Jan 27, 2015 at 02:14:43PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently XFS_IOCTL_SETXATTR will fail if run in a user namespace as
> > > it it not allowed to change project IDs. The current code, however,
> > > also prevents any other change being made as well, so things like
> > > extent size hints cannot be set in user namespaces. This is wrong,
> > > so only disallow access to project IDs and related flags from inside
> > > the init namespace.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_ioctl.c | 22 +++++++++++++---------
> > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index 563d2b4..ae6e1e3 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -1120,6 +1120,19 @@ xfs_ioctl_setattr(
> > >  		return -EINVAL;
> > >  
> > >  	/*
> > > +	 * Project Quota ID state is only allowed to change from within the init
> > > +	 * namespace. Enforce that restriction only if we are trying to change
> > > +	 * the quota ID state. Everything else is allowed in user namespaces.
> > > +	 */
> > > +	if (current_user_ns() != &init_user_ns) {
> > > +		if (xfs_get_projid(ip) != fa->fsx_projid)
> > > +			return -EINVAL;
> > > +		if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
> > > +		    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
> > 
> > Why not use != here? Looks fine, anyways:
> 
> Because ^ has an implicit cast of the variables to boolean (i.e flag
> set or not), whereas != will only work if XFS_XFLAG_PROJINHERIT =
> XFS_DIFLAG_PROJINHERIT. Given that the moment we add more DIFLAGs to
> the xfs inode, the current "XFLAG value must match DIFLAG value"
> rule is going to be broken, I think that logical evaluation is a
> much safer practice for these types of comparisons.
> 

Hrm, I'm not following how a boolean cast occurs here. Isn't ^ a bitwise
operation? If I tweak the DIFLAG_PROJINHERIT to bit 15 (rather than 9)
and regenerate assembly for the code above, I end up with something like
this:

	/* -EINVAL */
        movl    $-22, %eax      #, D.54727

	...

	/* load up the flags vars */
        movzwl  354(%rdi), %ecx # ip_5(D)->i_d.di_flags,ip_5(D)->i_d.di_flags
        movl    (%rsi), %edx    # fa_3(D)->fsx_xflags, D.54728

	...

	/* grab the associated bits and cmp */
        andl    $512, %edx      #, D.54728
        andl    $32768, %ecx    #, D.54728
        cmpl    %edx, %ecx      # D.54728, D.54728

	/* ret 0 if values are equal */
        movl    $0, %edx        #, tmp99
        cmove   %edx, %eax      # tmp99,, D.54727
        ret

So it seems like this breaks just the same if the bit meaning doesn't
match between fields..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
