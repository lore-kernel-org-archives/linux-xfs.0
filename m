Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2B4F7CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 16:36:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72F23AC006
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 14:36:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PBQzLZfYXFR4q36l for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2016 14:36:36 -0800 (PST)
Date: Sat, 6 Feb 2016 09:36:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Message-ID: <20160205223626.GN459@dastard>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<1454524816-11392-3-git-send-email-hch@lst.de>
	<20160205215718.GM20038@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160205215718.GM20038@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Fri, Feb 05, 2016 at 01:57:18PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2016 at 07:40:15PM +0100, Christoph Hellwig wrote:
> > -	struct kiocb		*iocb,
> > -	loff_t			offset,
> > -	ssize_t			size,
> > -	void			*private)
> > -{
> > -	struct inode		*inode = file_inode(iocb->ki_filp);
> > -	struct xfs_ioend	*ioend = private;
> > +		trace_xfs_end_io_direct_write_append(ip, offset, size);
> >  
> > -	if (size <= 0)
> > -		return 0;
> > -
> > -	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
> > -				     ioend ? ioend->io_type : 0, NULL);
> > -
> > -	if (!ioend) {
> > -		ASSERT(offset + size <= i_size_read(inode));
> > -		return 0;
> > +		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> > +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> > +		if (error) {
> > +			xfs_trans_cancel(tp);
> > +			return error;
> > +		}
> > +		error = xfs_setfilesize(ip, tp, offset, size);
> 
> Don't we need a xfs_trans_commit() here?

No, xfs_setfilesize() does that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
