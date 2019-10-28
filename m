Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF97BCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D1F21721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JvtyY0q4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJ1RFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:05:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfJ1RFb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:05:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SH51Jg078878;
        Mon, 28 Oct 2019 17:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4e6DKbZ1fUtLiFSUZQWd/g4TvekPpmQUltzzExpgHDs=;
 b=JvtyY0q4eIwTaHX5Lf+MSNI96ktpcgMqT10WwdhHjeiW4yBvovnfdACO43e1HuS72/Qu
 2LSXwoTmmhC/Iu9MyMgICG84xnMq3F+/Qt5b9/UYOFfv5Zcj2pg3fjtKaG8w4NMc6UhD
 bm6rbOd949AYDSpNaO3gjdzpG6QZoBaQn1AluIawecb63EBvGZ4R7e1Pxb5kTYjjA9iG
 3nxOrgbY9Mnlr1ORsp1SFjJsLvBHTvB15zNHGomtkKAg2SrKBmy23tWBRtKsegA+xPg7
 WBIDfYNEZVAd5gtzL8xPPWDCpMGD3jTYK5xnItdTwxB2r2Rn9kKDB6O5qdKcPEkDzogc OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vve3q3cuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:05:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGwRWv045420;
        Mon, 28 Oct 2019 17:05:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vwakybr2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:05:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SH5NfQ025194;
        Mon, 28 Oct 2019 17:05:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:05:22 -0700
Date:   Mon, 28 Oct 2019 10:05:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 04/12] xfs: don't use a different allocsice for -o wsync
 mounts
Message-ID: <20191028170521.GM15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:39PM +0100, Christoph Hellwig wrote:
> The -o wsync allocsize overwrite overwrite was part of a special hack
> for NFSv2 servers in IRIX and has no real purpose in modern Linux, so
> remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me not being around to absorb any of the context of how the 15/16
shift values were arrived at notwithstanding,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c | 9 ++-------
>  fs/xfs/xfs_mount.h | 7 -------
>  2 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ba5b6f3b2b88..b423033e14f4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -438,13 +438,8 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
>  	int		readio_log, writeio_log;
>  
>  	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
> -		if (mp->m_flags & XFS_MOUNT_WSYNC) {
> -			readio_log = XFS_WSYNC_READIO_LOG;
> -			writeio_log = XFS_WSYNC_WRITEIO_LOG;
> -		} else {
> -			readio_log = XFS_READIO_LOG_LARGE;
> -			writeio_log = XFS_WRITEIO_LOG_LARGE;
> -		}
> +		readio_log = XFS_READIO_LOG_LARGE;
> +		writeio_log = XFS_WRITEIO_LOG_LARGE;
>  	} else {
>  		readio_log = mp->m_readio_log;
>  		writeio_log = mp->m_writeio_log;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index f69e370db341..dc81e5c264ce 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -260,13 +260,6 @@ typedef struct xfs_mount {
>  #define XFS_MAX_IO_LOG		30	/* 1G */
>  #define XFS_MIN_IO_LOG		PAGE_SHIFT
>  
> -/*
> - * Synchronous read and write sizes.  This should be
> - * better for NFSv2 wsync filesystems.
> - */
> -#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
> -#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
> -
>  #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
>  				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
>  #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
> -- 
> 2.20.1
> 
