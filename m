Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234ACC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D889D64E20
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhBVONr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 09:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232354AbhBVOM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 09:12:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6KPUd85tU8TFpS6PeiKizzY1NP5pW5a6up88tmrJEY=;
        b=c40SEIx1PJ01C7tGA0JcquTm8p6Q9ODfhopiAP6EjOw0CvbgkOi49PoLCuwz+NFITDP6sq
        45j8xMnAPs0V0NfE9oz0ZaTAWWEn3XygVV+Yh8wZiE4iuxphJMf8IobQCnoZIIU/fTe3aT
        9ZXD/7+5mHALbB/jEhiDuX+GWPLY84U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-x6EEBR5tOSWNZlubVDYkFw-1; Mon, 22 Feb 2021 09:11:28 -0500
X-MC-Unique: x6EEBR5tOSWNZlubVDYkFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1033803F62;
        Mon, 22 Feb 2021 14:11:27 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2007C2BFE3;
        Mon, 22 Feb 2021 14:11:27 +0000 (UTC)
Date:   Mon, 22 Feb 2021 09:11:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
Message-ID: <20210222141125.GA886774@bfoster>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370467918.2389661.3070940511114217130.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161370467918.2389661.3070940511114217130.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 07:17:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a hook to the buffer cache so that xfs_repair can intercept the
> first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
> event that xfs_repair dirties the filesystem and goes down, this ensures
> that the sysadmin will have to re-start repair before mounting.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Modulo Eric's feedback:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/xfs_mount.h |    4 ++
>  libxfs/rdwr.c       |    4 ++
>  repair/xfs_repair.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 109 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 75230ca5..f93a9f11 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -11,6 +11,8 @@ struct xfs_inode;
>  struct xfs_buftarg;
>  struct xfs_da_geometry;
>  
> +typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
> +
>  /*
>   * Define a user-level mount structure with all we need
>   * in order to make use of the numerous XFS_* macros.
> @@ -95,6 +97,8 @@ typedef struct xfs_mount {
>  		int	qi_dqperchunk;
>  	}			*m_quotainfo;
>  
> +	buf_writeback_fn	m_buf_writeback_fn;
> +
>  	/*
>  	 * xlog is defined in libxlog and thus is not intialized by libxfs. This
>  	 * allows an application to initialize and store a reference to the log
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index ac783ce3..ca272387 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -812,6 +812,10 @@ libxfs_bwrite(
>  		return bp->b_error;
>  	}
>  
> +	/* Trigger the writeback hook if there is one. */
> +	if (bp->b_mount->m_buf_writeback_fn)
> +		bp->b_mount->m_buf_writeback_fn(bp);
> +
>  	/*
>  	 * clear any pre-existing error status on the buffer. This can occur if
>  	 * the buffer is corrupt on disk and the repair process doesn't clear
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 90d1a95a..8eb7da53 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -725,7 +725,7 @@ clear_needsrepair(
>  	 * that everything is ok with the ondisk filesystem.  Make sure any
>  	 * dirty buffers are sent to disk and that the disks have persisted
>  	 * writes to stable storage.  If that fails, leave NEEDSREPAIR in
> -	 * place.  Don't purge the buffer cache here since we're not done yet.
> +	 * place.
>  	 */
>  	error = -libxfs_flush_mount(mp);
>  	if (error) {
> @@ -751,6 +751,102 @@ clear_needsrepair(
>  		libxfs_buf_relse(bp);
>  }
>  
> +static void
> +update_sb_crc_only(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
> +}
> +
> +/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
> +static void
> +force_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf_ops	fake_ops;
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> +	    xfs_sb_version_needsrepair(&mp->m_sb))
> +		return;
> +
> +	bp = libxfs_getsb(mp);
> +	if (!bp || bp->b_error) {
> +		do_log(
> +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> +				bp ? bp->b_error : ENOMEM);
> +	} else {
> +		/*
> +		 * It's possible that we need to set NEEDSREPAIR before we've
> +		 * had a chance to fix the summary counters in the primary sb.
> +		 * With the exception of those counters, phase 1 already
> +		 * ensured that the geometry makes sense.
> +		 *
> +		 * Bad summary counters in the primary super can cause the
> +		 * write verifier to fail, so substitute a dummy that only sets
> +		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
> +		 * the kernel from mounting our potentially damaged filesystem
> +		 * until repair is run again, so it's ok to bypass the usual
> +		 * verification in this one case.
> +		 */
> +		fake_ops = xfs_sb_buf_ops; /* struct copy */
> +		fake_ops.verify_write = update_sb_crc_only;
> +
> +		mp->m_sb.sb_features_incompat |=
> +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +		/* Force the primary super to disk immediately. */
> +		bp->b_ops = &fake_ops;
> +		error = -libxfs_bwrite(bp);
> +		bp->b_ops = &xfs_sb_buf_ops;
> +		if (error)
> +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> +	}
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +}
> +
> +/*
> + * Intercept the first non-super write to the filesystem so we can set
> + * NEEDSREPAIR to protect the filesystem from mount in case of a crash.
> + */
> +static void
> +repair_capture_writeback(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
> +
> +	/*
> +	 * This write hook ignores any buffer that looks like a superblock to
> +	 * avoid hook recursion when setting NEEDSREPAIR.  Higher level code
> +	 * modifying an sb must control the flag manually.
> +	 */
> +	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
> +		return;
> +
> +	pthread_mutex_lock(&wb_mutex);
> +
> +	/*
> +	 * If someone else already dropped the hook, then needsrepair has
> +	 * already been set on the filesystem and we can unlock.
> +	 */
> +	if (mp->m_buf_writeback_fn != repair_capture_writeback)
> +		goto unlock;
> +
> +	/*
> +	 * If we get here, the buffer being written is not a superblock, and
> +	 * needsrepair needs to be set.  The hook is kept in place to plug all
> +	 * other writes until the sb write finishes.
> +	 */
> +	force_needsrepair(mp);
> +	mp->m_buf_writeback_fn = NULL;
> +unlock:
> +	pthread_mutex_unlock(&wb_mutex);
> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -847,6 +943,10 @@ main(int argc, char **argv)
>  	if (verbose > 2)
>  		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
>  
> +	/* Capture the first writeback so that we can set needsrepair. */
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		mp->m_buf_writeback_fn = repair_capture_writeback;
> +
>  	/*
>  	 * set XFS-independent status vars from the mount/sb structure
>  	 */
> 

