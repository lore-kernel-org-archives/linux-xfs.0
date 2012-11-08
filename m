Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8Nik01035805 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 17:44:46 -0600
Date: Thu, 8 Nov 2012 17:46:42 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 1/2] xfs: xfs_tosspages() bug
Message-ID: <20121108234642.GR9783@sgi.com>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.626928496@sgi.com> <20121108230649.GU6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121108230649.GU6434@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Fri, Nov 09, 2012 at 10:06:49AM +1100, Dave Chinner wrote:
> On Thu, Nov 08, 2012 at 04:23:16PM -0600, Andrew Dahl wrote:
> > xfs_tosspages() takes a closed interval as an argument, take 
> > this into account when rounding down to the last byte of the
> > last complete page. If the request consists of a single 
> > partial page, there will be nothing to toss. 
> > 
> > Signed-off-by: Andrew Dahl <adahl@sgi.com>
> > 
> > ---

...

> So the change is good.
> 
> However, there's a bigger issue here. We've planned to remove these
> wrappers for a long time, just never got around to doing it. Seeing
> as there is a bug in this wrapper and it needs to be fixed, now
> seems like the right time to remove it.

The removal of the wrappers would not be appropriate for -stable.  This fix
needs to go in separately from any refactoring so that it can be pulled back
within the rules outlined in Documentation/stable_kernel_rules.txt.

> Hence I'd suggest that fixing this particular bug should just
> remove xfs_tosspages() and call truncate_inode_pages_range()
> directly. There are only two calls to this function, so it should be
> a simple conversion.  That can then be followed up with more patches
> to remove the other wrappers in xfs_fs_subr.c and hence remove the
> file completely...

I have no objection to doing so in a followup series, and I don't consider it
to be a high priority either.

> >  int
> > Index: xfs/fs/xfs/xfs_vnodeops.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_vnodeops.c
> > +++ xfs/fs/xfs/xfs_vnodeops.c
> > @@ -2172,7 +2172,7 @@ xfs_change_file_space(
> >  	switch (cmd) {
> >  	case XFS_IOC_ZERO_RANGE:
> >  		prealloc_type |= XFS_BMAPI_CONVERT;
> > -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> > +		xfs_tosspages(ip, startoffset, bf->l_len ? startoffset + llen : -1, 0);
> >  		/* FALLTHRU */
> >  	case XFS_IOC_RESVSP:
> >  	case XFS_IOC_RESVSP64:
> 
> What's this hunk for? Indeed, one of the first things that the
> xfs_alloc_file_space() checks is this:
> 
>         if (len <= 0)
> 		return XFS_ERROR(EINVAL);
> 
> xfs_free_file_space() does the same check, so it is invalid to pass
> a bf_len <= 0 for any of these specific functions. Hence this change
> is wrong regardless of what the comment on the struct xfs_flock64_t
> says - preallocation and hole punch operations must have a positive
> length associated with them.

Andrew, if you agree that this second change is unnecessary go ahead and remove
it and repost.  Otherwise,

Reviewed-by: Ben Myers <bpm@sgi.com>

Welcome to the XFS community!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
