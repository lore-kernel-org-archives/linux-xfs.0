Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D680229DF6
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:23:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B46348F8065
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:23:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EEcxBaSSiEBZGsnR for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:23:39 -0800 (PST)
Date: Wed, 10 Feb 2016 08:23:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: rename XFS_BUF_ZEROFLAGS macro
Message-ID: <20160209212336.GB14668@dastard>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
	<20160208091235.GN5534@infradead.org>
	<20160208223120.GM27429@dastard>
	<20160209091632.GB23349@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209091632.GB23349@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 01:16:32AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 09, 2016 at 09:31:20AM +1100, Dave Chinner wrote:
> > > xlog_sync already sets a lot of these flags again, and is called on an
> > > iclog buffer which never has the READ or XBF_WRITE_FAIL set, so just
> > > replacing it with an opencoded
> > > 
> > > 	bp->b_flags &= (XBF_FUA | XBF_FLUSH);
> > 
> > We can't do that because there are internal flags like _XBF_PAGES
> > that are set on log buffers. Clearing such flags will cause problems
> > when the iclog buffer is finally released on unmount. Hence I'd
> > prefer to keep the code as it stands.
> 
> Sorry - meabt to write:
> 
> 	bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
> 
> which is all we'll need.  All other flags cleared by XFS_BUF_ZEROFLAGS
> are either never set for log buffers (XBF_READ, XBF_WRITE_FAIL), or
> always set for log buffers (XBF_WRITE, XBF_ASYNC, XBF_SYNCIO).

Ah, that makes more sense. I should have realised that, but there
are places where we do clear buffer flags like your original
suggestion so it didn't occur to me it was just a typo. I'll fix it
up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
