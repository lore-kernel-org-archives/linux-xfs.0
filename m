Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED3557FED
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 17:54:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A8DDAC005
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:54:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Iqgtj1b12CHHPFZb for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 15:54:52 -0800 (PST)
Date: Fri, 30 Jan 2015 10:53:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/9] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
Message-ID: <20150129235315.GG6282@dastard>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-7-git-send-email-david@fromorbit.com>
	<20150129153515.GF17652@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150129153515.GF17652@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 10:35:15AM -0500, Brian Foster wrote:
> On Tue, Jan 27, 2015 at 02:14:43PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently XFS_IOCTL_SETXATTR will fail if run in a user namespace as
> > it it not allowed to change project IDs. The current code, however,
> > also prevents any other change being made as well, so things like
> > extent size hints cannot be set in user namespaces. This is wrong,
> > so only disallow access to project IDs and related flags from inside
> > the init namespace.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 563d2b4..ae6e1e3 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1120,6 +1120,19 @@ xfs_ioctl_setattr(
> >  		return -EINVAL;
> >  
> >  	/*
> > +	 * Project Quota ID state is only allowed to change from within the init
> > +	 * namespace. Enforce that restriction only if we are trying to change
> > +	 * the quota ID state. Everything else is allowed in user namespaces.
> > +	 */
> > +	if (current_user_ns() != &init_user_ns) {
> > +		if (xfs_get_projid(ip) != fa->fsx_projid)
> > +			return -EINVAL;
> > +		if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) ^
> > +		    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
> 
> Why not use != here? Looks fine, anyways:

Because ^ has an implicit cast of the variables to boolean (i.e flag
set or not), whereas != will only work if XFS_XFLAG_PROJINHERIT =
XFS_DIFLAG_PROJINHERIT. Given that the moment we add more DIFLAGs to
the xfs inode, the current "XFLAG value must match DIFLAG value"
rule is going to be broken, I think that logical evaluation is a
much safer practice for these types of comparisons.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
