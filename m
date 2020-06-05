Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7BBC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 991D6206DC
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Udf7tNG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgFEP4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:56:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgFEP4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 11:56:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055Fq8kB055130;
        Fri, 5 Jun 2020 15:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zxOF6Ngbw0I33aE0cv5SD/HOk6aWTEVG+wsXLFotKXg=;
 b=Udf7tNG/NzlgKwp3F4ucqc3AhOPBCFwQiDUrJC0MuiBxOcL/48UdoVM1qm357FJbWlQ8
 sipw/QSbKWybi+G64f5vYADG7YWbDoKW5rtsnBQI+A95nvcMvj3T7+K9Bd6Qc9Ygh+Ff
 LmCcHH60dnaXycrNSfHqKKq5wi7vlaE0CdSJBCHSqoVS8GF8i4AX6mv2bCpvnEfiwRF0
 0/DG1VWm2/yACbpOOB2IWecxJKV0ypdPdvM4o9s80eWok33WlYojmvNkP56FwPM4+IPJ
 uk9gloh7VMQh4e8bIqt+9Vp8hqTPidasPoRXgbopvOtQVHt0GeEQMppGyI06grBRLPAU Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31f9243juk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 15:56:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055Fs9VE060484;
        Fri, 5 Jun 2020 15:56:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31f927ytfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 15:56:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055Fu5uL010420;
        Fri, 5 Jun 2020 15:56:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 08:56:05 -0700
Date:   Fri, 5 Jun 2020 08:56:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200605155604.GU2162697@magnolia>
References: <20200603121156.3399-1-hsiangkao@redhat.com>
 <20200605085200.24989-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605085200.24989-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=7 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=7 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 04:52:00PM +0800, Gao Xiang wrote:
