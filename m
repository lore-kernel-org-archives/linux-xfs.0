Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CACC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 847A3222C5
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSTXXrUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfKHAjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:39:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfKHAjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:39:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80d1fX146680;
        Fri, 8 Nov 2019 00:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6dQim0PwOvwBVm3Oudb/Gis6DJktm9yrFI2WZ+4hsdw=;
 b=QSTXXrUE/cyi6vmitzrEmGg51xgSarG27sQhHn+rA3bukuTJGDB2dZl02mVRISotGmeE
 5TEqbZAtItuq/uFdL4+angGfqgTTypmRqS92IRACdJ9sN5PGQVdzJ/GOY8ElZ5xYeaEW
 dXEd5BDy0NCyCzCxST7mfW/BHppMT/X8hsdTqsIYEXQ5EXWTJ9EV7oBu471gp1OwQ2kp
 vT2z1GuiBTo6C757o7Tp/gfWExRdB6gvg5csZhUpPxbLdC59ufixmFcfhshhYae4yY0H
 K+fRaRNFlisIeNiMWMV6cio7Kf8OUGbV63Q1PrGihLtBUkI57evQVfaTUPy8cuFVkvMi Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w11wgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:39:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dCXf001186;
        Fri, 8 Nov 2019 00:39:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41wb6gte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:39:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80caF6009446;
        Fri, 8 Nov 2019 00:38:36 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:38:35 -0800
Date:   Thu, 7 Nov 2019 16:38:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/46] xfs: remove the data_dot_offset field in struct
 xfs_dir_ops
Message-ID: <20191108003835.GW6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-26-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:49PM +0100, Christoph Hellwig wrote:
> The data_dot_offset value is always equal to data_entry_offset given
> that "." is always the first entry in the directory.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 3 ---
>  fs/xfs/libxfs/xfs_dir2.h      | 1 -
>  fs/xfs/xfs_dir2_readdir.c     | 9 ++++-----
>  3 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 19343c65be91..54754eef2437 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -204,7 +204,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
> -	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
>  	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
>  				XFS_DIR2_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
> @@ -225,7 +224,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
> -	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
>  	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
>  				XFS_DIR3_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
> @@ -246,7 +244,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir3_data_bestfree_p,
>  
> -	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
>  	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
>  				XFS_DIR3_DATA_ENTSIZE(1),
>  	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 9169da84065a..94e8c40a7d19 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -40,7 +40,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_free *
>  		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	xfs_dir2_data_aoff_t data_dot_offset;
>  	xfs_dir2_data_aoff_t data_dotdot_offset;
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index e18045465455..39985ca6ae2d 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -70,13 +70,12 @@ xfs_dir2_sf_getdents(
>  		return 0;
>  
>  	/*
> -	 * Precalculate offsets for . and .. as we will always need them.
> -	 *
> -	 * XXX(hch): the second argument is sometimes 0 and sometimes
> -	 * geo->datablk
> +	 * Precalculate offsets for "." and ".." as we will always need them.
> +	 * This relies on the fact that directories always start with the
> +	 * entries for "." and "..".
>  	 */
>  	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> -						dp->d_ops->data_dot_offset);
> +			dp->d_ops->data_entry_offset);
>  	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  						dp->d_ops->data_dotdot_offset);
>  
> -- 
> 2.20.1
> 
