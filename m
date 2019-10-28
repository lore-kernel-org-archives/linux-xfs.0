Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CFDCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A0721835
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hitk9CDq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfJ1RNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:13:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfJ1RNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:13:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA4cq100870;
        Mon, 28 Oct 2019 17:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BBa3lhvZEVSjedshuhzlwch4pEeiARqnBsAaDtABmMk=;
 b=Hitk9CDq8fyEZGbN0I4lV4d6+GgOTMaiTUozrigtgz9IIf8YEZDYm+j0Fj23MZ6bg3jz
 8LqsFqS8VrA/a/6X0IUqL1fWiaU0R1CUuUFggLKXz3etieh04jz3hnEJ7gGjNbQXLj7+
 7783H2D32XOIy3vtvp1/B9jVm/km1zuIYPBssWXfovXqMgCgaLKghpknjKzcPHCCj7vb
 qWQbZUPSr+YT77Y19kE7hdLs2yQDTY472QbyUyX+1p83RfC7C1PGWar+MMix2oFrqnSi
 SILHvj0FmyLBwDbkVwo9DQd0xuoovGw0JQjNmues6+TQM8lfYV/oo62Gx0BKRs079o8Q Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju3k21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:13:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBpWg164585;
        Mon, 28 Oct 2019 17:13:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvyks8jvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:13:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SHD5SG018912;
        Mon, 28 Oct 2019 17:13:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:13:05 -0700
Date:   Mon, 28 Oct 2019 10:13:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 09/12] xfs: reverse the polarity of
 XFS_MOUNT_COMPAT_IOSIZE
Message-ID: <20191028171304.GR15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-10-hch@lst.de>
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

On Sun, Oct 27, 2019 at 03:55:44PM +0100, Christoph Hellwig wrote:
> Replace XFS_MOUNT_COMPAT_IOSIZE with an inverted XFS_MOUNT_LARGEIO flag
> that makes the usage more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Makes much more sense,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iops.c  |  2 +-
>  fs/xfs/xfs_mount.h |  2 +-
>  fs/xfs/xfs_super.c | 12 +++---------
>  3 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9e1f89cdcc82..18e45e3a3f9f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -510,7 +510,7 @@ xfs_stat_blksize(
>  	 * default buffered I/O size, return that, otherwise return the compat
>  	 * default.
>  	 */
> -	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
> +	if (mp->m_flags & XFS_MOUNT_LARGEIO) {
>  		if (mp->m_swidth)
>  			return mp->m_swidth << mp->m_sb.sb_blocklog;
>  		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e5c364f1605e..a46cb3fd24b1 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -236,7 +236,7 @@ typedef struct xfs_mount {
>  						 * allocation */
>  #define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
>  #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
> -#define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
> +#define XFS_MOUNT_LARGEIO	(1ULL << 22)	/* report large preferred
>  						 * I/O size in stat() */
>  #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
>  						   allocator */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a7d89b87ed22..f21c59822a38 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -180,12 +180,6 @@ xfs_parseargs(
>  	if (sb->s_flags & SB_SYNCHRONOUS)
>  		mp->m_flags |= XFS_MOUNT_WSYNC;
>  
> -	/*
> -	 * Set some default flags that could be cleared by the mount option
> -	 * parsing.
> -	 */
> -	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -
>  	/*
>  	 * These can be overridden by the mount option parsing.
>  	 */
> @@ -274,10 +268,10 @@ xfs_parseargs(
>  			mp->m_flags &= ~XFS_MOUNT_IKEEP;
>  			break;
>  		case Opt_largeio:
> -			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> +			mp->m_flags |= XFS_MOUNT_LARGEIO;
>  			break;
>  		case Opt_nolargeio:
> -			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +			mp->m_flags &= ~XFS_MOUNT_LARGEIO;
>  			break;
>  		case Opt_attr2:
>  			mp->m_flags |= XFS_MOUNT_ATTR2;
> @@ -430,12 +424,12 @@ xfs_showargs(
>  		{ XFS_MOUNT_GRPID,		",grpid" },
>  		{ XFS_MOUNT_DISCARD,		",discard" },
>  		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
> +		{ XFS_MOUNT_LARGEIO,		",largeio" },
>  		{ XFS_MOUNT_DAX,		",dax" },
>  		{ 0, NULL }
>  	};
>  	static struct proc_xfs_info xfs_info_unset[] = {
>  		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
>  		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
>  		{ 0, NULL }
>  	};
> -- 
> 2.20.1
> 
