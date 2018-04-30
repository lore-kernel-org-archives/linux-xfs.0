Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:45850 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753277AbeD3WAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 18:00:23 -0400
Date: Tue, 1 May 2018 08:00:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: skip discard of unwritten extents
Message-ID: <20180430220020.GE13766@dastard>
References: <20180426180624.6134-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426180624.6134-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 26, 2018 at 02:06:24PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> What do folks think of something like this?

Definitely sounds like something we need to address.

> The motivation here is that
> the VDO (dedup) devs had reported seeing online discards during
> write-only workloads. These turn out to be related to trimming post-eof
> preallocation blocks after large file copies. To my knowledge, this
> isn't really a prevalent or serious issue, but I think that technically
> these discards are unnecessary and so I was looking into how we could
> avoid them.

We simply trucate post-eof extents, right? So we know in
xfs_itruncate_extents() if the inode size is changing, not to
mention we know if the extent is beyond EOF? e.g. all calls to
xfs_itruncate_extents() other than xfs_free_eofblocks() change the
inode size and so directly indicate they are removing written
blocks. Anything where the inode size is not changing is doing a
post-eof removal, and so we can assume no data has been written?

So rather than converting everything to unwritten extents, the "skip
discard flag" is simply triggered via extents being freed sitting
beyond the current EOF (not the new EOF) and/or being unwritten?

> This behavior is of course not directly related to unwritten extents,
> but the immediate/obvious solution to bubble up a bmapi flag of some
> kind to xfs_free_eofblocks() seemed rather crude. From there, I figured
> that we technically don't need to discard any unwritten extents (within
> or beyond EOF) because they haven't been written to since being
> allocated. In fact, I'm not sure we have to even busy them, but it's
> roughly equivalent logic either way and I'm trying to avoid getting too
> clever.

I think we still need to busy them to avoid re-allocating them in
the same checkpoint, as data extent free/realloc in the same
checkpoint could result in a failed recovery (i.e. partial
checkpoint replay) leaving the extent linked into two separate
files.

> I also recall that we've discussed using unwritten extents for delalloc
> -> real conversion to avoid the small stale data exposure window that
> exists in writeback. Without getting too deep into the reason we don't
> currently do an initial unwritten allocation [1], I don't think there's
> anything blocking us from converting any post-eof blocks that happen to
> be part of the resulting normal allocation. As it is, the imap is
> already trimmed to EOF by the writeback code for coherency reasons. If
> we were to convert post-eof blocks (not part of this patch) along with
> something like this patch, then we'd indirectly prevent discards for
> eofblocks trims.

I think we should leave that as a separate problem, as writeback
currently has issues with the way we manage bufferhead state.
i.e. things don't work right if we put unwritten extents under
delalloc buffers and vice versa. [ I have patches to address that
I'm working on.] And there's also the issue that we need to change
the delalloc reservations to take into account block allocations
required by unwritten extent conversion needed by delalloc.

Hence I think we should address that as a separate problem, not as
the solution to avoiding discard of post-eof extents.

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4bcc095fe44a..942c90ec6747 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2954,13 +2954,15 @@ xfs_free_extent(
>  	xfs_fsblock_t		bno,	/* starting block number of extent */
>  	xfs_extlen_t		len,	/* length of extent */
>  	struct xfs_owner_info	*oinfo,	/* extent owner */
> -	enum xfs_ag_resv_type	type)	/* block reservation type */
> +	enum xfs_ag_resv_type	type,	/* block reservation type */
> +	bool			skip_discard)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
>  	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
>  	int			error;
> +	unsigned int		busy_flags = 0;
>  
>  	ASSERT(len != 0);
>  	ASSERT(type != XFS_AG_RESV_AGFL);
> @@ -2984,7 +2986,9 @@ xfs_free_extent(
>  	if (error)
>  		goto err;
>  
> -	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
> +	if (skip_discard)
> +		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
> +	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
>  	return 0;

Rather than changing xfs_free_extent(), how about adding a
xfs_free_extent_nodiscard() wrapper, and only call it when
processing an extent that doesn't need discard? This means none of
the other code that frees extents needs to be changed. Similarly
add a xfs_bmap_add_free_nodiscard() wrapper. That will cut down on
the code churn caused by passing new parameters everywhere....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
