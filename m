Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7FFCA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C74214D8
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XX0v5dge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfKDUjO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:39:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51188 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbfKDUjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:39:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KcupA139577;
        Mon, 4 Nov 2019 20:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=cPtqCxsAIzvNIXcFVJLD5quidL7e+QolOXePcfsTVN4=;
 b=XX0v5dgeHoCPGGZPuPsIPGJIoggxQhGiz8a54oRlvNXWhxMQIx1X+BdtqEHw6CB5eFGF
 mIV2iHocHPvj+vBvgR8WJMeMmcI4PGvJgH5KdaZ0zm7Vnvugv4U+NgkB0SvXvzm74go9
 coLX7BQlolbG5/ZqOuFX4VpnQO5zEPOnCM5Bfn+ZCYrJYw8aO/xVRzbk6yLQQDRZcxxr
 WzKzbgJI1HaELchSkMA5vhy4AzMx1lapvQlF3won3DmoZ0P4wCZv8+zJWx4PU6Ogx55L
 CecPraMgeVNMjvu70HBh4gEyBZbIB9FwcPBGTc+zsDR7lw1gk+l4ohFjWCJPQV6IINoZ EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tt0dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:39:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kd8nN091288;
        Mon, 4 Nov 2019 20:39:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w1k8vfj0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:39:08 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KcNrQ007312;
        Mon, 4 Nov 2019 20:38:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:38:23 -0800
Date:   Mon, 4 Nov 2019 12:38:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/34] xfs: remove the unused ->data_first_entry_p method
Message-ID: <20191104203821.GZ4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-25-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-25-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:09PM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LOL.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  2 files changed, 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 84f8355072b4..35edf470efc8 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -111,36 +111,6 @@ xfs_dir3_data_entry_tag_p(
>  		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
>  }
>  
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_first_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR2_DATA_ENTSIZE(1) +
> -				XFS_DIR2_DATA_ENTSIZE(2));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_ftype_data_first_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1) +
> -				XFS_DIR3_DATA_ENTSIZE(2));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_first_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1) +
> -				XFS_DIR3_DATA_ENTSIZE(2));
> -}
> -
>  static struct xfs_dir2_data_free *
>  xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  {
> @@ -196,7 +166,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  				XFS_DIR2_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_first_entry_p = xfs_dir2_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  };
> @@ -216,7 +185,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  };
> @@ -236,7 +204,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
>  
> -	.data_first_entry_p = xfs_dir3_data_first_entry_p,
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  };
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 0198887a1c54..20417c42ca6f 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -45,8 +45,6 @@ struct xfs_dir_ops {
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
>  
> -	struct xfs_dir2_data_entry *
> -		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_entry *
>  		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_unused *
> -- 
> 2.20.1
> 
