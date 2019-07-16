Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbfGPADT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 20:03:19 -0400
Date: Mon, 15 Jul 2019 17:03:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190716000303.GD6147@magnolia>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
 <20190715222209.GN7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715222209.GN7689@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 16, 2019 at 08:22:09AM +1000, Dave Chinner wrote:
> On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
> > Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
> > sync with userspace.  (Currently no kernel caller sends this flag.)
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > index 93d14e47269d..a9ad90926b87 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
> >  		inode->i_mtime = tv;
> >  	if (flags & XFS_ICHGTIME_CHG)
> >  		inode->i_ctime = tv;
> > +	if (flags & XFS_ICHGTIME_CREATE) {
> > +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> > +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> > +	}
> 
> Please use the same format as the rest of the function. i.e.
> 
> 	if (flags & XFS_ICHGTIME_CREATE)
> 		ip->i_d.di_crtime = tv;
> 
> And convert userspace over to the same :P

How about promoting crtime to struct inode while we're at it?

(That said I think Eric was going for the quick resync now to keep
kernel libxfs in sync with xfsprogs libxfs...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
