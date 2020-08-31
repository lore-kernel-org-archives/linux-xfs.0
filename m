Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9E6C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E033F214D8
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jRouanfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgHaPel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:34:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgHaPei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 11:34:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFFiPo152066;
        Mon, 31 Aug 2020 15:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LHMLPK3qN2ZgmuMTHqc2hRBFhrE9lQOwbPVKLpv2Lgo=;
 b=jRouanfJ53Dt40Q22Ip/6oxfWKCkHTANidV5ekDG89IDzOWB38WE3b+9s+B3x+M+wh+A
 Hf1cVM5CG/sAhRzrmthCDoXp9duwjwHSmBCfL0ZL2swdYB5VXNi1Cg4jLtZwFYReuHFc
 ZGsRSydBbOfjdzx1Kt1ehv1bhr+nP/56q7/ogx3SJ4SSkcpcQSKjt7WA6/SMCgWprqjx
 SbDVHku2ne8FyePWVXDCLlTKLLWd8lYr+NumOlJ/SVYkifzuF6u0WBYLOldfRJL8/mxq
 GdzouSh082Y120+9aUhjS1IhyRcBUcc2SY3JCjQwfqCa7j15/WUO0lt5nxDIxHp6OF89 Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 337qrhe0bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 15:34:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFEXh2189686;
        Mon, 31 Aug 2020 15:34:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x0j254-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 15:34:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VFYXIu010882;
        Mon, 31 Aug 2020 15:34:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 08:34:32 -0700
Date:   Mon, 31 Aug 2020 08:34:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove typedef xfs_attr_sf_entry_t
Message-ID: <20200831153436.GC6096@magnolia>
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130423.136509-4-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:04:22PM +0200, Carlos Maiolino wrote:
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
>  fs/xfs/libxfs/xfs_attr_sf.h   | 14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index a8a4e21d19726..bcc76ff298646 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -736,7 +736,7 @@ xfs_attr_shortform_add(
>  	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
>  	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> -	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
> +	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
>  
>  	sfe->namelen = args->namelen;
>  	sfe->valuelen = args->valuelen;
> @@ -838,7 +838,7 @@ int
>  xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  {
>  	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> +	struct xfs_attr_sf_entry *sfe;
>  	int i;
>  	struct xfs_ifork *ifp;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index 48906c5196505..6b09a010940ea 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -13,7 +13,6 @@
>   * to fit into the literal area of the inode.
>   */
>  typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
> -typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
>  
>  /*
>   * We generate this then sort it, attr_list() must return things in hash-order.
> @@ -31,17 +30,18 @@ typedef struct xfs_attr_sf_sort {
>  	(1 << (NBBY*(int)sizeof(uint8_t)))
>  
>  static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> -	return sizeof(xfs_attr_sf_entry_t) + nlen + vlen;
> +	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
>  }
>  
>  /* space an entry uses */
> -static inline int xfs_attr_sf_entsize(xfs_attr_sf_entry_t *sfep) {
> -	return sizeof(xfs_attr_sf_entry_t) + sfep->namelen + sfep->valuelen;
> +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
> +	return sizeof(struct xfs_attr_sf_entry) +
> +		sfep->namelen + sfep->valuelen;
>  }
>  
> -static inline xfs_attr_sf_entry_t *
> -xfs_attr_sf_nextentry(xfs_attr_sf_entry_t *sfep) {
> -	return (xfs_attr_sf_entry_t *)((char *)(sfep) +
> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> +	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
>  				       xfs_attr_sf_entsize(sfep));
>  }
>  #endif	/* __XFS_ATTR_SF_H__ */
> -- 
> 2.26.2
> 
