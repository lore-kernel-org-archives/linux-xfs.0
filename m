Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q290UEST110698 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 18:30:14 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	g9mBSzIh4E5TQsoF for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 16:30:12 -0800 (PST)
Date: Fri, 9 Mar 2012 11:30:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/10] xfs: clean up minor sparse warnings
Message-ID: <20120309003010.GS5091@dastard>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-2-git-send-email-david@fromorbit.com>
	<20120308213410.GZ7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308213410.GZ7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 03:34:10PM -0600, Ben Myers wrote:
> On Wed, Mar 07, 2012 at 03:50:19PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> ...
> 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ab30253..2601d6b 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -103,12 +103,15 @@ xfs_mark_inode_dirty(
> >  }
> >  
> >  
> > -int xfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> > -		   void *fs_info)
> > +static int
> > +xfs_initxattrs(
> > +	struct inode		*inode,
> > +	const struct xattr	*xattr_array,
> > +	void			*fs_info)
> >  {
> > -	const struct xattr *xattr;
> > -	struct xfs_inode *ip = XFS_I(inode);
> > -	int error = 0;
> > +	const struct xattr	*xattr;
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	int			error = 0;
> 
> I didn't see a sparse warning which this fixes... FWICS all you've done
> here is make it static and fix the formatting.

If fixes this warning:

fs/xfs/xfs_iops.c:106:5: warning: symbol 'xfs_initxattrs' was not declared. Should it be static?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
