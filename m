Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0JC13qt210866 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 06:01:03 -0600
Date: Wed, 19 Jan 2011 07:03:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110119120321.GC12941@infradead.org>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118231831.GZ28803@dastard>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Wed, Jan 19, 2011 at 10:18:32AM +1100, Dave Chinner wrote:
> Except for the fact we use the delalloc state from the buffer to
> trigger allocation after mapping. We could probably just use
> isnullstartblock() for this - only a mapping from a buffer over a
> delalloc range should return a null startblock.

isnullstartblock returns true for both DELAYSTARTBLOCK and
HOLESTARTBLOCK, so we want to be explicit we can check for
br_startblock == DELAYSTARTBLOCK.

Note that we also need to explicitly check for br_state == 
XFS_EXT_UNWRITTEN to set the correct type for the ioend structure.

> XFS_BMAPI_IGSTATE does a couple of things. Firstly, It prevents
> xfs_bmapi() from allocating new extents (turns off write mode).
> This isn't an issue where it is used because neither of the call
> sites set XFS_BMAPI_WRITE.

I've been down enough to understand what it does.  But yes, the
single large I/O mapping might explain why we want it.  The next
version of xfs_map_blocks will get a comment for it..

> In fact, we probably should be setting this for normal written
> extents as well, so that the case:
> 
> 	A               B                 C
> 	+---------------+-----------------+
> 	    written          unwritten
> 
> is also handled with the same optimisation. That makes handling
> unwritten and overwrites identical, with only delalloc being
> different. If we assume delalloc when we get a null startblock,
> then we don't need to look at the buffer state at all for the
> initial mapping.

With the current xfs_bmapi code that won't work.  When merging a second
extent into the first we only add up the br_blockcount.  So for the
case above we'd get an extent returned that's not marked as unwrittent
and we wouldn't mark the ioend as unwrittent and thus perform not
extent conversion after I/O completion.  Just adding XFS_BMAPI_IGSTATE
blindly for the delalloc case on the other hand is fine, as the
merging of delayed extents is handled in a different if clause that
totally ignores XFS_BMAPI_IGSTATE.

The potention fix for this is to always set br_state if one of the
merged extents is an unwrittent extent. The only other caller is
xfs_getbmap which does report the unwrittent state to userspace,
but already is sloppy for merging the other way if BMV_IF_PREALLOC
is not set, so I can't see how beening sloppy this way to makes any
difference.

> It seems to me that with such modifications, the only thing that we
> are using the bufferhead for is the buffer_uptodate() flag to
> determine if we should write the block or not. If we can find some
> other way of holding this state then we don't need bufferheads in
> the write path at all, right?

There's really two steps.  First we can stop needing buffers headers
for the space allocation / mapping.  This is doable with the slight
tweak of XFS_BMAPI_IGSTATE semantics.

We still do need to set BH_Delay or BH_Unwrittent for use in
__block_write_begin and block_truncate_page, but they become completely
interchangeable at that point.

If we want to completely get rid of buffers heads things are a bit
more complicated.  It's doable as shown by the _nobh aops, but we'll
use quite a bit of per-block state that needs to be replaced by per-page
state, and we'll lose the way to cache the block number in the buffer
head.  While we don't make use of that in writepage we do so in
the write path, although I'm not sure how important it is.  If we
get your multi-page write work in it probably won't matter any more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
