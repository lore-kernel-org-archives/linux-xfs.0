Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB24F7F6D
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 20:42:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C958304039
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 18:42:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	k16p22vty6BxKnn1 for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 18:41:59 -0700 (PDT)
Date: Mon, 17 Mar 2014 12:41:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317014156.GC7072@dastard>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140317001130.GA7072@dastard>
	<20140317002918.GT18016@ZenIV.linux.org.uk>
	<20140317012804.GU18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317012804.GU18016@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Mar 17, 2014 at 01:28:04AM +0000, Al Viro wrote:
> On Mon, Mar 17, 2014 at 12:29:18AM +0000, Al Viro wrote:
> 
> > I think I know what's going on - O_DIRECT write starting a bit before
> > EOF on a file with the last extent that can be grown.  It fills
> > a buffer_head with b_size extending quite a bit past the EOF; the
> > blocks are really allocated.  What causes the problem is that we
> > have the flags set for the *first* block.  IOW, buffer_new(bh) is
> > false - the first block has already been allocated.  And for
> > direct-io.c it means "no zeroing the tail of the last block".
> 
> BTW, that's something I have directly observed - xfs_get_blocks_direct()
> called with iblock corresponding to a bit under 16Kb below EOF and
> returning with ->b_size equal to 700K and ->b_flags not containing BH_New.

What's the userspace IO pattern that triggers this?

> IOW, we really can't mix new and old blocks in that interface - not enough
> information is passed back to caller to be able to decide what does and
> what does not need zeroing out.  It should be either all-new or all-old.

Right, and XFS should not be mixing old and new in the way you are
describing, and that's what I can't reproduce. See my reply on the
other thread. Probably best to continue there...

> And it's not just the EOF, of course - the beginning of a hole in a sparse
> file isn't any different from the end of file in that respect.

Except that XFS treats that differently - it does allocation as
unwritten extents there, and any mapping that covers an unwritten
block will always result in buffer_new() getting set...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
