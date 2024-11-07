Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9361D86ED;
	Thu,  7 Nov 2024 23:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731023473; cv=none; b=iX7eeEYuJtP/ISldMpARjpHzVq+f/JtWIWTs6OtWO+8JMxdCnKQA6gKHZ5CYFOfoSCd0VirvewB9AABVn8VA5F2t1cyjvDIYsZA09MKrUtIDs7cxc7pi0Sbvyk34kdzKpzjsBjKVTRXS5oRb25PN5i5FmPpT+BmZtfHBbG6V2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731023473; c=relaxed/simple;
	bh=RqdUPtqZiOi/Trpuy/KKeKlEbjmheyiVbitf7HBbc94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=go9rSsLyAw4CvVBc93qiSPrbnr4cqpl6NJ9cvbZH4yKs9XLmJiEum4txzMKi+HEuiNH75JQNAxjMwIoc5zH3GiB9Pr+6v59LL9fff2x9naEGivmusvOB8OGRfF+qZIRFa7HBmucydHN3uLT5iNA2XJWXJOW61SYBCh7iIR9qRPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwYhu90u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwYhu90u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DF5C4CECC;
	Thu,  7 Nov 2024 23:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731023472;
	bh=RqdUPtqZiOi/Trpuy/KKeKlEbjmheyiVbitf7HBbc94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bwYhu90uCrJu4mpxiRugRm51SuBkuiwd2UTfIsLI23s5YOK+no9/nESy1VpfN7g8g
	 +QIfg8ybvvJ2zPFpOrYQWSl/yNOGJfX18yceisJ1z8UKbGdpA5Coe8C6h//ooyLKjz
	 oUlzUNmumpuhRW7QkbAa1CMSmD+NLAeRZn+EjZT20L6EkLC8lv4hhz74GD2+Khqpt4
	 4wOmwGR6G6RqjzLTO4P8OlWUkvNJAlaBXkSC6DEFT5Lft8oLIXRpK8RnKG94uDodVf
	 UUYILqTZPBrJn+P+paWj5LcULYEQhiVDrcfc4+ATcG+ty/2JRfBxtphO4DROiOApOQ
	 yLzYJ+TLs2F+A==
Date: Thu, 7 Nov 2024 15:51:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH 2/2] xfs: Fix incorrect parameter calculation in rt fsmap
Message-ID: <20241107235112.GV2386201@frogsfrogsfrogs>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <20240826031005.2493150-3-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826031005.2493150-3-wozizhi@huawei.com>

