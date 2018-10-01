Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26006 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbeJBGdf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 02:33:35 -0400
Date: Tue, 2 Oct 2018 09:53:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181001235315.GM18567@dastard>
References: <20181001224500.GE5872@magnolia>
 <20181001232128.GL18567@dastard>
 <20181001233336.GF5872@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001233336.GF5872@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: viro@ZenIV.linux.org.uk, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Oct 01, 2018 at 04:33:36PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 02, 2018 at 09:21:28AM +1000, Dave Chinner wrote:
> > On Mon, Oct 01, 2018 at 03:45:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Teach callers of inode->i_op->get_link in the vfs code to check for a
> > > NULL return value and return an error status instead of blindly
> > > dereferencing the returned NULL pointer.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/namei.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index 0cab6494978c..0744ab981fa0 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -4737,6 +4737,8 @@ int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
> > >  		if (IS_ERR(link))
> > >  			return PTR_ERR(link);
> > >  	}
> > > +	if (!link)
> > > +		return -EUCLEAN;
> > 
> > If we are going to start returning this as a filesystem corruption
> > error from the VFS, can we please start with adding
> > 
> > #define EFSCORRUPTED	EUCLEAN
> > 
> > into one of the global error definition headers? The code makes much
> > more sense when it uses EFSCORRUPTED....
> 
> Ok, which header file?  include/uapi/asm-generic/errno.h ?

Seems reasonable, because that's where EUCLEAN is defined.

> We'll finally be able to get rid of the redundant definitions in
> ext[24] too.

And filesystems like btrfs can be converted from EUCLEAN to
EFSCORRUPTED, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
