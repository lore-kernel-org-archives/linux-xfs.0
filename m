Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SB90vo178075 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 05:09:00 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3bA6fNz90IvTN0xK (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 03:08:58 -0800 (PST)
Date: Tue, 28 Feb 2012 06:08:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: make xfs_inode_item_size idempotent
Message-ID: <20120228110858.GB21870@infradead.org>
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003907.081625923@bombadil.infradead.org>
	<20120221051404.GM3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221051404.GM3592@dastard>
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

On Tue, Feb 21, 2012 at 04:14:04PM +1100, Dave Chinner wrote:
> One minor cleanup:
> 
> >  	case XFS_DINODE_FMT_LOCAL:
> > -		ASSERT(!(iip->ili_format.ilf_fields &
> > -			 (XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
> > -		if (iip->ili_format.ilf_fields & XFS_ILOG_ADATA) {
> > +		iip->ili_format.ilf_fields &=
> > +			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
> > +
> > +		if ((iip->ili_format.ilf_fields & XFS_ILOG_ADATA) &&
> > +		    ip->i_afp->if_bytes > 0) {
> >  			ASSERT(ip->i_afp->if_bytes > 0);
> 
> That assert can go - it's checked in the if statement now.

Fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