On Mon, Aug 26, 2024 at 11:10:05AM +0800, Zizhi Wo wrote:
> I noticed a bug related to xfs realtime device fsmap:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -r' /mnt
>  EXT: DEV    BLOCK-RANGE         OWNER            FILE-OFFSET      AG AG-OFFSET          TOTAL
>    0: 253:48 [0..7]:             unknown                                                     8
>    1: 253:48 [8..1048575]:       free space                                            1048568
>    2: 253:48 [1048576..1050623]: unknown                                                  2048
>    3: 253:48 [1050624..2097151]: free space                                            1046528
> 
> Bug:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -r 1050621 1050621' /mnt
>  EXT: DEV    BLOCK-RANGE         OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>    0: 253:48 [1050621..1050623]: unknown                                                   3
>    1: 253:48 [1050624..1050631]: free space                                                8
> Normally, we should not get any results, but we do get two queries.
> 
> The root cause of this problem lies in the calculation of "end_rtb" in
> xfs_getfsmap_rtdev_rtbitmap(), which uses XFS_BB_TO_FSB method (round up).
> However, in the subsequent call to xfs_rtalloc_query_range(), "high_rec"
> calculated based on "end_rtb" has a semantic meaning of being reachable
> within the loop. The first round of the loop in xfs_rtalloc_query_range()
> doesn't find any free extents. But after incrementing "rtstart" by 1, start
> still does not exceed "high_key", and the second round of the loop entered.
> It finds free extent and obtains the first unknown extent by subtracting it
> from "info->next_daddr". Even though we can accurately handle it through
> "info->end_daddr", two incorrect extents has already been returned before
> the last query. The main call stack is as follows:
> 
> xfs_getfsmap_rtdev_rtbitmap
>   // rounded up
>   end_rtb = XFS_BB_TO_FSB(..., keys[1].fmr_physical)
>   ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb)
>   xfs_rtalloc_query_range
>     // high_key is calculated based on end_rtb
>     high_key = min(high_rec->ar_startext, ...)
>     while (rtstart <= high_key)
>       // First loop, doesn't find free extent
>       xfs_rtcheck_range
>       rtstart = rtend + 1
>       // Second loop, the free extent outside the query interval is found
>       xfs_getfsmap_rtdev_rtbitmap_helper
>         // unknown and free were printed out together in the second round
>         xfs_getfsmap_helper
> 
> The issue is resolved by adjusting the relevant calculations. Both the loop
> exit condition in the xfs_rtalloc_query_range() and the length calculation
> condition (high_key - start + 1) in the xfs_rtfind_forw() reflect the open
> interval semantics of "high_key". Therefore, when calculating "end_rtb",
> XFS_BB_TO_FSBT is used. In addition, in order to satisfy the close interval
> semantics, "key[1].fmr_physical" needs to be decremented by 1. For the
> non-eofs case, there is no need to worry about over-counting because we can
> accurately count the block number through "info->end_daddr".
> 
> After applying this patch, the above problem have been solved:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -r 1050621 1050621' /mnt
> [root@fedora ~]#
> 
> Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
>  fs/xfs/xfs_fsmap.c           | 20 +++++++++++++++++---
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 386b672c5058..7af4e7afda7d 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1034,8 +1034,7 @@ xfs_rtalloc_query_range(
>  
>  	if (low_rec->ar_startext > high_rec->ar_startext)
>  		return -EINVAL;
> -	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
> -	    low_rec->ar_startext == high_rec->ar_startext)
> +	if (low_rec->ar_startext >= mp->m_sb.sb_rextents)
>  		return 0;
>  
>  	high_key = min(high_rec->ar_startext, mp->m_sb.sb_rextents - 1);
> @@ -1057,7 +1056,6 @@ xfs_rtalloc_query_range(
>  		if (is_free) {
>  			rec.ar_startext = rtstart;
>  			rec.ar_extcount = rtend - rtstart + 1;
> -
>  			error = fn(mp, tp, &rec, priv);
>  			if (error)
>  				break;

Not sure why these changes are necessary?

> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 8a2dfe96dae7..42c4b94b0493 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -515,11 +515,20 @@ xfs_getfsmap_rtdev_rtbitmap(
>  	int				error;
>  
>  	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
> -	if (keys[0].fmr_physical >= eofs)
> +	if (keys[0].fmr_physical >= eofs ||
> +		keys[0].fmr_physical == keys[1].fmr_physical)
>  		return 0;
>  	start_rtb = XFS_BB_TO_FSBT(mp,
>  				keys[0].fmr_physical + keys[0].fmr_length);
> -	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
> +	/*
> +	 * The passed keys[1] is an unreachable value, while "end_rtb" is used
> +	 * to calculate "ahigh.ar_startext", serving as an input parameter for
> +	 * xfs_rtalloc_query_range(), which is a value that can be reached.
> +	 * Therefore, it is necessary to use "keys[1].fmr_physical - 1" here.
> +	 * And because of the semantics of "end_rtb", it needs to be
> +	 * supplemented by 1 in the last calculation.
> +	 */
> +	end_rtb = XFS_BB_TO_FSBT(mp, min(eofs - 1, keys[1].fmr_physical - 1));

keys[1].fmr_physical should already be the ahigh.ar_startext value that
the user wants.  No need to subtract 1 here.

>  	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
>  
> @@ -549,9 +558,14 @@ xfs_getfsmap_rtdev_rtbitmap(
>  	/*
>  	 * Report any gaps at the end of the rtbitmap by simulating a null
>  	 * rmap starting at the block after the end of the query range.
> +	 * For the boundary case of eofs, we need to increment the count
> +	 * by 1 to prevent omission in block statistics.
> +	 * For the boundary case of non-eofs, even if incrementing by 1
> +	 * may lead to over-counting, it doesn't matter because it is
> +	 * handled by "info->end_daddr" in this situation, not "ahigh".
>  	 */
>  	info->last = true;
> -	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
> +	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext + 1);

Ah, that.  I think hch and I accidentally fixed this in
https://lore.kernel.org/linux-xfs/173084397143.1871025.11595051287386271783.stgit@frogsfrogsfrogs/

--D

>  
>  	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
>  	if (error)
> -- 
> 2.39.2
> 
> 
