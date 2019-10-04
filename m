Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21F0C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FBBD222BE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C2599RDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJDWkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 18:40:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJDWkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 18:40:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Mcvud049463;
        Fri, 4 Oct 2019 22:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3GnA9t5cJGWcSECrrRiFLAElP7hSN9u3F5Av9bKixgY=;
 b=C2599RDVHBwMdXYT09eLuwYr8ccUF9wXmUvhb6/LBtukTtEGOvt2ax/y5yQOV0actj4S
 pKa9qTvmxAVtTRKy0OkIJRfdYwev89DXkirreSivDmvNYoXl92bToI1Fysyf+oZNO6Db
 9NXClo+3PQckZ+q5LHaAOce0/VYv8QpiQfpA9yl3lwyCv/6nVCrrYoED2NePGnKZTgNg
 Z7HMBOB7p+22vwOKUJHebOaoRp2PE0M+zWoP91Gm/njUjvLKUQ2BiE1tFu16F7BAB9nZ
 x2sqTo/yZzC7mPjoPN7ZMR/3f6kBHTJe0RpAfr/PHZWrcfm55CihOSUqr7QjB5v8HKJ/ AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxvecs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:40:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94McbQx123075;
        Fri, 4 Oct 2019 22:40:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vebbx3ghx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:40:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x94Me2qm029653;
        Fri, 4 Oct 2019 22:40:02 GMT
Received: from localhost (/10.159.134.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 15:40:01 -0700
Date:   Fri, 4 Oct 2019 15:40:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 05/11] xfs: refactor cntbt lastblock scan best extent
 logic into helper
