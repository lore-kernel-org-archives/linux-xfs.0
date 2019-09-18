Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1EFC4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03BE821897
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="caPnJJnl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfIRUzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 16:55:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbfIRUzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 16:55:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKnN7L047461;
        Wed, 18 Sep 2019 20:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hXNORhMglGpQUMXw31bEb4Il9NF04oZJ7tHL8y4YsnQ=;
 b=caPnJJnlbWUbxLLj+x/nwUZrwQRw6BSqtnZ3KJeXGOJ4q1tgv18yfZC9M3zAgIyc1nwO
 T+dXWFBu3MUAo0IbtyJO35vEkhHaqWZhdZFbmLqlm8i03ddblw2bkKxoa89zxeLets3k
 TyDJW9r4Ll/U07zkPZK2QqQ22fKZfOOP6u29RvR3dvMCX4ggCk8yvKsNy0YSOUgrdZqa
 YqyIUulegATKU3Bel2TMhjoyvcsiUIPrlDzeYIeqd9DVWKqefU1iIBf/b3ngvSSr921T
 4heSpaSi9aAvMJj/GIRfBygmwOOENqIbclUDm/aTpQYqDRTOf1K+ofQgbSuYXWZ33qZK Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v385dxfvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:55:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKsugw047852;
        Wed, 18 Sep 2019 20:55:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v37mnar69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:55:09 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IKt8Zb013435;
        Wed, 18 Sep 2019 20:55:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 13:55:08 -0700
Date:   Wed, 18 Sep 2019 13:55:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 09/11] xfs: refactor near mode alloc bnobt scan into
 separate function
Message-ID: <20190918205507.GX2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-10-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:33AM -0400, Brian Foster wrote:
> In preparation to enhance the near mode allocation bnobt scan algorithm, lift
> it into a separate function. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 128 ++++++++++++++++++++++----------------
>  1 file changed, 74 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ab494fd50dd7..6f7e4666250c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1223,6 +1223,78 @@ xfs_alloc_walk_iter(
>  	return 0;
>  }
>  
> +/*
> + * Search in the by-bno btree to the left and to the right simultaneously until
> + * in each case we find a large enough free extent or run into the edge of the
> + * tree. When we run into the edge of the tree, we deactivate that cursor.
> + */
> +STATIC int
> +xfs_alloc_ag_vextent_bnobt(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_alloc_cur	*acur,
> +	int			*stat)
> +{
> +	struct xfs_btree_cur	*fbcur = NULL;
> +	int			error;
> +	int			i;
> +	bool			fbinc;
> +
> +	ASSERT(acur->len == 0);
> +	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
> +
> +	*stat = 0;
> +
> +	error = xfs_alloc_lookup_le(acur->bnolt, args->agbno, 0, &i);
> +	if (error)
> +		return error;
> +	error = xfs_alloc_lookup_ge(acur->bnogt, args->agbno, 0, &i);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Loop going left with the leftward cursor, right with the rightward
> +	 * cursor, until either both directions give up or we find an entry at
> +	 * least as big as minlen.
> +	 */
> +	while (xfs_alloc_cur_active(acur->bnolt) ||
> +	       xfs_alloc_cur_active(acur->bnogt)) {
> +		error = xfs_alloc_walk_iter(args, acur, acur->bnolt, false,
> +					    true, 1, &i);
> +		if (error)
> +			return error;
> +		if (i == 1) {
> +			trace_xfs_alloc_cur_left(args);
> +			fbcur = acur->bnogt;
> +			fbinc = true;
> +			break;
> +		}
> +
> +		error = xfs_alloc_walk_iter(args, acur, acur->bnogt, true, true,
> +					    1, &i);
> +		if (error)
> +			return error;
> +		if (i == 1) {
> +			trace_xfs_alloc_cur_right(args);
> +			fbcur = acur->bnolt;
> +			fbinc = false;
> +			break;
> +		}
> +	}
> +
> +	/* search the opposite direction for a better entry */
> +	if (fbcur) {
> +		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true, -1,
> +					    &i);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (acur->len)
> +		*stat = 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * Allocate a variable extent near bno in the allocation group agno.
>   * Extent's length (returned in len) will be between minlen and maxlen,
> @@ -1234,12 +1306,10 @@ xfs_alloc_ag_vextent_near(
>  	struct xfs_alloc_arg	*args)
>  {
>  	struct xfs_alloc_cur	acur = {0,};
> -	struct xfs_btree_cur	*fbcur = NULL;
>  	int		error;		/* error code */
>  	int		i;		/* result code, temporary */
>  	xfs_agblock_t	bno;
>  	xfs_extlen_t	len;
> -	bool		fbinc = false;
>  #ifdef DEBUG
>  	/*
>  	 * Randomly don't execute the first algorithm.
> @@ -1341,62 +1411,12 @@ xfs_alloc_ag_vextent_near(
>  	}
>  
>  	/*
> -	 * Second algorithm.
> -	 * Search in the by-bno tree to the left and to the right
> -	 * simultaneously, until in each case we find a space big enough,
> -	 * or run into the edge of the tree.  When we run into the edge,
> -	 * we deallocate that cursor.
> -	 * If both searches succeed, we compare the two spaces and pick
> -	 * the better one.
> -	 * With alignment, it's possible for both to fail; the upper
> -	 * level algorithm that picks allocation groups for allocations
> -	 * is not supposed to do this.
> +	 * Second algorithm. Search the bnobt left and right.
>  	 */
> -	error = xfs_alloc_lookup_le(acur.bnolt, args->agbno, 0, &i);
> -	if (error)
> -		goto out;
> -	error = xfs_alloc_lookup_ge(acur.bnogt, args->agbno, 0, &i);
> +	error = xfs_alloc_ag_vextent_bnobt(args, &acur, &i);
>  	if (error)
>  		goto out;
>  
> -	/*
> -	 * Loop going left with the leftward cursor, right with the rightward
> -	 * cursor, until either both directions give up or we find an entry at
> -	 * least as big as minlen.
> -	 */
> -	do {
> -		error = xfs_alloc_walk_iter(args, &acur, acur.bnolt, false,
> -					    true, 1, &i);
> -		if (error)
> -			goto out;
> -		if (i == 1) {
> -			trace_xfs_alloc_cur_left(args);
> -			fbcur = acur.bnogt;
> -			fbinc = true;
> -			break;
> -		}
> -
> -		error = xfs_alloc_walk_iter(args, &acur, acur.bnogt, true, true,
> -					    1, &i);
> -		if (error)
> -			goto out;
> -		if (i == 1) {
> -			trace_xfs_alloc_cur_right(args);
> -			fbcur = acur.bnolt;
> -			fbinc = false;
> -			break;
> -		}
> -	} while (xfs_alloc_cur_active(acur.bnolt) ||
> -		 xfs_alloc_cur_active(acur.bnogt));
> -
> -	/* search the opposite direction for a better entry */
> -	if (fbcur) {
> -		error = xfs_alloc_walk_iter(args, &acur, fbcur, fbinc, true, -1,
> -					    &i);
> -		if (error)
> -			goto out;
> -	}
> -
>  	/*
>  	 * If we couldn't get anything, give up.
>  	 */
> -- 
> 2.20.1
> 
