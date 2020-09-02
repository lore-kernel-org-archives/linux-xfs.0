Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7E4C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B377207EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oVFIOcCH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIBRf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:35:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgIBRf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:35:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HYtTK109300;
        Wed, 2 Sep 2020 17:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v/CfpU/gP1SuJukrEN8MgKW9yzdyFc+wqKILpOo3Kqw=;
 b=oVFIOcCHgZa+nqaTuHrg0GHylVX/FpFB5Dkckt3PRvUO7/NqKGtSdvTl3xS45luKpbGV
 0X6h9E8Mj0ygEz1goBLQGs+Sq0/0QdlEpRkIpf+BZMSqYyNUM4G3qYtI2ZWlvc5Up0rs
 jgejnJmW9aMtF0oWXR0IuiwfUG43jJhwqDSC5vlGEOmaZVGY2enL1mNlFw9kNfeE3xe6
 U+kM5FCMzbDp5kwnFn3SASAc8khoxVrS6QWV/88/UHN1EjfW2uLPkZRv6VUx82FWJlUa
 S2bKZGQMOx0T776G5+Yru0qDJl5K4x1SBer+Bgd9H0GIxGZnYmqR1ik4O/F0PGq4q6LB hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eer45wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:35:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HZ56F045761;
        Wed, 2 Sep 2020 17:35:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380sucy77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:35:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082HZqZP012331;
        Wed, 2 Sep 2020 17:35:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:35:52 -0700
Date:   Wed, 2 Sep 2020 10:35:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/4] xfs: remove typedef xfs_attr_sf_entry_t
Message-ID: <20200902173551.GR6096@magnolia>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-2-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 04:40:56PM +0200, Carlos Maiolino wrote:
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V2:
> 		- Reordered within the series, no functional changes
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
>  fs/xfs/libxfs/xfs_attr_sf.h   | 11 ++++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 305d4bc073370..76d3814f9dc79 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -736,7 +736,7 @@ xfs_attr_shortform_add(
>  	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
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
> index bb004fb7944a7..c4afb33079184 100644
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
> @@ -28,15 +27,17 @@ typedef struct xfs_attr_sf_sort {
>  } xfs_attr_sf_sort_t;
>  
>  #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(xfs_attr_sf_entry_t)-1 + (nlen)+(vlen)))
> +	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>  	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
>  #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> -	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
> +	((int)sizeof(struct xfs_attr_sf_entry)-1 + \
> +		(sfep)->namelen+(sfep)->valuelen)
>  #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
> -	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
> +	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
> +		XFS_ATTR_SF_ENTSIZE(sfep)))
>  #define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> -	(be16_to_cpu(((xfs_attr_shortform_t *)	\
> +	(be16_to_cpu(((struct xfs_attr_shortform *)	\
>  		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
>  
>  #endif	/* __XFS_ATTR_SF_H__ */
> -- 
> 2.26.2
> 
