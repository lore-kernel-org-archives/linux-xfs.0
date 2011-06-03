Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p530dC7X233021 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 19:39:12 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D24C7499A59
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 17:39:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PVvxWMUAgxC8KQkN for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 17:39:10 -0700 (PDT)
Date: Fri, 3 Jun 2011 10:39:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110603003907.GW561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<4DE823DD.7060600@philkarn.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE823DD.7060600@philkarn.net>
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
To: Phil Karn <karn@philkarn.net>
Cc: Paul Anderson <pha@umich.edu>, Linux fs XFS <xfs@oss.sgi.com>

On Thu, Jun 02, 2011 at 04:59:25PM -0700, Phil Karn wrote:
> On 6/2/11 2:24 PM, Paul Anderson wrote:
> 
> > The data itself has very odd lifecycle behavior, as well - since it is
> > research, the different stages are still being sorted out, but some
> > stages are essentially write once, read once, maybe keep, maybe
> > discard, depending on the research scenario.
> ...
> > The bulk of the work is not small-file - almost all is large files.
> 
> Out of curiosity, do your writers use the fallocate() call? If not, how
> fragmented do your filesystems get?
> 
> Even if most of your data isn't read very often, it seems like a good
> idea to minimize its fragmentation because that also reduces
> fragmentation of the free list, which makes it easier to keep contiguous
> other files that *are* heavily read. Also, fewer extents per file means
> less metadata per file, ergo less metadata and log I/O, etc.
> 
> When a writer knows in advance how big a file will be, I can't see any
> downside to having it call fallocate() to let the file system know.

You're ignoring the fact that delayed allocation effectively does
this for you without needing to physically allocate the blocks.
So when you have files that are short lived, you don't actually do
any allocation at all, Further delayed allocation results in
allocation order according to writeback order rather than write()
order, so I/O patterns are much nicer when using delayed allocation.

Basicaly you are removing one of the major IO optimisation
capabilities of XFS by preallocating everything like this.

> Soon
> after I switched to XFS six months ago I've been running locally patched
> versions of rsync/tar/cp and so on, and they really do minimize
> fragmentation with very little effort.

So you don't have any idea of how well XFS minimises fragmentation
without needing to use preallocation? Sounds like you have a classic
case of premature optimisation. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
