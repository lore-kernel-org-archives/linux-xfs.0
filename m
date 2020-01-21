Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CB8C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717EE2087E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YbuyeJqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgAUSW6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:22:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:22:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7q1b191333;
        Tue, 21 Jan 2020 18:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2u9N+wj7YUcaSqA+tp3AGGZVTbZYy2jRhyjkwWJIThE=;
 b=YbuyeJqMHWCPSEYGlB5dhXcD16VvrxiC6vXNzfyvfLnURfn2rCa9PU5q5SMWpECs7dS8
 HAQS6ZBU+kBN/fxXJygzxmVMKVHax3B0NC0Djc2z5/hCgpPsmO2WucClLDMMxe9E/gM9
 wr+TwqyG8aBiKnrw9l7DISXJuENFsSF2MSXDA7CG9GQPwVf1RqiRW4CGRwUEpnZ4olsE
 piPdSN5rqQH/IiWs5nSutC1anRyVITA07Ah1cZUV18Z8J6Xr9uUqzf/kRRLpxwQrSWUu
 gR6JHJKVpMBd9viV67NHLDA9py3vED6NYT9aXLelqOGryp5u7MNHBfGbk/PTT4CX0hDV /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseuf1ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:22:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7waA113225;
        Tue, 21 Jan 2020 18:20:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xnpfpgmmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:20:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIKqjf023273;
        Tue, 21 Jan 2020 18:20:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:20:52 -0800
Date:   Tue, 21 Jan 2020 10:20:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 15/29] xfs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
Message-ID: <20200121182051.GO8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-16-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:37AM +0100, Christoph Hellwig wrote:
> op_flags with the XFS_DA_OP_* flags is the usual place for in-kernel
> only flags, so move the notime flag there.

Whenever we're done removing the kernel-internal flags from
xfs_da_args.flags, I think it's worth amending the comments for @flags
and @op_flags noting that the first one is for argument flags from
userspace and the second one is for internal flags.

Otherwise this looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c  | 4 ++--
>  fs/xfs/libxfs/xfs_attr.h  | 8 +-------
>  fs/xfs/libxfs/xfs_types.h | 2 ++
>  fs/xfs/scrub/attr.c       | 2 +-
>  fs/xfs/xfs_ioctl.c        | 1 -
>  5 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c362dbab1a6a..fce4fd4a3370 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -186,7 +186,7 @@ xfs_attr_try_sf_addname(
>  	 * Commit the shortform mods, and we're done.
>  	 * NOTE: this is also the error path (EEXIST, etc).
>  	 */
> -	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
> +	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> @@ -385,7 +385,7 @@ xfs_attr_set(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
>  
> -	if ((args->flags & ATTR_KERNOTIME) == 0)
> +	if (!(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index a6de050675c9..0f369399effd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -33,19 +33,13 @@ struct xfs_attr_list_context;
>  #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
>  #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
>  
> -#define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> -
> -#define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME)
> -
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
>  	{ ATTR_ROOT,		"ROOT" }, \
>  	{ ATTR_TRUST,		"TRUST" }, \
>  	{ ATTR_SECURE,		"SECURE" }, \
>  	{ ATTR_CREATE,		"CREATE" }, \
> -	{ ATTR_REPLACE,		"REPLACE" }, \
> -	{ ATTR_KERNOTIME,	"KERNOTIME" }
> +	{ ATTR_REPLACE,		"REPLACE" }
>  
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 3379ebc0c7c5..1594325d7742 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -223,6 +223,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> +#define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
>  #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
>  
>  #define XFS_DA_OP_FLAGS \
> @@ -231,6 +232,7 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
>  	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
>  
>  /*
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index f983c2b969e0..05537627211d 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -147,7 +147,7 @@ xchk_xattr_listent(
>  		return;
>  	}
>  
> -	args.flags = ATTR_KERNOTIME;
> +	args.op_flags = XFS_DA_OP_NOTIME;
>  	if (flags & XFS_ATTR_ROOT)
>  		args.flags |= ATTR_ROOT;
>  	else if (flags & XFS_ATTR_SECURE)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 75b8fa7da1c9..9306cefa9e61 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -434,7 +434,6 @@ xfs_ioc_attrmulti_one(
>  
>  	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
>  		return -EINVAL;
> -	flags &= ~ATTR_KERNEL_FLAGS;
>  
>  	name = strndup_user(uname, MAXNAMELEN);
>  	if (IS_ERR(name))
> -- 
> 2.24.1
> 
