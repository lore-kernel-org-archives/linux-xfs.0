Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE19CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91B6E20700
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AE3RTV7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfJVQQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:16:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbfJVQQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 12:16:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MG9a7S148158;
        Tue, 22 Oct 2019 16:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jYx3ggx56t6Bpy36r5DXK+D/WYeV1m2It/LG7+WlF0Y=;
 b=AE3RTV7cHVc7IkOHOR0tFQJ1Q1icJeYh3HYt0Hbzdbox+1ktqtjJ5mEFMQfAR6xSAG6a
 gJeQu+JUO/7oSzHHxbCu84QDA/Gd5I+XuQfltrSZPI/rzRUiBWjiDskYYpr+OD/fMrfP
 Q8+M7Xunm5DC9xJDiTcdpzeHSy15PEce8Uc+fsgr2xmJ8bP6wRUR1LT2e0tkKTC5csmK
 xiCurVmFpejsW7P7Zg2ccFwIJxShFhPQUZxdDs7HxxeYe+rzyaEdQ0Aae7IpDHi9OPSb
 z3Qu/Tnv7l3mQ7Z45QdDGpd55HgRWtD3Qe7loS4LQEbfJU3JycaxVq240/Fi6Jto/akY +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qqq7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:16:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGDNej091714;
        Tue, 22 Oct 2019 16:16:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vsp3ynkaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:16:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MGG2dH026987;
        Tue, 22 Oct 2019 16:16:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:16:02 -0700
Date:   Tue, 22 Oct 2019 09:16:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: cap longest free extent to maximum
 allocatable
Message-ID: <20191022161601.GK913374@magnolia>
References: <20191021121322.25659-1-bfoster@redhat.com>
 <20191021121322.25659-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021121322.25659-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 08:13:21AM -0400, Brian Foster wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Cap longest extent to the largest we can allocate based on limits
> calculated at mount time. Dynamic state (such as finobt blocks)
> can result in the longest free extent exceeding the size we can
> allocate, and that results in failure to align full AG allocations
> when the AG is empty.
> 
> Result:
> 
> xfs_io-4413  [003]   426.412459: xfs_alloc_vextent_loopfailed: dev 8:96 agno 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 262148 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff
> 
> minlen and maxlen are now separated by the alignment size, and
> allocation fails because args.total > free space in the AG.
> 
> [bfoster: Added xfs_bmap_btalloc() changes.]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  | 18 +++++++++---------
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 533b04aaf6f6..9dead25d2e70 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
>  	 * reservations and AGFL rules in place, we can return this extent.
>  	 */
>  	if (pag->pagf_longest > delta)
> -		return pag->pagf_longest - delta;
> +		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
> +				pag->pagf_longest - delta);
>  
>  	/* Otherwise, let the caller try for 1 block if there's space. */
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 02469d59c787..c118577deaa9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3500,13 +3500,11 @@ xfs_bmap_btalloc(
>  			args.mod = args.prod - args.mod;
>  	}
>  	/*
> -	 * If we are not low on available data blocks, and the
> -	 * underlying logical volume manager is a stripe, and
> -	 * the file offset is zero then try to allocate data
> -	 * blocks on stripe unit boundary.
> -	 * NOTE: ap->aeof is only set if the allocation length
> -	 * is >= the stripe unit and the allocation offset is
> -	 * at the end of file.
> +	 * If we are not low on available data blocks, and the underlying
> +	 * logical volume manager is a stripe, and the file offset is zero then
> +	 * try to allocate data blocks on stripe unit boundary. NOTE: ap->aeof
> +	 * is only set if the allocation length is >= the stripe unit and the
> +	 * allocation offset is at the end of file.
>  	 */
>  	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
>  		if (!ap->offset) {
> @@ -3514,9 +3512,11 @@ xfs_bmap_btalloc(
>  			atype = args.type;
>  			isaligned = 1;
>  			/*
> -			 * Adjust for alignment
> +			 * Adjust minlen to try and preserve alignment if we
> +			 * can't guarantee an aligned maxlen extent.
>  			 */
> -			if (blen > args.alignment && blen <= args.maxlen)
> +			if (blen > args.alignment &&
> +			    blen <= args.maxlen + args.alignment)
>  				args.minlen = blen - args.alignment;
>  			args.minalignslop = 0;
>  		} else {
> -- 
> 2.20.1
> 
