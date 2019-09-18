Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDF8C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E179621897
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="buBDIa/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfIRStX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 14:49:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfIRStX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:49:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IImtFF106320;
        Wed, 18 Sep 2019 18:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mlrHzcwfA1t/WonUFOigq7mULVYoLyp8jZGlQcFzXA0=;
 b=buBDIa/EK8vydxODJEIxaMu5QEiqrR8lNeGwenl4ogOKITCLuics1YWGpeXak4X3cNot
 E/5JFohVsFg1Op1G70k3DzXzP3dRqTajhRt7q+kxbEPPYyPGy9cRcjF+1F72zMesEsHl
 T6HiXAk2sDzL2uxDS1fbISmMDZBjcmp6ldrXK+5d3LN4dbP7g8wzAgzpTTchfv+a0p88
 lfOhI8LLA9W9DPduQf3ZNoBpGZaEqmZBwDJTmRQTV3+SFwilKdLIa9yDk0t0V8JXPgWb
 ndqyC3ABWWymbOl8V5xZdpTTAm85H+xWUTmrALokg3HvC2dfP/PXWNkC41QkSW0y4pWP UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v385e5utd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:49:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIn2Rc101099;
        Wed, 18 Sep 2019 18:49:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v37mnj3pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:49:03 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IImXaF003800;
        Wed, 18 Sep 2019 18:48:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:48:33 -0700
Date:   Wed, 18 Sep 2019 11:48:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 03/11] xfs: track allocation busy state in allocation
 cursor
Message-ID: <20190918184832.GR2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180164
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

On Mon, Sep 16, 2019 at 08:16:27AM -0400, Brian Foster wrote:
> Extend the allocation cursor to track extent busy state for an
> allocation attempt. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d159377ed603..5c34d4c41761 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -716,6 +716,8 @@ struct xfs_alloc_cur {
>  	struct xfs_btree_cur		*cnt;	/* btree cursors */
>  	struct xfs_btree_cur		*bnolt;
>  	struct xfs_btree_cur		*bnogt;
> +	unsigned			busy_gen;/* busy state */

Nit: unsigned int here?

'unsigned' without the 'int' looks a little funny to me, but eh
whatever, I guess we do that in the iomap code so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	bool				busy;
>  };
>  
>  /*
> @@ -733,6 +735,9 @@ xfs_alloc_cur_setup(
>  
>  	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
>  
> +	acur->busy = false;
> +	acur->busy_gen = 0;
> +
>  	/*
>  	 * Perform an initial cntbt lookup to check for availability of maxlen
>  	 * extents. If this fails, we'll return -ENOSPC to signal the caller to
> @@ -1185,8 +1190,6 @@ xfs_alloc_ag_vextent_near(
>  	xfs_extlen_t	ltlena;		/* aligned ... */
>  	xfs_agblock_t	ltnew;		/* useful start bno of left side */
>  	xfs_extlen_t	rlen;		/* length of returned extent */
> -	bool		busy;
> -	unsigned	busy_gen;
>  #ifdef DEBUG
>  	/*
>  	 * Randomly don't execute the first algorithm.
> @@ -1211,7 +1214,6 @@ xfs_alloc_ag_vextent_near(
>  	ltlen = 0;
>  	gtlena = 0;
>  	ltlena = 0;
> -	busy = false;
>  
>  	/*
>  	 * Set up cursors and see if there are any free extents as big as
> @@ -1290,8 +1292,8 @@ xfs_alloc_ag_vextent_near(
>  			if (error)
>  				goto out;
>  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> -					&ltbnoa, &ltlena, &busy_gen);
> +			acur.busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> +					&ltbnoa, &ltlena, &acur.busy_gen);
>  			if (ltlena < args->minlen)
>  				continue;
>  			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
> @@ -1373,8 +1375,8 @@ xfs_alloc_ag_vextent_near(
>  			if (error)
>  				goto out;
>  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
> -					&ltbnoa, &ltlena, &busy_gen);
> +			acur.busy |= xfs_alloc_compute_aligned(args, ltbno,
> +					ltlen, &ltbnoa, &ltlena, &acur.busy_gen);
>  			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
>  				break;
>  			error = xfs_btree_decrement(acur.bnolt, 0, &i);
> @@ -1388,8 +1390,8 @@ xfs_alloc_ag_vextent_near(
>  			if (error)
>  				goto out;
>  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
> -					&gtbnoa, &gtlena, &busy_gen);
> +			acur.busy |= xfs_alloc_compute_aligned(args, gtbno,
> +					gtlen, &gtbnoa, &gtlena, &acur.busy_gen);
>  			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
>  				break;
>  			error = xfs_btree_increment(acur.bnogt, 0, &i);
> @@ -1449,9 +1451,10 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	if (!xfs_alloc_cur_active(acur.bnolt) &&
>  	    !xfs_alloc_cur_active(acur.bnogt)) {
> -		if (busy) {
> +		if (acur.busy) {
>  			trace_xfs_alloc_near_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> +			xfs_extent_busy_flush(args->mp, args->pag,
> +					      acur.busy_gen);
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> -- 
> 2.20.1
> 
