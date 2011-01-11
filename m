Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BLYZre114218 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 15:34:35 -0600
Subject: Re: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking
	the inode
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110111210250.GL28803@dastard>
References: <1294702668-15216-1-git-send-email-david@fromorbit.com>
	<1294702668-15216-5-git-send-email-david@fromorbit.com>
	<20110111173627.GB24025@infradead.org> <20110111210250.GL28803@dastard>
Date: Tue, 11 Jan 2011 15:36:03 -0600
Message-ID: <1294781763.3115.9.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 2011-01-12 at 08:02 +1100, Dave Chinner wrote:
> On Tue, Jan 11, 2011 at 12:36:27PM -0500, Christoph Hellwig wrote:
> > On Tue, Jan 11, 2011 at 10:37:44AM +1100, Dave Chinner wrote:
> > > +/*
> > > + * xfs_file_splice_write() does not use xfs_rw_ilock() because
> > > + * generic_file_splice_write() takes the i_mutex itself. This, in theory,

. . .

> > > +	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> > 
> > While using the xfs_rw_iunlock here actually is correct I think it's
> 
> Argh! I thought I reverted all the changes to
> xfs_file_splice_write().
> 
> > highly confusing, given that we didn't use it to take the ilock.
> 
> It definitely held the ilock around that size update before this
> series. ;)
> 
> > What
> > about just leaving all the code in xfs_file_splice_write as-is and not
> > touching it at all?
> 
> Updated version below.

Your explanation before and this update addressed all
my substantive issues.  I have one other thing (which
is essentially a style issue), which I'll still mention
below, but I think your next patch may make it moot
anyway...

In any case:

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .
> @@ -654,16 +690,20 @@ start:
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> +			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
>  			return XFS_ERROR(-EINVAL);
>  		}
>  
> -		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> +		/*
> +		 * For direct I/O, if there are cached pages or we're extending
> +		 * the file, we need IOLOCK_EXCL until we're sure the bytes at
> +		 * the new EOF have been zeroed and/or the cached pages are
> +		 * flushed out.  Upgrade the I/O lock and start again.
> +		 */
> +		if (iolock != XFS_IOLOCK_EXCL &&

I would prefer:   if (iolock == XFS_IOLOCK_SHARED)

> +		    (mapping->nrpages || pos > ip->i_size)) {
> +			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);

and (maybe) this could be             XFS_ILOCK_EXCL|XFS_IOLOCK_SHARED);

>  			iolock = XFS_IOLOCK_EXCL;
> -			need_i_mutex = 1;
> -			mutex_lock(&inode->i_mutex);
> -			xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
>  			goto start;
>  		}
>  	}

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
