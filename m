Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEB6C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1E123A9B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbhAHVWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:22:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33640 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbhAHVWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 16:22:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108L9Rx5159166;
        Fri, 8 Jan 2021 21:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HKi0ZcEywZfrMppcwHpkQuhE0/y6JfeANtMgZKXQ0ys=;
 b=YUdq13N79QI6oQO3QN+K81uNB5203Z2sZZ/T0cetOP9oRAEuRxTrTl/dgd58Fnnanm3i
 21TBuo/8fnw2nuC3bYk2JJRLWobnHr/wUmp/reItT5DBIQMm/tzX6mNajIwqvDY+Se52
 k5xy4HvTeGAymvl9SwFqgGFJsdfIBDZLEYxUlW4CSC6wMrCC7LeBVFOkCIF/4KTrCZWe
 G1hmrOxUmOoBjbK+AZ/Y/i+/2AG+M9GxaeEQyG83MtQOw9hdaVkN9sTJ+i/2/Lk3sywb
 z6iR+taDHmGucqCeS94Onk3QMpMgZvwQFlJNPU75ouHAKTTnl7U+SrKreIyWeBeoSDlx lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuy3btx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 21:21:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108LBVC5137968;
        Fri, 8 Jan 2021 21:21:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g4xmr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 21:21:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 108LLXox026894;
        Fri, 8 Jan 2021 21:21:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 13:21:33 -0800
Date:   Fri, 8 Jan 2021 13:21:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210108212132.GS38809@magnolia>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108190919.623672-3-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 09, 2021 at 03:09:17AM +0800, Gao Xiang wrote:
> Such usage isn't encouraged by the kernel coding style.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
>  fs/xfs/xfs_fsops.c     | 12 ++++++------
>  fs/xfs/xfs_fsops.h     |  4 ++--
>  fs/xfs/xfs_ioctl.c     |  4 ++--
>  4 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2a2e3cfd94f0..a17313efc1fe 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -308,12 +308,12 @@ struct xfs_ag_geometry {
>  typedef struct xfs_growfs_data {
>  	__u64		newblocks;	/* new data subvol size, fsblocks */
>  	__u32		imaxpct;	/* new inode space percentage limit */
> -} xfs_growfs_data_t;
> +};

So long as Eric is ok with fixing this up in xfs_fs_compat.h in
userspace,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  
>  typedef struct xfs_growfs_log {
>  	__u32		newblocks;	/* new log size, fsblocks */
>  	__u32		isint;		/* 1 if new log is internal */
> -} xfs_growfs_log_t;
> +};
>  
>  typedef struct xfs_growfs_rt {
>  	__u64		newblocks;	/* new realtime size, fsblocks */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index d254588f6e21..6c5f6a50da2e 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -25,8 +25,8 @@
>   */
>  static int
>  xfs_growfs_data_private(
> -	xfs_mount_t		*mp,		/* mount point for filesystem */
> -	xfs_growfs_data_t	*in)		/* growfs data input struct */
> +	struct xfs_mount	*mp,		/* mount point for filesystem */
> +	struct xfs_growfs_data	*in)		/* growfs data input struct */
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> @@ -35,7 +35,7 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		nb, nb_mod;
>  	xfs_rfsblock_t		delta;
>  	xfs_agnumber_t		oagcount;
> -	xfs_trans_t		*tp;
> +	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> @@ -170,8 +170,8 @@ xfs_growfs_data_private(
>  
>  static int
>  xfs_growfs_log_private(
> -	xfs_mount_t		*mp,	/* mount point for filesystem */
> -	xfs_growfs_log_t	*in)	/* growfs log input struct */
> +	struct xfs_mount	*mp,	/* mount point for filesystem */
> +	struct xfs_growfs_log	*in)	/* growfs log input struct */
>  {
>  	xfs_extlen_t		nb;
>  
> @@ -268,7 +268,7 @@ xfs_growfs_data(
>  int
>  xfs_growfs_log(
>  	xfs_mount_t		*mp,
> -	xfs_growfs_log_t	*in)
> +	struct xfs_growfs_log	*in)
>  {
>  	int error;
>  
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 92869f6ec8d3..d7e9af4a28eb 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -6,8 +6,8 @@
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
>  
> -extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
> -extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
> +extern int xfs_growfs_data(xfs_mount_t *mp, struct xfs_growfs_data *in);
> +extern int xfs_growfs_log(xfs_mount_t *mp, struct xfs_growfs_log *in);
>  extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
>  extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
>  				xfs_fsop_resblks_t *outval);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3fbd98f61ea5..a62520f49ec5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2260,7 +2260,7 @@ xfs_file_ioctl(
>  	}
>  
>  	case XFS_IOC_FSGROWFSDATA: {
> -		xfs_growfs_data_t in;
> +		struct xfs_growfs_data in;
>  
>  		if (copy_from_user(&in, arg, sizeof(in)))
>  			return -EFAULT;
> @@ -2274,7 +2274,7 @@ xfs_file_ioctl(
>  	}
>  
>  	case XFS_IOC_FSGROWFSLOG: {
> -		xfs_growfs_log_t in;
> +		struct xfs_growfs_log in;
>  
>  		if (copy_from_user(&in, arg, sizeof(in)))
>  			return -EFAULT;
> -- 
> 2.27.0
> 
