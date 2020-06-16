Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBEDC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 16:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8022151B
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 16:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l/1nRAHn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbgFPQLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 12:11:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbgFPQLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 12:11:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GG6rwL055757;
        Tue, 16 Jun 2020 16:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DIar1eQK2lzW0vIIjUygda1NQ7JNW/wFtpkqTwO3ZYw=;
 b=l/1nRAHnkUriGr9iTjumnkHPv2ako+k9tY3NcInb9B6492LmAqN0Dyd0avh0ChKDHi0s
 1idWWTV1yBnpLY5oyFQHji9ScGJrcmOTJNaLA5CSO16eQUOfA0aReP5q68Hrceh+z5bJ
 cw5VHedS53BK1u0nyJEG5n0ogB8TrdTQDHXQnQNkWjgytS9lVeUJKTaUXLUOYyOeA8zx
 4dkt3jdKKoRlf6uFaqJw4ksCYzxez3qNQ8Bh8V4rSNlnvauyNTImbMEyJ4hqsiWn6TJq
 rrWPx1726nzpq3P0q8TCTi9BDKcx4rSclDxav15K0HS/DrHgBZrJk4WetcE+rrg9w13m /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31p6e7yrym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 16:11:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GG9DUH082636;
        Tue, 16 Jun 2020 16:11:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31p6dh1719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 16:11:46 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05GGBj4p004898;
        Tue, 16 Jun 2020 16:11:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 09:11:44 -0700
Date:   Tue, 16 Jun 2020 09:11:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH v3] xfs_repair: fix rebuilding btree block less than
 minrecs
Message-ID: <20200616161143.GM11245@magnolia>
References: <20200610035842.22785-1-hsiangkao@redhat.com>
 <20200610052624.7425-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610052624.7425-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=5
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 10, 2020 at 01:26:24PM +0800, Gao Xiang wrote:
> In production, we found that sometimes xfs_repair phase 5
> rebuilds freespace node block with pointers less than minrecs
> and if we trigger xfs_repair again it would report such
> the following message:
> 
> bad btree nrecs (39, min=40, max=80) in btbno block 0/7882
> 
> The background is that xfs_repair starts to rebuild AGFL
> after the freespace btree is settled in phase 5 so we may
> need to leave necessary room in advance for each btree
> leaves in order to avoid freespace btree split and then
> result in AGFL rebuild fails. The old mathematics uses
> ceil(num_extents / maxrecs) to decide the number of node
> blocks. That would be fine without leaving extra space
> since minrecs = maxrecs / 2 but if some slack was decreased
> from maxrecs, the result would be larger than what is
> expected and cause num_recs_pb less than minrecs, i.e:
> 
> num_extents = 79, adj_maxrecs = 80 - 2 (slack) = 78
> 
> so we'd get
> 
> num_blocks = ceil(79 / 78) = 2,
> num_recs_pb = 79 / 2 = 39, which is less than
> minrecs = 80 / 2 = 40
> 
> OTOH, btree bulk loading code behaves in a different way.
> As in xfs_btree_bload_level_geometry it wrote
> 
> num_blocks = floor(num_extents / maxrecs)
> 
> which will never go below minrecs. And when it goes above
> maxrecs, just increment num_blocks and recalculate so we
> can get the reasonable results.
> 
> Later, btree bulk loader will replace the current repair code.
> But we may still want to look for a backportable solution
> for stable versions. Hence, keep the same logic to avoid
> the freespace as well as rmap btree minrecs underflow for now.
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v2:
>  still some minor styling fix (ASSERT, args)..
> 
> changes since v1:
>  - fix indentation, typedefs, etc code styling problem
>    pointed out by Darrick;
> 
>  - adapt init_rmapbt_cursor to the new algorithm since
>    it's similar pointed out by Darrick; thus the function
>    name remains the origin compute_level_geometry...
>    and hence, adjust the subject a bit as well.
> 
>  repair/phase5.c | 152 ++++++++++++++++++++----------------------------
>  1 file changed, 63 insertions(+), 89 deletions(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index abae8a08..d30d32b2 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -348,11 +348,32 @@ finish_cursor(bt_status_t *curs)
>   * failure at runtime. Hence leave a couple of records slack space in
>   * each block to allow immediate modification of the tree without
>   * requiring splits to be done.
> - *
> - * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
>   */
> -#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> +static void
> +compute_level_geometry(
> +	struct xfs_mount	*mp,
> +	struct bt_stat_level	*lptr,
> +	uint64_t		nr_this_level,

Probably didn't need a u64 here, but <shrug> that's probably just my
kernel-coloured glasses. :)

> +	int			slack,
> +	bool			leaf)
> +{
> +	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
> +	unsigned int		desired_npb;
> +
> +	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
> +	lptr->num_recs_tot = nr_this_level;
> +	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
> +
> +	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> +	lptr->modulo = nr_this_level % lptr->num_blocks;
> +	if (lptr->num_recs_pb > maxrecs ||
> +	    (lptr->num_recs_pb == maxrecs && lptr->modulo)) {
> +		lptr->num_blocks++;
> +
> +		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> +		lptr->modulo = nr_this_level % lptr->num_blocks;
> +	}

Seems to be more or less the same solution that I (half unknowingly)
coded into the btree bulkload geometry calculator, so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Still working on adapting the new phase5 code to try to fill the AGFL
as part of rebuilding the free space btrees, fwiw.)

