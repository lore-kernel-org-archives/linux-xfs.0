Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95308C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5458120716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TrZmAy+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCESIP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:08:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50423 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbgCESIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:08:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oin91n5KT759sYCKzAu4m/meInUhcVIOu8doqNtEuJA=;
        b=TrZmAy+rgJw64kaX8emdOLHq4fyWJNtIAS4JAZLGOD5YiySh64zeHV09IrTQGb3lh76TkE
        pQd4D07TFkqg90Lz04fEh+8ckLl4mQcWXZLWX/TheJe7q/wWvdr8jPYQwN0b0HnQJLJHip
        tlwQg3W01mhLPqqrsEl1rygm3VcHFTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-CBMWJtjxMvSIElnjzi7-Kw-1; Thu, 05 Mar 2020 13:08:11 -0500
X-MC-Unique: CBMWJtjxMvSIElnjzi7-Kw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13E8218A6EC0;
        Thu,  5 Mar 2020 18:08:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4E6F5D9C9;
        Thu,  5 Mar 2020 18:08:09 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:08:08 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: merge unmount record write iclog cleanup.
Message-ID: <20200305180808.GI28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-10-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The unmount iclog handling is duplicated in both
> xfs_log_unmount_write() and xfs_log_write_unmount_record(). We only
> need one copy of it in xfs_log_unmount_write() because that is the
> only function that calls xfs_log_write_unmount_record().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Any reason for the period at the end of the patch subject? I just
noticed it now, but the previous patch has one as well.

>  fs/xfs/xfs_log.c | 130 +++++++++++++++++------------------------------
>  1 file changed, 48 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bdf604d31d8c..a687c20dd77d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -931,61 +926,41 @@ xlog_unmount_write(
>  	}
>  
>  	error = xlog_write_unmount_record(log, tic, &lsn, flags);
> -	/*
> -	 * At this point, we're umounting anyway, so there's no point in
> -	 * transitioning log state to IOERROR. Just continue...
> -	 */
> -out_err:
> -	if (error)
> -		xfs_alert(mp, "%s: unmount record failed", __func__);
> -
> -	spin_lock(&log->l_icloglock);
> -	iclog = log->l_iclog;
> -	atomic_inc(&iclog->ic_refcnt);
> -	xlog_state_want_sync(log, iclog);
> -	error = xlog_state_release_iclog(log, iclog);
> -	switch (iclog->ic_state) {
> -	default:
> -		if (!XLOG_FORCED_SHUTDOWN(log)) {
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -		/* fall through */
> -	case XLOG_STATE_ACTIVE:
> -	case XLOG_STATE_DIRTY:
> +	if (error) {
> +		/* A full shutdown is unnecessary at this point of unmount */
> +		spin_lock(&log->l_icloglock);
> +		log->l_flags |= XLOG_IO_ERROR;

A previous patch added this to xlog_state_ioerror(). Nits aside, the
rest looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		xlog_state_ioerror(log);
>  		spin_unlock(&log->l_icloglock);
> -		break;
>  	}
>  
> -	if (tic) {
> -		trace_xfs_log_umount_write(log, tic);
> -		xlog_ungrant_log_space(log, tic);
> -		xfs_log_ticket_put(tic);
> -	}
> +	trace_xfs_log_umount_write(log, tic);
> +	xlog_ungrant_log_space(log, tic);
> +	xfs_log_ticket_put(tic);
> +out_err:
> +	if (error)
> +		xfs_alert(mp, "%s: unmount record failed", __func__);
> +	return error;
>  }
>  
>  /*
> - * Unmount record used to have a string "Unmount filesystem--" in the
> - * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
> - * We just write the magic number now since that particular field isn't
> - * currently architecture converted and "Unmount" is a bit foo.
> - * As far as I know, there weren't any dependencies on the old behaviour.
> + * Finalise the unmount by writing the unmount record to the log. This is the
> + * mark that the filesystem was cleanly unmounted.
> + *
> + * Avoid writing the unmount record on no-recovery mounts, ro-devices, or when
> + * the log has already been shut down.
>   */
> -
>  static int
> -xfs_log_unmount_write(xfs_mount_t *mp)
> +xfs_log_unmount_write(
> +	struct xfs_mount	*mp)
>  {
> -	struct xlog	 *log = mp->m_log;
> -	xlog_in_core_t	 *iclog;
> +	struct xlog		*log = mp->m_log;
> +	struct xlog_in_core	*iclog;
>  #ifdef DEBUG
> -	xlog_in_core_t	 *first_iclog;
> +	struct xlog_in_core	*first_iclog;
>  #endif
> -	int		 error;
> +	int			error;
>  
> -	/*
> -	 * Don't write out unmount record on norecovery mounts or ro devices.
> -	 * Or, if we are doing a forced umount (typically because of IO errors).
> -	 */
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
>  	    xfs_readonly_buftarg(log->l_targ)) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> @@ -1005,41 +980,32 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		iclog = iclog->ic_next;
>  	} while (iclog != first_iclog);
>  #endif
> -	if (! (XLOG_FORCED_SHUTDOWN(log))) {
> -		xlog_unmount_write(log);
> -	} else {
> -		/*
> -		 * We're already in forced_shutdown mode, couldn't
> -		 * even attempt to write out the unmount transaction.
> -		 *
> -		 * Go through the motions of sync'ing and releasing
> -		 * the iclog, even though no I/O will actually happen,
> -		 * we need to wait for other log I/Os that may already
> -		 * be in progress.  Do this as a separate section of
> -		 * code so we'll know if we ever get stuck here that
> -		 * we're in this odd situation of trying to unmount
> -		 * a file system that went into forced_shutdown as
> -		 * the result of an unmount..
> -		 */
> -		spin_lock(&log->l_icloglock);
> -		iclog = log->l_iclog;
> -		atomic_inc(&iclog->ic_refcnt);
> -		xlog_state_want_sync(log, iclog);
> -		error =  xlog_state_release_iclog(log, iclog);
> -		switch (iclog->ic_state) {
> -		case XLOG_STATE_ACTIVE:
> -		case XLOG_STATE_DIRTY:
> -		case XLOG_STATE_IOERROR:
> -			spin_unlock(&log->l_icloglock);
> -			break;
> -		default:
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -	}
>  
> +	if (!XLOG_FORCED_SHUTDOWN(log))
> +		error = xlog_unmount_write(log);
> +
> +	/*
> +	 * Sync and release the current iclog so the unmount record gets to
> +	 * disk. If we are in a shutdown state, no IO will be done, but we still
> +	 * we need to wait for other log I/Os that may already be in progress.
> +	 */
> +	spin_lock(&log->l_icloglock);
> +	iclog = log->l_iclog;
> +	atomic_inc(&iclog->ic_refcnt);
> +	xlog_state_want_sync(log, iclog);
> +	error =  xlog_state_release_iclog(log, iclog);
> +	switch (iclog->ic_state) {
> +	case XLOG_STATE_ACTIVE:
> +	case XLOG_STATE_DIRTY:
> +	case XLOG_STATE_IOERROR:
> +		spin_unlock(&log->l_icloglock);
> +		break;
> +	default:
> +		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +		break;
> +	}
>  	return error;
> -}	/* xfs_log_unmount_write */
> +}
>  
>  /*
>   * Empty the log for unmount/freeze.
> -- 
> 2.24.0.rc0
> 

