Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OMkr3k148958 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 17:46:54 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	47ZAr0QUb735mclc for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 15:46:51 -0700 (PDT)
Date: Sun, 25 Mar 2012 09:46:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: avoid shutdown hang in xlog_wait()
Message-ID: <20120324224648.GF5091@dastard>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
	<20120324170302.GB21708@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120324170302.GB21708@infradead.org>
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

On Sat, Mar 24, 2012 at 01:03:02PM -0400, Christoph Hellwig wrote:
> On Fri, Mar 23, 2012 at 12:47:43PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When a shutdown is triggered from failing to find an item in the AIL
> > during delete, we can be called from either metadata IO completion
> > context or from log IO completion context. In the case of log IO
> > completion context, we must indicate that this is a log error so
> > that the forced shutdown does not attempt to flush the log.
> > 
> > To flush the log whilst in log IO completion will cause a deadlock
> > as the shutdown won't proceed until log IO completes, and log Io
> > cannot complete because it has blocked waiting for itself to
> > complete....
> > 
> > We delete items in the AIL from log IO completion when we are
> > unpinning in-memory only items, or items that do not require
> > writeback to remove from the AIL (e.g. EFI/EFD items). Hence there
> > are several locations that need this treatment.
> 
> Looks good.  I wonder if it might be simple to simply pass a flags
> argument to xfs_ail_delete(_bulk) which tells which kind of shutdown
> to do.

I thought about doing that, but it seems strange and unusual to tell
code how to handle errors internally instead of returning the error
and letting the caller handle it...

I don't mind either way, though. If you prefer I pass in the
shutdown flag, I can change it all to do that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
