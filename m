Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFKqOoZ027989 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 14:52:24 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3FTNfEIkR9EHp69Q for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 12:54:29 -0800 (PST)
Date: Fri, 16 Nov 2012 07:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/32] xfs: remove xfs_flushinval_pages
Message-ID: <20121115205427.GH14281@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-6-git-send-email-david@fromorbit.com>
	<20121115162807.GE4019@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121115162807.GE4019@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Nov 15, 2012 at 11:28:07AM -0500, Christoph Hellwig wrote:
> > -		if ((iocb->ki_pos & target->bt_smask) ||
> > -		    (size & target->bt_smask)) {
> > -			if (iocb->ki_pos == i_size_read(inode))
> > +		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
> > +			if (pos == i_size_read(inode))
> >  				return 0;
> >  			return -XFS_ERROR(EINVAL);
> >  		}
> >  	}
> >  
> > -	n = mp->m_super->s_maxbytes - iocb->ki_pos;
> > +	n = mp->m_super->s_maxbytes - pos;
> 
> What does this have to do with the recent of the patch?

Left over from an original version of the patch that also changed
the ranges of the flushes.

> Not that is diapprove, but I don't think it fits here.
> 
> >  		if (inode->i_mapping->nrpages) {
> > -			ret = -xfs_flushinval_pages(ip,
> > -					(iocb->ki_pos & PAGE_CACHE_MASK),
> > -					-1, FI_REMAPF_LOCKED);
> > +			ret = -filemap_write_and_wait_range(
> > +							VFS_I(ip)->i_mapping,
> > +							pos, -1);
> >  			if (ret) {
> >  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
> >  				return ret;
> >  			}
> > +			truncate_pagecache_range(VFS_I(ip), pos, -1);
> 
> We already have a local "inode" variable that can be used in these two
> places.

Ah, copy-n-waste problem.

> Also the -1 end might be a 1:1 translation of what was there, but is not what
> we really want.  At very least it needs an XXX comment that the range should
> be revisited.

Yes, I know, but the original patch I had that changed the ranges to
something sensible was causing fsx and other failures all over the
place. It appears that setting the ranges appropriately here exposes
other (worse) bugs, so I decided to leave doing that until I have
time to go on a wild goose chase....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
