Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47DEC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89578207EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4nCzTA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIBRgT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:36:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgIBRgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:36:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HY9tR002876;
        Wed, 2 Sep 2020 17:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BsqXWGp3ZERiI9MM+vDmp1QZX44ixUzdnGnjzko5l78=;
 b=T4nCzTA3JHzNXZ3YorpLlrheN3NfxlWQYX7Hbu8/9Dr7agOnCoPwyyrcEDNLVIeKmQIz
 BISzGbOrgT+OTVl6SUEuzhygNZzTPeAzAEKT/fZpUJgjtOVU2pOZY/GuOjvahxZ77YKb
 eKM2Hsw8K7ybJI15G9QngA5UavIUy71Mo0b+Z5FTxySPlHDPat4j/EJm1eWFQ0YF87hM
 0iRdxqHx8+KQ+dmV88sKMJfQdthMoEsaDm9zhPVLUHN+4x/MHzH3aMg3eC1qejBCwX2C
 5Yt+DZZaJFjPhFWw+U3LoJ9C1MI/CJpKsh5IwxxHo8ieLedwPbRR/uvtJGRKD7BwdvvT eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eymc3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:36:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HYdW7136299;
        Wed, 2 Sep 2020 17:36:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x7a3d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:36:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082HaDJP001928;
        Wed, 2 Sep 2020 17:36:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:36:10 -0700
Date:   Wed, 2 Sep 2020 10:36:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/4] xfs: Remove typedef xfs_attr_shortform_t
Message-ID: <20200902173610.GS6096@magnolia>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-3-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=5 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 04:40:57PM +0200, Carlos Maiolino wrote:
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V2:
> 	 - Reordered within the series, no functional changes.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_da_format.h |  4 ++--
>  fs/xfs/xfs_attr_list.c        |  2 +-
>  fs/xfs/xfs_ondisk.h           | 12 ++++++------
>  4 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76d3814f9dc79..d920183b08a99 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -728,14 +728,14 @@ xfs_attr_shortform_add(
>  
>  	ifp = dp->i_afp;
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
> -	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
>  		ASSERT(0);
>  
>  	offset = (char *)sfe - (char *)sf;
>  	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>  	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
> -	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
>  
>  	sfe->namelen = args->namelen;
> @@ -787,7 +787,7 @@ xfs_attr_shortform_remove(
>  
>  	dp = args->dp;
>  	mp = dp->i_mount;
> -	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
>  
>  	error = xfs_attr_sf_findname(args, &sfe, &base);
>  	if (error != -EEXIST)
> @@ -837,7 +837,7 @@ xfs_attr_shortform_remove(
>  int
>  xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  {
> -	xfs_attr_shortform_t *sf;
> +	struct xfs_attr_shortform *sf;
>  	struct xfs_attr_sf_entry *sfe;
>  	int i;
>  	struct xfs_ifork *ifp;
> @@ -846,7 +846,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  
>  	ifp = args->dp->i_afp;
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
> -	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> @@ -873,7 +873,7 @@ xfs_attr_shortform_getvalue(
>  	int			i;
>  
>  	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
> -	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> @@ -908,12 +908,12 @@ xfs_attr_shortform_to_leaf(
>  
>  	dp = args->dp;
>  	ifp = dp->i_afp;
> -	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	size = be16_to_cpu(sf->hdr.totsize);
>  	tmpbuffer = kmem_alloc(size, 0);
>  	ASSERT(tmpbuffer != NULL);
>  	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
> -	sf = (xfs_attr_shortform_t *)tmpbuffer;
> +	sf = (struct xfs_attr_shortform *)tmpbuffer;
>  
>  	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
>  	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 059ac108b1b39..e708b714bf99d 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -579,7 +579,7 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>  /*
>   * Entries are packed toward the top as tight as possible.
>   */
> -typedef struct xfs_attr_shortform {
> +struct xfs_attr_shortform {
>  	struct xfs_attr_sf_hdr {	/* constant-structure header block */
>  		__be16	totsize;	/* total bytes in shortform list */
>  		__u8	count;	/* count of active entries */
> @@ -591,7 +591,7 @@ typedef struct xfs_attr_shortform {
>  		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
>  		uint8_t nameval[1];	/* name & value bytes concatenated */
>  	} list[1];			/* variable sized array */
> -} xfs_attr_shortform_t;
> +};
>  
>  typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
>  	__be16	base;			  /* base of free region */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 50f922cad91a4..4eb1d6faecfb2 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -61,7 +61,7 @@ xfs_attr_shortform_list(
>  	int				error = 0;
>  
>  	ASSERT(dp->i_afp != NULL);
> -	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> +	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
>  	ASSERT(sf != NULL);
>  	if (!sf->hdr.count)
>  		return 0;
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 5f04d8a5ab2a9..ad51c8eb447b1 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -84,12 +84,12 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
>  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
>  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.totsize,	0);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.count,	2);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].namelen,	4);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].valuelen, 5);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].flags,	6);
> -	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].nameval,	7);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
> -- 
> 2.26.2
> 
