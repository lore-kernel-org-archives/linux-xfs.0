Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68364C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E9632078B
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X+jq+C2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgEPATh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 20:19:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33038 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgEPATh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 20:19:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0Bnl1037062;
        Sat, 16 May 2020 00:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=W9plK2fw+oldbKLLWJTbbUiBa9NvXDvqma6fZurLcX8=;
 b=X+jq+C2sxddf+lw4xLo/y9H7hXkM9PQ5J4nL5NDT8b81k4ELZFE0YS4Aequpxfyf4Qlb
 HZeQdEPNOysTySdJOZ7PEtzVUC7IEepslwDUShmZ0ThElwu6wKMCjdiy6Z9ISMqbn9U4
 fUO3TeMdE3tfUFb1CQJJonWslANxjtYeLR6pa5kt52K6dACKdJ/jgEf+b67rwzb3KUS5
 JQ1aM+EDpj/pr0nfD0vBLR0tc7n3hJu7TFssD0qc0TuhwhzgqIVpNdm8Wz7NqmjwXdGP
 9P5axqscOZvin8CO70IdEoBClAFlIvqOVfIdteTCoseGAcp7hNhxyfI0ERJy5hsJ46sn NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwxdj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 00:19:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0ICwW132826;
        Sat, 16 May 2020 00:19:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3100yfq01r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 00:19:31 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04G0JRVA022130;
        Sat, 16 May 2020 00:19:28 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 17:19:27 -0700
Date:   Fri, 15 May 2020 17:19:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/12] xfs: call xfs_iformat_fork from xfs_inode_from_disk
Message-ID: <20200516001926.GR6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-3-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:13AM +0200, Christoph Hellwig wrote:
> We always need to fill out the fork structures when reading the inode,
> so call xfs_iformat_fork from the tail of xfs_inode_from_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 7 ++++---
>  fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
>  fs/xfs/xfs_log_recover.c      | 4 +---
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 81a010422bea3..dc00ce6fc4a2f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -180,7 +180,7 @@ xfs_imap_to_bp(
>  	return 0;
>  }
>  
> -void
> +int
>  xfs_inode_from_disk(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*from)
> @@ -241,6 +241,8 @@ xfs_inode_from_disk(
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> +
> +	return xfs_iformat_fork(ip, from);
>  }
>  
>  void
> @@ -641,8 +643,7 @@ xfs_iread(
>  	 * Otherwise, just get the truly permanent information.
>  	 */
>  	if (dip->di_mode) {
> -		xfs_inode_from_disk(ip, dip);
> -		error = xfs_iformat_fork(ip, dip);
> +		error = xfs_inode_from_disk(ip, dip);
>  		if (error)  {
>  #ifdef DEBUG
>  			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index d9b4781ac9fd4..0fbb99224ec73 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -54,7 +54,7 @@ int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
>  void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> -void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
> +int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
>  			       struct xfs_dinode *to);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 3207851158332..3960caf51c9f7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2874,9 +2874,7 @@ xfs_recover_inode_owner_change(
>  
>  	/* instantiate the inode */
>  	ASSERT(dip->di_version >= 3);
> -	xfs_inode_from_disk(ip, dip);
> -
> -	error = xfs_iformat_fork(ip, dip);
> +	error = xfs_inode_from_disk(ip, dip);
>  	if (error)
>  		goto out_free_ip;
>  
> -- 
> 2.26.2
> 
