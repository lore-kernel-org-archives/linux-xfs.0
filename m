Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4D0C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83C0206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MED0WDRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgESMsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 08:48:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58295 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgESMsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 08:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589892513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/l//UKgkqvanR5uIDJyyLLeuGT/Vl/DnKJI3Kqk+k7E=;
        b=MED0WDRDiUCdrHBw3JD2vap2JtynYLnYuXfBQoujWDf2NnYXQWFb9T/5gZteUEor21qdaI
        +g40+GFwK9Zw1r7Ib9sC+bp18phTA7V6TDSlsryCHW3nCcz0Zdpr0itErPRxgSPlaNSS/o
        vqICcRiPL0bseZfuc3xMamiRgpqUyDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-rXlewsz1MFaN_7J01k7HWg-1; Tue, 19 May 2020 08:48:31 -0400
X-MC-Unique: rXlewsz1MFaN_7J01k7HWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1903E8015D1;
        Tue, 19 May 2020 12:48:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E82182A12;
        Tue, 19 May 2020 12:48:29 +0000 (UTC)
Date:   Tue, 19 May 2020 08:48:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200519124827.GC23387@bfoster>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984936387.619853.12262802837092587871.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:49:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're estimating a new speculative preallocation length for an
> extending write, we should walk backwards through the extent list to
> determine the number of number of blocks that are physically and
> logically contiguous with the write offset, and use that as an input to
> the preallocation size computation.
> 
> This way, preallocation length is truly measured by the effectiveness of
> the allocator in giving us contiguous allocations without being
> influenced by the state of a given extent.  This fixes both the problem
> where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> the unnecessary shrinkage of preallocation when delalloc extents are
> turned into unwritten extents.
> 
> This was found as a regression in xfs/014 after changing delalloc writes
> to create unwritten extents during writeback.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iomap.c |   63 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 52 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ac970b13b1f8..2dffd56a433c 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -351,6 +351,46 @@ xfs_quota_calc_throttle(
>  	}
>  }
>  
> +/*
> + * Determine if the previous extent's range of offsets is contiguous with
> + * @offset_fsb.  If so, set @prev_contig to the number of blocks that are
> + * physically contiguous with that previous extent and return true.  If there
> + * is no previous extent or there's a hole right before @offset_fsb, return
> + * false.
> + *
> + * Note that we don't care if the previous extents are written or not.

Why? :) Might be helpful to elaborate on why we require this algorithm
now...

> + */
> +static inline bool
> +xfs_iomap_prev_contiguous(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*cur,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_extlen_t		*prev_contig)
> +{
> +	struct xfs_iext_cursor	ncur = *cur;
> +	struct xfs_bmbt_irec	got, old;
> +
> +	xfs_iext_prev(ifp, &ncur);
> +	if (!xfs_iext_get_extent(ifp, &ncur, &old))
> +		return false;
> +	if (old.br_startoff + old.br_blockcount < offset_fsb)
> +		return false;
> +
> +	*prev_contig = old.br_blockcount;
> +
> +	xfs_iext_prev(ifp, &ncur);
> +	while (xfs_iext_get_extent(ifp, &ncur, &got) &&
> +	       got.br_blockcount + got.br_startoff == old.br_startoff &&
> +	       got.br_blockcount + got.br_startblock == old.br_startblock &&
> +	       *prev_contig <= MAXEXTLEN) {
> +		*prev_contig += got.br_blockcount;
> +		old = got; /* struct copy */
> +		xfs_iext_prev(ifp, &ncur);
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * If we are doing a write at the end of the file and there are no allocations
>   * past this one, then extend the allocation out to the file system's write
> @@ -380,12 +420,12 @@ xfs_iomap_prealloc_size(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	struct xfs_bmbt_irec	prev;
>  	int			shift = 0;
>  	int64_t			freesp;
>  	xfs_fsblock_t		qblocks;
>  	int			qshift = 0;
>  	xfs_fsblock_t		alloc_blocks = 0;
> +	xfs_extlen_t		plen = 0;
>  
>  	if (offset + count <= XFS_ISIZE(ip))
>  		return 0;
> @@ -400,9 +440,9 @@ xfs_iomap_prealloc_size(
>  	 */
>  	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
> -	    prev.br_startoff + prev.br_blockcount < offset_fsb)
> +	    !xfs_iomap_prev_contiguous(ifp, icur, offset_fsb, &plen)) {
>  		return mp->m_allocsize_blocks;
> +	}
>  
>  	/*
>  	 * Determine the initial size of the preallocation. We are beyond the
> @@ -413,15 +453,16 @@ xfs_iomap_prealloc_size(
>  	 * preallocation size.
>  	 *
>  	 * If the extent is a hole, then preallocation is essentially disabled.
> -	 * Otherwise we take the size of the preceding data extent as the basis
> -	 * for the preallocation size. If the size of the extent is greater than
> -	 * half the maximum extent length, then use the current offset as the
> -	 * basis. This ensures that for large files the preallocation size
> -	 * always extends to MAXEXTLEN rather than falling short due to things
> -	 * like stripe unit/width alignment of real extents.
> +	 * Otherwise we take the size of the contiguous preceding data extents
> +	 * as the basis for the preallocation size. If the size of the extent

I'd refer to it as the "size of the contiguous range" or some such since
we're now talking about aggregating many extents to form the prealloc
basis.

I am a little curious if there's any noticeable impact from having to
perform the worst case extent walk in this path. For example, suppose we
had a speculatively preallocated file where we started writing (i.e.
converting) every other unwritten block such that this path had to walk
an extent per block until hitting the 8g max (8g == 2097152 4k blocks).
I guess the hope is that either most of those blocks wouldn't have been
written back and converted by the time we'd trigger the next post-eof
prealloc or that it would just be a wash in the stream of staggered
writes falling into our max sized preallocations. Either way, I think
it's more important to maintain the existing heuristic so this seems
reasonable from that perspective.

This scenario also makes me wonder if we should consider continuing to
do write time file size extension zeroing in certain cases vs. leaving
around unwritten extents. For example, the current post-eof prealloc
behavior is that writes that jump over current EOF will zero (via
buffered writes) any allocated blocks (delalloc or physical) between
current EOF and the start of the write. That behavior doesn't change
with delalloc -> unwritten if the prealloc is still delalloc at the time
of the extending write, but we'd presumably skip those zeroing writes if
the prealloc had been converted to real+unwritten first. Hmm.. that does
seem a little random to me, particularly if somebody starts to see
unwritten extents sprinkled throughout a file that never explicitly saw
preallocation. Perhaps we should avoid converting post-eof blocks? OTOH,
unwritten probably makes sense for large jumps in EOF vs zeroing GBs of
blocks, so one could argue that we should convert such ranges (if still
delalloc) rather than zero them at all. Thoughts? We should probably
work this out one way or another before landing the delalloc ->
unwritten behavior..

Brian

> +	 * is greater than half the maximum extent length, then use the current
> +	 * offset as the basis. This ensures that for large files the
> +	 * preallocation size always extends to MAXEXTLEN rather than falling
> +	 * short due to things like stripe unit/width alignment of real
> +	 * extents.
>  	 */
> -	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> -		alloc_blocks = prev.br_blockcount << 1;
> +	if (plen <= (MAXEXTLEN >> 1))
> +		alloc_blocks = plen << 1;
>  	else
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	if (!alloc_blocks)
> 

