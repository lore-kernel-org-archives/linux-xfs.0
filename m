Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218A3C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA367206A3
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FCel9MD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbfKHTeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:34:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfKHTeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:34:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JYPMs086764
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pRjNZk47y6gv5bmk6930WtBRxfuzD9I+oScs149F/go=;
 b=FCel9MD/fbLLcgYUm6pOQBieAXuRyFL0+09smqrdMS862jZ60pKKOZHY5EFKzPZWuDBt
 LWP5xAai4QiT/C+WsLf2G3AF+FVJmipPEC3Oo1uLX8ytj0hz6GuOYQ+vRnk48GYCGccc
 suzTFa2Q2vBTiRdJiYwn8Gv4dYMvLIQ/m3gLnkMXZzaJuRzi1HhH0nE2ak9m20euHUQF
 j4ROIzx8k7YXjgCNSiPdN3uYiOqjz743FOGW297rN3rSmkl1V2wUQ1dsxD8NlctNLz45
 VJ8H7vYw8WoCzBKnEh1iRIG91O1QSAJp7zu7Nj9Iu4o0t8f1QZ0flT+L7KnEPH/ixyRH +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w179ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:34:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JYhW6156021
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:34:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w5bmq79fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:34:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8JYkF5022772
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:34:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:34:46 -0800
Date:   Fri, 8 Nov 2019 11:34:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 06/17] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20191108193445.GX6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-7-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080190
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:50PM -0700, Allison Collins wrote:
> Break xfs_attr_rmtval_set into two helper functions
> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> xfs_attr_rmtval_set rolls the transaction between the
> helpers, but delayed operations cannot.  We will use
> the helpers later when constructing new delayed
> attribute routines.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 71 +++++++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_remote.h |  3 +-
>  2 files changed, 56 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index db9247a..db51388 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -21,6 +21,7 @@
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_attr_remote.h"
>  
>  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>  
> @@ -432,34 +433,20 @@ xfs_attr_rmtval_set(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_bmbt_irec	map;
>  	xfs_dablk_t		lblkno;
> -	xfs_fileoff_t		lfileoff = 0;
> -	uint8_t			*src = args->value;
>  	int			blkcnt;
> -	int			valuelen;
>  	int			nmap;
>  	int			error;
> -	int			offset = 0;
>  
>  	trace_xfs_attr_rmtval_set(args);
>  
> -	/*
> -	 * Find a "hole" in the attribute address space large enough for
> -	 * us to drop the new attribute's value into. Because CRC enable
> -	 * attributes have headers, we can't just do a straight byte to FSB
> -	 * conversion and have to take the header space into account.
> -	 */
> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> -	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
> -						   XFS_ATTR_FORK);
> +	error = xfs_attr_rmt_find_hole(args);
>  	if (error)
>  		return error;
>  
> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
> -	args->rmtblkcnt = blkcnt;
> -
> +	blkcnt = args->rmtblkcnt;
> +	lblkno = (xfs_dablk_t)args->rmtblkno;
>  	/*
>  	 * Roll through the "value", allocating blocks on disk as required.
>  	 */
> @@ -500,6 +487,56 @@ xfs_attr_rmtval_set(
>  			return error;
>  	}
>  
> +	return xfs_attr_rmtval_set_value(args);
> +}
> +
> +
> +/*
> + * Find a "hole" in the attribute address space large enough for us to drop the
> + * new attribute's value into
> + */
> +int
> +xfs_attr_rmt_find_hole(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode        *dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int			error;
> +	int			blkcnt;
> +	xfs_fileoff_t		lfileoff = 0;
> +
> +	/*
> +	 * Because CRC enable attributes have headers, we can't just do a
> +	 * straight byte to FSB conversion and have to take the header space
> +	 * into account.
> +	 */
> +	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> +	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
> +						   XFS_ATTR_FORK);
> +	if (error)
> +		return error;
> +
> +	args->rmtblkno = (xfs_dablk_t)lfileoff;
> +	args->rmtblkcnt = blkcnt;
> +
> +	return 0;
> +}
> +
> +int
> +xfs_attr_rmtval_set_value(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	uint8_t			*src = args->value;
> +	int			blkcnt;
> +	int			valuelen;
> +	int			nmap;
> +	int			error;
> +	int			offset = 0;
> +
>  	/*
>  	 * Roll through the "value", copying the attribute value to the
>  	 * already-allocated blocks.  Blocks are written synchronously
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 9d20b66..cd7670d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> -
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
