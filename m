Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84A337CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 03:16:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24899AC003
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:16:34 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ELkcUK3JL1KusYeP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 01:16:32 -0800 (PST)
Date: Tue, 9 Feb 2016 01:16:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: rename XFS_BUF_ZEROFLAGS macro
Message-ID: <20160209091632.GB23349@infradead.org>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
	<20160208091235.GN5534@infradead.org>
	<20160208223120.GM27429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208223120.GM27429@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 09:31:20AM +1100, Dave Chinner wrote:
> > xlog_sync already sets a lot of these flags again, and is called on an
> > iclog buffer which never has the READ or XBF_WRITE_FAIL set, so just
> > replacing it with an opencoded
> > 
> > 	bp->b_flags &= (XBF_FUA | XBF_FLUSH);
> 
> We can't do that because there are internal flags like _XBF_PAGES
> that are set on log buffers. Clearing such flags will cause problems
> when the iclog buffer is finally released on unmount. Hence I'd
> prefer to keep the code as it stands.

Sorry - meabt to write:

	bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);

which is all we'll need.  All other flags cleared by XFS_BUF_ZEROFLAGS
are either never set for log buffers (XBF_READ, XBF_WRITE_FAIL), or
always set for log buffers (XBF_WRITE, XBF_ASYNC, XBF_SYNCIO).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
