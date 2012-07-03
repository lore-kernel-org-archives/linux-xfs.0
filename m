Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63G5b7w104390 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 11:05:37 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	s9VuBxtB87W47ymm (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 09:05:33 -0700 (PDT)
Date: Tue, 3 Jul 2012 12:05:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120703160531.GA855@infradead.org>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120703002857.GY19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703002857.GY19223@dastard>
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

On Tue, Jul 03, 2012 at 10:28:57AM +1000, Dave Chinner wrote:
> On Mon, Jul 02, 2012 at 06:00:05AM -0400, Christoph Hellwig wrote:
> > xfs_bdstrat_cb only adds a check for a shutdown filesystem over xfs_buf_iorequest,
> > but xfs_buf_iodone_callbacks just checked for a shut down filesystem a little
> > earlier.  In addition the shutdown handling in xfs_bdstrat_cb is not very suitable
> > for this caller.
> 
> Makes sense - I have a patch locally that does this as part of a
> xfs_buf_iorequest(bp, blkno, length) conversion to get rid of
> XFS_BUF_SETADDR()....

Can you send these out ASAP?  I have another big batch of buffer error
handling changes for 3.6 I'm working on right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
