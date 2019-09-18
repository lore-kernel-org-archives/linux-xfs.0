Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118F1C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 21:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A2E20665
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 21:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C8XzHK33"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbfIRVEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 17:04:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfIRVEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 17:04:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKwxjI054662;
        Wed, 18 Sep 2019 21:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FlIIP5v0B87EuVqRzolrQZS2P6yxhaeSEMrIM4QMxRk=;
 b=C8XzHK33bLtTcmdEkK5zHENrAK2EhAso4X0qF+y9nOhPBaKjyjQALUMNsPH+2Jodx24c
 2wW8UImbNVlhGns2ul3WTxaLAL+YACyFv/CyP9L5+CAa6yNEtbgKnZm2X+S4fAPkYfTn
 6li0xz3HWRKWxH8Ki8qHj98GL7wBYvKMXVCwGq7MWo9xQ7bHEkLbsbqjfGOnpylvjePp
 thsVBla42OY8xq1+9gSY4NSRcxekuJ84hnPbnZOoVDOCbCaJoxKNvHzZ+lxBUCF7mBCH
 FLC5y6Ce0ZJjTrv3U3s074u61H9zu/vUqfh3P0fnWXnm82WO9oiiwR8zGoL+o8jMqrGR JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v385dxh5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 21:04:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IL3svf005044;
        Wed, 18 Sep 2019 21:04:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v37maa6uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 21:04:03 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IL3LT1029790;
        Wed, 18 Sep 2019 21:03:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 14:03:21 -0700
Date:   Wed, 18 Sep 2019 14:03:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 08/11] xfs: refactor and reuse best extent scanning
 logic
Message-ID: <20190918210320.GZ2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-9-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:32AM -0400, Brian Foster wrote:
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
> XXX: This slightly changes the cntbt lastblock scan logic to scan
> the entire block and use the best candidate as opposed to the
> current logic of checking until we locate a perfect match. Fix up
> cur_check() to terminate on perfect match.

Did that fix up happen in a previous patch?

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 103 ++++++++++++++++++--------------------
>  1 file changed, 48 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3eacc799c4cb..ab494fd50dd7 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1172,30 +1172,38 @@ xfs_alloc_ag_vextent_exact(
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
> +	bool			find_one,/* quit on first candidate */

Space between the comma and the comment?

--D

> +	int			count,	/* rec count (-1 for infinite) */
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
> @@ -1207,6 +1215,9 @@ xfs_alloc_find_best_extent(
>  			return error;
>  		if (i == 0)
>  			cur->bc_private.a.priv.abt.active = false;
> +
> +		if (count > 0)
> +			count--;
>  	}
>  
>  	return 0;
> @@ -1226,7 +1237,6 @@ xfs_alloc_ag_vextent_near(
>  	struct xfs_btree_cur	*fbcur = NULL;
>  	int		error;		/* error code */
>  	int		i;		/* result code, temporary */
> -	int		j;		/* result code, temporary */
>  	xfs_agblock_t	bno;
>  	xfs_extlen_t	len;
>  	bool		fbinc = false;
> @@ -1313,19 +1323,12 @@ xfs_alloc_ag_vextent_near(
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
> @@ -1357,49 +1360,39 @@ xfs_alloc_ag_vextent_near(
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
