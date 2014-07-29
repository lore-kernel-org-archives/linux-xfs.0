Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EE887F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 09:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DCD3304039
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 07:33:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QS73QLPXYHeTLjCb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 07:33:56 -0700 (PDT)
Date: Tue, 29 Jul 2014 10:43:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/18] xfs: refactor xfs_inobt_insert() to eliminate loop
	and support variable count
Message-ID: <20140729144303.GA17085@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-2-git-send-email-bfoster@redhat.com>
	<20140724221038.GN20518@dastard>
	<20140728160351.GB59542@bfoster.bfoster>
	<20140728233219.GF26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140728233219.GF26465@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2014 at 09:32:19AM +1000, Dave Chinner wrote:
> On Mon, Jul 28, 2014 at 12:03:52PM -0400, Brian Foster wrote:
> > On Fri, Jul 25, 2014 at 08:10:38AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 24, 2014 at 10:22:51AM -0400, Brian Foster wrote:
> > > > Inodes are always allocated in chunks of 64 and thus the loop in
> > > > xfs_inobt_insert() is unnecessary.
> > > 
> > > I don't believe this is true. The number of inodes allocated at once
> > > is:
> > > 
> > >         mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
> > > 	                                        sbp->sb_inopblock);
> > > 
> > 
> > So I'm going on that effectively that the number of inodes per block
> > will never be larger than 8 (v5) due to a max block size of 4k.
> 
> The whole world is not x86... ;)
> 
> > > So when the block size is, say, 64k, the number of 512 byte inodes
> > > allocated at once is 128. i.e. 2 chunks. Hence xfs_inobt_insert()
> > > can be called with a inode could of > 64 and therefore the loop is
> > > still necessary...
> > > 
> > 
> > Playing with mkfs I see that we actually can format >4k bsize
> > filesystems and the min and max are set at 512b and 64k. I can't
> > actually mount such filesystems due to the page size limitation.
> 
> The whole world is not x86.... ;)
> 
> ia64 and power default to 64k page size, so we have to code
> everything to work with 64k block sizes.
> 

Yeah, I was aware there are >4k paged arches. I just wasn't sure which
and how they're used. I'll look into these.

> > FWIW,
> > the default log size params appear to be broken for bsize >= 32k as
> 
> In what way?
> 

# mkfs.xfs -f /dev/test/scratch -bsize=32k
log size 320 blocks too small, minimum size is 512 blocks
Usage: mkfs.xfs
...

This is a 10G lv so I suspect the following code is related:

	...
	} else if (dblocks < GIGABYTES(16, blocklog)) {
	...
		logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
				min_logblocks * XFS_DFL_LOG_FACTOR);
	} else {
	...

E.g., MIN_LOG_BYTES is 10MB and MIN_LOG_BLOCKS is 512 (then multiplied
by 5 here). The latter calculation results in 80MB, so we choose the
former and the subsequent log size validation fails due to not meeting
the minimum block count requirement. It still doesn't make much sense to
me why we use the min here. The minimum log ends up being 16MB for 32k
block size even if we skip the LOG_FACTOR scaling.

> > well, so I wonder if/how often that format tends to occur.
> 
> More often than you think.
> 

Not too surprising. :) FWIW, this is in fact limited to the <16GB fs
case. The small size range probably reduces the chances of hitting this
(as opposed to block size).

> > What's the situation with regard to >PAGE_SIZE block size support? Is
> > this something we actually could support today?
> 
> Well, the problem is bufferheads and page cache don't support blocks
> large than page size. The metadata side of XFS supports it just fine
> through the xfs_buf structures, but the file data side doesn't.
> That's one of the things I'm slowly trying to find time to fix (i.e.
> kill bufferheads).
> 

Ok.

> > Do we know about any
> > large page sized arches that could push us into this territory with the
> > actual page size limitation?
> 
> Yes, see above. We have always supported 64k block sizes on Linux
> ever since ia64 supported 64k page sizes (i.e. for at least 10
> years), so we can't now say "we only support 4k block sizes"....
> 

Indeed, I'd expect to have to support it. I was just looking for more
background.

> > I suppose if we have >4k page sized arches that utilize block sizes
> > outside of the 256b-4k range, that's enough to justify the existence of
> > the range in the general sense. I just might have to factor this area of
> > code a bit differently. It would also be nice if there was a means to
> > test.
> 
> Grab a ppc64 box from the RH QE guys or ask them to test it....
> 

Will do, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
