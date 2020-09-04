Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88112C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB2620829
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cuiCH1dI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIDPml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:42:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgIDPme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:42:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084Fe0xk024596;
        Fri, 4 Sep 2020 15:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AIjF/6CtBFhMcj/sW3sXjGFuKe+poM5Kfsx6BiXaYKQ=;
 b=cuiCH1dI3Z7hAyFNPdpye+ub+//OT5RfzxfBqWbusyBfovcUKEEW1C1OrXyPujggJJyh
 pWfJ6eW5SbtTuLddYQnw2x/28MpRhemFNomBv+IDo2DI0JMxTZbzqrU3QtSjri8J5Wt0
 60NKvxZx1c9lnnGzS2SWMwkWtg53UQkhWGCRbA3UnItZ7D7Zhsfjpam/Vt2Sq49Fz7q6
 ORZzMIItNbtr/yVzlu79fK4wzUJU3IrveQ7t2cQlXQMh/C5vuC7znITlrJBfgfQCi+nU
 uTWozCneYCd/n/GokY+QdOsQylmUplLbk5Gt1Fz6ZMP1oAHAb/YliAhyBcnX/SSF1Aym lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmndk6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Sep 2020 15:42:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084FZLHa086701;
        Fri, 4 Sep 2020 15:42:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380ktng6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Sep 2020 15:42:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 084FgTkj001603;
        Fri, 4 Sep 2020 15:42:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 08:42:29 -0700
Date:   Fri, 4 Sep 2020 08:42:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200904154228.GG6096@magnolia>
References: <20200903142839.72710-4-cmaiolino@redhat.com>
 <20200903161724.85328-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903161724.85328-1-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 06:17:24PM +0200, Carlos Maiolino wrote:
> nameval is a variable-size array, so, define it as it, and remove all
> the -1 magic number subtractions
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 
> 	V2:
> 	 - Drop wrong change to XFS_ATTR_SF_ENTSIZE_MAX
> 	V3:
> 	- Use XFS_ATTR_SF_ENTSIZE_BYNAME in xfs_attr_shortform_allfit()
> 	- Remove int casting and fix spacing on
> 	  XFS_ATTR_SF_ENTSIZE_BYNAME
> 	V4:
> 	- Fix indentation on xfs_attr_shortform_allfit()
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 9 +++------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 4 ++--
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  3 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d920183b08a99..b0c8626e166ac 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -992,9 +992,8 @@ xfs_attr_shortform_allfit(
>  			return 0;
>  		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
>  			return 0;
> -		bytes += sizeof(struct xfs_attr_sf_entry) - 1
> -				+ name_loc->namelen
> -				+ be16_to_cpu(name_loc->valuelen);
> +		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(name_loc->namelen,
> +					be16_to_cpu(name_loc->valuelen));
>  	}
>  	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
>  	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> @@ -1036,10 +1035,8 @@ xfs_attr_shortform_verify(
>  		 * struct xfs_attr_sf_entry has a variable length.
>  		 * Check the fixed-offset parts of the structure are
>  		 * within the data buffer.
> -		 * xfs_attr_sf_entry is defined with a 1-byte variable
> -		 * array at the end, so we must subtract that off.
>  		 */
> -		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
> +		if (((char *)sfep + sizeof(*sfep)) >= endp)
>  			return __this_address;
>  
>  		/* Don't allow names with known bad length. */
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index c4afb33079184..29934103ce559 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -27,11 +27,11 @@ typedef struct xfs_attr_sf_sort {
>  } xfs_attr_sf_sort_t;
>  
>  #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(struct xfs_attr_sf_entry)-1 + (nlen)+(vlen)))
> +	((sizeof(struct xfs_attr_sf_entry) + (nlen) + (vlen)))
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>  	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
>  #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> -	((int)sizeof(struct xfs_attr_sf_entry)-1 + \
> +	((int)sizeof(struct xfs_attr_sf_entry) + \
>  		(sfep)->namelen+(sfep)->valuelen)
>  #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
>  	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index e708b714bf99d..b40a4e80f5ee6 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -589,7 +589,7 @@ struct xfs_attr_shortform {
>  		uint8_t namelen;	/* actual length of name (no NULL) */
>  		uint8_t valuelen;	/* actual length of value (no NULL) */
>  		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		uint8_t nameval[1];	/* name & value bytes concatenated */
> +		uint8_t nameval[];	/* name & value bytes concatenated */
>  	} list[1];			/* variable sized array */
>  };
>  
> -- 
> 2.26.2
> 
