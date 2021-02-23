Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A357C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C286764E89
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhBWUbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:31:00 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55049 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhBWUa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:30:59 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 0CA04106D3D;
        Wed, 24 Feb 2021 07:30:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEeJx-0017hb-WD; Wed, 24 Feb 2021 07:30:14 +1100
Date:   Wed, 24 Feb 2021 07:30:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Allow scrub to detect inodes with non-maximal sized
 extents
Message-ID: <20210223203013.GX4662@dread.disaster.area>
References: <20210223082629.16719-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223082629.16719-1-chandanrlinux@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=0EbtQTlrJvHHMCBtTDQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 01:56:29PM +0530, Chandan Babu R wrote:
> This commit now makes it possible for scrub to check if an inode's extents are
> maximally sized i.e. it checks if an inode's extent is contiguous (in terms of
> both file offset and disk offset) with neighbouring extents and the total
> length of both the extents is less than the maximum allowed extent
> length (i.e. MAXEXTLEN).

It took me a while to understand that what this is actually doing
(had to read the code because I couldn't work out what this meant).
Essentially, it is determining if two extents that are physically
and logically adjacent were not merged together into a single extent
when the combined size of the two extents would fit into a single
extent record.

I'm not sure this is an issue - it most definitely isn't corruption
as nothing will have any problems looking up either extent, nor
modifying or removing either extent. It's not ideal, but it isn't
corruption.

I can see how it would come about, too, because extent removal
doesn't merge remaining partial extents.

That is, create a long written extent in a file, then use fallocate
to allocate an adjacent extent that puts the two extents over
MAXEXTLEN. Now we have two phsyically and logically adjacent extents
that only differ by state. Now do a single write that converts the
entire unwritten extent to written so no merging occurs during the
state conversion.  Now punch out the far end of the second extent.

This ends up in xfs_bmap_del_extent_real(), which simply removes the
end of the second extent. It does not look up the previous extent
and attempt to merge the remaining part of the second extent into
the previous adjacent extent.

Hence, at this point, we have two logically and physically adjacent
extents whose combined length is less than MAXLEN. This patch will
now signal that as corruption, which is wrong.

> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/scrub/inode.c   | 11 +++++++----
>  fs/xfs/xfs_bmap_util.c | 36 +++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_bmap_util.h |  5 +++--
>  fs/xfs/xfs_qm.c        |  2 +-
>  4 files changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index faf65eb5bd31..33b530785e36 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -478,23 +478,26 @@ xchk_inode_xref_bmap(
>  	xfs_filblks_t		count;
>  	xfs_filblks_t		acount;
>  	int			error;
> +	bool			maximal_sized_exts;
>  
>  	if (xchk_skip_xref(sc->sm))
>  		return;
>  
>  	/* Walk all the extents to check nextents/naextents/nblocks. */
> +	maximal_sized_exts = true;
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
> -			&nextents, &count);
> +			&nextents, &count, &maximal_sized_exts);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < be32_to_cpu(dip->di_nextents) || !maximal_sized_exts)
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
> +	maximal_sized_exts = true;
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
> -			&nextents, &acount);
> +			&nextents, &acount, &maximal_sized_exts);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != be16_to_cpu(dip->di_anextents) || !maximal_sized_exts)
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e7d68318e6a5..eca39677a46f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -176,6 +176,25 @@ xfs_bmap_rtalloc(
>   * Extent tree block counting routines.
>   */
>  
> +STATIC bool
> +is_maximal_extent(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*icur,
> +	struct xfs_bmbt_irec	*got)
> +{
> +	struct xfs_bmbt_irec	left;
> +
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &left) &&
> +		!isnullstartblock(left.br_startblock) &&
> +		left.br_startoff + left.br_blockcount == got->br_startoff &&
> +		left.br_startblock + left.br_blockcount == got->br_startblock &&
> +		left.br_state == got->br_state &&
> +		left.br_blockcount + got->br_blockcount <= MAXEXTLEN)
> +		return false;
> +	else
> +		return true;
> +}
> +
>  /*
>   * Count leaf blocks given a range of extent records.  Delayed allocation
>   * extents are not counted towards the totals.
> @@ -183,7 +202,8 @@ xfs_bmap_rtalloc(
>  xfs_extnum_t
>  xfs_bmap_count_leaves(
>  	struct xfs_ifork	*ifp,
> -	xfs_filblks_t		*count)
> +	xfs_filblks_t		*count,
> +	bool			*maximal_sized_exts)
>  {
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	got;
> @@ -191,6 +211,10 @@ xfs_bmap_count_leaves(
>  
>  	for_each_xfs_iext(ifp, &icur, &got) {
>  		if (!isnullstartblock(got.br_startblock)) {
> +			if (maximal_sized_exts)
> +				*maximal_sized_exts =
> +					is_maximal_extent(ifp, &icur, &got);

This looks broken, anyway. Even if you find a "bad" extent, the
state will get overwritten by the next good extent and hence never
get reported.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
