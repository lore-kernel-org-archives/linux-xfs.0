Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AD9C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16FA320737
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o5CjqdgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHZRsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 13:48:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgHZRsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 13:48:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QHdnhf151987;
        Wed, 26 Aug 2020 17:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DnJF/oZevBagJ7FOpH7KvBOaRJCSp5N1h3eh8+mfSE8=;
 b=o5CjqdgDR7DShrqsuCXjX/tm6QmjHmqJt9fg95XyZ2JC/gwdW2HVwS+dVdJZOC50+cLd
 t0+ZmrSdP63oEilzDtkfOkxQavq+e404eL2wELbgMsLH4srA8AHqygrzvfAZI+iQsGv5
 VINl/g51ePp04zW2fKEmjv3lsdOwKKUX4GECy2GKkAHrC5awf/YqeGIcbrMhj/EU7cF3
 64wFnnLPfXTVHnJDIebvOq41NrVxJX+Qr4s5SAcVnJGazfn29MH0vJXWvhZ0zqxa4Pt4
 ulgDlWr7G2Ty27+xX/CKdtAAUjWlDN3wUjIgAuvfWfEQAVfGAIiuaP2npNTzhOmC8Spj mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbs1x72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 17:48:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QHaGWc187573;
        Wed, 26 Aug 2020 17:46:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 333ruatwdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 17:46:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QHkA6B006284;
        Wed, 26 Aug 2020 17:46:11 GMT
Received: from localhost (/10.159.241.208)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 10:46:10 -0700
Date:   Wed, 26 Aug 2020 10:46:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: store inode btree block counts in AGI header
Message-ID: <20200826174609.GR6096@magnolia>
References: <159770499163.3956743.11547013163186111497.stgit@magnolia>
 <159770499882.3956743.13285713456151087581.stgit@magnolia>
 <20200826172311.GC355692@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826172311.GC355692@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 01:23:11PM -0400, Brian Foster wrote:
> On Mon, Aug 17, 2020 at 03:56:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a btree block usage counters for both inode btrees to the AGI header
> > so that we don't have to walk the entire finobt at mount time to create
> > the per-AG reservations.
> > 
> 
> I like the idea. I assume there will be mkfs/repair code to accompany
> this..?

Yep.

https://lore.kernel.org/linux-xfs/159770508586.3958545.417872750558976156.stgit@magnolia/

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c           |    4 ++
> >  fs/xfs/libxfs/xfs_format.h       |   19 +++++++++
> >  fs/xfs/libxfs/xfs_ialloc.c       |    1 
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |   78 +++++++++++++++++++++++++++++++++++---
> >  fs/xfs/scrub/agheader.c          |   30 +++++++++++++++
> >  fs/xfs/scrub/agheader_repair.c   |   17 ++++++++
> >  fs/xfs/xfs_ondisk.h              |    2 -
> >  fs/xfs/xfs_super.c               |    4 ++
> >  8 files changed, 146 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 8cf73fe4338e..65d443c787d0 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -333,6 +333,10 @@ xfs_agiblock_init(
> >  	}
> >  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
> >  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		agi->agi_iblocks = cpu_to_be32(1);
> > +		agi->agi_fblocks = cpu_to_be32(1);
> > +	}
> >  }
> >  
> >  typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 31b7ece985bb..fb4a29eb1c7b 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -449,6 +449,7 @@ xfs_sb_has_compat_feature(
> >  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> > +#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> >  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> >  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > @@ -563,6 +564,18 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> >  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
> >  }
> >  
> > +/*
> > + * Inode btree block counter.  We record the number of inobt and finobt blocks
> > + * in the AGI header so that we can skip the finobt walk at mount time when
> > + * setting up per-AG reservations.  Since this is mostly an optimization of an
> > + * existing feature, we only enable it when that feature is also enabled.
> > + */
> > +static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
> > +{
> > +	return xfs_sb_version_hasfinobt(sbp) &&
> > +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
> > +}
> 
> The logic seems sane, but I wonder if we really should check for v5 +
> COMPAT_INOBTCNT here and let mkfs worry about the feature compatibility
> matrix. That would also mean we'd want to check hasfinobt() as well in
> places we adjust the ->agi_fblocks field, log the two fields separately,
> etc.

