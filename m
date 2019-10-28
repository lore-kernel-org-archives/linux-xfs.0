Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07244CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B8C21721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SsVn7V+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfJ1RMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:12:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfJ1RMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:12:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA54k100878;
        Mon, 28 Oct 2019 17:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=y3Dj0i7pSm+VKydzK1qQim8Vl7tlEusDi6PPXPnnB6Q=;
 b=SsVn7V+bg6J6G8B8AeaRUTB0q6vy4y1XS87gQPgJjuA7aqlCsv/h1iViJKdEZiJgjhgI
 u/NM3VQ7GZTWAOL3sDR57IccrHp9I5LbjNkbv2RAPMIm72I2ItRICsB2S8mccKGTh8kf
 XCI7CjpERpO0MyNcRGn/JXKmnVbmZUs13ILIosbJ95/mPzf5oiNNZBguSgUA3IUQEXc6
 3ODACpTcu2FJc2+51J42+DeItb2Nt0tiJ7ehqsIHVaN/1bJCv2xG6ZU26PT7fxkTbJLu
 qkT+O7IEkT0M/CMHJfOpPUz++yApwoY30+jDTioRkiRlTvLKt/LrVUkCCnkeYgfS40O5 Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju3jyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:12:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBnPD164474;
        Mon, 28 Oct 2019 17:12:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vvyks8hum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:12:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SHCcJP004782;
        Mon, 28 Oct 2019 17:12:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:12:37 -0700
Date:   Mon, 28 Oct 2019 10:12:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 08/12] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to
 XFS_MOUNT_ALLOCISZE
Message-ID: <20191028171236.GQ15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-9-hch@lst.de>
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

s/ALLOCISZE/ALLOCSIZE/ in the subject

On Sun, Oct 27, 2019 at 03:55:43PM +0100, Christoph Hellwig wrote:
> Make the flag match the mount option and usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 4 ++--
>  fs/xfs/xfs_iops.c  | 2 +-
>  fs/xfs/xfs_mount.h | 2 +-
>  fs/xfs/xfs_super.c | 6 +++---
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 64bd30a24a71..3c2098f1ded0 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -390,7 +390,7 @@ xfs_iomap_prealloc_size(
>  	if (offset + count <= XFS_ISIZE(ip))
>  		return 0;
>  
> -	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> +	if (!(mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
>  	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
>  		return 0;
>  
> @@ -398,7 +398,7 @@ xfs_iomap_prealloc_size(
>  	 * If an explicit allocsize is set, the file is small, or we
>  	 * are writing behind a hole, then use the minimum prealloc:
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
> +	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
>  	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
>  	    prev.br_startoff + prev.br_blockcount < offset_fsb)
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 382d72769470..9e1f89cdcc82 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -513,7 +513,7 @@ xfs_stat_blksize(
>  	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
>  		if (mp->m_swidth)
>  			return mp->m_swidth << mp->m_sb.sb_blocklog;
> -		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> +		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
>  			return 1U << mp->m_allocsize_log;
>  	}
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 712dbb2039cd..e5c364f1605e 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -227,7 +227,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
>  #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
>  #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
> -#define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
> +#define XFS_MOUNT_ALLOCSIZE	(1ULL << 12)	/* specified allocation size */
>  #define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
>  #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
>  #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3e5002d2a79e..a7d89b87ed22 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -228,7 +228,7 @@ xfs_parseargs(
>  			if (suffix_kstrtoint(args, 10, &size))
>  				return -EINVAL;
>  			mp->m_allocsize_log = ffs(size) - 1;
> -			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> +			mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
>  			break;
>  		case Opt_grpid:
>  		case Opt_bsdgroups:
> @@ -396,7 +396,7 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> +	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
>  	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
>  	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
>  		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> @@ -450,7 +450,7 @@ xfs_showargs(
>  			seq_puts(m, xfs_infop->str);
>  	}
>  
> -	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> +	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
>  		seq_printf(m, ",allocsize=%dk",
>  				(int)(1 << mp->m_allocsize_log) >> 10);
>  
> -- 
> 2.20.1
> 
