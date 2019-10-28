Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11ABCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7967721721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rzC8iWJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404024AbfJ1RIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:08:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfJ1RIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:08:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SH50gW072285;
        Mon, 28 Oct 2019 17:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fxttfvN9vZErxbdeV/xgdab1XKyDQ8HzXN/oCM8zkTo=;
 b=rzC8iWJ60Q9l34+2VlqzcPjgkHZaVNOSca7kbiIAblyXXHt418Vug/sIKMuTcy3dRGeD
 YbpDox2gdYZjO8jHVLsPzhqXk0dBMZWco6ml/tl2DiSajiPbRrXqgsUmkelXOo0yqLUG
 DCqYvrLvD1g+Cu6n7xVWibh8nlZxTD0RDSAizqGnJoCenVSxNvnIDFK4nf39uhMc2qBL
 r84pyLofNf5QXfw8OnAOlPBWRhBxB6vmRw0TfYtFlXPLAgbajzdIKVrfBjPsJ6f38M2v
 jElYbObrpEFTqDFTO7WosPdOuvyWavkNO/NSQmf9M9eMIJO87KyDBwtjX/nXUUmuBHWG YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vvumf8a0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:07:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SH6i1d021857;
        Mon, 28 Oct 2019 17:07:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vvyn02qyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:07:57 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SH7tE7001770;
        Mon, 28 Oct 2019 17:07:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:07:55 -0700
Date:   Mon, 28 Oct 2019 10:07:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 06/12] xfs: rename the m_writeio_* fields in struct
 xfs_mount
Message-ID: <20191028170754.GO15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-7-hch@lst.de>
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

On Sun, Oct 27, 2019 at 03:55:41PM +0100, Christoph Hellwig wrote:
> Use the allocsize name to match the mount option and usage instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 16 ++++++++--------
>  fs/xfs/xfs_iops.c  |  2 +-
>  fs/xfs/xfs_mount.c |  8 ++++----
>  fs/xfs/xfs_mount.h |  4 ++--
>  fs/xfs/xfs_super.c |  4 ++--
>  fs/xfs/xfs_trace.h |  2 +-
>  6 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4af50b101d2b..64bd30a24a71 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -29,8 +29,8 @@
>  #include "xfs_reflink.h"
>  
>  
> -#define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
> -						<< mp->m_writeio_log)
> +#define XFS_ALLOC_ALIGN(mp, off) \
> +	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
>  
>  static int
>  xfs_alert_fsblock_zero(
> @@ -391,7 +391,7 @@ xfs_iomap_prealloc_size(
>  		return 0;
>  
>  	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> -	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)))
> +	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
>  		return 0;
>  
>  	/*
> @@ -402,7 +402,7 @@ xfs_iomap_prealloc_size(
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
>  	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
>  	    prev.br_startoff + prev.br_blockcount < offset_fsb)
> -		return mp->m_writeio_blocks;
> +		return mp->m_allocsize_blocks;
>  
>  	/*
>  	 * Determine the initial size of the preallocation. We are beyond the
> @@ -495,10 +495,10 @@ xfs_iomap_prealloc_size(
>  	while (alloc_blocks && alloc_blocks >= freesp)
>  		alloc_blocks >>= 4;
>  check_writeio:
> -	if (alloc_blocks < mp->m_writeio_blocks)
> -		alloc_blocks = mp->m_writeio_blocks;
> +	if (alloc_blocks < mp->m_allocsize_blocks)
> +		alloc_blocks = mp->m_allocsize_blocks;
>  	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
> -				      mp->m_writeio_blocks);
> +				      mp->m_allocsize_blocks);
>  	return alloc_blocks;
>  }
>  
> @@ -962,7 +962,7 @@ xfs_buffered_write_iomap_begin(
>  			xfs_off_t	end_offset;
>  			xfs_fileoff_t	p_end_fsb;
>  
> -			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
> +			end_offset = XFS_ALLOC_ALIGN(mp, offset + count - 1);
>  			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
>  					prealloc_blocks;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 271fcbe04d48..382d72769470 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -514,7 +514,7 @@ xfs_stat_blksize(
>  		if (mp->m_swidth)
>  			return mp->m_swidth << mp->m_sb.sb_blocklog;
>  		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> -			return 1U << mp->m_writeio_log;
> +			return 1U << mp->m_allocsize_log;
>  	}
>  
>  	return PAGE_SIZE;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 359fcfb494d4..1853797ea938 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -440,13 +440,13 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
>  	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
>  		writeio_log = XFS_WRITEIO_LOG_LARGE;
>  	else
> -		writeio_log = mp->m_writeio_log;
> +		writeio_log = mp->m_allocsize_log;
>  
>  	if (sbp->sb_blocklog > writeio_log)
> -		mp->m_writeio_log = sbp->sb_blocklog;
> +		mp->m_allocsize_log = sbp->sb_blocklog;
>  	} else
> -		mp->m_writeio_log = writeio_log;
> -	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
> +		mp->m_allocsize_log = writeio_log;
> +	mp->m_allocsize_blocks = 1 << (mp->m_allocsize_log - sbp->sb_blocklog);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fba818d5c540..109081c16a07 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -98,8 +98,8 @@ typedef struct xfs_mount {
>  	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
>  	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
>  	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> -	uint			m_writeio_log;	/* min write size log bytes */
> -	uint			m_writeio_blocks; /* min write size blocks */
> +	uint			m_allocsize_log;/* min write size log bytes */
> +	uint			m_allocsize_blocks; /* min write size blocks */
>  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
>  	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
>  	struct xlog		*m_log;		/* log specific stuff */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a477348ab68b..d1a0958f336d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -405,7 +405,7 @@ xfs_parseargs(
>  		}
>  
>  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_writeio_log = iosizelog;
> +		mp->m_allocsize_log = iosizelog;
>  	}
>  
>  	return 0;
> @@ -456,7 +456,7 @@ xfs_showargs(
>  
>  	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
>  		seq_printf(m, ",allocsize=%dk",
> -				(int)(1 << mp->m_writeio_log) >> 10);
> +				(int)(1 << mp->m_allocsize_log) >> 10);
>  
>  	if (mp->m_logbufs > 0)
>  		seq_printf(m, ",logbufs=%d", mp->m_logbufs);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 926f4d10dc02..c13bb3655e48 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -725,7 +725,7 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
>  		__entry->writeio_blocks = writeio_blocks;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx prealloc blocks %llu shift %d "
> -		  "m_writeio_blocks %u",
> +		  "m_allocsize_blocks %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
>  		  __entry->blocks, __entry->shift, __entry->writeio_blocks)
>  )
> -- 
> 2.20.1
> 
