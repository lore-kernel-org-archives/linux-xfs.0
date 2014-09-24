Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C92F7F63
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A2718F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:30:22 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	p3JSW5bH22nXxv9X for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:30:17 -0700 (PDT)
Date: Thu, 25 Sep 2014 09:30:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: borrow indirect blocks from freed extent when
	available
Message-ID: <20140924233014.GB4758@dastard>
References: <1411500538-6831-1-git-send-email-bfoster@redhat.com>
	<20140923215816.GC4322@dastard>
	<20140924122746.GA53094@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140924122746.GA53094@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 24, 2014 at 08:27:46AM -0400, Brian Foster wrote:
> On Wed, Sep 24, 2014 at 07:58:16AM +1000, Dave Chinner wrote:
> > On Tue, Sep 23, 2014 at 03:28:58PM -0400, Brian Foster wrote:
> > > xfs_bmap_del_extent() handles extent removal from the in-core and
> > > on-disk extent lists. When removing a delalloc range, it updates the
> > > indirect block reservation appropriately based on the removal. It
> > > currently enforces that the new indirect block reservation is less than
> > > or equal to the original. This is normally the case in all situations
> > > except for when the removed range creates a hole in a single delalloc
> > > extent, thus splitting a single delalloc extent in two.
> > > 
> > > The indirect block reservation is divided evenly between the two new
> > > extents in this scenario. However, it is possible with small enough
> > > extents to split an indlen==1 extent into two such slightly smaller
> > > extents. This leaves one extent with 0 indirect blocks and leads to
> > > assert failures in other areas (e.g., xfs_bunmapi() if the extent
> > > happens to be removed).
> > 
> > I had long suspected we had an issue in this code, but was never
> > able to nail down a reproducer that triggered it. Do you have a
> > reproducer, or did you find this by reading/tracing the code?
> > 
> 
> I have a setup on which fsx reproduces an instance of this within a few
> minutes consistently. It looks like the same sequence of events each
> occurrence so I can try to derive a more specific test case for it. I
> suspect the right sequence of delayed allocation followed by hole
> punching or zeroing should be able to trigger it.

*nod*

> > > Refactor xfs_bunmapi() to make the updates that must be consistent
> > > against the inode (e.g., delalloc block counter, quota reservation)
> > > right before the extent is deleted. Move the sb block counter update
> > > after the extent is deleted and update xfs_bmap_del_extent() to steal
> > > some blocks from the freed extent if a larger overall indirect
> > > reservation is required by the extent removal.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Hi all,
> > > 
> > > I'm seeing the following assert more frequently with fsx and the recent
> > > xfs_free_file_space() changes (at least on 1k fsb fs'):
> > > 
> > > XFS: Assertion failed: startblockval(del.br_startblock) > 0, file: fs/xfs/libxfs/xfs_bmap.c, line: 5281
> > > 
> > > This occurs for the reason described in the commit log description. This
> > > is a quick experiment I wanted to test to verify the problem goes away
> > > (so far, so good). Very lightly tested so far.
> > 
> > I suspect it's also the cause of these occasional assert failures
> > that I see:
> > 
> > XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 327
> > 
> > during delalloc conversion because there wasn't a space reservation
> > for the blocks allocated (i.e. indlen was zero) and so we overrun
> > the transaction block reservation.
> > 
> 
> Interesting, I've seen this as well though I'll have to go back and see
> where I was getting it from. I did run fsx overnight without any assert
> failures at all, which seems rare lately. ;) I wasn't running my usual
> parallel fsstress however. I've started that and I reproduce an instance
> of that assert failure within a few minutes, so if related it appears
> this might not be the only contributer. I'll look more into that one
> next.

I knew I'd looked at this before:

http://oss.sgi.com/archives/xfs/2014-03/msg00314.html

That got lost because I wrote it in a topic branch and not my usual
working branch, so when I dropped the topic branch. Guilt, however,
keeps all the patches from topic branches around, and so when I just
did a grep for da_new across .git/patch, this showed up.

It's basically the same "steal blocks from the deleted extent
reservation fix, and it was trying to address the above failure.
However, there are some other details in it (like changing the
location of delalloc accounting updates) that might be relevant.


I'm pretty sure the test case was simply something like:

xfs_io -f -c "pwrite 0 1m" \
	  -c "fzero 4k 8k" \
	  -c "fzero 16k 8k" \
	  -c "fzero 32k 8k" \
	  -c "fzero 64k 8k" \
	 .....

To basically split the delalloc extent repeatedly and hence drain
the reservation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
