Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387849AbfGOPKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 11:10:08 -0400
Date: Mon, 15 Jul 2019 08:09:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190715150950.GA6147@magnolia>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
 <20190715113007.GB23406@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715113007.GB23406@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 15, 2019 at 07:30:08AM -0400, Brian Foster wrote:
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
> Could we add a "for libxfs" or some such one liner comment to this so
> long as this is unused in the kernel? With that:

FWIW I was planning (5.4) to fix xfs_ialloc to use ICHGTIME_CREATE, so
it won't be "for libxfs only" for long. :)

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  }
> >  
> >  /*
> > 
> > 
