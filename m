Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F22C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E8F2076A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fs07YZCt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgFIWMw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 18:12:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgFIWMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 18:12:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 059MCijT179907;
        Tue, 9 Jun 2020 22:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4k/X3+w6QUBO8KiFIF7nO1HZleJdJ3k7J5xqYxu4iOE=;
 b=Fs07YZCtMbmXrCb+rLoEv0tZm6uOIoSs7TJbLxUhhXh08F+/ck2NXxzyFM6er3imQ5Lk
 NA9/k/zb2ou1RKLrzrBx9WnZ8M/6QF7vPRvm6JjhHWHJA0XwK1uUv8VIQ6V8boyWIMRl
 6jKh+TmpJJo3rkA8Ph20Lcrv43IKAhOiduzETsFPPzL4DRNJRVKJrkS9ksmrcdk7FhyD
 3Xqt7lYsrigOEjvSnyUB/fiJzSfSTqBkMue60WRoPgYEPXDnD61inW4yUU0RHI8WUepC
 R1v0g6t9evydR5091t1Iru3PvxB/8SGCIQ0B/q4ejqIVg5HLRGEBSM9E2dOMH33ixXy4 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3smy7yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 22:12:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 059M3hKO047970;
        Tue, 9 Jun 2020 22:12:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31gn2xcaem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 22:12:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 059MCgTx008582;
        Tue, 9 Jun 2020 22:12:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 15:12:40 -0700
Date:   Tue, 9 Jun 2020 15:12:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] xfs_repair: fix rebuilding btree node block less
 than minrecs
