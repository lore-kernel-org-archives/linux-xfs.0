Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C41ECA9EC2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D33208C0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UP+7t1eU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfJ1QuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:50:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfJ1QuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:50:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGn3si079086;
        Mon, 28 Oct 2019 16:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FgXYXxa7JMcMtkWx113lniDXmPguuYQiBAY5E43XGDw=;
 b=UP+7t1eU/HGcSiMEWNai8RzL1mZo9bpKBy4Zni0WbNNYQaa/Rpqsnze/nX2UfpyDLuEp
 qYu8nwCeQU86fo8nSe+TJ4xGyLyBXPXmkDX3FfB1IfIAf2qPp/ytsOmXC59P1EnfrDOk
 vm4fZRwH1Rfe2F7ta95dRHayzLXwX7XyNjUsB7zb8W0345CyV88BFGlkW+yTVaw1Q9xX
 yXZdFsFDrC31P2xsC8zMgPOyPEIcdNUiJM3sAeWF7Qvu9RPjqR9x/ETAo8XUHLdM8p6C
 Y+5419VIzDvFeZLaRbSd9qeSLyVi7zT7Dc6aBKy9IyMNazJWzW5hw0TltcSh2vQVyEPZ QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju3e13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:50:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGniH5085129;
        Mon, 28 Oct 2019 16:50:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvyks75p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:50:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SGo7YP000797;
        Mon, 28 Oct 2019 16:50:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:50:06 -0700
Date:   Mon, 28 Oct 2019 09:50:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 03/12] xfs: cleanup calculating the stat optimal I/O size
Message-ID: <20191028165005.GK15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:38PM +0100, Christoph Hellwig wrote:
> Move xfs_preferred_iosize to xfs_iops.c, unobsfucate it and also handle
> the realtime special case in the helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iops.c  | 47 ++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_mount.h | 24 -----------------------
>  2 files changed, 37 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 404f2dd58698..b6dbfd8eb6a1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -484,6 +484,42 @@ xfs_vn_get_link_inline(
>  	return link;
>  }
>  
> +static uint32_t
> +xfs_stat_blksize(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	/*
> +	 * If the file blocks are being allocated from a realtime volume, then
> +	 * always return the realtime extent size.
> +	 */
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
> +
> +	/*
> +	 * Allow large block sizes to be reported to userspace programs if the
> +	 * "largeio" mount option is used.
> +	 *
> +	 * If compatibility mode is specified, simply return the basic unit of
> +	 * caching so that we don't get inefficient read/modify/write I/O from
> +	 * user apps. Otherwise....
> +	 *
> +	 * If the underlying volume is a stripe, then return the stripe width in
> +	 * bytes as the recommended I/O size. It is not a stripe and we've set a
> +	 * default buffered I/O size, return that, otherwise return the compat
> +	 * default.
> +	 */
> +	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
> +		if (mp->m_swidth)
> +			return mp->m_swidth << mp->m_sb.sb_blocklog;
> +		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> +			return 1U << max(mp->m_readio_log, mp->m_writeio_log);
> +	}
> +
> +	return PAGE_SIZE;
> +}
> +
>  STATIC int
>  xfs_vn_getattr(
>  	const struct path	*path,
> @@ -543,16 +579,7 @@ xfs_vn_getattr(
>  		stat->rdev = inode->i_rdev;
>  		break;
>  	default:
> -		if (XFS_IS_REALTIME_INODE(ip)) {
> -			/*
> -			 * If the file blocks are being allocated from a
> -			 * realtime volume, then return the inode's realtime
> -			 * extent size or the realtime volume's extent size.
> -			 */
> -			stat->blksize =
> -				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
> -		} else
> -			stat->blksize = xfs_preferred_iosize(mp);
> +		stat->blksize = xfs_stat_blksize(ip);
>  		stat->rdev = 0;
>  		break;
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fdb60e09a9c5..f69e370db341 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -267,30 +267,6 @@ typedef struct xfs_mount {
>  #define	XFS_WSYNC_READIO_LOG	15	/* 32k */
>  #define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
>  
> -/*
> - * Allow large block sizes to be reported to userspace programs if the
> - * "largeio" mount option is used.
> - *
> - * If compatibility mode is specified, simply return the basic unit of caching
> - * so that we don't get inefficient read/modify/write I/O from user apps.
> - * Otherwise....
> - *
> - * If the underlying volume is a stripe, then return the stripe width in bytes
> - * as the recommended I/O size. It is not a stripe and we've set a default
> - * buffered I/O size, return that, otherwise return the compat default.
> - */
> -static inline unsigned long
> -xfs_preferred_iosize(xfs_mount_t *mp)
> -{
> -	if (mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)
> -		return PAGE_SIZE;
> -	return (mp->m_swidth ?
> -		(mp->m_swidth << mp->m_sb.sb_blocklog) :
> -		((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ?
> -			(1 << (int)max(mp->m_readio_log, mp->m_writeio_log)) :
> -			PAGE_SIZE));
> -}
> -
>  #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
>  				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
>  #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
> -- 
> 2.20.1
> 