Urrk, I confused the logic here. :(

Originally this feature only added the finobt blockcount (hence the
hasfinobt check) because only the finobt needed a per-ag reservation.
Later I thought better of that and added the inobt blockcount too, just
in case we ever need it...

> That is arguably overkill, but then why do we have an ->agi_iblocks
> field at all? It seems a little odd to have that inobt variant but only
> ever account it when finobt is enabled, while it also doesn't appear to
> be used. If there are additional implicit benefits in terms of allowing
> more fs consistency checks in repair/scrub, then it would seem
> beneficial to allow this feature to work with or without finobt. Hm?

...so yes, having the inobt blockcount enables further consistency
checks in scrub.  You are correct that this feature should work with or
without finobt, though.  I'll correct that for v2.

> > + /*
> >   * end of superblock version macros
> >   */
> > @@ -765,6 +778,9 @@ typedef struct xfs_agi {
> >  	__be32		agi_free_root; /* root of the free inode btree */
> >  	__be32		agi_free_level;/* levels in free inode btree */
> >  
> > +	__be32		agi_iblocks;	/* inobt blocks used */
> > +	__be32		agi_fblocks;	/* finobt blocks used */
> > +
> >  	/* structure must be padded to 64 bit alignment */
> >  } xfs_agi_t;
> >  
> > @@ -785,7 +801,8 @@ typedef struct xfs_agi {
> >  #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
> >  #define	XFS_AGI_FREE_ROOT	(1 << 11)
> >  #define	XFS_AGI_FREE_LEVEL	(1 << 12)
> > -#define	XFS_AGI_NUM_BITS_R2	13
> > +#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
> > +#define	XFS_AGI_NUM_BITS_R2	14
> >  
> >  /* disk block (xfs_daddr_t) in the AG */
> >  #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index f742a96a2fe1..fef1d94c60a4 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2473,6 +2473,7 @@ xfs_ialloc_log_agi(
> >  		offsetof(xfs_agi_t, agi_unlinked),
> >  		offsetof(xfs_agi_t, agi_free_root),
> >  		offsetof(xfs_agi_t, agi_free_level),
> > +		offsetof(xfs_agi_t, agi_iblocks),
> >  		sizeof(xfs_agi_t)
> >  	};
> >  #ifdef DEBUG
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 3c8aebc36e64..fc28b38fb463 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -67,6 +67,25 @@ xfs_finobt_set_root(
> >  			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
> >  }
> >  
> > +/* Update the inode btree block counter for this btree. */
> > +static inline void
> > +xfs_inobt_change_blocks(
> 
> Nit, but how about xfs_inobt_mod_blocks() to be consistent with the
> transaction accounting helpers?

<nod> Fixed.

> > +	struct xfs_btree_cur	*cur,
> > +	int			howmuch)
> > +{
> > +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
> > +	struct xfs_agi		*agi = agbp->b_addr;
> > +
> > +	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
> > +		return;
> > +
> > +	if (cur->bc_btnum == XFS_BTNUM_FINO)
> > +		be32_add_cpu(&agi->agi_fblocks, howmuch);
> > +	else
> > +		be32_add_cpu(&agi->agi_iblocks, howmuch);
> > +	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
> > +}
> > +
> >  STATIC int
> >  __xfs_inobt_alloc_block(
> >  	struct xfs_btree_cur	*cur,
> > @@ -102,6 +121,7 @@ __xfs_inobt_alloc_block(
> >  
> >  	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
> >  	*stat = 1;
> > +	xfs_inobt_change_blocks(cur, 1);
> >  	return 0;
> >  }
> >  
> > @@ -122,10 +142,17 @@ xfs_finobt_alloc_block(
> >  	union xfs_btree_ptr	*new,
> >  	int			*stat)
> >  {
> > +	int			error;
> > +
> >  	if (cur->bc_mp->m_finobt_nores)
> > -		return xfs_inobt_alloc_block(cur, start, new, stat);
> > -	return __xfs_inobt_alloc_block(cur, start, new, stat,
> > -			XFS_AG_RESV_METADATA);
> > +		error = xfs_inobt_alloc_block(cur, start, new, stat);
> > +	else
> > +		error = __xfs_inobt_alloc_block(cur, start, new, stat,
> > +				XFS_AG_RESV_METADATA);
> > +	if (error)
> > +		return error;
> > +
> > +	return 0;
> 
> Is there a logic change somewhere in here that I'm missing..? :P

Nope.  Leftovers, sorry about that. :(

> >  }
> >  
> >  STATIC int
> > @@ -134,6 +161,7 @@ __xfs_inobt_free_block(
> >  	struct xfs_buf		*bp,
> >  	enum xfs_ag_resv_type	resv)
> >  {
> > +	xfs_inobt_change_blocks(cur, -1);
> >  	return xfs_free_extent(cur->bc_tp,
> >  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> >  			&XFS_RMAP_OINFO_INOBT, resv);
> > @@ -480,19 +508,29 @@ xfs_inobt_commit_staged_btree(
> >  {
> >  	struct xfs_agi		*agi = agbp->b_addr;
> >  	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> > +	int			fields;
> 
> This (along with a bunch of the changes below) are for scrub, right? I
> think that might be better off in a separate patch. In fact, I'd
> probably split this up into the following patches: 
> 
> 1.) new fields + accounting
> 2.) scrub bits
> 3.) finobt mount time optimization
> 3.) enable feature bit
> 
> Otherwise the rest mostly looks good to me.

<nod> OK I can do that.

--D

> Brian
> 
> >  
> >  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> >  
> >  	if (cur->bc_btnum == XFS_BTNUM_INO) {
> > +		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
> >  		agi->agi_root = cpu_to_be32(afake->af_root);
> >  		agi->agi_level = cpu_to_be32(afake->af_levels);
> > -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
> > +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> > +			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
> > +			fields |= XFS_AGI_IBLOCKS;
> > +		}
> > +		xfs_ialloc_log_agi(tp, agbp, fields);
> >  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
> >  	} else {
> > +		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
> >  		agi->agi_free_root = cpu_to_be32(afake->af_root);
> >  		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> > -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
> > -					     XFS_AGI_FREE_LEVEL);
> > +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> > +			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
> > +			fields |= XFS_AGI_IBLOCKS;
> > +		}
> > +		xfs_ialloc_log_agi(tp, agbp, fields);
> >  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
> >  	}
> >  }
> > @@ -673,6 +711,28 @@ xfs_inobt_count_blocks(
> >  	return error;
> >  }
> >  
> > +/* Read finobt block count from AGI header. */
> > +static int
> > +xfs_finobt_read_blocks(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_extlen_t		*tree_blocks)
> > +{
> > +	struct xfs_buf		*agbp;
> > +	struct xfs_agi		*agi;
> > +	int			error;
> > +
> > +	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> > +	if (error)
> > +		return error;
> > +
> > +	agi = agbp->b_addr;
> > +	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
> > +	xfs_trans_brelse(tp, agbp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Figure out how many blocks to reserve and how many are used by this btree.
> >   */
> > @@ -690,7 +750,11 @@ xfs_finobt_calc_reserves(
> >  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> >  		return 0;
> >  
> > -	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> > +		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
> > +	else
> > +		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
> > +				&tree_len);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index e9bcf1faa183..ae8e2e0ac64a 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -781,6 +781,35 @@ xchk_agi_xref_icounts(
> >  		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> >  }
> >  
> > +/* Check agi_[fi]blocks against tree size */
> > +static inline void
> > +xchk_agi_xref_fiblocks(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
> > +	xfs_agblock_t		blocks;
> > +	int			error = 0;
> > +
> > +	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
> > +		return;
> > +
> > +	if (sc->sa.ino_cur) {
> > +		error = xfs_btree_count_blocks(sc->sa.ino_cur, &blocks);
> > +		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
> > +			return;
> > +		if (blocks != be32_to_cpu(agi->agi_iblocks))
> > +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> > +	}
> > +
> > +	if (sc->sa.fino_cur) {
> > +		error = xfs_btree_count_blocks(sc->sa.fino_cur, &blocks);
> > +		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
> > +			return;
> > +		if (blocks != be32_to_cpu(agi->agi_fblocks))
> > +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> > +	}
> > +}
> > +
> >  /* Cross-reference with the other btrees. */
> >  STATIC void
> >  xchk_agi_xref(
> > @@ -804,6 +833,7 @@ xchk_agi_xref(
> >  	xchk_agi_xref_icounts(sc);
> >  	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
> >  	xchk_xref_is_not_shared(sc, agbno, 1);
> > +	xchk_agi_xref_fiblocks(sc);
> >  
> >  	/* scrub teardown will take care of sc->sa for us */
> >  }
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index bca2ab1d4be9..a85b5bb743f2 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -803,17 +803,34 @@ xrep_agi_calc_from_btrees(
> >  	struct xfs_mount	*mp = sc->mp;
> >  	xfs_agino_t		count;
> >  	xfs_agino_t		freecount;
> > +	xfs_agblock_t		blocks;
> >  	int			error;
> >  
> >  	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> >  			XFS_BTNUM_INO);
> >  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
> > +	if (error)
> > +		goto err;
> > +	error = xfs_btree_count_blocks(cur, &blocks);
> >  	if (error)
> >  		goto err;
> >  	xfs_btree_del_cursor(cur, error);
> >  
> >  	agi->agi_count = cpu_to_be32(count);
> >  	agi->agi_freecount = cpu_to_be32(freecount);
> > +
> > +	/* Update the AGI btree counters. */
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> > +		agi->agi_iblocks = cpu_to_be32(blocks);
> > +
> > +		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> > +				XFS_BTNUM_FINO);
> > +		if (error)
> > +			goto err;
> > +		xfs_btree_del_cursor(cur, error);
> > +		agi->agi_fblocks = cpu_to_be32(blocks);
> > +	}
> > +
> >  	return 0;
> >  err:
> >  	xfs_btree_del_cursor(cur, error);
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 5f04d8a5ab2a..acb9b737fe6b 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -23,7 +23,7 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> > -	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 71ac6c1cdc36..c7ffcb57b586 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1549,6 +1549,10 @@ xfs_fc_fill_super(
> >  		goto out_filestream_unmount;
> >  	}
> >  
> > +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> > +		xfs_warn(mp,
> > + "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> > +
> >  	error = xfs_mountfs(mp);
> >  	if (error)
> >  		goto out_filestream_unmount;
> > 
> 
