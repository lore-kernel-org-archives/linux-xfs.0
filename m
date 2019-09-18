Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55353C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E76C222C0
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AYBJvMP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfIRS43 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 14:56:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfIRS43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:56:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIn1qK159349;
        Wed, 18 Sep 2019 18:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=j341HoRFg9GeVV9iFZ9IOJMkTBr2UF+MgowEm5X6xnM=;
 b=AYBJvMP6fqjB1hqR/dgmK+8wmyo6zo39bqwUQdxMeEyQn7RwABgxYhk6Zsq7vfU2qAXA
 LiVa0ypEK0bFnH+CC1q47GppWW4HCdpKXbrMIgpVcpSZORixQk+KDD9zfhDW7SWr5Ur1
 UHbLoaRcP288rtNAHGRRFdPBpx6yk7QNeite5swP7Fj4JMWR6P8fTAX8opKPLLrZaPeA
 TiTGYeKNMb7ysqdHBgoKoZLaV1C5k5T0NRJpXwFxwvcUHXq2T5amyYEnQNjVInQ7P81d
 JPhPB+3oooHVvEuQQIrnXWjPVnn/bb+ZtiZtiMF32v/DhY5jtXTzAMdvRyIli6iLH4Q9 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v385dwvs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:56:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIrbKb046176;
        Wed, 18 Sep 2019 18:56:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v37mb2q28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:56:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IIuHBl005707;
        Wed, 18 Sep 2019 18:56:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:56:17 -0700
Date:   Wed, 18 Sep 2019 11:56:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 04/11] xfs: track best extent from cntbt lastblock
 scan in alloc cursor
Message-ID: <20190918185616.GS2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-5-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:28AM -0400, Brian Foster wrote:
> If the size lookup lands in the last block of the by-size btree, the
> near mode algorithm scans the entire block for the extent with best
> available locality. In preparation for similar best available
> extent tracking across both btrees, extend the allocation cursor
> with best extent data and lift the associated state from the cntbt
> last block scan code. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 63 ++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 5c34d4c41761..ee46989ab723 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -716,6 +716,11 @@ struct xfs_alloc_cur {
>  	struct xfs_btree_cur		*cnt;	/* btree cursors */
>  	struct xfs_btree_cur		*bnolt;
>  	struct xfs_btree_cur		*bnogt;
> +	xfs_agblock_t			rec_bno;/* extent startblock */
> +	xfs_extlen_t			rec_len;/* extent length */
> +	xfs_agblock_t			bno;	/* alloc bno */
> +	xfs_extlen_t			len;	/* alloc len */
> +	xfs_extlen_t			diff;	/* diff from search bno */
>  	unsigned			busy_gen;/* busy state */
>  	bool				busy;
>  };
> @@ -735,6 +740,11 @@ xfs_alloc_cur_setup(
>  
>  	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
>  
> +	acur->rec_bno = 0;
> +	acur->rec_len = 0;
> +	acur->bno = 0;
> +	acur->len = 0;
> +	acur->diff = -1;

xfs_extlen_t is a uint32_t; is this going to cause comparison problems?

Also ... assuming that acur->diff is the successor to the bdiff variable
below, shouldn't it be initialized to zero like bdiff was?

--D

>  	acur->busy = false;
>  	acur->busy_gen = 0;
>  
> @@ -1247,10 +1257,7 @@ xfs_alloc_ag_vextent_near(
>  	 * but we never loop back to the top.
>  	 */
>  	while (xfs_btree_islastblock(acur.cnt, 0)) {
> -		xfs_extlen_t	bdiff;
> -		int		besti=0;
> -		xfs_extlen_t	blen=0;
> -		xfs_agblock_t	bnew=0;
> +		xfs_extlen_t	diff;
>  
>  #ifdef DEBUG
>  		if (dofirst)
> @@ -1281,8 +1288,8 @@ xfs_alloc_ag_vextent_near(
>  				break;
>  		}
>  		i = acur.cnt->bc_ptrs[0];
> -		for (j = 1, blen = 0, bdiff = 0;
> -		     !error && j && (blen < args->maxlen || bdiff > 0);
> +		for (j = 1;
> +		     !error && j && (acur.len < args->maxlen || acur.diff > 0);
>  		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
>  			/*
>  			 * For each entry, decide if it's better than
> @@ -1301,44 +1308,40 @@ xfs_alloc_ag_vextent_near(
>  			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
>  			xfs_alloc_fix_len(args);
>  			ASSERT(args->len >= args->minlen);
> -			if (args->len < blen)
> +			if (args->len < acur.len)
>  				continue;
> -			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> +			diff = xfs_alloc_compute_diff(args->agbno, args->len,
>  				args->alignment, args->datatype, ltbnoa,
>  				ltlena, &ltnew);
>  			if (ltnew != NULLAGBLOCK &&
> -			    (args->len > blen || ltdiff < bdiff)) {
> -				bdiff = ltdiff;
> -				bnew = ltnew;
> -				blen = args->len;
> -				besti = acur.cnt->bc_ptrs[0];
> +			    (args->len > acur.len || diff < acur.diff)) {
> +				acur.rec_bno = ltbno;
> +				acur.rec_len = ltlen;
> +				acur.diff = diff;
> +				acur.bno = ltnew;
> +				acur.len = args->len;
>  			}
>  		}
>  		/*
>  		 * It didn't work.  We COULD be in a case where
>  		 * there's a good record somewhere, so try again.
>  		 */
> -		if (blen == 0)
> +		if (acur.len == 0)
>  			break;
> -		/*
> -		 * Point at the best entry, and retrieve it again.
> -		 */
> -		acur.cnt->bc_ptrs[0] = besti;
> -		error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
> -		if (error)
> -			goto out;
> -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> -		args->len = blen;
>  
>  		/*
> -		 * We are allocating starting at bnew for blen blocks.
> +		 * Allocate at the bno/len tracked in the cursor.
>  		 */
> -		args->agbno = bnew;
> -		ASSERT(bnew >= ltbno);
> -		ASSERT(bnew + blen <= ltbno + ltlen);
> -		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, ltbno,
> -					ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
> +		args->agbno = acur.bno;
> +		args->len = acur.len;
> +		ASSERT(acur.bno >= acur.rec_bno);
> +		ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> +		ASSERT(acur.rec_bno + acur.rec_len <=
> +		       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> +
> +		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt,
> +				acur.rec_bno, acur.rec_len, acur.bno, acur.len,
> +				0);
>  		if (error)
>  			goto out;
>  		trace_xfs_alloc_near_first(args);
> -- 
> 2.20.1
> 
