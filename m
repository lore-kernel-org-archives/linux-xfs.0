Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUN7KmV239323 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 17:07:20 -0600
Date: Fri, 30 Nov 2012 18:09:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121130230938.GB12674@infradead.org>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
	<20121130160920.GA9873@infradead.org> <50B8F2FC.6060501@sgi.com>
	<20121130222110.GB12955@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121130222110.GB12955@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sat, Dec 01, 2012 at 09:21:10AM +1100, Dave Chinner wrote:
> > eeek. yep, I will loop through and count the pages needed in each
> > segment.
> 
> That's wrong - the pages must be mappable as a contiguous memory
> range. That's how this code avoids copying the data from
> discontiguous page ranges into a contiguous mapped memory range.
> If you separate each IO into to it's own set of pages, then you have
> to completely rewrite _xfs_buf_ioapply(), which AFAICT works just
> fine with the page allocation that is done right now....

Yeah, you're right.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
