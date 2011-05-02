Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42AATnI226722 for <xfs@oss.sgi.com>; Mon, 2 May 2011 05:10:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5DF71647DC2
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 03:14:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PRKHQ0CNeNUYth2x for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 03:14:05 -0700 (PDT)
Date: Mon, 2 May 2011 06:14:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs performance problem
Message-ID: <20110502101401.GA9155@infradead.org>
References: <4DB72084.8020205@inf.ethz.ch> <20110427023534.GF12436@dastard>
	<201104291827.35801.Martin@lichtvoll.de>
	<20110501085246.GF13542@dastard>
	<20110501165546.GB5391@infradead.org>
	<20110501182442.GA1635@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110501182442.GA1635@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Sun, May 01, 2011 at 08:24:42PM +0200, Markus Trippelsdorf wrote:
> Another thing is that with the recent updates to block FLUSH handling,
> using FUA might even be less efficient.  The new implementation
> aggressively merges those commit writes and flushes.  IOW, depending
> on timing, multiple consecutive commit writes can be merged as,
> 
>  FLUSH + commit writes + FLUSH
> 
> or
> 
>  FLUSH + some commit writes + FLUSH + other commit writes + FLUSH
> 
> and so on,

Except that writing multiple log buffers right next to each other
is rather unusual - you'd have to have a burst of metadata only
operations to get there.  What's more common is that a log write
interrupts streams of actual data I/O, and the longer we drain
the queue the more performance impact it has.

Moreover I'm working on avoiding the pre-flush if it's not needed,
e.g. there were no appending writes, and there as no pushing of the
log tail required, in which case the log write will only be
a write with FUA set, with no FLUSH and thus no queue draining on
SATA at all.

Also when you move away from SATA to higher latency links like FC
or iSCSI (maybe even over a WAN) avoiding protocol roundtrips buys
you a lot of performance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
