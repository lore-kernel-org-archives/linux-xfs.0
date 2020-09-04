Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29321C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34A420770
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NJmBej2K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgIDPn7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:43:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIDPn7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:43:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084Fd2Wb124746;
        Fri, 4 Sep 2020 15:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f+r1ZazOACO6MbQXKtqdMkwU6iqTpFJCtqNGUwuzrXA=;
 b=NJmBej2KqfI6MQOX0Gp4bod9v5b0qT1v2Qpl3e9y/9pb1xDnsyCuAz9SzoY6alNeSR+b
 tG+51O6MdF/Y3RmmvpTlZLE+gtEfyEXafugap5ublHXABu7k4UdPh8IuBDcjBi/lunr/
 lBE2rAWY3F+fdhzNKUdjTJ07pNmhCQH67mFSwE+GiimpRQL5fknfLzu2k3euJlz6R8LW
 N0VeXry0ZbjlfOIJ1WtAAgyNFNsmv1RS2Y2CQCDdoPqeVSa/YWo4nlONDL1SU/PJV9D6
 WzulijC5OZnjafwgPjZlJuc9+mdKs4B0zaHTt/MoGHlJxbG3nCQeGkHs902f+9VKS5ST NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eerf875-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Sep 2020 15:43:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084FYmbO086881;
        Fri, 4 Sep 2020 15:41:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380xdgfkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Sep 2020 15:41:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 084FfrEW013669;
        Fri, 4 Sep 2020 15:41:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 08:41:53 -0700
Date:   Fri, 4 Sep 2020 08:41:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200904154152.GE6096@magnolia>
References: <20200903161724.85328-1-cmaiolino@redhat.com>
 <20200903161859.85511-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903161859.85511-1-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 06:18:59PM +0200, Carlos Maiolino wrote:
> xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> instead of playing with more #includes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V2:
> 	 - keep macro comments above inline functions
> 	V3:
> 	- Add extra spacing in xfs_attr_sf_totsize()
> 	- Fix open curling braces on inline functions
> 	- use void * casting on xfs_attr_sf_nextentry()
> 	V4:
> 	- Fix open curling braces
> 	- remove unneeded parenthesis
> 
>  fs/xfs/libxfs/xfs_attr.c      | 15 ++++++++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 30 +++++++++++++++++++-----------
>  fs/xfs/xfs_attr_list.c        |  4 ++--
>  4 files changed, 42 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e055c079f397..16ef80943b8ef 100644
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
> +/* total space in use */
> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
> +{
> +	struct xfs_attr_shortform *sf =
> +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +
> +	return be16_to_cpu(sf->hdr.totsize);
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
> index b0c8626e166ac..00955484175b1 100644
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
>  	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
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
>  	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> -				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> +				sfe = xfs_attr_sf_nextentry(sfe), i++) {
>  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
>  				sfe->flags))
>  			return -EEXIST;
> @@ -876,7 +876,7 @@ xfs_attr_shortform_getvalue(
>  	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
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
> @@ -992,7 +992,7 @@ xfs_attr_shortform_allfit(
>  			return 0;
>  		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
>  			return 0;
> -		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(name_loc->namelen,
> +		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
>  					be16_to_cpu(name_loc->valuelen));
>  	}
>  	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
> @@ -1048,7 +1048,7 @@ xfs_attr_shortform_verify(
>  		 * within the data buffer.  The next entry starts after the
>  		 * name component, so nextentry is an acceptable test.
>  		 */
> -		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> +		next_sfep = xfs_attr_sf_nextentry(sfep);
>  		if ((char *)next_sfep > endp)
>  			return __this_address;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index 29934103ce559..37578b369d9b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -26,18 +26,26 @@ typedef struct xfs_attr_sf_sort {
>  	unsigned char	*name;		/* name value, pointer into buffer */
>  } xfs_attr_sf_sort_t;
>  
> -#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	((sizeof(struct xfs_attr_sf_entry) + (nlen) + (vlen)))
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>  	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
> -#define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> -	((int)sizeof(struct xfs_attr_sf_entry) + \
> -		(sfep)->namelen+(sfep)->valuelen)
> -#define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
> -	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
> -		XFS_ATTR_SF_ENTSIZE(sfep)))
> -#define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> -	(be16_to_cpu(((struct xfs_attr_shortform *)	\
> -		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
> +
> +/* space name/value uses */
> +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen)
> +{
> +	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
> +}
> +
> +/* space an entry uses */
> +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep)
> +{
> +	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
> +}
> +
> +/* next entry in struct */
> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
> +{
> +	return (void *)sfep + xfs_attr_sf_entsize(sfep);
> +}
>  
>  #endif	/* __XFS_ATTR_SF_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 4eb1d6faecfb2..8f8837fe21cf0 100644
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
