Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDA9C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EF8222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U0yGXKne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKMEma (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:42:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKMEma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:42:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4dF0Y170115;
        Wed, 13 Nov 2019 04:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HKP6/9D9cC5QQ7r2rPOGs6NJ8gPnPyDzRqWMlDNxTKo=;
 b=U0yGXKnebU3DxLebU7pBeE8p/+ab8AAbWOYVtfDCMwZBXl08XK1QEw7erxFUeRx3atiW
 D3pupxynR8WIG58r+qqTIgNwyss1rp4gtgIJHBkw9c41ruLFErsAL2HbiRpGkh+ioenU
 au2y1eJYzrASCiT/O8/+Pf838L1aRPFJ3p2g6kLUr5ijo4jqYrVtNyqGeRiteyEpTpvT
 +rCQPPIBCMEYtI+Pfz/BbOVBB3Z7sYfRwFx4iWTPzSUqn7t/fVTOA6/GPfnfQvU4EJXw
 9O2FPyHXC00RkIiIKJXs2ewz//gHDApsGpS2dYpoHH1ILMUEuGrdbvoGoqsdsyDGUbte Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndq9ke1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:42:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4cASo179546;
        Wed, 13 Nov 2019 04:42:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w7vbc56s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:42:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD4gQ9K010130;
        Wed, 13 Nov 2019 04:42:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:42:26 -0800
Date:   Tue, 12 Nov 2019 20:42:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: removed unused typedef definitions
Message-ID: <20191113044225.GK6219@magnolia>
References: <321019c7-574e-e7e1-0eb6-e60776ad7948@sandeen.net>
 <3e3ddc13-4417-a0b1-85d1-a03a37a46461@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3ddc13-4417-a0b1-85d1-a03a37a46461@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 04:59:31PM -0600, Eric Sandeen wrote:
> Remove some typdefs for type_t's that are no longer referred to
> by their typedef'd types.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, have fun cleaning them out of xfsprogs. ;)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index c968b60cee15..8f6b485a3119 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -920,13 +920,13 @@ static inline uint xfs_dinode_size(int version)
>   * This enum is used in string mapping in xfs_trace.h; please keep the
>   * TRACE_DEFINE_ENUMs for it up to date.
>   */
> -typedef enum xfs_dinode_fmt {
> +enum xfs_dinode_fmt {
>  	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
>  	XFS_DINODE_FMT_LOCAL,		/* bulk data */
>  	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
>  	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
>  	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
> -} xfs_dinode_fmt_t;
> +};
>  
>  #define XFS_INODE_FORMAT_STR \
>  	{ XFS_DINODE_FMT_DEV,		"dev" }, \
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index f3d18eaecebb..3bf671637a91 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -30,14 +30,14 @@ typedef struct xlog_recover_item {
>  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
>  } xlog_recover_item_t;
>  
> -typedef struct xlog_recover {
> +struct xlog_recover {
>  	struct hlist_node	r_list;
>  	xlog_tid_t		r_log_tid;	/* log's transaction id */
>  	xfs_trans_header_t	r_theader;	/* trans header for partial */
>  	int			r_state;	/* not needed */
>  	xfs_lsn_t		r_lsn;		/* xact lsn */
>  	struct list_head	r_itemq;	/* q for items */
> -} xlog_recover_t;
> +};
>  
>  #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
>  
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index 7985344d3aa6..13b1d4b967bb 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -99,7 +99,7 @@ typedef struct compat_xfs_fsop_handlereq {
>  	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
>  
>  /* The bstat field in the swapext struct needs translation */
> -typedef struct compat_xfs_swapext {
> +struct compat_xfs_swapext {
>  	int64_t			sx_version;	/* version */
>  	int64_t			sx_fdtarget;	/* fd of target file */
>  	int64_t			sx_fdtmp;	/* fd of tmp file */
> @@ -107,7 +107,7 @@ typedef struct compat_xfs_swapext {
>  	xfs_off_t		sx_length;	/* leng from offset */
>  	char			sx_pad[16];	/* pad space, unused */
>  	struct compat_xfs_bstat	sx_stat;	/* stat of target b4 copy */
> -} __compat_packed compat_xfs_swapext_t;
> +} __compat_packed;
>  
>  #define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
>  
> 
> 
