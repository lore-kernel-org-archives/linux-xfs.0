Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2262CC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D355321D7F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YURl78Ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKHAva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:51:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKHAva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:51:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dApf146712;
        Fri, 8 Nov 2019 00:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S4/ZdkC8r52KZ25OxyJy9VvMef4C5jh7ofLVQ7LCPuA=;
 b=YURl78KabiFFyGge3cCPwGbdRPyjvKKBFUMOKO0owAwPnkFfhC2MplVGZFBv6mzboufI
 VaEAmGCHRSGy5xHotcjhSTtU7YfiFBwIUnfCjq0JfHPS5af0MyrSgI3ski+JHahI4JNZ
 fxeCRFA1mQBZb/f13TIXemm6N7PrUATiMLd1fcotoFhAVMKBZge/Sc/k6oq9wGWWyauF
 qCTSwD/hVNRMHnbjYSLYCShYbMeFonjImNxm1L6ZV+IVxZoTp0qtKXUVauAMNT8NZGz5
 zqxownhJHbi6GsViYvPHKOwh7gRDggaCTGJIJFkinkVIQmop4Octb1BhcilYaVsyiQVj wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w11xr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:51:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dTTv130386;
        Fri, 8 Nov 2019 00:51:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w41wjmpfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:51:25 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80pPqA016884;
        Fri, 8 Nov 2019 00:51:25 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:51:24 -0800
Date:   Thu, 7 Nov 2019 16:51:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/46] xfs: remove the ->data_unused_p method
Message-ID: <20191108005124.GZ6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-29-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-29-hch@lst.de>
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

On Thu, Nov 07, 2019 at 07:23:52PM +0100, Christoph Hellwig wrote:
> Replace the two users of the ->data_unused_p dir ops method with a
> direct calculation using ->data_entry_offset, and clean them up a bit.
> xfs_dir2_sf_to_block already had an offset variable containing the
> value of ->data_entry_offset, which we are now reusing to make it
> clear that the initial freespace entry is at the same place that
> we later fill in the 1 entry, and in xfs_dir3_data_init the function
> is cleaned up a bit to keep the initialization of fields of a given
> structure close to each other, and to avoid a local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 17 ---------------
>  fs/xfs/libxfs/xfs_dir2.h       |  2 --
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_data.c  | 40 +++++++++++++++-------------------
>  4 files changed, 19 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 711faff4aea2..347092ec28ab 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -130,13 +130,6 @@ xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
>  		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
>  }
>  
> -static struct xfs_dir2_data_unused *
> -xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_unused *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
>  static struct xfs_dir2_data_entry *
>  xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
>  {
> @@ -144,13 +137,6 @@ xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
>  		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
>  }
>  
> -static struct xfs_dir2_data_unused *
> -xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_unused *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
> @@ -164,7 +150,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
>  	.data_entry_p = xfs_dir2_data_entry_p,
> -	.data_unused_p = xfs_dir2_data_unused_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -180,7 +165,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
>  	.data_entry_p = xfs_dir2_data_entry_p,
> -	.data_unused_p = xfs_dir2_data_unused_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> @@ -196,7 +180,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
>  
>  	.data_entry_p = xfs_dir3_data_entry_p,
> -	.data_unused_p = xfs_dir3_data_unused_p,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 8bfcf4c1b9c4..75aec05aae10 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -45,8 +45,6 @@ struct xfs_dir_ops {
>  
>  	struct xfs_dir2_data_entry *
>  		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
> -	struct xfs_dir2_data_unused *
> -		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  };
>  
>  extern const struct xfs_dir_ops *
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index e7719356829d..9061f378d52a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1112,7 +1112,7 @@ xfs_dir2_sf_to_block(
>  	 * The whole thing is initialized to free by the init routine.
>  	 * Say we're using the leaf and tail area.
>  	 */
> -	dup = dp->d_ops->data_unused_p(hdr);
> +	dup = bp->b_addr + offset;
>  	needlog = needscan = 0;
>  	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
>  			i, &needlog, &needscan);
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 2c79be4c3153..3ecec8e1c5f6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -631,24 +631,20 @@ xfs_dir2_data_freescan(
>   */
>  int						/* error */
>  xfs_dir3_data_init(
> -	xfs_da_args_t		*args,		/* directory operation args */
> -	xfs_dir2_db_t		blkno,		/* logical dir block number */
> -	struct xfs_buf		**bpp)		/* output block buffer */
> +	struct xfs_da_args		*args,	/* directory operation args */
> +	xfs_dir2_db_t			blkno,	/* logical dir block number */
> +	struct xfs_buf			**bpp)	/* output block buffer */
>  {
> -	struct xfs_buf		*bp;		/* block buffer */
> -	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> -	xfs_inode_t		*dp;		/* incore directory inode */
> -	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
> -	struct xfs_dir2_data_free *bf;
> -	int			error;		/* error return value */
> -	int			i;		/* bestfree index */
> -	xfs_mount_t		*mp;		/* filesystem mount point */
> -	xfs_trans_t		*tp;		/* transaction pointer */
> -	int                     t;              /* temp */
> -
> -	dp = args->dp;
> -	mp = dp->i_mount;
> -	tp = args->trans;
> +	struct xfs_trans		*tp = args->trans;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_mount		*mp = dp->i_mount;
> +	struct xfs_buf			*bp;
> +	struct xfs_dir2_data_hdr	*hdr;
> +	struct xfs_dir2_data_unused	*dup;
> +	struct xfs_dir2_data_free 	*bf;
> +	int				error;
> +	int				i;
> +
>  	/*
>  	 * Get the buffer set up for the block.
>  	 */
> @@ -677,6 +673,8 @@ xfs_dir3_data_init(
>  
>  	bf = dp->d_ops->data_bestfree_p(hdr);
>  	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset);
> +	bf[0].length =
> +		cpu_to_be16(args->geo->blksize - dp->d_ops->data_entry_offset);
>  	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
>  		bf[i].length = 0;
>  		bf[i].offset = 0;
> @@ -685,13 +683,11 @@ xfs_dir3_data_init(
>  	/*
>  	 * Set up an unused entry for the block's body.
>  	 */
> -	dup = dp->d_ops->data_unused_p(hdr);
> +	dup = bp->b_addr + dp->d_ops->data_entry_offset;
>  	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
> -
> -	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
> -	bf[0].length = cpu_to_be16(t);
> -	dup->length = cpu_to_be16(t);
> +	dup->length = bf[0].length;
>  	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
> +
>  	/*
>  	 * Log it and return it.
>  	 */
> -- 
> 2.20.1
> 
