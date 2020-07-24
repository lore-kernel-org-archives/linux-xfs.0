Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDDFC433E8
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E8A20748
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tADtUa99"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGXFoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 01:44:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:44:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5bwnH065327;
        Fri, 24 Jul 2020 05:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=R5I2YakBmNpkY+ouCQoPiI0yZo5RO2vdq9lUlxcp7qM=;
 b=tADtUa99/hmTzcv1Uhg4BxM0mL4CSNP02gkVTC6uVfUy6IxAzmUjArktRBa+oHi6pvAN
 Q0zSRl8BjEXHsHdIV+OGp7WsoAuQkCBrK5J5pCMG9ViGF1i5Y1qzuqcRyeuWSPNV6Bss
 QyXtcI738EttXf5BmXmxW9QzQgYZ7FBW1Rt0bNDhlu/nyWGlKzkIXvv4LrxmDsMdABti
 7D4+ofn0Crl0y5FrYbn0Jeu/LtVOzsZFrqhAuejZFkYCyRCR6F4TFRqUxeveWxZfMXsW
 SmAF82E60FyI5s+FbIVCn9zh/pF23nsQ0O2amJIEuP5Aa1KNzXrV7W1n/p/dhb6Kubnp Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1mw78u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 05:44:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5cADm105199;
        Fri, 24 Jul 2020 05:42:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32fn6q0r62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 05:42:18 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06O5edtL009136;
        Fri, 24 Jul 2020 05:40:39 GMT
Received: from localhost (/10.159.156.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 05:40:39 +0000
Date:   Thu, 23 Jul 2020 22:40:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Refactor xfs_da_state_alloc() helper
Message-ID: <20200724054037.GU3151642@magnolia>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-6-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=7 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=7 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:18AM +0200, Carlos Maiolino wrote:
> Every call to xfs_da_state_alloc() also requires setting up state->args
> and state->mp
> 
> Change xfs_da_state_alloc() to receive an xfs_da_args_t as argument and
> return a xfs_da_state_t with both args and mp already set.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Will fix the typedef thing for xfs_da_state_alloc when I commit this;
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V3:
> 		- Originally this patch removed xfs_da_state_alloc(),
> 		  per hch's suggestion, instead of removing, it has been
> 		  refactored, to also set state->{args,mp} which removes
> 		  a few lines of code.
> 
>  fs/xfs/libxfs/xfs_attr.c      | 17 +++++------------
>  fs/xfs/libxfs/xfs_da_btree.c  |  8 ++++++--
>  fs/xfs/libxfs/xfs_da_btree.h  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c | 17 +++++------------
>  fs/xfs/scrub/dabtree.c        |  4 +---
>  5 files changed, 18 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3b1bd6e112f89..52e01fc0c5d04 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -750,9 +750,7 @@ xfs_attr_node_addname(
>  	dp = args->dp;
>  	mp = dp->i_mount;
>  restart:
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = mp;
> +	state = xfs_da_state_alloc(args);
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
> @@ -899,9 +897,8 @@ xfs_attr_node_addname(
>  		 * attr, not the "new" one.
>  		 */
>  		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> -		state = xfs_da_state_alloc();
> -		state->args = args;
> -		state->mp = mp;
> +		state = xfs_da_state_alloc(args);
> +
>  		state->inleaf = 0;
>  		error = xfs_da3_node_lookup_int(state, &retval);
>  		if (error)
> @@ -975,9 +972,7 @@ xfs_attr_node_removename(
>  	 * Tie a string around our finger to remind us where we are.
>  	 */
>  	dp = args->dp;
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = dp->i_mount;
> +	state = xfs_da_state_alloc(args);
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
> @@ -1207,9 +1202,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  
>  	trace_xfs_attr_node_get(args);
>  
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> +	state = xfs_da_state_alloc(args);
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index a4e1f01daf3d8..47da88154b434 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -79,9 +79,13 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
>   * We don't put them on the stack since they're large.
>   */
>  xfs_da_state_t *
> -xfs_da_state_alloc(void)
> +xfs_da_state_alloc(xfs_da_args_t *args)
>  {
> -	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
> +	xfs_da_state_t *state = kmem_cache_zalloc(xfs_da_state_zone,
> +						  GFP_NOFS | __GFP_NOFAIL);
> +	state->args = args;
> +	state->mp = args->dp->i_mount;
> +	return state;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 6e25de6621e4f..bb039dcb0cce4 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -219,7 +219,7 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
>  				const unsigned char *name, int len);
>  
>  
> -xfs_da_state_t *xfs_da_state_alloc(void);
> +xfs_da_state_t *xfs_da_state_alloc(xfs_da_args_t *args);
>  void xfs_da_state_free(xfs_da_state_t *state);
>  
>  void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 6ac4aad98cd76..5d51265d29d6f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -2015,9 +2015,7 @@ xfs_dir2_node_addname(
>  	/*
>  	 * Allocate and initialize the state (btree cursor).
>  	 */
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> +	state = xfs_da_state_alloc(args);
>  	/*
>  	 * Look up the name.  We're not supposed to find it, but
>  	 * this gives us the insertion point.
> @@ -2086,9 +2084,8 @@ xfs_dir2_node_lookup(
>  	/*
>  	 * Allocate and initialize the btree cursor.
>  	 */
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> +	state = xfs_da_state_alloc(args);
> +
>  	/*
>  	 * Fill in the path to the entry in the cursor.
>  	 */
> @@ -2139,9 +2136,7 @@ xfs_dir2_node_removename(
>  	/*
>  	 * Allocate and initialize the btree cursor.
>  	 */
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> +	state = xfs_da_state_alloc(args);
>  
>  	/* Look up the entry we're deleting, set up the cursor. */
>  	error = xfs_da3_node_lookup_int(state, &rval);
> @@ -2206,9 +2201,7 @@ xfs_dir2_node_replace(
>  	/*
>  	 * Allocate and initialize the btree cursor.
>  	 */
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> +	state = xfs_da_state_alloc(args);
>  
>  	/*
>  	 * We have to save new inode number and ftype since
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 44b15015021f3..e56786f0a13c8 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -476,9 +476,7 @@ xchk_da_btree(
>  	ds.dargs.whichfork = whichfork;
>  	ds.dargs.trans = sc->tp;
>  	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
> -	ds.state = xfs_da_state_alloc();
> -	ds.state->args = &ds.dargs;
> -	ds.state->mp = mp;
> +	ds.state = xfs_da_state_alloc(&ds.dargs);
>  	ds.sc = sc;
>  	ds.private = private;
>  	if (whichfork == XFS_ATTR_FORK) {
> -- 
> 2.26.2
> 