Message-ID: <20200609221239.GE11245@magnolia>
References: <20200609114053.31924-1-hsiangkao@redhat.com>
 <20200609201423.GD11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609201423.GD11245@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=5
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 01:14:23PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 09, 2020 at 07:40:53PM +0800, Gao Xiang wrote:
> > In production, we found that sometimes xfs_repair phase 5
> > rebuilds freespace node block with pointers less than minrecs
> > and if we trigger xfs_repair again it would report such
> > the following message:
> > 
> > bad btree nrecs (39, min=40, max=80) in btbno block 0/7882
> > 
> > The background is that xfs_repair starts to rebuild AGFL
> > after the freespace btree is settled in phase 5 so we may
> > need to leave necessary room in advance for each btree
> > leaves in order to avoid freespace btree split and then
> > result in AGFL rebuild fails. The old mathematics uses
> > ceil(num_extents / maxrecs) to decide the number of node
> > blocks. That would be fine without leaving extra space
> > since minrecs = maxrecs / 2 but if some slack was decreased
> > from maxrecs, the result would be larger than what is
> > expected and cause num_recs_pb less than minrecs, i.e:
> > 
> > num_extents = 79, adj_maxrecs = 80 - 2 (slack) = 78
> > 
> > so we'd get
> > 
> > num_blocks = ceil(79 / 78) = 2,
> > num_recs_pb = 79 / 2 = 39, which is less than
> > minrecs = 80 / 2 = 40
> > 
> > OTOH, btree bulk loading code behaves in a different way.
> > As in xfs_btree_bload_level_geometry it wrote
> > 
> > num_blocks = floor(num_extents / maxrecs)
> > 
> > which will never go below minrecs. And when it goes
> > above maxrecs, just increment num_blocks and recalculate
> > so we can get the reasonable results.
> > 
> > In the long term, btree bulk loader will replace the current
> > repair code as well as to resolve AGFL dependency issue.
> > But we may still want to look for a backportable solution
> > for stable versions. Hence, use the same logic to avoid the
> > freespace btree minrecs underflow for now.
> > 
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: Eric Sandeen <sandeen@sandeen.net>
> > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > not heavy tested yet..
> > 
> >  repair/phase5.c | 101 +++++++++++++++++++++---------------------------
> >  1 file changed, 45 insertions(+), 56 deletions(-)
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index abae8a08..997804a5 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -348,11 +348,29 @@ finish_cursor(bt_status_t *curs)
> >   * failure at runtime. Hence leave a couple of records slack space in
> >   * each block to allow immediate modification of the tree without
> >   * requiring splits to be done.
> > - *
> > - * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
> >   */
> > -#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> > -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> > +static void
> > +compute_level_geometry(xfs_mount_t *mp, bt_stat_level_t *lptr,
> > +		       uint64_t nr_this_level, bool leaf)
> 
> Please don't use structure typedefs here.
> 
> Also, please indent the argument list like the rest of xfs code, e.g.
> 
> static void
> compute_bnobt_geometry(
> 	struct xfs_mount	*mp,
> 	struct bt_stat_level	*lptr,
> 
> (etc)
> 
> > +{
> > +	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
> > +	int			slack = leaf ? 2 : 0;
> > +	unsigned int		desired_npb;
> > +
> > +	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
> > +	lptr->num_recs_tot = nr_this_level;
> > +	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
> > +
> > +	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> > +	lptr->modulo = nr_this_level % lptr->num_blocks;
> > +	if (lptr->num_recs_pb > maxrecs || (lptr->num_recs_pb == maxrecs &&
> > +			lptr->modulo)) {
> 
> Indentation....
> 
> 	if (lptr->num_recs_pb > maxrecs ||
> 	    (lptr->num_recs_pb == maxrecs && lptr->modulo)) {
> 		lptr->num_blocks++;
> 		...
> 	}
> 
> > +		lptr->num_blocks++;
> > +
> > +		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> > +		lptr->modulo = nr_this_level % lptr->num_blocks;

Oops, I hit send too quickly; the computation looks ok to me.

Granted that's probably due to having written another btree geometry
calculation function. :D

Also, I think init_rmapbt_cursor does a similar trick and therefore
suffers from a similar bug.  See the comment "Leave enough slack in the
rmapbt that we can insert..." around line 1412 or so?

--D

> > +	}
> > +}
> >  
> >  /*
> >   * this calculates a freespace cursor for an ag.
> > @@ -370,6 +388,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  	int			i;
> >  	int			extents_used;
> >  	int			extra_blocks;
> > +	uint64_t		old_blocks;
> >  	bt_stat_level_t		*lptr;
> >  	bt_stat_level_t		*p_lptr;
> >  	extent_tree_node_t	*ext_ptr;
> > @@ -388,10 +407,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  	 * of the tree and set up the cursor for the leaf level
> >  	 * (note that the same code is duplicated further down)
> >  	 */
> > -	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> > -	lptr->num_recs_pb = num_extents / lptr->num_blocks;
> > -	lptr->modulo = num_extents % lptr->num_blocks;
> > -	lptr->num_recs_tot = num_extents;
> > +	compute_level_geometry(mp, lptr, num_extents, true);
> >  	level = 1;
> >  
> >  #ifdef XR_BLD_FREE_TRACE
> > @@ -406,18 +422,12 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  	 * per level is the # of blocks in the level below it
> >  	 */
> >  	if (lptr->num_blocks > 1)  {
> > -		for (; btree_curs->level[level - 1].num_blocks > 1
> > -				&& level < XFS_BTREE_MAXLEVELS;
> > -				level++)  {
> > +		do {
> > +			p_lptr = lptr;
> >  			lptr = &btree_curs->level[level];
> > -			p_lptr = &btree_curs->level[level - 1];
> > -			lptr->num_blocks = howmany(p_lptr->num_blocks,
> > -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> > -			lptr->modulo = p_lptr->num_blocks
> > -					% lptr->num_blocks;
> > -			lptr->num_recs_pb = p_lptr->num_blocks
> > -					/ lptr->num_blocks;
> > -			lptr->num_recs_tot = p_lptr->num_blocks;
> > +
> > +			compute_level_geometry(mp, lptr,
> > +					p_lptr->num_blocks, false);
> >  #ifdef XR_BLD_FREE_TRACE
> >  			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
> >  					level,
> > @@ -426,7 +436,9 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  					lptr->modulo,
> >  					lptr->num_recs_tot);
> >  #endif
> > -		}
> > +			level++;
> > +		} while (lptr->num_blocks > 1);
> > +		ASSERT (level < XFS_BTREE_MAXLEVELS);
> >  	}
> >  
> >  	ASSERT(lptr->num_blocks == 1);
> > @@ -496,8 +508,11 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  	 * see if the number of leaf blocks will change as a result
> >  	 * of the number of extents changing
> >  	 */
> > -	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
> > -			!= btree_curs->level[0].num_blocks)  {
> > +	old_blocks = btree_curs->level[0].num_blocks;
> > +	compute_level_geometry(mp, &btree_curs->level[0], num_extents, true);
> > +	extra_blocks = 0;
> > +
> > +	if (old_blocks != btree_curs->level[0].num_blocks)  {
> >  		/*
> >  		 * yes -- recalculate the cursor.  If the number of
> >  		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
> > @@ -553,30 +568,20 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  		}
> >  
> >  		lptr = &btree_curs->level[0];
> > -		lptr->num_blocks = howmany(num_extents,
> > -					XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> > -		lptr->num_recs_pb = num_extents / lptr->num_blocks;
> > -		lptr->modulo = num_extents % lptr->num_blocks;
> > -		lptr->num_recs_tot = num_extents;
> >  		level = 1;
> >  
> >  		/*
> >  		 * if we need more levels, set them up
> >  		 */
> >  		if (lptr->num_blocks > 1)  {
> > -			for (level = 1; btree_curs->level[level-1].num_blocks
> > -					> 1 && level < XFS_BTREE_MAXLEVELS;
> > -					level++)  {
> > -				lptr = &btree_curs->level[level];
> > -				p_lptr = &btree_curs->level[level-1];
> > -				lptr->num_blocks = howmany(p_lptr->num_blocks,
> > -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> > -				lptr->modulo = p_lptr->num_blocks
> > -						% lptr->num_blocks;
> > -				lptr->num_recs_pb = p_lptr->num_blocks
> > -						/ lptr->num_blocks;
> > -				lptr->num_recs_tot = p_lptr->num_blocks;
> > -			}
> > +			do {
> > +				p_lptr = lptr;
> > +				lptr = &btree_curs->level[level++];
> > +
> > +				compute_level_geometry(mp, lptr,
> > +						p_lptr->num_blocks, false);
> > +			} while (lptr->num_blocks > 1);
> 
> /me wonders why it's necessary to wrap the do...while in an if test,
> as opposed to using a while loop with the if test up front?
> 
> --D
> 
> > +			ASSERT (level < XFS_BTREE_MAXLEVELS);
> >  		}
> >  		ASSERT(lptr->num_blocks == 1);
> >  		btree_curs->num_levels = level;
> > @@ -591,22 +596,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  
> >  		ASSERT(blocks_allocated_total >= blocks_needed);
> >  		extra_blocks = blocks_allocated_total - blocks_needed;
> > -	} else  {
> > -		if (extents_used > 0) {
> > -			/*
> > -			 * reset the leaf level geometry to account
> > -			 * for consumed extents.  we can leave the
> > -			 * rest of the cursor alone since the number
> > -			 * of leaf blocks hasn't changed.
> > -			 */
> > -			lptr = &btree_curs->level[0];
> > -
> > -			lptr->num_recs_pb = num_extents / lptr->num_blocks;
> > -			lptr->modulo = num_extents % lptr->num_blocks;
> > -			lptr->num_recs_tot = num_extents;
> > -		}
> > -
> > -		extra_blocks = 0;
> >  	}
> >  
> >  	btree_curs->num_tot_blocks = blocks_allocated_pt;
> > -- 
> > 2.18.1
> > 
