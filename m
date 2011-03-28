Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SLonK8187372 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:50:49 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD3731DFA1F2
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:53:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	exDg58ag0M7i5Bvl for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2011 14:53:57 -0700 (PDT)
Date: Tue, 29 Mar 2011 08:53:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Very aggressive memory reclaim
Message-ID: <20110328215344.GC3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
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
To: John Lepikhin <johnlepikhin@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[cc xfs and mm lists]

On Mon, Mar 28, 2011 at 08:39:29PM +0400, John Lepikhin wrote:
> Hello,
> 
> I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
> memory, intensive HDD traffic and 20..50 forks per second. Vanilla
> kernel 2.6.37.4. The problem is that kernel frees memory very
> aggressively.
> 
> For example:
> 
> 25% of memory is used by processes
> 50% for page caches
> 7% for slabs, etc.
> 18% free.
> 
> That's bad but works. After few hours:
> 
> 25% of memory is used by processes
> 62% for page caches
> 7% for slabs, etc.
> 5% free.
> 
> Most of files are cached, works perfectly. This is the moment when
> kernel decides to free some memory. After memory reclaim:
> 
> 25% of memory is used by processes
> 25% for page caches(!)
> 7% for slabs, etc.
> 43% free(!)
> 
> Page cache is dropped, server becomes too slow. This is the beginning
> of new cycle.
> 
> I didn't found any huge mallocs at that moment. Looks like because of
> large number of small mallocs (forks) kernel have pessimistic forecast
> about future memory usage and frees too much memory. Is there any
> options of tuning this? Any other variants?

First it would be useful to determine why the VM is reclaiming so
much memory. If it is somewhat predictable when the excessive
reclaim is going to happen, it might be worth capturing an event
trace from the VM so we can see more precisely what it is doiing
during this event. In that case, recording the kmem/* and vmscan/*
events is probably sufficient to tell us what memory allocations
triggered reclaim and how much reclaim was done on each event.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
