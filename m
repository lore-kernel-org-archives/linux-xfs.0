Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743CCC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 515402074D
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HypflD0y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbgF3RtG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:49:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388538AbgF3RtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:49:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHn29W029566;
        Tue, 30 Jun 2020 17:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fxKVCRpl/NlB0mjH56WPob/LViWtiK1QXyjypILstus=;
 b=HypflD0yQ0uVKCzoctLFQNShJfBUgyLeWqPBfbo+GaUSIS5G0jXQf7aI7mi/7l89lIkF
 s5MM8j+npdVqlipPc76vyDoz9M7xCG5OfKx6canKVHkxsUESdjdHD8WCn8vby8+rBnNX
 4Kh6Or7awDV08jKZIdicjLq1TWrlQN2ZMOTUxeAt5vFQqgjdzKZ+PgtBkGbpbC0aFceI
 8+IEsU/Ch01L+Qd5yt/zEvHDellBbPN3zxKNpQOZox6Otq8DshBMp8QHUWGSvv6Vv/qv
 kw12lrexqMkd9QpQUbTTBTR6/S73rHXPFiKm0qewEBgqTlqJJ839CP1//GxVqbcGbWKe 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn60j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:49:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHllLQ085748;
        Tue, 30 Jun 2020 17:49:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg1x4vxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:49:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHn0mQ013155;
        Tue, 30 Jun 2020 17:49:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:49:00 +0000
Date:   Tue, 30 Jun 2020 10:48:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: move the di_flushiter field to struct
 xfs_inode
Message-ID: <20200630174859.GD7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-8-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:54AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> flushiter field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_icache.c           |  2 +-
>  fs/xfs/xfs_inode.c            | 19 +++++++++----------
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  6 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 860e35611e001a..03bd7cdd0ddc81 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -205,7 +205,7 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the unitialized part of it.
>  	 */
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> @@ -329,7 +329,7 @@ xfs_inode_to_disk(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> +		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 663a97fa78f05f..8cc96f2766ff4f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint16_t	di_flushiter;	/* incremented on flush */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ad01e694f3ab9b..e6b40f7035aa5a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -521,7 +521,7 @@ xfs_iget_cache_miss(
>  	 * simply build the new inode core with a random generation number.
>  	 *
>  	 * For version 4 (and older) superblocks, log recovery is dependent on
> -	 * the di_flushiter field being initialised from the current on-disk
> +	 * the i_flushiter field being initialised from the current on-disk
>  	 * value and hence we must also read the inode off disk even when
>  	 * initializing new inodes.
>  	 */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f1893824cd4e2f..5e0336e0dbae44 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3765,16 +3765,15 @@ xfs_iflush_int(
>  	}
>  
>  	/*
> -	 * Inode item log recovery for v2 inodes are dependent on the
> -	 * di_flushiter count for correct sequencing. We bump the flush
> -	 * iteration count so we can detect flushes which postdate a log record
> -	 * during recovery. This is redundant as we now log every change and
> -	 * hence this can't happen but we need to still do it to ensure
> -	 * backwards compatibility with old kernels that predate logging all
> -	 * inode changes.
> +	 * Inode item log recovery for v2 inodes are dependent on the flushiter
> +	 * count for correct sequencing.  We bump the flush iteration count so
> +	 * we can detect flushes which postdate a log record during recovery.
> +	 * This is redundant as we now log every change and hence this can't
> +	 * happen but we need to still do it to ensure backwards compatibility
> +	 * with old kernels that predate logging all inode changes.
>  	 */
>  	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
> -		ip->i_d.di_flushiter++;
> +		ip->i_flushiter++;
>  
>  	/*
>  	 * If there are inline format data / attr forks attached to this inode,
> @@ -3795,8 +3794,8 @@ xfs_iflush_int(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
> -		ip->i_d.di_flushiter = 0;
> +	if (ip->i_flushiter == DI_MAX_FLUSH)
> +		ip->i_flushiter = 0;
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2cdb7b6b298852..581618ea1156da 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -59,6 +59,7 @@ typedef struct xfs_inode {
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> +	uint16_t		i_flushiter;	/* incremented on flush */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ab0d8cf8ceb6ab..8357fe37d3eb8a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -351,7 +351,7 @@ xfs_inode_to_log_dinode(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = from->di_flushiter;
> +		to->di_flushiter = ip->i_flushiter;
>  	}
>  }
>  
> -- 
> 2.26.2
> 
