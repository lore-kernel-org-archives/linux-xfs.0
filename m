Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6809C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8707A20768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zAFtsAyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbgF3RzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:55:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3RzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:55:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqhPr046016;
        Tue, 30 Jun 2020 17:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9EaXF0PV8G467hzWg6XtXsTO8oPTqtvKdG0muYdOuRQ=;
 b=zAFtsAyMBL6c8YZbl72qlBHEdQywd7dmyGk/hE9Dx5diijBVrims4NQ9LTBVOYwb2Ipl
 A02JeezCKERknijDjZ5bMPTwMF7Q3qLAlGacyDStsVu/sIqEK59Cxi5Yl5bniMTJOMkY
 pup0Py83XUCwLECBvovtEfKKX52KHIQcRVGjIrTefiPFmHhtbMDHHU68nIvGBDQsP8Aa
 Iv3M7DWtT8tytfHzabux0nULCb80PdkmYle1GEqyeyVho+m/x/pGkaLusMkCTQYQkpP8
 DeDP/RbZRvxe1slquUqz9g7AF1VwES4/4UMHnaZtQMSbKNXORX5gGVjtaRyY25S4jFWy Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrn61mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:55:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqaOr166880;
        Tue, 30 Jun 2020 17:55:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52j8era-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:55:05 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UHt4dP005198;
        Tue, 30 Jun 2020 17:55:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:55:03 +0000
Date:   Tue, 30 Jun 2020 10:55:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/15] xfs: move the di_crtime field to struct xfs_inode
Message-ID: <20200630175502.GJ7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-14-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:11:00AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the crtime
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h   | 2 --
>  fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
>  fs/xfs/xfs_inode.c              | 2 +-
>  fs/xfs/xfs_inode.h              | 1 +
>  fs/xfs/xfs_inode_item.c         | 4 ++--
>  fs/xfs/xfs_iops.c               | 2 +-
>  fs/xfs/xfs_itable.c             | 4 ++--
>  8 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 79e470933abfa8..af595ee23635aa 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -253,8 +253,8 @@ xfs_inode_from_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> -		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> +		ip->i_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> +		ip->i_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
>  		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> @@ -319,8 +319,8 @@ xfs_inode_to_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
> -		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> +		to->di_crtime.t_sec = cpu_to_be32(ip->i_crtime.tv_sec);
> +		to->di_crtime.t_nsec = cpu_to_be32(ip->i_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 4bfad6d6d5710a..2a8e7a7ed8d18d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -18,8 +18,6 @@ struct xfs_dinode;
>  struct xfs_icdinode {
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
> -
> -	struct timespec64 di_crtime;	/* time created */
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index b5dfb665484223..3c690829634cdc 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -67,7 +67,7 @@ xfs_trans_ichgtime(
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
>  	if (flags & XFS_ICHGTIME_CREATE)
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 593e8c5c2fd658..59f11314750a46 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -841,7 +841,7 @@ xfs_ialloc(
>  		inode_set_iversion(inode, 1);
>  		ip->i_diflags2 = 0;
>  		ip->i_cowextsize = 0;
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  	}
>  
>  	flags = XFS_ILOG_CORE;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 709f04fadde65e..106a8d6cc010cb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -66,6 +66,7 @@ typedef struct xfs_inode {
>  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> +	struct timespec64	i_crtime;	/* time created */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 04e671d2957ca2..dff3bc6a33720a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -340,8 +340,8 @@ xfs_inode_to_log_dinode(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = inode_peek_iversion(inode);
> -		to->di_crtime.t_sec = from->di_crtime.tv_sec;
> -		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> +		to->di_crtime.t_sec = ip->i_crtime.tv_sec;
> +		to->di_crtime.t_nsec = ip->i_crtime.tv_nsec;
>  		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 3642f9935cae3f..6aace9c6586ca5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -559,7 +559,7 @@ xfs_vn_getattr(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
> -			stat->btime = ip->i_d.di_crtime;
> +			stat->btime = ip->i_crtime;
>  		}
>  	}
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 4d1509437c3576..7945c6c4844940 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -97,8 +97,8 @@ xfs_bulkstat_one_int(
>  	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
>  	buf->bs_ctime = inode->i_ctime.tv_sec;
>  	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
> -	buf->bs_btime = dic->di_crtime.tv_sec;
> -	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
> +	buf->bs_btime = ip->i_crtime.tv_sec;
> +	buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
>  	buf->bs_gen = inode->i_generation;
>  	buf->bs_mode = inode->i_mode;
>  
> -- 
> 2.26.2
> 
