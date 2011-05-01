Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p419XRmu167927 for <xfs@oss.sgi.com>; Sun, 1 May 2011 04:33:27 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D47015D06EB
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 02:37:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SD6x9iHvwHuVhTxH for <xfs@oss.sgi.com>;
	Sun, 01 May 2011 02:37:01 -0700 (PDT)
Date: Sun, 1 May 2011 19:36:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Message-ID: <20110501093659.GH13542@dastard>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>, Linux fs XFS <xfs@oss.sgi.com>

On Sat, Apr 30, 2011 at 04:27:48PM +0100, Peter Grandi wrote:
> Regardless, op-journaled file system designs like JFS and XFS
> write small records (way below a stripe set size, and usually
> way below a chunk size) to the journal when they queue
> operations,

XFS will write log-stripe-unit sized records to disk. If the log
buffers are not full, it pads them. Supported log-sunit sizes are up
to 256k.

> even if sometimes depending on design and options
> may "batch" the journal updates (potentially breaking safety
> semantics). Also they do small write when they dequeue the
> operations from the journal to the actual metadata records
> involved.
> 
> How bad can this be when the journal is say internal for a
> filesystem that is held on wide-stride RAID6 set? I suspect very
> very bad, with apocalyptic read-modify-write storms, eating IOPS.

Not bad at all, because the journal writes are sequential, and XFS
can have multiple log IOs in progress at once (up to 8 x 256k =
2MB). So in general while metadata operations are in progress, XFS
will fill full stripes with log IO and you won't get problems with
RMW.

> Where are studies or even just impressions of anedoctes on how
> bad this is?

Just buy decent RAID hardware with a BBWC and journal IO does not
hurt at all.

> Are there instrumentation tools in JFS or XFS that may allow me
> to watch/inspect what is happening with the journal? For Linux
> MD to see what are the rates of stripe r-m-w cases?

XFS has plenty of event tracing, including all the transaction
reservation and commit accounting in it. And if you know what you
are looking for, you can see all the log IO and transaction
completion processing in the event traces, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
