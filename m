Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q216REJ0085914 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 00:27:14 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4SiexbrBL6IRQoKa for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 22:27:12 -0800 (PST)
Date: Thu, 1 Mar 2012 17:27:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Poor performance using discard
Message-ID: <20120301062709.GB5091@dastard>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
	<4F4E809A.40308@sandeen.net> <20120301055943.GA23051@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120301055943.GA23051@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Thomas Lynema <lyz27@yahoo.com>, xfs@oss.sgi.com

On Thu, Mar 01, 2012 at 12:59:43AM -0500, Christoph Hellwig wrote:
> On Wed, Feb 29, 2012 at 01:46:34PM -0600, Eric Sandeen wrote:
> > On 2/28/12 10:08 PM, Dave Chinner wrote:
> > 
> > > Also, I think you need to provide a block trace (output of
> > > blktrace/blkparse for the rm -rf workloads) for both the XFS and
> > > ext4 cases so we can see what discards are actually being issued and
> > > how long they take to complete....
> > > 
> > 
> > I ran a quick test on a loopback device on 3.3.0-rc4.  Loopback supports
> > discards.  I made 1G filesystems on loopback on ext4 & xfs, mounted with
> > -o discard, cloned a git tree to them, and ran rm -rf; sync under blktrace.
> > 
> > XFS took about 11 seconds, ext4 took about 1.7.
> > 
> > (without trim, times were roughly the same - but discard/trim is probably
> > quite fast on the looback file)
> > 
> > Both files were reduced in disk usage about the same amount, so online
> > discard was working for both:
> > 
> > # du -h ext4_fsfile xfs_fsfile
> > 497M	ext4_fsfile
> > 491M	xfs_fsfile
> > 
> > XFS issued many more discards than ext4:
> 
> XFS frees inode blocks, directory blocks and btree blocks.  ext4 only
> ever frees data blocks and the occasional indirect block on files.

One other thing the ext4 tracing implementation does is merge
adjacent ranges, whereas the XFS implementation does not. XFS has
more tracking complexity than ext4, though, in that it tracks free
extents in multiple concurrent journal commits whereas ext4 only has
to track across a single journal commit.  Hence ext4 can merge
without having to care about where the adjacent range is being
committed in the same journal checkpoint.

Further, ext4 doesn't reallocate from the freed extents until after
the journal commit completes, whilst XFS can reallocate freed ranges
before the freeing is journalled and hence can modify ranges in the
free list prior to journal commit.

We could probably implement extent merging in the free extent
tracking similar to ext4, but I'm not sure how much it would gain us
because of the way we do reallocation of freed ranges prior to
journal commit....

> So a proper discard implementation on XFS without either a reall fast
> non-blocking and/or vectored trim (like actually supported in hardware)
> XFS will be fairly slow.
>
> Unfortunately all the required bits are missing in the Linux block
> layer, thus you really should use fstrim for now. 

Another good reason for using fstrim instead of online discard... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
