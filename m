Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RMnWJM149145 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 17:49:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QX2PCNuO6lqbhNM3 for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 15:50:51 -0700 (PDT)
Date: Fri, 28 Sep 2012 08:50:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120927225043.GA25626@dastard>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
	<20120423202441.GD21260@poseidon.cudanet.local>
	<20120423232759.GO9541@dastard> <20120927124914.GD28852@poseidon>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120927124914.GD28852@poseidon>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 08:49:15AM -0400, Josef 'Jeff' Sipek wrote:
> On Tue, Apr 24, 2012 at 09:27:59AM +1000, Dave Chinner wrote:
> ...
> > So, yes, your hangs are definitely due to inode buffer RMW cycles
> > when trying to flush dirty inodes from the cache. I have a few
> > ideas on how to fix this - but I'm not sure whether a current TOT
> > solution will be easily back-portable. The simplest solution is a
> > readahead based solution - AIL pushing is async, and will cycle back
> > to inodes that it failed to flush the first time past, so triggering
> > readahead on the first pass might work just fine.
> 
> Have you had time to look at this?

No.

> (We got bitten by this again and I
> really don't want to go back to ext4.)  Is there anything I can help with?

What is needed is a xfs_inode_readahead function(), which takes an
xfs inode and attempts to issue readahead on the underlying buffer
if it is not found in cache.

The simplest thing to do is add another flag to xfs_buf_read that is
passed through from xfs_iflush() to say "don't block on read".
Indeed, we used to have a XBF_DONT_BLOCK flag that we removed
recently becuse it was the default behaviour for everything. That
could be reintroduced to tell xfs_buf_read_map() that it should
return the bufer if it is in cache, or issue readahead and return
null if it is not found in memory so that a read a little while
later might find it. COmbined iwth the XBF_TRYLOCK that xfs_iflush
alrady uses, it won't block on read IO already in progress, either.
i.e. there's a difference between not-in-cache and
in-cache-but-locked when it comes to issuing readahead, so there
might need to be slight changes to xfs_buf_find() to accomodate
that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
