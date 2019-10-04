Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022BFC4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC69C20873
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DPs8ntYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfJDW7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 18:59:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDW7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 18:59:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Mo5rD008731;
        Fri, 4 Oct 2019 22:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rSGwZ4o0WdLarUJ0SpMQTqzMycPIAh3Wgv67Up6eWxs=;
 b=DPs8ntYqBwzypzq7uB/kizxo3/CUl0a/ld20mVCfdne0stSmDZJTS5VO0xg3dfoiqydI
 Ef3XhkSSEH40XRUsSisaVSr1zmFlu8ORfnXSkI2uNo6eWXH20zfcur+KTHEB65x/K1KP
 4q227EbU/svkyeuiO7ZDGFz/yL7fKmIr/GTJuMq1xy90RKFgn/GzqOitO5hDHZjzVy6B
 pQ4QTlv9xvZAW7ZlV66uaC0xhYCJXcRKF1uX1oiK+3M+/qh8HwbHqtmoXGUIJkIYIYHY
 JNkBh2xKgtWf4xQIbeNKOZvNxpIq4FHRnOvlrhNAkbi61JBdEXLG5bWI340bkVFxsMcC PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfqx9ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:59:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94MwCNF039593;
        Fri, 4 Oct 2019 22:59:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vdk0vnyc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:59:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94Mx8Qr016670;
        Fri, 4 Oct 2019 22:59:08 GMT
Received: from localhost (/10.159.134.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 15:59:08 -0700
Date:   Fri, 4 Oct 2019 15:59:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 08/11] xfs: refactor and reuse best extent scanning
 logic
