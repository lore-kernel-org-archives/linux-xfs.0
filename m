Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC567C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E05724655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QqKD9FjB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgAUWPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 17:15:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36944 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgAUWPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 17:15:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMDYmb164068
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4qJXx1uqizryoXyWRVw3CyTfiGinQ5Nl9teYJyHWWyA=;
 b=QqKD9FjBhXC5Xlq2Ct5//12zcWUqrelcmg9nygybQzDhEUcXL60K09RAafnhPwZTCYAq
 NXNerj/21FhRi3hu5edbiAWGEFMp+EXxfwnglnxAZ3FvuieosZTt2uhp1I85M/u2+0/7
 cZTXhLMu6G4mIPPvLws/41ihUqlOglxMwp/d3Kdb2Q2EhKUooQ7xFgZyf+JNAVLY7mtO
 GEjddluFA1sg8772mMX3+YfX0SBo7UKY7202X6TzqEaXeYg/8TBvytZvOskRZZrB6TIx
 +r+ryd8uQvA0//UesJwr2jI+wj8T1z2ZZ5YyIuz+GUtlWVpnOOf604DSXAcW102awUSv zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq83t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:15:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMDu1f154801
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:15:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xnsj5g6pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:15:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LMF9io024298
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:15:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 14:15:09 -0800
Date:   Tue, 21 Jan 2020 14:15:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 02/16] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20200121221508.GF8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:21PM -0700, Allison Collins wrote:
> This patch embeds an xfs_name in xfs_da_args, replacing the name,
> namelen, and flags members.  This helps to clean up the xfs_da_args
> structure and make it more uniform with the new xfs_name parameter being
> passed around.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I'm not really sure /what/ tag to apply to this -- it looks reasonably
sane, it conflicts with a separate proposed cleanup series that would
make some of this rather less awkward, and yet at the same time I've not
actually put hch's series in for-next pending questions...)

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
>  fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>  fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>  fs/xfs/scrub/attr.c             |  12 ++---
>  fs/xfs/xfs_trace.h              |  20 ++++----
>  12 files changed, 130 insertions(+), 123 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6717f47..9acdb23 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
> -	args->flags = flags;
> -	args->name = name->name;
> -	args->namelen = name->len;
> -	if (args->namelen >= MAXNAMELEN)
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
> +	args->name.type = flags;
> +	if (args->name.len >= MAXNAMELEN)
>  		return -EFAULT;		/* match IRIX behaviour */
>  
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
>  	return 0;
>  }
>  
> @@ -236,7 +235,7 @@ xfs_attr_try_sf_addname(
>  	 * Commit the shortform mods, and we're done.
>  	 * NOTE: this is also the error path (EEXIST, etc).
>  	 */
> -	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
> +	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> @@ -357,6 +356,9 @@ xfs_attr_set(
>  	if (error)
>  		return error;
>  
> +	/* Use name now stored in args */
> +	name = &args.name;
> +
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> @@ -372,7 +374,7 @@ xfs_attr_set(
>  	 */
>  	if (XFS_IFORK_Q(dp) == 0) {
>  		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
> +			XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
>  
>  		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
>  		if (error)
> @@ -457,6 +459,9 @@ xfs_attr_remove(
>  	if (error)
>  		return error;
>  
> +	/* Use name now stored in args */
> +	name = &args.name;
> +
>  	/*
>  	 * we have no control over the attribute names that userspace passes us
>  	 * to remove, so we have to allow the name lookup prior to attribute
> @@ -532,10 +537,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_addname(args);
>  
>  	retval = xfs_attr_shortform_lookup(args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		return retval;
>  	} else if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)
> +		if (args->name.type & ATTR_CREATE)
>  			return retval;
>  		retval = xfs_attr_shortform_remove(args);
>  		if (retval)
> @@ -545,15 +550,15 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  		 * that the leaf format add routine won't trip over the attr
>  		 * not being around.
>  		 */
> -		args->flags &= ~ATTR_REPLACE;
> +		args->name.type &= ~ATTR_REPLACE;
>  	}
>  
> -	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> +	if (args->name.len >= XFS_ATTR_SF_ENTSIZE_MAX ||
>  	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
>  		return -ENOSPC;
>  
>  	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
> -	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>  
>  	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
>  	if (!forkoff)
> @@ -598,11 +603,11 @@ xfs_attr_leaf_addname(
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
>  	retval = xfs_attr3_leaf_lookup_int(bp, args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return retval;
>  	} else if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE) {	/* pure create op */
> +		if (args->name.type & ATTR_CREATE) {	/* pure create op */
>  			xfs_trans_brelse(args->trans, bp);
>  			return retval;
>  		}
> @@ -872,10 +877,10 @@ xfs_attr_node_addname(
>  		goto out;
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		goto out;
>  	} else if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)
> +		if (args->name.type & ATTR_CREATE)
>  			goto out;
>  
>  		trace_xfs_attr_node_replace(args);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fed537a..cb5ef66 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -464,7 +464,7 @@ xfs_attr_copy_value(
>  	/*
>  	 * No copy if all we have to do is get the length
>  	 */
> -	if (args->flags & ATTR_KERNOVAL) {
> +	if (args->name.type & ATTR_KERNOVAL) {
>  		args->valuelen = valuelen;
>  		return 0;
>  	}
> @@ -679,27 +679,27 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>  #ifdef DEBUG
> -		if (sfe->namelen != args->namelen)
> +		if (sfe->namelen != args->name.len)
>  			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> +		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>  			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>  			continue;
>  		ASSERT(0);
>  #endif
>  	}
>  
>  	offset = (char *)sfe - (char *)sf;
> -	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>  	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
>  
> -	sfe->namelen = args->namelen;
> +	sfe->namelen = args->name.len;
>  	sfe->valuelen = args->valuelen;
> -	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
> -	memcpy(sfe->nameval, args->name, args->namelen);
> -	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
> +	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->name.type);
> +	memcpy(sfe->nameval, args->name.name, args->name.len);
> +	memcpy(&sfe->nameval[args->name.len], args->value, args->valuelen);
>  	sf->hdr.count++;
>  	be16_add_cpu(&sf->hdr.totsize, size);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
> @@ -749,11 +749,11 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
>  	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>  					base += size, i++) {
>  		size = XFS_ATTR_SF_ENTSIZE(sfe);
> -		if (sfe->namelen != args->namelen)
> +		if (sfe->namelen != args->name.len)
>  			continue;
> -		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
> +		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
>  			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>  			continue;
>  		break;
>  	}
> @@ -816,11 +816,11 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> +		if (sfe->namelen != args->name.len)
>  			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> +		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>  			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>  			continue;
>  		return -EEXIST;
>  	}
> @@ -847,13 +847,13 @@ xfs_attr_shortform_getvalue(
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> +		if (sfe->namelen != args->name.len)
>  			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> +		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>  			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>  			continue;
> -		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> +		return xfs_attr_copy_value(args, &sfe->nameval[args->name.len],
>  						sfe->valuelen);
>  	}
>  	return -ENOATTR;
> @@ -912,13 +912,13 @@ xfs_attr_shortform_to_leaf(
>  
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; i++) {
> -		nargs.name = sfe->nameval;
> -		nargs.namelen = sfe->namelen;
> -		nargs.value = &sfe->nameval[nargs.namelen];
> +		nargs.name.name = sfe->nameval;
> +		nargs.name.len = sfe->namelen;
> +		nargs.value = &sfe->nameval[nargs.name.len];
>  		nargs.valuelen = sfe->valuelen;
>  		nargs.hashval = xfs_da_hashname(sfe->nameval,
>  						sfe->namelen);
> -		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
> +		nargs.name.type = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
>  		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
>  		ASSERT(error == -ENOATTR);
>  		error = xfs_attr3_leaf_add(bp, &nargs);
> @@ -1119,12 +1119,12 @@ xfs_attr3_leaf_to_shortform(
>  			continue;
>  		ASSERT(entry->flags & XFS_ATTR_LOCAL);
>  		name_loc = xfs_attr3_leaf_name_local(leaf, i);
> -		nargs.name = name_loc->nameval;
> -		nargs.namelen = name_loc->namelen;
> -		nargs.value = &name_loc->nameval[nargs.namelen];
> +		nargs.name.name = name_loc->nameval;
> +		nargs.name.len = name_loc->namelen;
> +		nargs.value = &name_loc->nameval[nargs.name.len];
>  		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
>  		nargs.hashval = be32_to_cpu(entry->hashval);
> -		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
> +		nargs.name.type = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
>  		xfs_attr_shortform_add(&nargs, forkoff);
>  	}
>  	error = 0;
> @@ -1450,7 +1450,7 @@ xfs_attr3_leaf_add_work(
>  				     ichdr->freemap[mapindex].size);
>  	entry->hashval = cpu_to_be32(args->hashval);
>  	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
> -	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
> +	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->name.type);
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
>  		entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
> @@ -1474,15 +1474,16 @@ xfs_attr3_leaf_add_work(
>  	 */
>  	if (entry->flags & XFS_ATTR_LOCAL) {
>  		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
> -		name_loc->namelen = args->namelen;
> +		name_loc->namelen = args->name.len;
>  		name_loc->valuelen = cpu_to_be16(args->valuelen);
> -		memcpy((char *)name_loc->nameval, args->name, args->namelen);
> -		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
> +		memcpy((char *)name_loc->nameval, args->name.name,
> +		       args->name.len);
> +		memcpy((char *)&name_loc->nameval[args->name.len], args->value,
>  				   be16_to_cpu(name_loc->valuelen));
>  	} else {
>  		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> -		name_rmt->namelen = args->namelen;
> -		memcpy((char *)name_rmt->name, args->name, args->namelen);
> +		name_rmt->namelen = args->name.len;
> +		memcpy((char *)name_rmt->name, args->name.name, args->name.len);
>  		entry->flags |= XFS_ATTR_INCOMPLETE;
>  		/* just in case */
>  		name_rmt->valuelen = 0;
> @@ -2409,23 +2410,25 @@ xfs_attr3_leaf_lookup_int(
>  		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
> -			if (name_loc->namelen != args->namelen)
> +			if (name_loc->namelen != args->name.len)
>  				continue;
> -			if (memcmp(args->name, name_loc->nameval,
> -							args->namelen) != 0)
> +			if (memcmp(args->name.name, name_loc->nameval,
> +							args->name.len) != 0)
>  				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_namesp_match(args->name.type,
> +						   entry->flags))
>  				continue;
>  			args->index = probe;
>  			return -EEXIST;
>  		} else {
>  			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
> -			if (name_rmt->namelen != args->namelen)
> +			if (name_rmt->namelen != args->name.len)
>  				continue;
> -			if (memcmp(args->name, name_rmt->name,
> -							args->namelen) != 0)
> +			if (memcmp(args->name.name, name_rmt->name,
> +							args->name.len) != 0)
>  				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_namesp_match(args->name.type,
> +						   entry->flags))
>  				continue;
>  			args->index = probe;
>  			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> @@ -2467,16 +2470,17 @@ xfs_attr3_leaf_getvalue(
>  	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
>  	if (entry->flags & XFS_ATTR_LOCAL) {
>  		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
> -		ASSERT(name_loc->namelen == args->namelen);
> -		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
> +		ASSERT(name_loc->namelen == args->name.len);
> +		ASSERT(memcmp(args->name.name, name_loc->nameval,
> +			      args->name.len) == 0);
>  		return xfs_attr_copy_value(args,
> -					&name_loc->nameval[args->namelen],
> +					&name_loc->nameval[args->name.len],
>  					be16_to_cpu(name_loc->valuelen));
>  	}
>  
>  	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> -	ASSERT(name_rmt->namelen == args->namelen);
> -	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> +	ASSERT(name_rmt->namelen == args->name.len);
> +	ASSERT(memcmp(args->name.name, name_rmt->name, args->name.len) == 0);
>  	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
>  	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> @@ -2692,7 +2696,7 @@ xfs_attr_leaf_newentsize(
>  {
>  	int			size;
>  
> -	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
> +	size = xfs_attr_leaf_entsize_local(args->name.len, args->valuelen);
>  	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
>  		if (local)
>  			*local = 1;
> @@ -2700,7 +2704,7 @@ xfs_attr_leaf_newentsize(
>  	}
>  	if (local)
>  		*local = 0;
> -	return xfs_attr_leaf_entsize_remote(args->namelen);
> +	return xfs_attr_leaf_entsize_remote(args->name.len);
>  }
>  
>  
> @@ -2754,8 +2758,8 @@ xfs_attr3_leaf_clearflag(
>  		name = (char *)name_rmt->name;
>  	}
>  	ASSERT(be32_to_cpu(entry->hashval) == args->hashval);
> -	ASSERT(namelen == args->namelen);
> -	ASSERT(memcmp(name, args->name, namelen) == 0);
> +	ASSERT(namelen == args->name.len);
> +	ASSERT(memcmp(name, args->name.name, namelen) == 0);
>  #endif /* DEBUG */
>  
>  	entry->flags &= ~XFS_ATTR_INCOMPLETE;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a6ef5df..3e725c3 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -380,7 +380,7 @@ xfs_attr_rmtval_get(
>  
>  	trace_xfs_attr_rmtval_get(args);
>  
> -	ASSERT(!(args->flags & ATTR_KERNOVAL));
> +	ASSERT(!(args->name.type & ATTR_KERNOVAL));
>  	ASSERT(args->rmtvaluelen == args->valuelen);
>  
>  	valuelen = args->rmtvaluelen;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 8c3eafe..da7e1af 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2125,8 +2125,10 @@ xfs_da_compname(
>  	const unsigned char *name,
>  	int		len)
>  {
> -	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
> -					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
> +	if (args->name.len == len && !memcmp(args->name.name, name, len))
> +		return XFS_CMP_EXACT;
> +
> +	return XFS_CMP_DIFFERENT;
>  }
>  
>  int
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 0f4fbb0..14f1be3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -54,12 +54,10 @@ enum xfs_dacmp {
>   */
>  typedef struct xfs_da_args {
>  	struct xfs_da_geometry *geo;	/* da block geometry */
> -	const uint8_t		*name;		/* string (maybe not NULL terminated) */
> -	int		namelen;	/* length of string (maybe no NULL) */
> +	struct xfs_name	name;		/* name, length and argument  flags*/
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
>  	xfs_dahash_t	hashval;	/* hash value of name */
>  	xfs_ino_t	inumber;	/* input/output inode number */
>  	struct xfs_inode *dp;		/* directory inode to manipulate */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index dd6fcaa..3aadddc 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -74,14 +74,14 @@ xfs_ascii_ci_compname(
>  	enum xfs_dacmp		result;
>  	int			i;
>  
> -	if (args->namelen != len)
> +	if (args->name.len != len)
>  		return XFS_CMP_DIFFERENT;
>  
>  	result = XFS_CMP_EXACT;
>  	for (i = 0; i < len; i++) {
> -		if (args->name[i] == name[i])
> +		if (args->name.name[i] == name[i])
>  			continue;
> -		if (tolower(args->name[i]) != tolower(name[i]))
> +		if (tolower(args->name.name[i]) != tolower(name[i]))
>  			return XFS_CMP_DIFFERENT;
>  		result = XFS_CMP_CASE;
>  	}
> @@ -265,8 +265,7 @@ xfs_dir_createname(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>  	args->filetype = name->type;
>  	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = inum;
> @@ -361,8 +360,7 @@ xfs_dir_lookup(
>  	 */
>  	args = kmem_zalloc(sizeof(*args), KM_NOFS);
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>  	args->filetype = name->type;
>  	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->dp = dp;
> @@ -433,8 +431,7 @@ xfs_dir_removename(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>  	args->filetype = name->type;
>  	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = ino;
> @@ -494,8 +491,7 @@ xfs_dir_replace(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>  	args->filetype = name->type;
>  	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = inum;
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index d6ced59..592e47c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -355,7 +355,7 @@ xfs_dir2_block_addname(
>  	if (error)
>  		return error;
>  
> -	len = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
> +	len = xfs_dir2_data_entsize(dp->i_mount, args->name.len);
>  
>  	/*
>  	 * Set up pointers to parts of the block.
> @@ -539,8 +539,8 @@ xfs_dir2_block_addname(
>  	 * Create the new data entry.
>  	 */
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, args->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, args->name.len);
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index a131b52..24a7fda 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -653,7 +653,7 @@ xfs_dir2_leaf_addname(
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
>  	ents = leafhdr.ents;
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
> -	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
> +	length = xfs_dir2_data_entsize(dp->i_mount, args->name.len);
>  
>  	/*
>  	 * See if there are any entries with the same hash value
> @@ -856,8 +856,8 @@ xfs_dir2_leaf_addname(
>  	 */
>  	dep = (xfs_dir2_data_entry_t *)dup;
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, dep->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, dep->namelen);
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a0cc5e2..3c74efc 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -666,7 +666,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
>  		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>  	}
> -	length = xfs_dir2_data_entsize(mp, args->namelen);
> +	length = xfs_dir2_data_entsize(mp, args->name.len);
>  	/*
>  	 * Loop over leaf entries with the right hash value.
>  	 */
> @@ -1911,7 +1911,7 @@ xfs_dir2_node_addname_int(
>  	int			needscan = 0;	/* need to rescan data frees */
>  	__be16			*tagp;		/* data entry tag pointer */
>  
> -	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
> +	length = xfs_dir2_data_entsize(dp->i_mount, args->name.len);
>  	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
>  					   &findex, length);
>  	if (error)
> @@ -1966,8 +1966,8 @@ xfs_dir2_node_addname_int(
>  	/* Fill in the new entry and log it. */
>  	dep = (xfs_dir2_data_entry_t *)dup;
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, dep->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, dep->namelen);
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 7b7f6fb..058c526 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -387,7 +387,7 @@ xfs_dir2_sf_addname(
>  	/*
>  	 * Compute entry (and change in) size.
>  	 */
> -	incr_isize = xfs_dir2_sf_entsize(dp->i_mount, sfp, args->namelen);
> +	incr_isize = xfs_dir2_sf_entsize(dp->i_mount, sfp, args->name.len);
>  	objchange = 0;
>  
>  	/*
> @@ -470,7 +470,7 @@ xfs_dir2_sf_addname_easy(
>  	/*
>  	 * Grow the in-inode space.
>  	 */
> -	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
> +	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->name.len),
>  			  XFS_DATA_FORK);
>  	/*
>  	 * Need to set up again due to realloc of the inode data.
> @@ -480,9 +480,9 @@ xfs_dir2_sf_addname_easy(
>  	/*
>  	 * Fill in the new entry.
>  	 */
> -	sfep->namelen = args->namelen;
> +	sfep->namelen = args->name.len;
>  	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
>  	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
>  
> @@ -540,7 +540,7 @@ xfs_dir2_sf_addname_hard(
>  	 */
>  	for (offset = args->geo->data_first_offset,
>  	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
> -	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
> +	      add_datasize = xfs_dir2_data_entsize(mp, args->name.len),
>  	      eof = (char *)oldsfep == &buf[old_isize];
>  	     !eof;
>  	     offset = new_offset + xfs_dir2_data_entsize(mp, oldsfep->namelen),
> @@ -570,9 +570,9 @@ xfs_dir2_sf_addname_hard(
>  	/*
>  	 * Fill in the new entry, and update the header counts.
>  	 */
> -	sfep->namelen = args->namelen;
> +	sfep->namelen = args->name.len;
>  	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
>  	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
>  	sfp->count++;
> @@ -615,7 +615,7 @@ xfs_dir2_sf_addname_pick(
>  	int			used;		/* data bytes used */
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	size = xfs_dir2_data_entsize(mp, args->namelen);
> +	size = xfs_dir2_data_entsize(mp, args->name.len);
>  	offset = args->geo->data_first_offset;
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	holefit = 0;
> @@ -887,7 +887,7 @@ xfs_dir2_sf_lookup(
>  	/*
>  	 * Special case for .
>  	 */
> -	if (args->namelen == 1 && args->name[0] == '.') {
> +	if (args->name.len == 1 && args->name.name[0] == '.') {
>  		args->inumber = dp->i_ino;
>  		args->cmpresult = XFS_CMP_EXACT;
>  		args->filetype = XFS_DIR3_FT_DIR;
> @@ -896,8 +896,8 @@ xfs_dir2_sf_lookup(
>  	/*
>  	 * Special case for ..
>  	 */
> -	if (args->namelen == 2 &&
> -	    args->name[0] == '.' && args->name[1] == '.') {
> +	if (args->name.len == 2 &&
> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>  		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
>  		args->cmpresult = XFS_CMP_EXACT;
>  		args->filetype = XFS_DIR3_FT_DIR;
> @@ -984,7 +984,7 @@ xfs_dir2_sf_removename(
>  	 * Calculate sizes.
>  	 */
>  	byteoff = (int)((char *)sfep - (char *)sfp);
> -	entsize = xfs_dir2_sf_entsize(mp, sfp, args->namelen);
> +	entsize = xfs_dir2_sf_entsize(mp, sfp, args->name.len);
>  	newsize = oldsize - entsize;
>  	/*
>  	 * Copy the part if any after the removed entry, sliding it down.
> @@ -1085,12 +1085,12 @@ xfs_dir2_sf_replace(
>  	} else
>  		i8elevated = 0;
>  
> -	ASSERT(args->namelen != 1 || args->name[0] != '.');
> +	ASSERT(args->name.len != 1 || args->name.name[0] != '.');
>  	/*
>  	 * Replace ..'s entry.
>  	 */
> -	if (args->namelen == 2 &&
> -	    args->name[0] == '.' && args->name[1] == '.') {
> +	if (args->name.len == 2 &&
> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>  		ino = xfs_dir2_sf_get_parent_ino(sfp);
>  		ASSERT(args->inumber != ino);
>  		xfs_dir2_sf_put_parent_ino(sfp, args->inumber);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd4..d4a9fe4 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -147,17 +147,17 @@ xchk_xattr_listent(
>  		return;
>  	}
>  
> -	args.flags = ATTR_KERNOTIME;
> +	args.name.type = ATTR_KERNOTIME;
>  	if (flags & XFS_ATTR_ROOT)
> -		args.flags |= ATTR_ROOT;
> +		args.name.type |= ATTR_ROOT;
>  	else if (flags & XFS_ATTR_SECURE)
> -		args.flags |= ATTR_SECURE;
> +		args.name.type |= ATTR_SECURE;
>  	args.geo = context->dp->i_mount->m_attr_geo;
>  	args.whichfork = XFS_ATTR_FORK;
>  	args.dp = context->dp;
> -	args.name = name;
> -	args.namelen = namelen;
> -	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.name.name = name;
> +	args.name.len = namelen;
> +	args.hashval = xfs_da_hashname(args.name.name, args.name.len);
>  	args.trans = context->tp;
>  	args.value = xchk_xattr_valuebuf(sx->sc);
>  	args.valuelen = valuelen;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a86be7f..159b8af 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1633,7 +1633,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__dynamic_array(char, name, args->namelen)
> +		__dynamic_array(char, name, args->name.len)
>  		__field(int, namelen)
>  		__field(xfs_dahash_t, hashval)
>  		__field(xfs_ino_t, inumber)
> @@ -1642,9 +1642,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>  		__entry->ino = args->dp->i_ino;
> -		if (args->namelen)
> -			memcpy(__get_str(name), args->name, args->namelen);
> -		__entry->namelen = args->namelen;
> +		if (args->name.len)
> +			memcpy(__get_str(name), args->name.name,
> +			       args->name.len);
> +		__entry->namelen = args->name.len;
>  		__entry->hashval = args->hashval;
>  		__entry->inumber = args->inumber;
>  		__entry->op_flags = args->op_flags;
> @@ -1697,7 +1698,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__dynamic_array(char, name, args->namelen)
> +		__dynamic_array(char, name, args->name.len)
>  		__field(int, namelen)
>  		__field(int, valuelen)
>  		__field(xfs_dahash_t, hashval)
> @@ -1707,12 +1708,13 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>  		__entry->ino = args->dp->i_ino;
> -		if (args->namelen)
> -			memcpy(__get_str(name), args->name, args->namelen);
> -		__entry->namelen = args->namelen;
> +		if (args->name.len)
> +			memcpy(__get_str(name), args->name.name,
> +			       args->name.len);
> +		__entry->namelen = args->name.len;
>  		__entry->valuelen = args->valuelen;
>  		__entry->hashval = args->hashval;
> -		__entry->flags = args->flags;
> +		__entry->flags = args->name.type;
>  		__entry->op_flags = args->op_flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
> -- 
> 2.7.4
> 
