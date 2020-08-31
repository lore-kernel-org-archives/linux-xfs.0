Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99264C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D0FC207EA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JnmumhSV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgHaPeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:34:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgHaPeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 11:34:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFEw4m042022;
        Mon, 31 Aug 2020 15:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nyFitVViG9bE8NiRhiriMBDB+wAMV6pjXZfQNFz8gE8=;
 b=JnmumhSVhuYxpkxxFUdwVuhUaeaGhFCi2AkKYkY0Qdb/jsR11aoFGAd+lnDnf0UPRi16
 xgtrFhY34L8bK+qFVjQGkAc3zf6GkpmTAHYeSeGW0pKLGsSM+3iRKkPBAIcNJOLJMDx5
 +OQecT9sJ6A07HP/S8VapkFG3R65MnqGVoMtkYPSHDflMBNG4hlkRQKtlFPS7eoW2olm
 3FvfF7KokhM+VgbMokRvx0KrBgdnWysDQ0QJVdrr4nckY5U6BQA9vjvsHyCuI0nRfNO0
 WOOJGbucHsD8HKA9H88ToPhG1TscujW5Xu5Gcjso9neNVVoAEIf7UiR4K30XuDYlMcA2 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqpyg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 15:34:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFFc2T117935;
        Mon, 31 Aug 2020 15:34:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3380xuwsd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 15:34:03 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VFY2au010614;
        Mon, 31 Aug 2020 15:34:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 08:34:02 -0700
Date:   Mon, 31 Aug 2020 08:34:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Convert xfs_attr_sf macros to inline functions
Message-ID: <20200831153405.GB6096@magnolia>
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130423.136509-3-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:04:21PM +0200, Carlos Maiolino wrote:
> xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> instead of playing with more #includes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

/me would have preferred you kill the typedef at the start of the series
instead of creating new functions with them and then changing them in
the next patch, but aside from that...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 15 ++++++++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 23 ++++++++++++++---------
>  fs/xfs/xfs_attr_list.c        |  4 ++--
>  4 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e055c079f397..2b48fdb394e80 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -428,7 +428,7 @@ xfs_attr_set(
>  		 */
>  		if (XFS_IFORK_Q(dp) == 0) {
>  			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> -				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
> +				xfs_attr_sf_entsize_byname(args->namelen,
>  						args->valuelen);
>  
>  			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> @@ -523,6 +523,15 @@ xfs_attr_set(
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
>  
> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> +
> +	xfs_attr_shortform_t *sf =
> +		(xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> +
> +	return (be16_to_cpu(sf->hdr.totsize));
> +
> +}
> +
>  /*
>   * Add a name to the shortform attribute list structure
>   * This is the external routine.
> @@ -555,8 +564,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
>  		return -ENOSPC;
>  
> -	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
> -	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +	newsize = xfs_attr_sf_totsize(args->dp);
> +	newsize += xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
>  
>  	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
>  	if (!forkoff)
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 7bbc97e0e4d4a..a8a4e21d19726 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -684,9 +684,9 @@ xfs_attr_sf_findname(
>  	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	end = sf->hdr.count;
> -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> +	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
>  			     base += size, i++) {
> -		size = XFS_ATTR_SF_ENTSIZE(sfe);
> +		size = xfs_attr_sf_entsize(sfe);
>  		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
>  				    sfe->flags))
>  			continue;
> @@ -733,7 +733,7 @@ xfs_attr_shortform_add(
>  		ASSERT(0);
>  
>  	offset = (char *)sfe - (char *)sf;
> -	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
>  	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
> @@ -792,7 +792,7 @@ xfs_attr_shortform_remove(
>  	error = xfs_attr_sf_findname(args, &sfe, &base);
>  	if (error != -EEXIST)
>  		return error;
> -	size = XFS_ATTR_SF_ENTSIZE(sfe);
> +	size = xfs_attr_sf_entsize(sfe);
>  
>  	/*
>  	 * Fix up the attribute fork data, covering the hole
> @@ -849,7 +849,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> -				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> +				sfe = xfs_attr_sf_nextentry(sfe), i++) {
>  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
>  				sfe->flags))
>  			return -EEXIST;
> @@ -876,7 +876,7 @@ xfs_attr_shortform_getvalue(
>  	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> -				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> +				sfe = xfs_attr_sf_nextentry(sfe), i++) {
>  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
>  				sfe->flags))
>  			return xfs_attr_copy_value(args,
> @@ -951,7 +951,7 @@ xfs_attr_shortform_to_leaf(
>  		ASSERT(error != -ENOSPC);
>  		if (error)
>  			goto out;
> -		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> +		sfe = xfs_attr_sf_nextentry(sfe);
>  	}
>  	error = 0;
>  	*leaf_bp = bp;
> @@ -1049,7 +1049,7 @@ xfs_attr_shortform_verify(
>  		 * within the data buffer.  The next entry starts after the
>  		 * name component, so nextentry is an acceptable test.
>  		 */
> -		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> +		next_sfep = xfs_attr_sf_nextentry(sfep);
>  		if ((char *)next_sfep > endp)
>  			return __this_address;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index d93012a0be4d0..48906c5196505 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -27,16 +27,21 @@ typedef struct xfs_attr_sf_sort {
>  	unsigned char	*name;		/* name value, pointer into buffer */
>  } xfs_attr_sf_sort_t;
>  
> -#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(xfs_attr_sf_entry_t) + (nlen)+(vlen)))
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>  	(1 << (NBBY*(int)sizeof(uint8_t)))
> -#define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> -	((int)sizeof(xfs_attr_sf_entry_t) + (sfep)->namelen+(sfep)->valuelen)
> -#define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
> -	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
> -#define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> -	(be16_to_cpu(((xfs_attr_shortform_t *)	\
> -		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
>  
> +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> +	return sizeof(xfs_attr_sf_entry_t) + nlen + vlen;
> +}
> +
> +/* space an entry uses */
> +static inline int xfs_attr_sf_entsize(xfs_attr_sf_entry_t *sfep) {
> +	return sizeof(xfs_attr_sf_entry_t) + sfep->namelen + sfep->valuelen;
> +}
> +
> +static inline xfs_attr_sf_entry_t *
> +xfs_attr_sf_nextentry(xfs_attr_sf_entry_t *sfep) {
> +	return (xfs_attr_sf_entry_t *)((char *)(sfep) +
> +				       xfs_attr_sf_entsize(sfep));
> +}
>  #endif	/* __XFS_ATTR_SF_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 50f922cad91a4..fbe5574f08930 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -96,7 +96,7 @@ xfs_attr_shortform_list(
>  			 */
>  			if (context->seen_enough)
>  				break;
> -			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> +			sfe = xfs_attr_sf_nextentry(sfe);
>  		}
>  		trace_xfs_attr_list_sf_all(context);
>  		return 0;
> @@ -136,7 +136,7 @@ xfs_attr_shortform_list(
>  		/* These are bytes, and both on-disk, don't endian-flip */
>  		sbp->valuelen = sfe->valuelen;
>  		sbp->flags = sfe->flags;
> -		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> +		sfe = xfs_attr_sf_nextentry(sfe);
>  		sbp++;
>  		nsbuf++;
>  	}
> -- 
> 2.26.2
> 
