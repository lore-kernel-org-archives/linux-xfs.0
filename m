Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA95oJd9137035 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 23:50:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFB47164FCB
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 21:51:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	EalIQBKPiSzOQRcw for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 21:51:45 -0800 (PST)
Date: Tue, 9 Nov 2010 16:51:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: fix failed write handling
Message-ID: <20101109055142.GJ2715@dastard>
References: <20101109002559.GA30016@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109002559.GA30016@infradead.org>
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

On Mon, Nov 08, 2010 at 07:26:00PM -0500, Christoph Hellwig wrote:
> Since the move to the new truncate sequence we call xfs_setattr to
> truncate down excessively instanciated blocks.  As shown by the testcase
> in kernel.org BZ #22452 that doesn't work too well.  Due to the confusion
> of the internal inode size, and the VFS inode i_size it zeroes data that
> it shouldn't.
> 
> But full blown truncate seems like overkill here.  We only instanciate
> delayed allocations in the write path, and given that we never released
> the iolock we can't have converted them to real allocations yet either.
> 
> The only nasty case is pre-existing preallocation which we need to skip.
> The patch below does that by borrowing code from xfs_aops_discard_page.
> It does pass xfstests for 4k block filesystems and fixes the original
> bug.  I'm not quite sure if we could hit a corner case with smaller
> block sizes when parts of a page are preallocated and some not.

Seems likely - preallocated block past EOF are not unusual.

> That
> could be handled by looping around bmapi as long as we find extents
> for our range.  The path could probably also be refactored to share
> code with xfs_aops_discard_page.  And we probably need the ilock
> just as in that path, but I only got to that when almost through
> xfstests, and the day is over for me today, so let's just get the
> patch out for now.

Yes, definitely need the ilock - that's the only lock that provides
protection for the extent tree.

It looks to me that we need a general "discard delalloc blocks from
range" function - I'll write one (basically the guts of
xfs_aops_discard_page) and convert xfs_aops_discard_page() and this
code to use it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
