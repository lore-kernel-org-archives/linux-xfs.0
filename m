Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A606CA9EC2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37F5521721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GSjG9bbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404054AbfJ1RLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:11:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404040AbfJ1RLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:11:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA8kn083421;
        Mon, 28 Oct 2019 17:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6vz8tIYVUxmkbwd5lci22y+JppOEAfPS6jRRKWrdv0U=;
 b=GSjG9bbQEVGcZQsuMjDCtwn62gc3+cPwG3HxksJ0mgamacok0ooqIZcBvyHGTBT2KjLx
 3GXlyhbEwqFIzjWuIPG6Y8FV3/CWAupEnPmC8sGyqLnkbiF7b4HBZfi81HzwnSUHNFDG
 cbc0ODYyIncIGd++j1XHf0vQllo1jIosxVYgahHXuQFDKOxn+OU9gCC6K9fy4TwrhJXC
 f90GN7T2KB2lzDTejjxoIWplTdrXnWIizBTzbyS9WdNOxV3uOx3Y964ZslA88huLeVMW
 InIIrnfDijJRRqt3YXs4fCZprO8lSBAOqpz6dbjvXBc/jtEth/3Y7LHn5067qiLHmwZ7 Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vve3q3dwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:11:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBIoL037584;
        Mon, 28 Oct 2019 17:11:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vvyn02wxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:11:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SHBcZG031359;
        Mon, 28 Oct 2019 17:11:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:11:38 -0700
Date:   Mon, 28 Oct 2019 10:11:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 07/12] xfs: simplify parsing of allocsize mount option
Message-ID: <20191028171137.GP15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-8-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:42PM +0100, Christoph Hellwig wrote:
> Rework xfs_parseargs to fill out the default value and then parse the
> option directly into the mount structure, similar to what we do for
> other updates, and open code the now trivial updates based on on the
> on-disk superblock directly into xfs_mountfs.
> 
> Note that this change rejects the allocsize=0 mount option that has been
> documented as invalid for a long time instead of just ignoring it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c | 31 +++++--------------------------
>  fs/xfs/xfs_mount.h |  6 ------
>  fs/xfs/xfs_super.c | 26 +++++++++++---------------
>  3 files changed, 16 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1853797ea938..3e8eedf01eb2 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -425,30 +425,6 @@ xfs_update_alignment(xfs_mount_t *mp)
>  	return 0;
>  }
>  
> -/*
> - * Set the default minimum read and write sizes unless
> - * already specified in a mount option.
> - * We use smaller I/O sizes when the file system
> - * is being used for NFS service (wsync mount option).
> - */
> -STATIC void
> -xfs_set_rw_sizes(xfs_mount_t *mp)
> -{
> -	xfs_sb_t	*sbp = &(mp->m_sb);
> -	int		readio_log, writeio_log;
> -
> -	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
> -		writeio_log = XFS_WRITEIO_LOG_LARGE;
> -	else
> -		writeio_log = mp->m_allocsize_log;
> -
> -	if (sbp->sb_blocklog > writeio_log)
> -		mp->m_allocsize_log = sbp->sb_blocklog;
> -	} else
> -		mp->m_allocsize_log = writeio_log;
> -	mp->m_allocsize_blocks = 1 << (mp->m_allocsize_log - sbp->sb_blocklog);
> -}
> -
>  /*
>   * precalculate the low space thresholds for dynamic speculative preallocation.
>   */
> @@ -713,9 +689,12 @@ xfs_mountfs(
>  		goto out_remove_errortag;
>  
>  	/*
> -	 * Set the minimum read and write sizes
> +	 * Update the preferred write size based on the information from the
> +	 * on-disk superblock.
>  	 */
> -	xfs_set_rw_sizes(mp);
> +	mp->m_allocsize_log =
> +		max_t(uint32_t, sbp->sb_blocklog, mp->m_allocsize_log);
> +	mp->m_allocsize_blocks = 1U << (mp->m_allocsize_log - sbp->sb_blocklog);
>  
>  	/* set the low space thresholds for dynamic preallocation */
>  	xfs_set_low_space_thresholds(mp);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 109081c16a07..712dbb2039cd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -244,12 +244,6 @@ typedef struct xfs_mount {
>  
>  #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
>  
> -
> -/*
> - * Default write size.
> - */
> -#define XFS_WRITEIO_LOG_LARGE	16
> -
>  /*
>   * Max and min values for mount-option defined I/O
>   * preallocation sizes.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d1a0958f336d..3e5002d2a79e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -159,8 +159,7 @@ xfs_parseargs(
>  	const struct super_block *sb = mp->m_super;
>  	char			*p;
>  	substring_t		args[MAX_OPT_ARGS];
> -	int			iosize = 0;
> -	uint8_t			iosizelog = 0;
> +	int			size = 0;
>  
>  	/*
>  	 * set up the mount name first so all the errors will refer to the
> @@ -192,6 +191,7 @@ xfs_parseargs(
>  	 */
>  	mp->m_logbufs = -1;
>  	mp->m_logbsize = -1;
> +	mp->m_allocsize_log = 16; /* 64k */
>  
>  	if (!options)
>  		goto done;
> @@ -225,9 +225,10 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -			if (suffix_kstrtoint(args, 10, &iosize))
> +			if (suffix_kstrtoint(args, 10, &size))
>  				return -EINVAL;
> -			iosizelog = ffs(iosize) - 1;
> +			mp->m_allocsize_log = ffs(size) - 1;
> +			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
>  			break;
>  		case Opt_grpid:
>  		case Opt_bsdgroups:
> @@ -395,17 +396,12 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -	if (iosizelog) {
> -		if (iosizelog > XFS_MAX_IO_LOG ||
> -		    iosizelog < XFS_MIN_IO_LOG) {
> -			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> -				iosizelog, XFS_MIN_IO_LOG,
> -				XFS_MAX_IO_LOG);
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_allocsize_log = iosizelog;
> +	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> +	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
> +	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
> +		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> +			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
> +		return -EINVAL;
>  	}
>  
>  	return 0;
> -- 
> 2.20.1
> 
