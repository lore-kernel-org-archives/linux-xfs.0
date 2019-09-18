Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA58C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 19:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2991D222C7
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 19:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mkcZC4VR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfIRTD5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 15:03:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36148 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfIRTD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 15:03:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IImt0B106308;
        Wed, 18 Sep 2019 19:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HXTMrCu/gvW9IJRJLDqCx7A4iyCE6QaVLDixLTETlfg=;
 b=mkcZC4VRNCmGehlZ4RTbZA4BdFt9NppHiiVS4JXUY6/A/F8I55EFoq1V9It0fnfsOxMP
 gf0cRYo6BZ/irkaFzqPAf/9HYIsRj3rXMli93+EHEIrIFiAQgnWFUN6jO3AeSD65HhRm
 UL4aElEeKS+wIrD8FJU7A8BaveDchJqbrcjmm6918WQyHE1btJz3C6XQmJm9aNh+ne5t
 bfANy1lm7oyZaT+F3TUONTv4ijmGK+hMLL0b+hl10luUb94hQMS2uVHtbYhaJAHECfZN
 mopdBth1O9YLM5L0Y9b+AXoLqe6AnQym5hvliM14q78ekAthEk9Jd8mpBxTiSJ2J61te qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v385e5x6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 19:03:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIs4tF115725;
        Wed, 18 Sep 2019 19:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v37mnjxm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 19:03:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IJ3ilk013237;
        Wed, 18 Sep 2019 19:03:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 12:03:44 -0700
Date:   Wed, 18 Sep 2019 12:03:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/11] xfs: refactor cntbt lastblock scan best extent
 logic into helper
Message-ID: <20190918190341.GT2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-6-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:29AM -0400, Brian Foster wrote:
> The cntbt lastblock scan checks the size, alignment, locality, etc.
> of each free extent in the block and compares it with the current
> best candidate. This logic will be reused by the upcoming optimized
> cntbt algorithm, so refactor it into a separate helper.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 113 +++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_trace.h        |  25 +++++++++
>  2 files changed, 111 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ee46989ab723..2fa7bb6a00a8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
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
> +	struct xfs_alloc_arg		*args,
> +	struct xfs_alloc_cur		*acur,
> +	struct xfs_btree_cur		*cur,
> +	int				*new)
> +{
> +	int			error, i;

Inconsistent indentation here.

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
> index eaae275ed430..b12fad3e45cb 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1663,6 +1663,31 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
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
> +	TP_printk("dev %d:%d btnum %d bno 0x%x len 0x%x diff 0x%x new %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->btnum,

Perhaps:

	__print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),

instead of dumping the raw btnum value?

Other than those two things, this looks like a pretty straightforward
hoisting.

--D

> +		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> +)
> +
>  DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_PROTO(struct xfs_da_args *args),
>  	TP_ARGS(args),
> -- 
> 2.20.1
> 
