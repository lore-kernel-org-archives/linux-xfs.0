Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbeKUJab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 04:30:31 -0500
Date: Tue, 20 Nov 2018 14:58:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/7] xfs: delalloc -> unwritten COW fork allocation can
 go wrong
Message-ID: <20181120225853.GK6792@magnolia>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181120063605.GN19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120063605.GN19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 05:36:05PM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Long saga. There have been days spent following this through dead end
> after dead end in multi-GB event traces. This morning, after writing
> a trace-cmd wrapper that enabled me to be more selective about XFS
> trace points, I discovered that I could get just enough essential
> tracepoints enabled that there was a 50:50 chance the fsx config
> would fail at ~115k ops. If it didn't fail at op 115547, I stopped
> fsx at op 115548 anyway.
> 
> That gave me two traces - one where the problem manifested, and one
> where it didn't. After refining the traces to have the necessary
> information, I found that in the failing case there was a real
> extent in the COW fork compared to an unwritten extent in the
> working case.
> 
> Walking back through the two traces to the point where the CWO fork
> extents actually diverged, I found that the bad case had an extra
> unwritten extent in it. This is likely because the bug it led me to
> had triggered multiple times in those 115k ops, leaving stray
> COW extents around. What I saw was a COW delalloc conversion to an
> unwritten extent (as they should always be through
> xfs_iomap_write_allocate()) resulted in a /written extent/:
> 
> xfs_writepage:        dev 259:0 ino 0x83 pgoff 0x17000 size 0x79a00 offset 0 length 0
> xfs_iext_remove:      dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/2 offset 32 block 152 count 20 flag 1 caller xfs_bmap_add_extent_delay_real
> xfs_bmap_pre_update:  dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/1 offset 1 block 4503599627239429 count 31 flag 0 caller xfs_bmap_add_extent_delay_real
> xfs_bmap_post_update: dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/1 offset 1 block 121 count 51 flag 0 caller xfs_bmap_add_ex
> 
> Basically, Cow fork before:
> 
> 	0 1            32          52
> 	+H+DDDDDDDDDDDD+UUUUUUUUUUU+
> 	   PREV		RIGHT
> 
> COW delalloc conversion allocates:
> 
> 	  1	       32
> 	  +uuuuuuuuuuuu+
> 	  NEW
> 
> And the result according to the xfs_bmap_post_update trace was:
> 
> 	0 1            32          52
> 	+H+wwwwwwwwwwwwwwwwwwwwwwww+
> 	   PREV
> 
> Which is clearly wrong - it should be a merged unwritten extent,
> not an unwritten extent.
> 
> That lead me to look at the LEFT_FILLING|RIGHT_FILLING|RIGHT_CONTIG
> case in xfs_bmap_add_extent_delay_real(), and sure enough, there's
> the bug.
> 
> It takes the old delalloc extent (PREV) and adds the length of the
> RIGHT extent to it, takes the start block from NEW, removes the
> RIGHT extent and then updates PREV with the new extent.
> 
> What it fails to do is update PREV.br_state. For delalloc, this is
> always XFS_EXT_NORM, while in this case we are converting the
> delayed allocation to unwritten, so it needs to be updated to
> XFS_EXT_UNWRITTEN. This LF|RF|RC case does not do this, and so
> the resultant extent is always written.
> 
> And that's the bug I've been chasing for a week - a bmap btree bug,
> not a reflink/dedupe/copy_file_range bug, but a BMBT bug introduced
> with the recent in core extent tree scalability enhancements.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok, seems to fix the fsx failures I know how to reproduce... :P

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2d78fd53e822..39eaa2b86060 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1694,10 +1694,13 @@ xfs_bmap_add_extent_delay_real(
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
>  		/*
>  		 * Filling in all of a previously delayed allocation extent.
> -		 * The right neighbor is contiguous, the left is not.
> +		 * The right neighbor is contiguous, the left is not. Take care
> +		 * with delay -> unwritten extent allocation here because the
> +		 * delalloc record we are overwriting is always written.
>  		 */
>  		PREV.br_startblock = new->br_startblock;
>  		PREV.br_blockcount += RIGHT.br_blockcount;
> +		PREV.br_state = new->br_state;
>  
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_remove(bma->ip, &bma->icur, state);
