Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2CEC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD7B20679
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GCbalnMD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKLQUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:20:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:20:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGKK3Y146542;
        Tue, 12 Nov 2019 16:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DEcfeoCDcc08QmPt1OY9mPZYy1TL5XQjIbBKBE+tcRA=;
 b=GCbalnMDfjZxQQitkMzrZOjzzbKDXxyDEUU9wES90bZ3QE0DxRfVyqLMfHEnJUcTcknA
 pwwfnBpVyZxnsnFuiJOom7f9D3YaLssuPFzHq7zYEIQIwNlU5q0+0DuStJ6jUhDiEaeD
 B12J2v4YDClB88xbabS+jpCe+jnm7x+MNLdTUaB4wRgrp+G3dgD3AzUxSOE8QQB144ZY
 jPogtMuSOgYvXvE156avbGF+tvtwK+PVBnbK0TE+E0tEog1NMw8/T5fEWtBXDEpBIGT/
 2qnnR70sUwDRVp1uSNGHbUsNzntiGgPnUalUY/Oyy48Bla8K5pbJdHmq8F5UA24roka7 Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndq5ye3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:20:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGDdfX144243;
        Tue, 12 Nov 2019 16:20:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w7j01hyyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:20:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xACGKRen032110;
        Tue, 12 Nov 2019 16:20:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 08:20:27 -0800
Date:   Tue, 12 Nov 2019 08:20:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: use a struct timespec64 for the in-core crtime
Message-ID: <20191112162026.GX6219@magnolia>
References: <20191020082145.32515-1-hch@lst.de>
 <20191020082145.32515-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020082145.32515-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 20, 2019 at 10:21:42AM +0200, Christoph Hellwig wrote:
> struct xfs_icdinode is purely an in-memory data structure, so don't use
> a log on-disk structure for it.  This simplifies the code a bit, and
> also reduces our include hell slightly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h   | 2 +-
>  fs/xfs/libxfs/xfs_trans_inode.c | 6 ++----
>  fs/xfs/xfs_inode.c              | 3 +--
>  fs/xfs/xfs_inode_item.c         | 4 ++--
>  fs/xfs/xfs_iops.c               | 3 +--
>  fs/xfs/xfs_itable.c             | 4 ++--
>  7 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 28ab3c5255e1..d31156718b20 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -256,8 +256,8 @@ xfs_inode_from_disk(
>  	if (to->di_version == 3) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
> -		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> +		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> +		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> @@ -306,8 +306,8 @@ xfs_inode_to_disk(
>  
>  	if (from->di_version == 3) {
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
> -		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> +		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
> +		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index ab0f84165317..c9ac69c82d21 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -37,7 +37,7 @@ struct xfs_icdinode {
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
>  
> -	xfs_ictimestamp_t di_crtime;	/* time created */
> +	struct timespec64 di_crtime;	/* time created */
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index a9ad90926b87..b7b81c5de2de 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -66,10 +66,8 @@ xfs_trans_ichgtime(

I spotted a misaligned variable declaration for @tv in this function and
will fold that into this patch on commit.

@@ -55,7 +55,7 @@ xfs_trans_ichgtime(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	struct timespec64 tv;
+	struct timespec64	tv;
 
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

Looks ok otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  		inode->i_mtime = tv;
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
> -	if (flags & XFS_ICHGTIME_CREATE) {
> -		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> -		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> -	}
> +	if (flags & XFS_ICHGTIME_CREATE)
> +		ip->i_d.di_crtime = tv;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b262e61c..24efdbf534c7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -845,8 +845,7 @@ xfs_ialloc(
>  		inode_set_iversion(inode, 1);
>  		ip->i_d.di_flags2 = 0;
>  		ip->i_d.di_cowextsize = 0;
> -		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> -		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> +		ip->i_d.di_crtime = tv;
>  	}
>  
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index bb8f076805b9..a15db5d679ac 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -340,8 +340,8 @@ xfs_inode_to_log_dinode(
>  
>  	if (from->di_version == 3) {
>  		to->di_changecount = inode_peek_iversion(inode);
> -		to->di_crtime.t_sec = from->di_crtime.t_sec;
> -		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
> +		to->di_crtime.t_sec = from->di_crtime.tv_sec;
> +		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
>  		to->di_flags2 = from->di_flags2;
>  		to->di_cowextsize = from->di_cowextsize;
>  		to->di_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index fe285d123d69..47d8cdb86e5c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -516,8 +516,7 @@ xfs_vn_getattr(
>  	if (ip->i_d.di_version == 3) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
> -			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
> -			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
> +			stat->btime = ip->i_d.di_crtime;
>  		}
>  	}
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 884950adbd16..11771112a634 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -97,8 +97,8 @@ xfs_bulkstat_one_int(
>  	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
>  	buf->bs_ctime = inode->i_ctime.tv_sec;
>  	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
> -	buf->bs_btime = dic->di_crtime.t_sec;
> -	buf->bs_btime_nsec = dic->di_crtime.t_nsec;
> +	buf->bs_btime = dic->di_crtime.tv_sec;
> +	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
>  	buf->bs_gen = inode->i_generation;
>  	buf->bs_mode = inode->i_mode;
>  
> -- 
> 2.20.1
> 
