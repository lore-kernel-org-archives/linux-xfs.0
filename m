Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0JDTYGl221493 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 07:29:34 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09CE51488857
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 05:31:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Cock4FVVlre33lrl for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 05:31:51 -0800 (PST)
Date: Thu, 20 Jan 2011 00:31:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110119133147.GN16267@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110119120321.GC12941@infradead.org>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Wed, Jan 19, 2011 at 07:03:21AM -0500, Christoph Hellwig wrote:
> On Wed, Jan 19, 2011 at 10:18:32AM +1100, Dave Chinner wrote:
> > Except for the fact we use the delalloc state from the buffer to
> > trigger allocation after mapping. We could probably just use
> > isnullstartblock() for this - only a mapping from a buffer over a
> > delalloc range should return a null startblock.
> 
> isnullstartblock returns true for both DELAYSTARTBLOCK and
> HOLESTARTBLOCK, so we want to be explicit we can check for
> br_startblock == DELAYSTARTBLOCK.

True.

> 
> Note that we also need to explicitly check for br_state == 
> XFS_EXT_UNWRITTEN to set the correct type for the ioend structure.

Yes. As i mentioned on IRC I hacked a  quick prototype together to
test this out and did exactly this. ;)

> 
> > XFS_BMAPI_IGSTATE does a couple of things. Firstly, It prevents
> > xfs_bmapi() from allocating new extents (turns off write mode).
> > This isn't an issue where it is used because neither of the call
> > sites set XFS_BMAPI_WRITE.
> 
> I've been down enough to understand what it does.  But yes, the
> single large I/O mapping might explain why we want it.  The next
> version of xfs_map_blocks will get a comment for it..
> 
> > In fact, we probably should be setting this for normal written
> > extents as well, so that the case:
> > 
> > 	A               B                 C
> > 	+---------------+-----------------+
> > 	    written          unwritten
> > 
> > is also handled with the same optimisation. That makes handling
> > unwritten and overwrites identical, with only delalloc being
> > different. If we assume delalloc when we get a null startblock,
> > then we don't need to look at the buffer state at all for the
> > initial mapping.
> 
> With the current xfs_bmapi code that won't work.  When merging a second
> extent into the first we only add up the br_blockcount.  So for the
> case above we'd get an extent returned that's not marked as unwrittent
> and we wouldn't mark the ioend as unwrittent and thus perform not
> extent conversion after I/O completion.  Just adding XFS_BMAPI_IGSTATE
> blindly for the delalloc case on the other hand is fine, as the
> merging of delayed extents is handled in a different if clause that
> totally ignores XFS_BMAPI_IGSTATE.
>
> The potention fix for this is to always set br_state if one of the
> merged extents is an unwrittent extent. The only other caller is
> xfs_getbmap which does report the unwrittent state to userspace,
> but already is sloppy for merging the other way if BMV_IF_PREALLOC
> is not set, so I can't see how beening sloppy this way to makes any
> difference.

Yup:


@@ -4827,6 +4827,18 @@ xfs_bmapi(
 			ASSERT(mval->br_startoff ==
 			       mval[-1].br_startoff + mval[-1].br_blockcount);
 			mval[-1].br_blockcount += mval->br_blockcount;
+			/*
+			 * if one of the extent types is unwritten, make sure
+			 * the extent is reported as unwritten so the caller
+			 * always takes the correct action for unwritten
+			 * extents. This means we always return consistent
+			 * state regardless of whether we find a written or
+			 * unwritten extent first.
+			 */
+			if (mval[-1].br_state != XFS_EXT_UNWRITTEN &&
+			    mval->br_state == XFS_EXT_UNWRITTEN) {
+				mval[-1].br_state = XFS_EXT_UNWRITTEN;
+			}
 		} else if (n > 0 &&
 			   mval->br_startblock == DELAYSTARTBLOCK &&
 			   mval[-1].br_startblock == DELAYSTARTBLOCK &&

> > It seems to me that with such modifications, the only thing that we
> > are using the bufferhead for is the buffer_uptodate() flag to
> > determine if we should write the block or not. If we can find some
> > other way of holding this state then we don't need bufferheads in
> > the write path at all, right?
> 
> There's really two steps.  First we can stop needing buffers headers
> for the space allocation / mapping.  This is doable with the slight
> tweak of XFS_BMAPI_IGSTATE semantics.
> 
> We still do need to set BH_Delay or BH_Unwrittent for use in
> __block_write_begin and block_truncate_page, but they become completely
> interchangeable at that point.
> 
> If we want to completely get rid of buffers heads things are a bit
> more complicated.  It's doable as shown by the _nobh aops, but we'll
> use quite a bit of per-block state that needs to be replaced by per-page
> state,

Sure, or use a similar method to btrfs which stores dirty state bits
in a separate extent tree. Worst case memory usage is still much
less than a bufferhead per block...

> and we'll lose the way to cache the block number in the buffer
> head.  While we don't make use of that in writepage we do so in
> the write path, although I'm not sure how important it is.  If we
> get your multi-page write work in it probably won't matter any more.

The only place we use bh->b_blocknr is for ioend manipulation. Am I
missing something else?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
