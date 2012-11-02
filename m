Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2NoEP1206190 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 18:50:14 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BN3jKihGJsYNLeoC for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 16:52:06 -0700 (PDT)
Date: Sat, 3 Nov 2012 10:51:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: fix reading of wrapped log data
Message-ID: <20121102235130.GC29378@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-7-git-send-email-david@fromorbit.com>
	<20121102130700.GE12578@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102130700.GE12578@infradead.org>
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

On Fri, Nov 02, 2012 at 09:07:00AM -0400, Christoph Hellwig wrote:
> On Fri, Nov 02, 2012 at 11:38:44AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
> > 3.0-rc1 introduced a regression when recovering log buffers that
> > wrapped around the end of log. The second part of the log buffer at
> > the start of the physical log was being read into the header buffer
> > rather than the data buffer, and hence recovery was seeing garbage
> > in the data buffer when it got to the region of the log buffer that
> > was incorrectly read.
> 
> I think you mentioned earlier you found a reproducer for this, any
> chance it could be added to xfstests?

My reproducer is specific to the hardware I was testing on and
various filesystem parameters (e.g. log size, RAM, writeback rates
to storage, etc), and it was dependent on compilebench to generate
the load. I've been trying to isolate it down to a reproducable case
simliar to test 016, but I haven't quite got it there yet.

And, yes, I very much want a test that covers recovery of wrapped
log buffers. I was very surprised when I realised that it wasnt'
specifically tested by xfstests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
