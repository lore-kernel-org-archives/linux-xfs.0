Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C79C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF5B221EB
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qZE2k2Go"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgJNQGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 12:06:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730579AbgJNQGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 12:06:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EFrvkk051971;
        Wed, 14 Oct 2020 16:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TzBGJF0JhfidqPNY92Qe6cgD7daDx89H46d8pqZeSdc=;
 b=qZE2k2GoPzhaxpMByoSh0EQaQUhGWYVd2fjYUKWt36tmMzetIkfSYFeLTt0NAeknQpKp
 MaR8q/9oaMFWffHAfbTY5ZqN4a9MhGBJwkEiidAVzn6Vi4GS934/nbs2JcgRVnF03k17
 QWX2LUaQi0McuBzOelRBrluhwDfw91qAtatqDq258kfU2egGHmVgrWqxWLol5ozY8BTs
 a/DIfQFTvkumr9RFa37l2YwNbHMSmOpc3X7ujfaHPG+nD5JyzgQD2bHM7JiJAo3fLmqI
 SzZz5IMJxkJ2Wt7N73PUnBXG56y96lhgmcguWw4XiIoxAzj/OHQhPrhA/tbFrDhKFshQ YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaeer37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 16:06:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EFsZ4Z027077;
        Wed, 14 Oct 2020 16:06:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pvy1ryb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 16:06:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09EG6Zog022661;
        Wed, 14 Oct 2020 16:06:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 09:06:35 -0700
Date:   Wed, 14 Oct 2020 09:06:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201014160633.GD9832@magnolia>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014005809.6619-1-hsiangkao@aol.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=5 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010140114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=5 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010140114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> At the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> Honestly, I've got headache about shrinking entire AGs
> since the codebase doesn't expect agcount can be decreased
> suddenly, I got some ideas from people but the modification
> seems all over the codebase, I will keep on this at least
> to learn more about XFS internals.
> 
> It might be worth sending out shrinking the last AG first
> since users might need to shrink a little unused space
> occasionally, yet I'm not quite sure the log space reservation
> calculation in this patch and other details are correct.
> I've done some manual test and it seems work. Yeah, as a
> formal patch it needs more test to be done but I'd like
> to hear more ideas about this first since I'm not quite
> familiar with XFS for now and this topic involves a lot
> new XFS-specific implementation details.
> 
> Kindly point out all strange places and what I'm missing
> so I can revise it. It would be of great help for me to
> learn more about XFS. At least just as a record on this
> topic for further discussion.
> 
> Thanks,
> Gao Xiang
> 
>  fs/xfs/libxfs/xfs_ag.c    | 46 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h    |  2 ++
>  fs/xfs/libxfs/xfs_alloc.c | 55 +++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h | 10 +++++++
>  fs/xfs/xfs_fsops.c        | 49 ++++++++++++++++++++++++----------
>  fs/xfs/xfs_trans.c        |  1 -
>  6 files changed, 148 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..cac7b715e90b 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -485,6 +485,52 @@ xfs_ag_init_headers(
>  	return error;
>  }
>  
> +int
> +xfs_ag_shrink_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct aghdr_init_data	*id,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_buf		*agibp, *agfbp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	int			error;
> +
> +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	agi = agibp->b_addr;
> +
> +	/* Cannot touch the log space */
> +	if (is_log_ag(mp, id) &&
> +	    XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) +
> +	    mp->m_sb.sb_logblocks > be32_to_cpu(agi->agi_length) - len)
> +		return -EINVAL;

The space used by the internal log shouldn't also show up in the free
space btrees, so I think you could rely on the _alloc_vextent_shrink
call to return ENOSPC, right?

> +
> +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_alloc_vextent_shrink(tp, agfbp,
> +			be32_to_cpu(agi->agi_length) - len, len);
> +	if (error)
> +		return error;
> +
> +	/* Change the agi length */
> +	be32_add_cpu(&agi->agi_length, -len);
> +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> +
> +	/* Change agf length */
> +	agf = agfbp->b_addr;
> +	be32_add_cpu(&agf->agf_length, -len);
> +	ASSERT(agf->agf_length == agi->agi_length);
> +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> +	return 0;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in

"Extend..." ?

>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5166322807e7..f3b5bbfeadce 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -24,6 +24,8 @@ struct aghdr_init_data {
>  };
>  
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
> +			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
>  			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..681357bb2701 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1118,6 +1118,61 @@ xfs_alloc_ag_vextent_small(
>  	return error;
>  }
>  
> +/*
> + * Allocate an extent for shrinking the last allocation group
> + * to fix the freespace btree.
> + * agfl fix is avoided in order to keep from dirtying the
> + * transaction unnecessarily compared with xfs_alloc_vextent().
> + */
> +int
> +xfs_alloc_vextent_shrink(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> +	struct xfs_alloc_arg	args = {
> +		.tp = tp,
> +		.mp = mp,
> +		.type = XFS_ALLOCTYPE_THIS_BNO,
> +		.agbp = agbp,
> +		.agno = agno,
> +		.agbno = agbno,
> +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),

/me would have thought you could compute agbno from the AGF buffer
passed in and the length parameter.

> +		.minlen = len,
> +		.maxlen = len,
> +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> +		.resv = XFS_AG_RESV_NONE,

Hmm.  Using AG_RESV_NONE here means that the allocation can fail because
there won't be enough free space left to satisfy the AG metadata
preallocations.  I think you have to call xfs_ag_resv_free before
calling this allocation function to remove the preallocations, and then
call xfs_ag_resv_init afterwards (regardless of whether the shrink
succeeds) to re-establish the preallocations to fit the new AG size.

> +		.prod = 1,
> +		.alignment = 1,
> +		.pag = agbp->b_pag
> +	};
> +	int			error;
> +
> +	error = xfs_alloc_ag_vextent_exact(&args);
> +	if (error || args.agbno == NULLAGBLOCK)
> +		return -EBUSY;
> +
> +	ASSERT(args.agbno == agbno);
> +	ASSERT(args.len == len);
> +	ASSERT(!args.wasfromfl || args.resv != XFS_AG_RESV_AGFL);