Message-ID: <20191004225907.GF1473994@magnolia>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-9-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040193
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 01:17:59PM -0400, Brian Foster wrote:
> The bnobt "find best" helper implements a simple btree walker
> function. This general pattern, or a subset thereof, is reused in
> various parts of a near mode allocation operation. For example, the
> bnobt left/right scans are each iterative btree walks along with the
> cntbt lastblock scan.
> 
> Rework this function into a generic btree walker, add a couple
> parameters to control termination behavior from various contexts and
> reuse it where applicable.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 110 +++++++++++++++++++-------------------
>  1 file changed, 55 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 32b378c8e16c..85e82e184ec9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -875,6 +875,13 @@ xfs_alloc_cur_check(
>  	acur->diff = diff;
>  	*new = 1;
>  
> +	/*
> +	 * We're done if we found a perfect allocation. This only deactivates
> +	 * the current cursor, but this is just an optimization to terminate a
> +	 * cntbt search that otherwise runs to the edge of the tree.
> +	 */
> +	if (acur->diff == 0 && acur->len == args->maxlen)
> +		deactivate = true;
>  out:
>  	if (deactivate)
>  		cur->bc_private.a.priv.abt.active = false;
> @@ -1172,30 +1179,38 @@ xfs_alloc_ag_vextent_exact(
>  }
>  
>  /*
> - * Search the btree in a given direction and check the records against the good
> - * extent we've already found.
> + * Search a given number of btree records in a given direction. Check each
> + * record against the good extent we've already found.
>   */
>  STATIC int
> -xfs_alloc_find_best_extent(
> +xfs_alloc_walk_iter(
>  	struct xfs_alloc_arg	*args,
>  	struct xfs_alloc_cur	*acur,
>  	struct xfs_btree_cur	*cur,
> -	bool			increment)
> +	bool			increment,
> +	bool			find_one, /* quit on first candidate */
> +	int			count,    /* rec count (-1 for infinite) */
> +	int			*stat)
>  {
>  	int			error;
>  	int			i;
>  
> +	*stat = 0;
> +
>  	/*
>  	 * Search so long as the cursor is active or we find a better extent.
>  	 * The cursor is deactivated if it extends beyond the range of the
>  	 * current allocation candidate.
>  	 */
> -	while (xfs_alloc_cur_active(cur)) {
> +	while (xfs_alloc_cur_active(cur) && count) {
>  		error = xfs_alloc_cur_check(args, acur, cur, &i);
>  		if (error)
>  			return error;
> -		if (i == 1)
> -			break;
> +		if (i == 1) {
> +			*stat = 1;
> +			if (find_one)
> +				break;
> +		}
>  		if (!xfs_alloc_cur_active(cur))
>  			break;
>  
> @@ -1207,6 +1222,9 @@ xfs_alloc_find_best_extent(
>  			return error;
>  		if (i == 0)
>  			cur->bc_private.a.priv.abt.active = false;
> +
> +		if (count > 0)
> +			count--;
>  	}
>  
>  	return 0;
> @@ -1226,7 +1244,6 @@ xfs_alloc_ag_vextent_near(
>  	struct xfs_btree_cur	*fbcur = NULL;
>  	int			error;		/* error code */
>  	int			i;		/* result code, temporary */
> -	int			j;		/* result code, temporary */
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
>  	bool			fbinc = false;
> @@ -1313,19 +1330,12 @@ xfs_alloc_ag_vextent_near(
>  			if (!i)
>  				break;
>  		}
> -		i = acur.cnt->bc_ptrs[0];
> -		for (j = 1;
> -		     !error && j && xfs_alloc_cur_active(acur.cnt) &&
> -		     (acur.len < args->maxlen || acur.diff > 0);
> -		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
> -			/*
> -			 * For each entry, decide if it's better than
> -			 * the previous best entry.
> -			 */
> -			error = xfs_alloc_cur_check(args, &acur, acur.cnt, &i);
> -			if (error)
> -				goto out;
> -		}
> +
> +		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, true, false,
> +					    -1, &i);
> +		if (error)
> +			goto out;
> +
>  		/*
>  		 * It didn't work.  We COULD be in a case where
>  		 * there's a good record somewhere, so try again.
> @@ -1357,49 +1367,39 @@ xfs_alloc_ag_vextent_near(
>  		goto out;
>  
>  	/*
> -	 * Loop going left with the leftward cursor, right with the
> -	 * rightward cursor, until either both directions give up or
> -	 * we find an entry at least as big as minlen.
> +	 * Loop going left with the leftward cursor, right with the rightward
> +	 * cursor, until either both directions give up or we find an entry at
> +	 * least as big as minlen.
>  	 */
>  	do {
> -		if (xfs_alloc_cur_active(acur.bnolt)) {
> -			error = xfs_alloc_cur_check(args, &acur, acur.bnolt, &i);
> -			if (error)
> -				goto out;
> -			if (i == 1) {
> -				trace_xfs_alloc_cur_left(args);
> -				fbcur = acur.bnogt;
> -				fbinc = true;
> -				break;
> -			}
> -			error = xfs_btree_decrement(acur.bnolt, 0, &i);
> -			if (error)
> -				goto out;
> -			if (!i)
> -				acur.bnolt->bc_private.a.priv.abt.active = false;
> +		error = xfs_alloc_walk_iter(args, &acur, acur.bnolt, false,
> +					    true, 1, &i);
> +		if (error)
> +			goto out;
> +		if (i == 1) {
> +			trace_xfs_alloc_cur_left(args);
> +			fbcur = acur.bnogt;
> +			fbinc = true;
> +			break;
>  		}
> -		if (xfs_alloc_cur_active(acur.bnogt)) {
> -			error = xfs_alloc_cur_check(args, &acur, acur.bnogt, &i);
> -			if (error)
> -				goto out;
> -			if (i == 1) {
> -				trace_xfs_alloc_cur_right(args);
> -				fbcur = acur.bnolt;
> -				fbinc = false;
> -				break;
> -			}
> -			error = xfs_btree_increment(acur.bnogt, 0, &i);
> -			if (error)
> -				goto out;
> -			if (!i)
> -				acur.bnogt->bc_private.a.priv.abt.active = false;
> +
> +		error = xfs_alloc_walk_iter(args, &acur, acur.bnogt, true, true,
> +					    1, &i);
> +		if (error)
> +			goto out;
> +		if (i == 1) {
> +			trace_xfs_alloc_cur_right(args);
> +			fbcur = acur.bnolt;
> +			fbinc = false;
> +			break;
>  		}
>  	} while (xfs_alloc_cur_active(acur.bnolt) ||
>  		 xfs_alloc_cur_active(acur.bnogt));
>  
>  	/* search the opposite direction for a better entry */
>  	if (fbcur) {
> -		error = xfs_alloc_find_best_extent(args, &acur, fbcur, fbinc);
> +		error = xfs_alloc_walk_iter(args, &acur, fbcur, fbinc, true, -1,
> +					    &i);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.20.1
> 
