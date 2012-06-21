Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LGYDka094469 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 11:34:13 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hLvGVccSWiKfhsAY (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 09:34:10 -0700 (PDT)
Date: Thu, 21 Jun 2012 12:34:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120621163409.GA7897@infradead.org>
References: <20120621091803.GB10673@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120621091803.GB10673@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 21, 2012 at 07:18:03PM +1000, Dave Chinner wrote:
> Folks,
> 
> I just had a stack overflow in the delayed write buffer error
> handling with a shut down filesystem:

I've looked at this a bit more, and it seems the effect really can't
be an XFS shutdown.  We never do the shutdown check inside
xfs_buf_iorequest.  The issue obviously is real, but could it be that
you had an actual persistent I/O error on the underlying device?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