Message-ID: <20191004224001.GD1473994@magnolia>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-6-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040191
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 01:17:56PM -0400, Brian Foster wrote:
> The cntbt lastblock scan checks the size, alignment, locality, etc.
> of each free extent in the block and compares it with the current
> best candidate. This logic will be reused by the upcoming optimized
> cntbt algorithm, so refactor it into a separate helper. Note that
> acur->diff is now initialized to -1 (unsigned) instead of 0 to
> support the more granular comparison logic in the new helper.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 115 ++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_trace.h        |  26 +++++++++
>  2 files changed, 113 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4514a059486e..38183953636a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -744,7 +744,7 @@ xfs_alloc_cur_setup(
>  	acur->rec_len = 0;
>  	acur->bno = 0;
>  	acur->len = 0;
> -	acur->diff = 0;
> +	acur->diff = -1;
>  	acur->busy = false;
>  	acur->busy_gen = 0;
>  
> @@ -791,6 +791,89 @@ xfs_alloc_cur_close(
>  	acur->cnt = acur->bnolt = acur->bnogt = NULL;
>  }
>  
> +/*
> + * Check an extent for allocation and track the best available candidate in the
> + * allocation structure. The cursor is deactivated if it has entered an out of
> + * range state based on allocation arguments. Optionally return the extent
> + * extent geometry and allocation status if requested by the caller.
> + */
> +static int
> +xfs_alloc_cur_check(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_alloc_cur	*acur,
> +	struct xfs_btree_cur	*cur,
> +	int			*new)
> +{
> +	int			error, i;
> +	xfs_agblock_t		bno, bnoa, bnew;
> +	xfs_extlen_t		len, lena, diff = -1;
> +	bool			busy;
> +	unsigned		busy_gen = 0;
> +	bool			deactivate = false;
> +
> +	*new = 0;
> +
> +	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
> +	if (error)
> +		return error;
> +	XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
> +
> +	/*
> +	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
> +	 * range (i.e., walking backwards looking for a minlen extent).
> +	 */
> +	if (len < args->minlen) {
> +		deactivate = true;
> +		goto out;
> +	}
> +
> +	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
> +					 &busy_gen);
> +	acur->busy |= busy;
> +	if (busy)
> +		acur->busy_gen = busy_gen;
> +	/* deactivate a bnobt cursor outside of locality range */
> +	if (bnoa < args->min_agbno || bnoa > args->max_agbno)
> +		goto out;
> +	if (lena < args->minlen)
> +		goto out;
> +
> +	args->len = XFS_EXTLEN_MIN(lena, args->maxlen);
> +	xfs_alloc_fix_len(args);
> +	ASSERT(args->len >= args->minlen);
> +	if (args->len < acur->len)
> +		goto out;
> +
> +	/*
> +	 * We have an aligned record that satisfies minlen and beats or matches
> +	 * the candidate extent size. Compare locality for near allocation mode.
> +	 */
> +	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
> +	diff = xfs_alloc_compute_diff(args->agbno, args->len,
> +				      args->alignment, args->datatype,
> +				      bnoa, lena, &bnew);
> +	if (bnew == NULLAGBLOCK)
> +		goto out;
> +	if (diff > acur->diff)
> +		goto out;
> +
> +	ASSERT(args->len > acur->len ||
> +	       (args->len == acur->len && diff <= acur->diff));
> +	acur->rec_bno = bno;
> +	acur->rec_len = len;
> +	acur->bno = bnew;
> +	acur->len = args->len;
> +	acur->diff = diff;
> +	*new = 1;
> +
> +out:
> +	if (deactivate)
> +		cur->bc_private.a.priv.abt.active = false;
> +	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
> +				  *new);
> +	return 0;
> +}
> +
>  /*
>   * Deal with the case where only small freespaces remain. Either return the
>   * contents of the last freespace record, or allocate space from the freelist if
> @@ -1257,8 +1340,6 @@ xfs_alloc_ag_vextent_near(
>  	 * but we never loop back to the top.
>  	 */
>  	while (xfs_btree_islastblock(acur.cnt, 0)) {
> -		xfs_extlen_t	diff;
> -
>  #ifdef DEBUG
>  		if (dofirst)
>  			break;
> @@ -1289,38 +1370,16 @@ xfs_alloc_ag_vextent_near(
>  		}
>  		i = acur.cnt->bc_ptrs[0];
>  		for (j = 1;
> -		     !error && j && (acur.len < args->maxlen || acur.diff > 0);
> +		     !error && j && xfs_alloc_cur_active(acur.cnt) &&
> +		     (acur.len < args->maxlen || acur.diff > 0);
>  		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
>  			/*
>  			 * For each entry, decide if it's better than
>  			 * the previous best entry.
>  			 */
> -			error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
> +			error = xfs_alloc_cur_check(args, &acur, acur.cnt, &i);
>  			if (error)
>  				goto out;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			acur.busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> -					&ltbnoa, &ltlena, &acur.busy_gen);
> -			if (ltlena < args->minlen)
> -				continue;
> -			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
> -				continue;
> -			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> -			xfs_alloc_fix_len(args);
> -			ASSERT(args->len >= args->minlen);
> -			if (args->len < acur.len)
> -				continue;
> -			diff = xfs_alloc_compute_diff(args->agbno, args->len,
> -				args->alignment, args->datatype, ltbnoa,
> -				ltlena, &ltnew);
> -			if (ltnew != NULLAGBLOCK &&
> -			    (args->len > acur.len || diff < acur.diff)) {
> -				acur.rec_bno = ltbno;
> -				acur.rec_len = ltlen;
> -				acur.diff = diff;
> -				acur.bno = ltnew;
> -				acur.len = args->len;
> -			}
>  		}
>  		/*
>  		 * It didn't work.  We COULD be in a case where
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index eaae275ed430..cf618919cacf 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1663,6 +1663,32 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
>  
> +TRACE_EVENT(xfs_alloc_cur_check,
> +	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
> +		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
> +	TP_ARGS(mp, btnum, bno, len, diff, new),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(xfs_agblock_t, bno)
> +		__field(xfs_extlen_t, len)
> +		__field(xfs_extlen_t, diff)
> +		__field(bool, new)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->btnum = btnum;
> +		__entry->bno = bno;
> +		__entry->len = len;
> +		__entry->diff = diff;
> +		__entry->new = new;
> +	),
> +	TP_printk("dev %d:%d btree %s bno 0x%x len 0x%x diff 0x%x new %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> +)
> +
>  DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_PROTO(struct xfs_da_args *args),
>  	TP_ARGS(args),
> -- 
> 2.20.1
> 
