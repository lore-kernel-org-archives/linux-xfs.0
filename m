Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C6FC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC7D20758
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HYdmZf39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgIBRzG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:55:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBRzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:55:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HeudO008429;
        Wed, 2 Sep 2020 17:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f9lU1+jUFR1Kh17sOtDwGqXqwWUXmJPpnTzweTL9hvc=;
 b=HYdmZf39CrP5urgk8Dme+107YHrHLovjw+wnEPTQeu4onSRep9wL3prMwoedq/ggPemb
 DH6IKmwNHNF/L3Yle1R5B/oR2N0MhmCBGxfMcM32jrYlte/gHQ2K+2E9uSMY+u6bTYTY
 7AmeBPzjd0mCV1A/RzQjhK+GGzo9h1R9lSlNeyP9z4pLOK5yc9c/0x5lhUIwpiAI5R6k
 D2nCJb4Kilv19JEzzgwU6hmbDKWr7QsOc0IbqPzK+5/ikk04GZLPwQkV9iaDte27vjBa
 wKbpp5clP6/mwCaaQDgCibDMiivlEC0HlmJAStUilRwI96LrW/0LALwDcEMJ9AfZrCdz +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eymc6mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:54:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HfEM8038012;
        Wed, 2 Sep 2020 17:54:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380kqda3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:54:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082Hsxwu015069;
        Wed, 2 Sep 2020 17:54:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:54:58 -0700
Date:   Wed, 2 Sep 2020 10:54:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200902175457.GX6096@magnolia>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-5-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 04:40:59PM +0200, Carlos Maiolino wrote:
> xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> instead of playing with more #includes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> 	V2:
> 	 - keep macro comments above inline functions
> 	 - Use struct_size() on xfs_attr_sf_entsize()
> 
>  fs/xfs/libxfs/xfs_attr.c      | 13 ++++++++++---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 28 +++++++++++++++++-----------
>  fs/xfs/xfs_attr_list.c        |  4 ++--
>  4 files changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e055c079f397..ff1fa2ed40ab9 100644
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
> @@ -523,6 +523,13 @@ xfs_attr_set(
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
>  
> +/* total space in use */
> +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> +	struct xfs_attr_shortform *sf =
> +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +	return be16_to_cpu(sf->hdr.totsize);

Please add a newline between the variable declaration and the return
statement.

> +}
> +
>  /*
>   * Add a name to the shortform attribute list structure
>   * This is the external routine.
> @@ -555,8 +562,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
> index 89193871e6a7f..f64ab351b760c 100644
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
> index f608a2966d7f8..0d761306da965 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -26,18 +26,24 @@ typedef struct xfs_attr_sf_sort {
>  	unsigned char	*name;		/* name value, pointer into buffer */
>  } xfs_attr_sf_sort_t;
>  
> -#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(struct xfs_attr_sf_entry) + (nlen)+(vlen)))
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
> +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> +	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;

/me suspects you could (ab)use struct_size here too, e.g.

	return struct_size((struct xfs_attr_sf_entry *)NULL, nameval,
			nlen + vlen);

Though now I look at the casting mess and think NAH.
Ok never mind. :)

The patch looks ok, modulo that spacing thing from above.

--D

> +}
> +
> +/* space an entry uses */
> +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
> +	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
> +}
> +
> +/* next entry in struct */
> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> +	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
> +					    xfs_attr_sf_entsize(sfep));
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