Can wasfromfl==true actually happen?  I think for this shrink case we
need to prevent that from ever happening.

> +
> +	if (!args.wasfromfl) {
> +		error = xfs_alloc_update_counters(tp, agbp, -(long)len);
> +		if (error)
> +			return error;
> +
> +		ASSERT(!xfs_extent_busy_search(mp, args.agno, agbno, args.len));
> +	}
> +	xfs_ag_resv_alloc_extent(args.pag, args.resv, &args);

(I think you can skip this call if you free the AG's preallocations
before allocating the last freespace.)

> +
> +	XFS_STATS_INC(mp, xs_allocx);
> +	XFS_STATS_ADD(mp, xs_allocb, args.len);
> +	return 0;
> +}
> +
>  /*
>   * Allocate a variable extent in the allocation group agno.
>   * Type and bno are used to determine where in the allocation group the
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..6080140bcb56 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -160,6 +160,16 @@ int				/* error */
>  xfs_alloc_vextent(
>  	xfs_alloc_arg_t	*args);	/* allocation argument structure */
>  
> +/*
> + * Allocate an extent for shrinking the last AG
> + */
> +int
> +xfs_alloc_vextent_shrink(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len);	/* length of extent */
> +
>  /*
>   * Free an extent.
>   */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ef1d5bb88b93..80927d323939 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -36,19 +36,21 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		new;
>  	xfs_agnumber_t		oagcount;
>  	xfs_trans_t		*tp;
> +	bool			extend;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	if (nb < mp->m_sb.sb_dblocks)
> -		return -EINVAL;
>  	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
>  		return error;

Please convert this to the more normal format:

error = xfs_sb_validate...();
if (error)
	return error;

> -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
>  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error)
> -		return error;
> -	xfs_buf_relse(bp);
> +		if (error)
> +			return error;
> +		xfs_buf_relse(bp);
> +	}
>  
>  	new = nb;	/* use new as a temporary here */
>  	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> @@ -56,10 +58,18 @@ xfs_growfs_data_private(
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> +		if (!nagcount)
>  			return -EINVAL;

Realistically, we don't ever want fewer than 2 AGs since that would
leave us with no superblock redundancy.  Repair doesn't really support
the 1 AG case.

>  	}
> -	new = nb - mp->m_sb.sb_dblocks;
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		new = nb - mp->m_sb.sb_dblocks;
> +		extend = true;
> +	} else {
> +		new = mp->m_sb.sb_dblocks - nb;
> +		extend = false;
> +	}

Er... maybe you should start by hoisting all the "make data device
larger" code into a separate function so that you can add the "make data
device smaller" code as a second function.  Then xfs_growfs_data_private
can decide which of the two to call based on the new size.

> +
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -67,10 +77,14 @@ xfs_growfs_data_private(
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
>  		if (error)
>  			return error;
> +	} else if (nagcount != oagcount) {
> +		/* TODO: shrinking a whole AG hasn't yet implemented */
> +		return -EINVAL;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,

XFS_GROWFS_SPACE_RES is defined as twice m_ag_maxlevels, which I think
means (in the grow case) that it's reserving space for one full split
for each free space btree.

Shrink, by contrast, is removing the rightmost record from the bnobt and
some arbitrary record from the cntbt.  Can removing 1 record from each
btree actually cause a split?

> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> @@ -103,15 +117,22 @@ xfs_growfs_data_private(
>  			goto out_trans_cancel;
>  		}
>  	}
> -	error = xfs_buf_delwri_submit(&id.buffer_list);
> -	if (error)
> -		goto out_trans_cancel;
> +
> +	if (!list_empty(&id.buffer_list)) {
> +		error = xfs_buf_delwri_submit(&id.buffer_list);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
>  
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
>  	/* If there are new blocks in the old last AG, extend it. */
>  	if (new) {
> -		error = xfs_ag_extend_space(mp, tp, &id, new);
> +		if (extend)
> +			error = xfs_ag_extend_space(mp, tp, &id, new);
> +		else
> +			error = xfs_ag_shrink_space(mp, tp, &id, new);

This logic is getting harder for me to track because the patch combines
grow and shrink logic in the same function....

--D

> +
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -123,7 +144,7 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (nb > mp->m_sb.sb_dblocks)
> +	if (nb != mp->m_sb.sb_dblocks)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c94e71f741b6..81b9c32f9bef 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
>  		tp->t_res_frextents_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_DBLOCKS:
> -		ASSERT(delta > 0);
>  		tp->t_dblocks_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_AGCOUNT:
> -- 
> 2.24.0
> 
