Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1FBCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D78C21721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qIFloPsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404021AbfJ1RHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:07:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfJ1RHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:07:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SH50Sl096268;
        Mon, 28 Oct 2019 17:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=apnZjoXckiJx0kwhxvKOH3pak3pTS2nNZbVQYM5+f3w=;
 b=qIFloPsjcPj6y8HNkQ03bP8uCclI0kp8a1JYbpCjKpuAXRMKhVru++ysUGEwYGO0SWtL
 Z4mQAsNhYC4pEWU9gj0EhQYu9/wx2NYFxlvIzdSu2tMA1KjzA0Dw45yHHy5/LyAKf908
 f+aR10EiTMrnXDO3cMnJLR6bCfsa+/g34KpEjbN9bzm1Jihcmii92iwKtho8AuT+UZcw
 4c8UoUqfSPduFW9kHSZXRAJsO71C9OjW5F0igbuWghtshMvBwGxWgBvUsX5orM8jSO/o
 iHU8kKRZnsghBi3lyP1GEH7WkOlyzUGSAxNSnVwTHCA3sRYmsKsFZ3WrQpvJE7mUqSGY Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vvdju3hur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:07:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SH6mB5062857;
        Mon, 28 Oct 2019 17:07:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vw09g3n4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:06:57 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SH6TCQ013359;
        Mon, 28 Oct 2019 17:06:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:06:29 -0700
Date:   Mon, 28 Oct 2019 10:06:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 05/12] xfs: remove the m_readio_* fields in struct
 xfs_mount
Message-ID: <20191028170628.GN15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280165
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

On Sun, Oct 27, 2019 at 03:55:40PM +0100, Christoph Hellwig wrote:
> m_readio_blocks is entirely unused, and m_readio_blocks is only used in
> xfs_stat_blksize in a max statements that is a no-op as it always has
> the same value as m_writeio_log.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iops.c  |  2 +-
>  fs/xfs/xfs_mount.c | 18 ++++--------------
>  fs/xfs/xfs_mount.h |  5 +----
>  fs/xfs/xfs_super.c |  1 -
>  4 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b6dbfd8eb6a1..271fcbe04d48 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -514,7 +514,7 @@ xfs_stat_blksize(
>  		if (mp->m_swidth)
>  			return mp->m_swidth << mp->m_sb.sb_blocklog;
>  		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> -			return 1U << max(mp->m_readio_log, mp->m_writeio_log);
> +			return 1U << mp->m_writeio_log;
>  	}
>  
>  	return PAGE_SIZE;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b423033e14f4..359fcfb494d4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -437,25 +437,15 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
>  	xfs_sb_t	*sbp = &(mp->m_sb);
>  	int		readio_log, writeio_log;
>  
> -	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
> -		readio_log = XFS_READIO_LOG_LARGE;
> +	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
>  		writeio_log = XFS_WRITEIO_LOG_LARGE;
> -	} else {
> -		readio_log = mp->m_readio_log;
> +	else
>  		writeio_log = mp->m_writeio_log;
> -	}
>  
> -	if (sbp->sb_blocklog > readio_log) {
> -		mp->m_readio_log = sbp->sb_blocklog;
> -	} else {
> -		mp->m_readio_log = readio_log;
> -	}
> -	mp->m_readio_blocks = 1 << (mp->m_readio_log - sbp->sb_blocklog);
> -	if (sbp->sb_blocklog > writeio_log) {
> +	if (sbp->sb_blocklog > writeio_log)
>  		mp->m_writeio_log = sbp->sb_blocklog;
> -	} else {
> +	} else
>  		mp->m_writeio_log = writeio_log;
> -	}
>  	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
>  }
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index dc81e5c264ce..fba818d5c540 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -98,8 +98,6 @@ typedef struct xfs_mount {
>  	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
>  	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
>  	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> -	uint			m_readio_log;	/* min read size log bytes */
> -	uint			m_readio_blocks; /* min read size blocks */
>  	uint			m_writeio_log;	/* min write size log bytes */
>  	uint			m_writeio_blocks; /* min write size blocks */
>  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
> @@ -248,9 +246,8 @@ typedef struct xfs_mount {
>  
>  
>  /*
> - * Default minimum read and write sizes.
> + * Default write size.
>   */
> -#define XFS_READIO_LOG_LARGE	16
>  #define XFS_WRITEIO_LOG_LARGE	16
>  
>  /*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4089de3daded..a477348ab68b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -405,7 +405,6 @@ xfs_parseargs(
>  		}
>  
>  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_readio_log = iosizelog;
>  		mp->m_writeio_log = iosizelog;
>  	}
>  
> -- 
> 2.20.1
> 
