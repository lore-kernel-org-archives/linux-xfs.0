Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CBBC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 22:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiDVWoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiDVWlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 18:41:45 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3D4B161E90
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 14:43:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C5607534552;
        Sat, 23 Apr 2022 07:43:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ni13w-003KPZ-9H; Sat, 23 Apr 2022 07:43:36 +1000
Date:   Sat, 23 Apr 2022 07:43:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: speed up rmap lookups by using non-overlapped
 lookups when possible
Message-ID: <20220422214336.GW1544202@dread.disaster.area>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
 <164997685638.383709.4789775648712621300.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997685638.383709.4789775648712621300.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6263218a
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=THs0KBySIzEuiYoJLZYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reverse mapping on a reflink-capable filesystem has some pretty high
> overhead when performing file operations.  This is because the rmap
> records for logically and physically adjacent extents might not be
> adjacent in the rmap index due to data block sharing.  As a result, we
> use expensive overlapped-interval btree search, which walks every record
> that overlaps with the supplied key in the hopes of finding the record.
> 
> However, profiling data shows that when the index contains a record that
> is an exact match for a query key, the non-overlapped btree search
> function can find the record much faster than the overlapped version.
> Try the non-overlapped lookup first, which will make scrub run much
> faster.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rmap.c |   38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 3eea8056e7bc..5aa94deb3afd 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -402,12 +402,38 @@ xfs_rmap_lookup_le_range(
>  	info.irec = irec;
>  	info.stat = stat;
>  
> -	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
> -			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
> -	error = xfs_rmap_query_range(cur, &info.high, &info.high,
> -			xfs_rmap_lookup_le_range_helper, &info);
> -	if (error == -ECANCELED)
> -		error = 0;
> +	trace_xfs_rmap_lookup_le_range(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> +			bno, 0, owner, offset, flags);
> +
> +	/*
> +	 * Historically, we always used the range query to walk every reverse
> +	 * mapping that could possibly overlap the key that the caller asked
> +	 * for, and filter out the ones that don't.  That is very slow when
> +	 * there are a lot of records.
> +	 *
> +	 * However, there are two scenarios where the classic btree search can
> +	 * produce correct results -- if the index contains a record that is an
> +	 * exact match for the lookup key; and if there are no other records
> +	 * between the record we want and the key we supplied.
> +	 *
> +	 * As an optimization, try a non-overlapped lookup first.  This makes
> +	 * scrub run much faster on most filesystems because bmbt records are
> +	 * usually an exact match for rmap records.  If we don't find what we
> +	 * want, we fall back to the overlapped query.
> +	 */
> +	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
> +	if (error)
> +		return error;
> +	if (*stat) {
> +		*stat = 0;
> +		xfs_rmap_lookup_le_range_helper(cur, irec, &info);
> +	}
> +	if (!(*stat)) {
> +		error = xfs_rmap_query_range(cur, &info.high, &info.high,
> +				xfs_rmap_lookup_le_range_helper, &info);
> +		if (error == -ECANCELED)
> +			error = 0;
> +	}

Ok, I can see what this is doing, but the code is nasty - zeroing
info.stat via *stat = 0, then having
xfs_rmap_lookup_le_range_helper() modify *stat via info.stat and
then relying on that implicit update to skip the very next if
(!(*stat)) clause is not very nice.

xfs_rmap_lookup_le_range_helper() returns -ECANCELED when it's
found a match, so we can use this rather than relying on *stat
to determine what to do:

	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
	if (error)
		return error;

	info.irec = irec;
	info.stat = 0;
	if (*stat)
		error = xfs_rmap_lookup_le_range_helper(cur, irec, &info);
	if (!error)
		error = xfs_rmap_query_range(cur, &info.high, &info.high,
				xfs_rmap_lookup_le_range_helper, &info);
	if (error == -ECANCELED)
		error = 0;

	*stat = info.stat;
....

Cheers,

Dave.

>  	if (*stat)
>  		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
>  				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
> 
> 

-- 
Dave Chinner
david@fromorbit.com