--D

> +}
>  
>  /*
>   * this calculates a freespace cursor for an ag.
> @@ -370,6 +391,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	int			i;
>  	int			extents_used;
>  	int			extra_blocks;
> +	uint64_t		old_blocks;
>  	bt_stat_level_t		*lptr;
>  	bt_stat_level_t		*p_lptr;
>  	extent_tree_node_t	*ext_ptr;
> @@ -388,10 +410,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	 * of the tree and set up the cursor for the leaf level
>  	 * (note that the same code is duplicated further down)
>  	 */
> -	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> -	lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -	lptr->modulo = num_extents % lptr->num_blocks;
> -	lptr->num_recs_tot = num_extents;
> +	compute_level_geometry(mp, lptr, num_extents, 2, true);
>  	level = 1;
>  
>  #ifdef XR_BLD_FREE_TRACE
> @@ -405,30 +424,23 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	 * if we need more levels, set them up.  # of records
>  	 * per level is the # of blocks in the level below it
>  	 */
> -	if (lptr->num_blocks > 1)  {
> -		for (; btree_curs->level[level - 1].num_blocks > 1
> -				&& level < XFS_BTREE_MAXLEVELS;
> -				level++)  {
> -			lptr = &btree_curs->level[level];
> -			p_lptr = &btree_curs->level[level - 1];
> -			lptr->num_blocks = howmany(p_lptr->num_blocks,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> -			lptr->modulo = p_lptr->num_blocks
> -					% lptr->num_blocks;
> -			lptr->num_recs_pb = p_lptr->num_blocks
> -					/ lptr->num_blocks;
> -			lptr->num_recs_tot = p_lptr->num_blocks;
> +	while (lptr->num_blocks > 1) {
> +		p_lptr = lptr;
> +		lptr = &btree_curs->level[level];
> +
> +		compute_level_geometry(mp, lptr,
> +				p_lptr->num_blocks, 0, false);
>  #ifdef XR_BLD_FREE_TRACE
> -			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
> -					level,
> -					lptr->num_blocks,
> -					lptr->num_recs_pb,
> -					lptr->modulo,
> -					lptr->num_recs_tot);
> +		fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
> +				level,
> +				lptr->num_blocks,
> +				lptr->num_recs_pb,
> +				lptr->modulo,
> +				lptr->num_recs_tot);
>  #endif
> -		}
> +		level++;
>  	}
> -
> +	ASSERT(level < XFS_BTREE_MAXLEVELS);
>  	ASSERT(lptr->num_blocks == 1);
>  	btree_curs->num_levels = level;
>  
> @@ -496,8 +508,11 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	 * see if the number of leaf blocks will change as a result
>  	 * of the number of extents changing
>  	 */
> -	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
> -			!= btree_curs->level[0].num_blocks)  {
> +	old_blocks = btree_curs->level[0].num_blocks;
> +	compute_level_geometry(mp, &btree_curs->level[0], num_extents, 2, true);
> +	extra_blocks = 0;
> +
> +	if (old_blocks != btree_curs->level[0].num_blocks)  {
>  		/*
>  		 * yes -- recalculate the cursor.  If the number of
>  		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
> @@ -553,31 +568,19 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		}
>  
>  		lptr = &btree_curs->level[0];
> -		lptr->num_blocks = howmany(num_extents,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> -		lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -		lptr->modulo = num_extents % lptr->num_blocks;
> -		lptr->num_recs_tot = num_extents;
>  		level = 1;
>  
>  		/*
>  		 * if we need more levels, set them up
>  		 */
> -		if (lptr->num_blocks > 1)  {
> -			for (level = 1; btree_curs->level[level-1].num_blocks
> -					> 1 && level < XFS_BTREE_MAXLEVELS;
> -					level++)  {
> -				lptr = &btree_curs->level[level];
> -				p_lptr = &btree_curs->level[level-1];
> -				lptr->num_blocks = howmany(p_lptr->num_blocks,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> -				lptr->modulo = p_lptr->num_blocks
> -						% lptr->num_blocks;
> -				lptr->num_recs_pb = p_lptr->num_blocks
> -						/ lptr->num_blocks;
> -				lptr->num_recs_tot = p_lptr->num_blocks;
> -			}
> +		while (lptr->num_blocks > 1) {
> +			p_lptr = lptr;
> +			lptr = &btree_curs->level[level++];
> +
> +			compute_level_geometry(mp, lptr,
> +					p_lptr->num_blocks, 0, false);
>  		}
> +		ASSERT(level < XFS_BTREE_MAXLEVELS);
>  		ASSERT(lptr->num_blocks == 1);
>  		btree_curs->num_levels = level;
>  
> @@ -591,22 +594,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  
>  		ASSERT(blocks_allocated_total >= blocks_needed);
>  		extra_blocks = blocks_allocated_total - blocks_needed;
> -	} else  {
> -		if (extents_used > 0) {
> -			/*
> -			 * reset the leaf level geometry to account
> -			 * for consumed extents.  we can leave the
> -			 * rest of the cursor alone since the number
> -			 * of leaf blocks hasn't changed.
> -			 */
> -			lptr = &btree_curs->level[0];
> -
> -			lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -			lptr->modulo = num_extents % lptr->num_blocks;
> -			lptr->num_recs_tot = num_extents;
> -		}
> -
> -		extra_blocks = 0;
>  	}
>  
>  	btree_curs->num_tot_blocks = blocks_allocated_pt;
> @@ -1376,7 +1363,6 @@ init_rmapbt_cursor(
>  	struct bt_stat_level	*lptr;
>  	struct bt_stat_level	*p_lptr;
>  	xfs_extlen_t		blocks_allocated;
> -	int			maxrecs;
>  
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
>  		memset(btree_curs, 0, sizeof(struct bt_status));
> @@ -1412,32 +1398,20 @@ init_rmapbt_cursor(
>  	 * Leave enough slack in the rmapbt that we can insert the
>  	 * metadata AG entries without too many splits.
>  	 */
> -	maxrecs = mp->m_rmap_mxr[0];
> -	if (num_recs > maxrecs)
> -		maxrecs -= 10;
> -	blocks_allocated = lptr->num_blocks = howmany(num_recs, maxrecs);
> -
> -	lptr->modulo = num_recs % lptr->num_blocks;
> -	lptr->num_recs_pb = num_recs / lptr->num_blocks;
> -	lptr->num_recs_tot = num_recs;
> +	compute_level_geometry(mp, lptr, num_recs,
> +			num_recs > mp->m_rmap_mxr[0] ? 10 : 0, true);
> +	blocks_allocated = lptr->num_blocks;
>  	level = 1;
>  
> -	if (lptr->num_blocks > 1)  {
> -		for (; btree_curs->level[level-1].num_blocks > 1
> -				&& level < XFS_BTREE_MAXLEVELS;
> -				level++)  {
> -			lptr = &btree_curs->level[level];
> -			p_lptr = &btree_curs->level[level - 1];
> -			lptr->num_blocks = howmany(p_lptr->num_blocks,
> -				mp->m_rmap_mxr[1]);
> -			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
> -			lptr->num_recs_pb = p_lptr->num_blocks
> -					/ lptr->num_blocks;
> -			lptr->num_recs_tot = p_lptr->num_blocks;
> +	while (lptr->num_blocks > 1) {
> +		p_lptr = lptr;
> +		lptr = &btree_curs->level[level++];
>  
> -			blocks_allocated += lptr->num_blocks;
> -		}
> +		compute_level_geometry(mp, lptr,
> +				p_lptr->num_blocks, 0, false);
> +		blocks_allocated += lptr->num_blocks;
>  	}
> +	ASSERT(level < XFS_BTREE_MAXLEVELS);
>  	ASSERT(lptr->num_blocks == 1);
>  	btree_curs->num_levels = level;
>  
> -- 
> 2.18.1
> 