> In the course of some operations, we look up the perag from
> the mount multiple times to get or change perag information.
> These are often very short pieces of code, so while the
> lookup cost is generally low, the cost of the lookup is far
> higher than the cost of the operation we are doing on the
> perag.
> 
> Since we changed buffers to hold references to the perag
> they are cached in, many modification contexts already hold
> active references to the perag that are held across these
> operations. This is especially true for any operation that
> is serialised by an allocation group header buffer.
> 
> In these cases, we can just use the buffer's reference to
> the perag to avoid needing to do lookups to access the
> perag. This means that many operations don't need to do
> perag lookups at all to access the perag because they've
> already looked up objects that own persistent references
> and hence can use that reference instead.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v2:
>   kill unneeded ASSERTs, leaving which first brought
>   into a context pointed out by Dave (including callback
>   entrances).
> 
>  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
>  fs/xfs/libxfs/xfs_ag_resv.h        | 12 ----------
>  fs/xfs/libxfs/xfs_alloc.c          | 23 +++++++-----------
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
>  fs/xfs/libxfs/xfs_ialloc.c         | 29 +++++++----------------
>  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 11 +++++----
>  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
>  8 files changed, 41 insertions(+), 91 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9d84007a5c65..8cf73fe4338e 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -563,7 +563,8 @@ xfs_ag_get_geometry(
>  	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
>  	if (error)
>  		goto out_agi;
> -	pag = xfs_perag_get(mp, agno);
> +
> +	pag = agi_bp->b_pag;
>  
>  	/* Fill out form. */
>  	memset(ageo, 0, sizeof(*ageo));
> @@ -583,7 +584,6 @@ xfs_ag_get_geometry(
>  	xfs_ag_geom_health(pag, ageo);
>  
>  	/* Release resources. */
> -	xfs_perag_put(pag);
>  	xfs_buf_relse(agf_bp);
>  out_agi:
>  	xfs_buf_relse(agi_bp);
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index f3fd0ee9a7f7..8a8eb4bc48bb 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -37,16 +37,4 @@ xfs_ag_resv_rmapbt_alloc(
>  	xfs_perag_put(pag);
>  }
>  
> -static inline void
> -xfs_ag_resv_rmapbt_free(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno)
> -{
> -	struct xfs_perag	*pag;
> -
> -	pag = xfs_perag_get(mp, agno);
> -	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
> -	xfs_perag_put(pag);
> -}
> -
>  #endif	/* __XFS_AG_RESV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203e74fa64aa..6c40b0cb4fcc 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -710,13 +710,12 @@ xfs_alloc_read_agfl(
>  STATIC int
>  xfs_alloc_update_counters(
>  	struct xfs_trans	*tp,
> -	struct xfs_perag	*pag,
>  	struct xfs_buf		*agbp,
>  	long			len)
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  
> -	pag->pagf_freeblks += len;
> +	agbp->b_pag->pagf_freeblks += len;
>  	be32_add_cpu(&agf->agf_freeblks, len);
>  
>  	xfs_trans_agblocks_delta(tp, len);
> @@ -1175,8 +1174,7 @@ xfs_alloc_ag_vextent(
>  	}
>  
>  	if (!args->wasfromfl) {
> -		error = xfs_alloc_update_counters(args->tp, args->pag,
> -						  args->agbp,
> +		error = xfs_alloc_update_counters(args->tp, args->agbp,
>  						  -((long)(args->len)));
>  		if (error)
>  			return error;
> @@ -1887,7 +1885,6 @@ xfs_free_ag_extent(
>  	enum xfs_ag_resv_type		type)
>  {
>  	struct xfs_mount		*mp;
> -	struct xfs_perag		*pag;
>  	struct xfs_btree_cur		*bno_cur;
>  	struct xfs_btree_cur		*cnt_cur;
>  	xfs_agblock_t			gtbno; /* start of right neighbor */
> @@ -2167,10 +2164,8 @@ xfs_free_ag_extent(
>  	/*
>  	 * Update the freespace totals in the ag and superblock.
>  	 */
> -	pag = xfs_perag_get(mp, agno);
> -	error = xfs_alloc_update_counters(tp, pag, agbp, len);
> -	xfs_ag_resv_free_extent(pag, type, tp, len);
> -	xfs_perag_put(pag);
> +	error = xfs_alloc_update_counters(tp, agbp, len);
> +	xfs_ag_resv_free_extent(agbp->b_pag, type, tp, len);
>  	if (error)
>  		goto error0;
>  
> @@ -2689,7 +2684,7 @@ xfs_alloc_get_freelist(
>  	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
>  		agf->agf_flfirst = 0;
>  
> -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> +	pag = agbp->b_pag;
>  	ASSERT(!pag->pagf_agflreset);
>  	be32_add_cpu(&agf->agf_flcount, -1);
>  	xfs_trans_agflist_delta(tp, -1);
> @@ -2701,7 +2696,6 @@ xfs_alloc_get_freelist(
>  		pag->pagf_btreeblks++;
>  		logflags |= XFS_AGF_BTREEBLKS;
>  	}
> -	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(tp, agbp, logflags);
>  	*bnop = bno;
> @@ -2797,7 +2791,7 @@ xfs_alloc_put_freelist(
>  	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
>  		agf->agf_fllast = 0;
>  
> -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> +	pag = agbp->b_pag;
>  	ASSERT(!pag->pagf_agflreset);
>  	be32_add_cpu(&agf->agf_flcount, 1);
>  	xfs_trans_agflist_delta(tp, 1);
> @@ -2809,7 +2803,6 @@ xfs_alloc_put_freelist(
>  		pag->pagf_btreeblks--;
>  		logflags |= XFS_AGF_BTREEBLKS;
>  	}
> -	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(tp, agbp, logflags);
>  
> @@ -3006,7 +2999,8 @@ xfs_alloc_read_agf(
>  	ASSERT(!(*bpp)->b_error);
>  
>  	agf = (*bpp)->b_addr;
> -	pag = xfs_perag_get(mp, agno);
> +	pag = (*bpp)->b_pag;
> +	ASSERT(pag->pag_agno == agno);

I thought these assertions were all dropped in v3?

Alternately-- if you want to sanity check that b_pag and the buffer
belong to the same ag, why not do that in xfs_buf_find for all the
buffers?

>  	if (!pag->pagf_init) {
>  		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
>  		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> @@ -3034,7 +3028,6 @@ xfs_alloc_read_agf(
>  		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
>  	}
>  #endif
> -	xfs_perag_put(pag);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 60c453cb3ee3..c1d276f791ea 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -38,16 +38,15 @@ xfs_allocbt_set_root(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	int			btnum = cur->bc_btnum;
> -	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
> +	struct xfs_perag	*pag = agbp->b_pag;
>  
>  	ASSERT(ptr->s != 0);
> +	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));

I still see a few of these after-the-fact agno checks throughout the patch.

--D

>  
>  	agf->agf_roots[btnum] = ptr->s;
>  	be32_add_cpu(&agf->agf_levels[btnum], inc);
>  	pag->pagf_levels[btnum] += inc;
> -	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
>  }
> @@ -115,7 +114,6 @@ xfs_allocbt_update_lastrec(
>  	int			reason)
>  {
>  	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
> -	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	struct xfs_perag	*pag;
>  	__be32			len;
>  	int			numrecs;
> @@ -160,9 +158,9 @@ xfs_allocbt_update_lastrec(
>  	}
>  
>  	agf->agf_longest = len;
> -	pag = xfs_perag_get(cur->bc_mp, seqno);
> +	pag = cur->bc_ag.agbp->b_pag;
> +	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
>  	pag->pagf_longest = be32_to_cpu(len);
> -	xfs_perag_put(pag);
>  	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 7fcf62b324b0..14aa1faaa081 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -888,10 +888,9 @@ xfs_ialloc_ag_alloc(
>  	 */
>  	be32_add_cpu(&agi->agi_count, newlen);
>  	be32_add_cpu(&agi->agi_freecount, newlen);
> -	pag = xfs_perag_get(args.mp, agno);
> +	pag = agbp->b_pag;
>  	pag->pagi_freecount += newlen;
>  	pag->pagi_count += newlen;
> -	xfs_perag_put(pag);
>  	agi->agi_newino = cpu_to_be32(newino);
>  
>  	/*
> @@ -1134,7 +1133,7 @@ xfs_dialloc_ag_inobt(
>  	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
>  	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
>  	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
> -	struct xfs_perag	*pag;
> +	struct xfs_perag	*pag = agbp->b_pag;
>  	struct xfs_btree_cur	*cur, *tcur;
>  	struct xfs_inobt_rec_incore rec, trec;
>  	xfs_ino_t		ino;
> @@ -1143,8 +1142,6 @@ xfs_dialloc_ag_inobt(
>  	int			i, j;
>  	int			searchdistance = 10;
>  
> -	pag = xfs_perag_get(mp, agno);
> -
>  	ASSERT(pag->pagi_init);
>  	ASSERT(pag->pagi_inodeok);
>  	ASSERT(pag->pagi_freecount > 0);
> @@ -1384,14 +1381,12 @@ xfs_dialloc_ag_inobt(
>  
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
> -	xfs_perag_put(pag);
>  	*inop = ino;
>  	return 0;
>  error1:
>  	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
>  error0:
>  	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> -	xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -1587,7 +1582,6 @@ xfs_dialloc_ag(
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>  	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
>  	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
> -	struct xfs_perag		*pag;
>  	struct xfs_btree_cur		*cur;	/* finobt cursor */
>  	struct xfs_btree_cur		*icur;	/* inobt cursor */
>  	struct xfs_inobt_rec_incore	rec;
> @@ -1599,8 +1593,6 @@ xfs_dialloc_ag(
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
>  
> -	pag = xfs_perag_get(mp, agno);
> -
>  	/*
>  	 * If pagino is 0 (this is the root inode allocation) use newino.
>  	 * This must work because we've just allocated some.
> @@ -1667,7 +1659,7 @@ xfs_dialloc_ag(
>  	 */
>  	be32_add_cpu(&agi->agi_freecount, -1);
>  	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
> -	pag->pagi_freecount--;
> +	agbp->b_pag->pagi_freecount--;
>  
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
>  
> @@ -1680,7 +1672,6 @@ xfs_dialloc_ag(
>  
>  	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> -	xfs_perag_put(pag);
>  	*inop = ino;
>  	return 0;
>  
> @@ -1688,7 +1679,6 @@ xfs_dialloc_ag(
>  	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
>  error_cur:
>  	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> -	xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -1945,7 +1935,6 @@ xfs_difree_inobt(
>  {
>  	struct xfs_agi			*agi = agbp->b_addr;
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> -	struct xfs_perag		*pag;
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_inobt_rec_incore	rec;
>  	int				ilen;
> @@ -2007,6 +1996,8 @@ xfs_difree_inobt(
>  	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
>  	    rec.ir_free == XFS_INOBT_ALL_FREE &&
>  	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
> +		struct xfs_perag	*pag = agbp->b_pag;
> +
>  		xic->deleted = true;
>  		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
>  		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
> @@ -2020,10 +2011,8 @@ xfs_difree_inobt(
>  		be32_add_cpu(&agi->agi_count, -ilen);
>  		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
>  		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
> -		pag = xfs_perag_get(mp, agno);
>  		pag->pagi_freecount -= ilen - 1;
>  		pag->pagi_count -= ilen;
> -		xfs_perag_put(pag);
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
>  
> @@ -2049,9 +2038,7 @@ xfs_difree_inobt(
>  		 */
>  		be32_add_cpu(&agi->agi_freecount, 1);
>  		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
> -		pag = xfs_perag_get(mp, agno);
> -		pag->pagi_freecount++;
> -		xfs_perag_put(pag);
> +		agbp->b_pag->pagi_freecount++;
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
>  	}
>  
> @@ -2661,7 +2648,8 @@ xfs_ialloc_read_agi(
>  		return error;
>  
>  	agi = (*bpp)->b_addr;
> -	pag = xfs_perag_get(mp, agno);
> +	pag = (*bpp)->b_pag;
> +	ASSERT(pag->pag_agno == agno);
>  	if (!pag->pagi_init) {
>  		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
>  		pag->pagi_count = be32_to_cpu(agi->agi_count);
> @@ -2674,7 +2662,6 @@ xfs_ialloc_read_agi(
>  	 */
>  	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
>  		XFS_FORCED_SHUTDOWN(mp));
> -	xfs_perag_put(pag);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 7fd6044a4f78..f445a8e2d04e 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -37,15 +37,14 @@ xfs_refcountbt_set_root(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
> -	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
> +	struct xfs_perag	*pag = agbp->b_pag;
>  
>  	ASSERT(ptr->s != 0);
> +	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
>  
>  	agf->agf_refcount_root = ptr->s;
>  	be32_add_cpu(&agf->agf_refcount_level, inc);
>  	pag->pagf_refcount_level += inc;
> -	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(cur->bc_tp, agbp,
>  			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index b7c05314d07c..be660b2fd422 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -63,16 +63,15 @@ xfs_rmapbt_set_root(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	int			btnum = cur->bc_btnum;
> -	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
> +	struct xfs_perag	*pag = agbp->b_pag;
>  
>  	ASSERT(ptr->s != 0);
> +	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
>  
>  	agf->agf_roots[btnum] = ptr->s;
>  	be32_add_cpu(&agf->agf_levels[btnum], inc);
>  	pag->pagf_levels[btnum] += inc;
> -	xfs_perag_put(pag);
>  
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
>  }
> @@ -123,6 +122,7 @@ xfs_rmapbt_free_block(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_perag	*pag;
>  	xfs_agblock_t		bno;
>  	int			error;
>  
> @@ -139,8 +139,9 @@ xfs_rmapbt_free_block(
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
>  
> -	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_ag.agno);
> -
> +	pag = cur->bc_ag.agbp->b_pag;
> +	ASSERT(pag->pag_agno == cur->bc_ag.agno);
> +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64f5f9a440ae..d0e7db7a2c32 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2248,7 +2248,6 @@ xfs_iunlink(
>  	}
>  
>  	if (next_agino != NULLAGINO) {
> -		struct xfs_perag	*pag;
>  		xfs_agino_t		old_agino;
>  
>  		/*
> @@ -2265,9 +2264,7 @@ xfs_iunlink(
>  		 * agino has been unlinked, add a backref from the next inode
>  		 * back to agino.
>  		 */
> -		pag = xfs_perag_get(mp, agno);
> -		error = xfs_iunlink_add_backref(pag, agino, next_agino);
> -		xfs_perag_put(pag);
> +		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
>  		if (error)
>  			return error;
>  	}
> @@ -2403,7 +2400,6 @@ xfs_iunlink_remove(
>  	struct xfs_buf		*agibp;
>  	struct xfs_buf		*last_ibp;
>  	struct xfs_dinode	*last_dip = NULL;
> -	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
> @@ -2447,32 +2443,22 @@ xfs_iunlink_remove(
>  	 * this inode's backref to point from the next inode.
>  	 */
>  	if (next_agino != NULLAGINO) {
> -		pag = xfs_perag_get(mp, agno);
> -		error = xfs_iunlink_change_backref(pag, next_agino,
> +		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
>  				NULLAGINO);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
> -	if (head_agino == agino) {
> -		/* Point the head of the list to the next unlinked inode. */
> -		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> -				next_agino);
> -		if (error)
> -			goto out;
> -	} else {
> +	if (head_agino != agino) {
>  		struct xfs_imap	imap;
>  		xfs_agino_t	prev_agino;
>  
> -		if (!pag)
> -			pag = xfs_perag_get(mp, agno);
> -
>  		/* We need to search the list for the inode being freed. */
>  		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
>  				&prev_agino, &imap, &last_dip, &last_ibp,
> -				pag);
> +				agibp->b_pag);
>  		if (error)
> -			goto out;
> +			return error;
>  
>  		/* Point the previous inode on the list to the next inode. */
>  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> @@ -2486,15 +2472,13 @@ xfs_iunlink_remove(
>  		 * change_backref takes care of deleting the backref if
>  		 * next_agino is NULLAGINO.
>  		 */
> -		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> -		if (error)
> -			goto out;
> +		return xfs_iunlink_change_backref(agibp->b_pag, agino,
> +				next_agino);
>  	}
>  
> -out:
> -	if (pag)
> -		xfs_perag_put(pag);
> -	return error;
> +	/* Point the head of the list to the next unlinked inode. */
> +	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> +			next_agino);
>  }
>  
>  /*
> -- 
> 2.18.1
> 
