Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBB2C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 18:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiDYSit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 14:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiDYSis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 14:38:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4C120198
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 11:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A0AB81A0C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 18:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B096AC385A9;
        Mon, 25 Apr 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650911740;
        bh=R7ZOfaVg8QHG4jjgVmMBq3VfmzqRGJN+XGYdZk7Ua7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNNsojOAuh3FPNC5T0fCrZybL41GB3HVGuqGvx//x6+R2XWGpL50OvDTAVh+B1Hlq
         AwBRx6do9ORUFTfTOd/S4HmQFvlc3pueLGEmFiGtowJDQNjfvYe08YjKWiWy7gCoF2
         kkpTfDCG3m5tE5alnB7ZSfRvKaV2joClrwZupHSdFEp8I7dwaCFdgh/i798yEEXUKF
         iH6s3uzkEnN03OdL4aPbjwKU57IRvvu+p42Yd+5/C/i3BxwwH/gFft7bYf6lgpQHPM
         VkI0Kw2s8Eru+ATew5h1DdaNeaTQCRxFcyDfNQhjE1TSK9MMMU+BTMJhhamvLWQqgY
         sF+p0soyJt+iw==
Date:   Mon, 25 Apr 2022 11:35:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: speed up rmap lookups by using non-overlapped
 lookups when possible
Message-ID: <20220425183539.GM17025@magnolia>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
 <164997685638.383709.4789775648712621300.stgit@magnolia>
 <20220422214336.GW1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422214336.GW1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 23, 2022 at 07:43:36AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 03:54:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reverse mapping on a reflink-capable filesystem has some pretty high
> > overhead when performing file operations.  This is because the rmap
> > records for logically and physically adjacent extents might not be
> > adjacent in the rmap index due to data block sharing.  As a result, we
> > use expensive overlapped-interval btree search, which walks every record
> > that overlaps with the supplied key in the hopes of finding the record.
> > 
> > However, profiling data shows that when the index contains a record that
> > is an exact match for a query key, the non-overlapped btree search
> > function can find the record much faster than the overlapped version.
> > Try the non-overlapped lookup first, which will make scrub run much
> > faster.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_rmap.c |   38 ++++++++++++++++++++++++++++++++------
> >  1 file changed, 32 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index 3eea8056e7bc..5aa94deb3afd 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -402,12 +402,38 @@ xfs_rmap_lookup_le_range(
> >  	info.irec = irec;
> >  	info.stat = stat;
> >  
> > -	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
> > -			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
> > -	error = xfs_rmap_query_range(cur, &info.high, &info.high,
> > -			xfs_rmap_lookup_le_range_helper, &info);
> > -	if (error == -ECANCELED)
> > -		error = 0;
> > +	trace_xfs_rmap_lookup_le_range(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> > +			bno, 0, owner, offset, flags);
> > +
> > +	/*
> > +	 * Historically, we always used the range query to walk every reverse
> > +	 * mapping that could possibly overlap the key that the caller asked
> > +	 * for, and filter out the ones that don't.  That is very slow when
> > +	 * there are a lot of records.
> > +	 *
> > +	 * However, there are two scenarios where the classic btree search can
> > +	 * produce correct results -- if the index contains a record that is an
> > +	 * exact match for the lookup key; and if there are no other records
> > +	 * between the record we want and the key we supplied.
> > +	 *
> > +	 * As an optimization, try a non-overlapped lookup first.  This makes
> > +	 * scrub run much faster on most filesystems because bmbt records are
> > +	 * usually an exact match for rmap records.  If we don't find what we
> > +	 * want, we fall back to the overlapped query.
> > +	 */
> > +	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
> > +	if (error)
> > +		return error;
> > +	if (*stat) {
> > +		*stat = 0;
> > +		xfs_rmap_lookup_le_range_helper(cur, irec, &info);
> > +	}
> > +	if (!(*stat)) {
> > +		error = xfs_rmap_query_range(cur, &info.high, &info.high,
> > +				xfs_rmap_lookup_le_range_helper, &info);
> > +		if (error == -ECANCELED)
> > +			error = 0;
> > +	}
> 
> Ok, I can see what this is doing, but the code is nasty - zeroing
> info.stat via *stat = 0, then having
> xfs_rmap_lookup_le_range_helper() modify *stat via info.stat and
> then relying on that implicit update to skip the very next if
> (!(*stat)) clause is not very nice.
> 
> xfs_rmap_lookup_le_range_helper() returns -ECANCELED when it's
> found a match, so we can use this rather than relying on *stat
> to determine what to do:
> 
> 	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
> 	if (error)
> 		return error;
> 
> 	info.irec = irec;
> 	info.stat = 0;
> 	if (*stat)
> 		error = xfs_rmap_lookup_le_range_helper(cur, irec, &info);
> 	if (!error)
> 		error = xfs_rmap_query_range(cur, &info.high, &info.high,
> 				xfs_rmap_lookup_le_range_helper, &info);
> 	if (error == -ECANCELED)
> 		error = 0;
> 
> 	*stat = info.stat;
> ....

I think this can be simplified even further by removing the field
xfs_find_left_neighbor_info.stat, and then the code becomes:

	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec,
			&found);
	if (error)
		return error;
	if (found)
		error = xfs_rmap_lookup_le_range_helper(cur, irec, &info);
	if (!error)
		error = xfs_rmap_query_range(cur, &info.high, &info.high,
				xfs_rmap_lookup_le_range_helper, &info);
	if (error != -ECANCELED)
		return error;

	*stat = 0;
	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
			irec->rm_flags);
	return 0;

--D

> 
> Cheers,
> 
> Dave.
> 
> >  	if (*stat)
> >  		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> >  				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
