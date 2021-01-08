Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3397CC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0552023A9F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbhAHVWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:22:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbhAHVWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 16:22:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108L8uUX158985;
        Fri, 8 Jan 2021 21:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OhPDsbJCnljXSoCM5i6+ql+fCLzbaJmO4zPAHZCAKMk=;
 b=MU38aijZ96yBMFa++6TpJDe0NInAXI8z4nPEARpn/9VmK2X3OTgF+7sRemUjtfmYyzLe
 cKdy+ibng+GB+qnmLQc5PozWwbkkzYJp91ADshwV/GS/IbehbAh8uaRkO+Q51nZwcaoO
 qdnrhhtdOddSsUFDi6F1IFoWzv5OJpbAhDcP8jupuF76gWYFDDiKzlWDsfsd0G9BqLWQ
 IrtUxWrq1gDwcS6uDR61yXoqK9P53q6jWl0Va9USjzmCwD3a5BRACyp8cm5lBsE3O1X8
 njBP48N3kZPdhn2KcU82B6WFQ7T6HRViySVVrSWatgbH4DHZ9UCeL/Z1TgKGV5UEsSA8 bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuy3bup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 21:21:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108LAXhA180263;
        Fri, 8 Jan 2021 21:19:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35w3qvxf25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 21:19:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 108LJhDR013391;
        Fri, 8 Jan 2021 21:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 21:19:43 +0000
Date:   Fri, 8 Jan 2021 13:19:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 4/4] xfs: support shrinking unused space in the last AG
Message-ID: <20210108211942.GQ38809@magnolia>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108190919.623672-5-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 09, 2021 at 03:09:19AM +0800, Gao Xiang wrote:
> As the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block and introduce a helper
> xfs_ag_shrink_space() to fixup the last AG.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 72 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  2 ++
>  fs/xfs/xfs_fsops.c     | 69 ++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_trans.c     |  1 -
>  4 files changed, 126 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..bec10c85e2a9 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -485,6 +485,78 @@ xfs_ag_init_headers(
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
> +	int			error, err2;
> +	struct xfs_alloc_arg	args = {
> +		.tp	= tp,
> +		.mp	= mp,
> +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> +		.minlen = len,
> +		.maxlen = len,
> +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> +		.resv	= XFS_AG_RESV_NONE,
> +		.prod	= 1
> +	};
> +
> +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	agi = agibp->b_addr;
> +
> +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> +	if (error)
> +		return error;
> +
> +	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
> +				    be32_to_cpu(agi->agi_length) - len);
> +
> +	/* remove the preallocations before allocation and re-establish then */
> +	error = xfs_ag_resv_free(agibp->b_pag);
> +	if (error)
> +		return error;
> +
> +	/* internal log shouldn't also show up in the free space btrees */
> +	error = xfs_alloc_vextent(&args);
> +	if (error)
> +		goto out;
> +
> +	if (args.agbno == NULLAGBLOCK) {
> +		error = -ENOSPC;
> +		goto out;
> +	}
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
> +
> +out:
> +	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> +	if (err2 && err2 != -ENOSPC) {
> +		xfs_warn(mp,
> +"Error %d reserving per-AG metadata reserve pool.", err2);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return err2;
> +	}
> +	return error;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
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
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a792d1f0ac55..eea38395e804 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -79,19 +79,22 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		delta;
>  	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
> +	bool			extend;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	if (nb < mp->m_sb.sb_dblocks)
> -		return -EINVAL;
> -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> +	if (error)
>  		return error;
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
>  	delta = nb;	/* use delta as a temporary here */

Yikes, can this become a separate variable please?

>  	nb_mod = do_div(delta, mp->m_sb.sb_agblocks);
> @@ -99,10 +102,18 @@ xfs_growfs_data_private(
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> +		if (nagcount < 2)
>  			return -EINVAL;
>  	}
> -	delta = nb - mp->m_sb.sb_dblocks;
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		delta = nb - mp->m_sb.sb_dblocks;
> +		extend = true;
> +	} else {
> +		delta = mp->m_sb.sb_dblocks - nb;
> +		extend = false;

/me wonders why delta isn't simply int64_t, and then you can do things
like:

if (delta > 0)
	growfs
else if (delta < 0)
	shrinkfs

?

> +	}
> +
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -110,22 +121,34 @@ xfs_growfs_data_private(
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
>  		if (error)
>  			return error;
> +	} else if (nagcount != oagcount) {
> +		/* TODO: shrinking the entire AGs hasn't yet completed */
> +		return -EINVAL;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +			(extend ? XFS_GROWFS_SPACE_RES(mp) : delta), 0,
> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> -	if (error)
> -		goto out_trans_cancel;
> -
> +	if (extend) {
> +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> +						  nagcount, &delta);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
> -	/* If there are new blocks in the old last AG, extend it. */
> +	/* If there are some blocks in the last AG, resize it. */
>  	if (delta) {
> -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> +		if (extend) {
> +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> +		} else {
> +			id.agno = nagcount - 1;
> +			error = xfs_ag_shrink_space(mp, tp, &id, delta);
> +		}
> +
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -137,11 +160,19 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (nb > mp->m_sb.sb_dblocks)
> +	if (nb != mp->m_sb.sb_dblocks)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> +
> +	/*
> +	 * update in-core counters (especially sb_fdblocks) now
> +	 * so xfs_validate_sb_write() can pass.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		xfs_log_sb(tp);
> +
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> @@ -178,6 +209,10 @@ xfs_growfs_data_private(
>  	return error;
>  
>  out_trans_cancel:
> +	if (!extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
> +		xfs_trans_commit(tp);
> +		return error;

When do we encounter the (!extend && DIRTY && cancelled) state?

--D

> +	}
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e72730f85af1..fd2cbf414b80 100644
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
> 2.27.0
> 
