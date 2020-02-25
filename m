Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F69BC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5892F218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qw5AFzqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgBYPIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:08:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41710 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728065AbgBYPII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RyQeHKiEkYWUp0xQQ2ojZ2hWZnFX5JzJF4QnajK40eg=;
        b=Qw5AFzqV7X2Bxq0Xt81Jjvd9iBpWgwXMo2fwm22KfokrudZ7ijqAIUseMn4b5EprDfukTb
        Ph8SkR/H7sJuT49UlbWYg2dSzZ3ZoXtJGgvC8YP2tfSjfc/6axbwS/f8z57krjd5wSI+3/
        cn9vGphFqPLJ5YFJIE9PEHJI95iBsew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-FOlOSIRfMTepbK2rWkWi2Q-1; Tue, 25 Feb 2020 10:08:02 -0500
X-MC-Unique: FOlOSIRfMTepbK2rWkWi2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49A0E108C22F;
        Tue, 25 Feb 2020 15:08:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD2261059100;
        Tue, 25 Feb 2020 15:08:00 +0000 (UTC)
Date:   Tue, 25 Feb 2020 10:07:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: flush all dirty buffers and report errors
 when unmounting filesystem
Message-ID: <20200225150759.GA26938@bfoster>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258945354.451075.11223931828645692053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258945354.451075.11223931828645692053.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:10:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach libxfs_umount to flush all dirty buffers when unmounting the
> filesystem, to log write verifier errors and IO errors, and to return an
> error code when things go wrong.  Subsequent patches will teach critical
> utilities to exit with EXIT_FAILURE when this happens.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/xfs_mount.h |    2 +
>  libxfs/init.c       |   96 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  libxfs/libxfs_io.h  |    7 ++++
>  libxfs/rdwr.c       |   38 ++++++++++++++++++--
>  4 files changed, 135 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 29b3cc1b..7bd23fbb 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -184,7 +184,7 @@ xfs_perag_resv(
>  
>  extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
>  				dev_t, dev_t, dev_t, int);
> -extern void	libxfs_umount (xfs_mount_t *);
> +int		libxfs_umount(struct xfs_mount *mp);
>  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
>  
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a0d4b7f4..d4804ead 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
>  	}
>  	btp->bt_mount = mp;
>  	btp->dev = dev;
> +	btp->flags = 0;
> +
>  	return btp;
>  }
>  
> @@ -791,17 +793,104 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
>  	mp->m_rsumip = mp->m_rbmip = NULL;
>  }
>  
> +/* Flush a device and report on writes that didn't make it to stable storage. */
> +static inline int
> +libxfs_flush_buftarg(
> +	struct xfs_buftarg	*btp,
> +	const char		*buftarg_descr)
> +{
> +	int			error = 0;
> +	int			err2;
> +
> +	/*
> +	 * Write verifier failures are evidence of a buggy program.  Make sure
> +	 * that this state is always reported to the caller.
> +	 */
> +	if (btp->flags & XFS_BUFTARG_CORRUPT_WRITE) {
> +		fprintf(stderr,
> +_("%s: Refusing to write a corrupt buffer to the %s!\n"),
> +				progname, buftarg_descr);
> +		error = -EFSCORRUPTED;
> +	}
> +
> +	if (btp->flags & XFS_BUFTARG_LOST_WRITE) {
> +		fprintf(stderr,
> +_("%s: Lost a write to the %s!\n"),
> +				progname, buftarg_descr);
> +		if (!error)
> +			error = -EIO;
> +	}
> +
> +	err2 = libxfs_blkdev_issue_flush(btp);
> +	if (err2) {
> +		fprintf(stderr,
> +_("%s: Flushing the %s failed, err=%d!\n"),
> +				progname, buftarg_descr, -err2);
> +	}
> +	if (!error)
> +		error = err2;
> +
> +	return error;
> +}
> +
> +/*
> + * Flush all dirty buffers to stable storage and report on writes that didn't
> + * make it to stable storage.
> + */
> +static int
> +libxfs_flush_mount(
> +	struct xfs_mount	*mp)
> +{
> +	int			error = 0;
> +	int			err2;
> +
> +	/*
> +	 * Purge the buffer cache to write all dirty buffers to disk and free
> +	 * all incore buffers.  Buffers that fail write verification will cause
> +	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
> +	 * cannot be written will cause the LOST_WRITE flag to be set in the
> +	 * buftarg.
> +	 */
> +	libxfs_bcache_purge();
> +
> +	/* Flush all kernel and disk write caches, and report failures. */
> +	if (mp->m_ddev_targp) {
> +		err2 = libxfs_flush_buftarg(mp->m_ddev_targp, _("data device"));
> +		if (!error)
> +			error = err2;
> +	}
> +
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> +		err2 = libxfs_flush_buftarg(mp->m_logdev_targp,
> +				_("log device"));
> +		if (!error)
> +			error = err2;
> +	}
> +
> +	if (mp->m_rtdev_targp) {
> +		err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,
> +				_("realtime device"));
> +		if (!error)
> +			error = err2;
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * Release any resource obtained during a mount.
>   */
> -void
> -libxfs_umount(xfs_mount_t *mp)
> +int
> +libxfs_umount(
> +	struct xfs_mount	*mp)
>  {
>  	struct xfs_perag	*pag;
>  	int			agno;
> +	int			error;
>  
>  	libxfs_rtmount_destroy(mp);
> -	libxfs_bcache_purge();
> +
> +	error = libxfs_flush_mount(mp);
>  
>  	for (agno = 0; agno < mp->m_maxagi; agno++) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> @@ -816,6 +905,7 @@ libxfs_umount(xfs_mount_t *mp)
>  		kmem_free(mp->m_logdev_targp);
>  	kmem_free(mp->m_ddev_targp);
>  
> +	return error;
>  }
>  
>  /*
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 579df52b..6bb75a67 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -23,10 +23,17 @@ struct xfs_perag;
>  struct xfs_buftarg {
>  	struct xfs_mount	*bt_mount;
>  	dev_t			dev;
> +	unsigned int		flags;
>  };
>  
> +/* We purged a dirty buffer and lost a write. */
> +#define XFS_BUFTARG_LOST_WRITE		(1 << 0)
> +/* A dirty buffer failed the write verifier. */
> +#define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
> +
>  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
>  				    dev_t logdev, dev_t rtdev);
> +int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
>  
>  #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 8b47d438..4253b890 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -17,6 +17,7 @@
>  #include "xfs_inode_fork.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> +#include "libfrog/platform.h"
>  
>  #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
>  
> @@ -1219,6 +1220,19 @@ libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
>  	}
>  }
>  
> +/* Complain about (and remember) dropping dirty buffers. */
> +static void
> +libxfs_whine_dirty_buf(
> +	struct xfs_buf		*bp)
> +{
> +	fprintf(stderr, _("%s: Releasing dirty buffer to free list!\n"),
> +			progname);
> +
> +	if (bp->b_error == -EFSCORRUPTED)
> +		bp->b_target->flags |= XFS_BUFTARG_CORRUPT_WRITE;
> +	bp->b_target->flags |= XFS_BUFTARG_LOST_WRITE;
> +}
> +
>  static void
>  libxfs_brelse(
>  	struct cache_node	*node)
> @@ -1228,8 +1242,7 @@ libxfs_brelse(
>  	if (!bp)
>  		return;
>  	if (bp->b_flags & LIBXFS_B_DIRTY)
> -		fprintf(stderr,
> -			"releasing dirty buffer to free list!\n");
> +		libxfs_whine_dirty_buf(bp);
>  
>  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
>  	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> @@ -1249,8 +1262,7 @@ libxfs_bulkrelse(
>  
>  	list_for_each_entry(bp, list, b_node.cn_mru) {
>  		if (bp->b_flags & LIBXFS_B_DIRTY)
> -			fprintf(stderr,
> -				"releasing dirty buffer (bulk) to free list!\n");
> +			libxfs_whine_dirty_buf(bp);
>  		count++;
>  	}
>  
> @@ -1479,6 +1491,24 @@ libxfs_irele(
>  	kmem_cache_free(xfs_inode_zone, ip);
>  }
>  
> +/*
> + * Flush everything dirty in the kernel and disk write caches to stable media.
> + * Returns 0 for success or a negative error code.
> + */
> +int
> +libxfs_blkdev_issue_flush(
> +	struct xfs_buftarg	*btp)
> +{
> +	int			fd, ret;
> +
> +	if (btp->dev == 0)
> +		return 0;
> +
> +	fd = libxfs_device_to_fd(btp->dev);
> +	ret = platform_flush_device(fd, btp->dev);
> +	return ret ? -errno : 0;
> +}
> +
>  /*
>   * Write out a buffer list synchronously.
>   *
> 

