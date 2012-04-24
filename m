Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OFAIl4080348 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 10:10:18 -0500
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id hA6Yqsw32orwGSSA for <xfs@oss.sgi.com>;
	Tue, 24 Apr 2012 08:10:16 -0700 (PDT)
Date: Tue, 24 Apr 2012 11:10:10 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120424151010.GA21619@poseidon.cudanet.local>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
	<20120423202441.GD21260@poseidon.cudanet.local>
	<20120423232759.GO9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120423232759.GO9541@dastard>
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

On Tue, Apr 24, 2012 at 09:27:59AM +1000, Dave Chinner wrote:
> On Mon, Apr 23, 2012 at 04:24:41PM -0400, Josef 'Jeff' Sipek wrote:
> > On Sat, Apr 21, 2012 at 10:29:32AM +1000, Dave Chinner wrote:
> > ...
> > > but also given the length of the incident, some other data is definitely
> > > needed:
> > > 	- a 30s event trace - it'll compress pretty well
> > > 	  (trace-cmd record -e xfs* sleep 30; trace-cmd report > output.txt)
> > 
> > http://31bits.net/download/output-1335211829.txt.bz2
> 
> Ok, that's instructive. Inode RMW cycles in the xfsaild:
...
> Every buffer read is followed by a queuing for write.  It is also
> showing that it is typically taking 10-25ms per inode read IO, which
> is exactly what I'd expect for your given storage. There are 2500 of
> these over the 30s period, which translates to about one every 12ms
> across the 30s sample.
> 
> So, yes, your hangs are definitely due to inode buffer RMW cycles
> when trying to flush dirty inodes from the cache. I have a few
> ideas on how to fix this - but I'm not sure whether a current TOT
> solution will be easily back-portable.

If it is too much effort to backport, we should be able to move the box to a
3.3 stable kernel (assuming no driver problems).

> The simplest solution is a readahead based solution - AIL pushing is
> async, and will cycle back to inodes that it failed to flush the first
> time past, so triggering readahead on the first pass might work just fine.
...

This makes sense.  With a large enough log, could you not end up evicting
the readahead inodes by the time you get back to them?

> That way the xfsaild will make a pass across the AIL doing
> readahead and doesn't block on RMW cycles. Effectively we get async
> RMW cycles occurring, and the latency of a single cycle will no
> longer be the performance limiting factor. I'll start to prototype
> something to address this - it isn't a new idea, and I've seen it
> done before, so i should be able to get something working.

Cool.  Let me know when you have something we can try.  I don't quite know
what it is that's causing this giant backlog of inode modifications - I
suspect it's the rsync that's pushing it over.  But regardless, I'm
interested in testing the fix.

Thanks!

Jeff.

-- 
Fact: 30.3% of all statistics are generated randomly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
