Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464AFC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8612073B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQFH2eRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFQJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:09:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32160 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgCFQJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 11:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583510962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmMGLBpRY2oEsJ3oeo+kwY+RweyNM5tK2z2o0GXmmT4=;
        b=eQFH2eRCcJTMs+MCBSsgwxEY9wuvGFh+gH2LdEGfZ7p2YQmUaqh0ep3daGqVLivKvvJHfR
        5RGIoDkkBbjV0sTaWn2ans6vmtRTlAgZ775lNvoru5N7guWVoNZ/EHV+KZrrRKDgKcBRqJ
        s6EZp/JeQOO7sgvUxowPlMgai9faL0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-lUX7nz3ePVmvR3RHLQQroQ-1; Fri, 06 Mar 2020 11:09:20 -0500
X-MC-Unique: lUX7nz3ePVmvR3RHLQQroQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5897E1005509;
        Fri,  6 Mar 2020 16:09:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F371F5C28D;
        Fri,  6 Mar 2020 16:09:18 +0000 (UTC)
Date:   Fri, 6 Mar 2020 11:09:17 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200306160917.GD2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:31AM -0700, Christoph Hellwig wrote:
> Remove the ignored return value from xfs_log_unmount_write, and also
> remove a rather pointless assert on the return value from xfs_log_force.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

I guess there's going to be obvious conflicts with Dave's series and
some of these changes. I'm just going to ignore that and you guys can
figure it out. :)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 796ff37d5bb5..fa499ddedb94 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -953,8 +953,7 @@ xfs_log_write_unmount_record(
>   * currently architecture converted and "Unmount" is a bit foo.
>   * As far as I know, there weren't any dependencies on the old behaviour.
>   */
> -
> -static int
> +static void
>  xfs_log_unmount_write(xfs_mount_t *mp)
>  {
>  	struct xlog	 *log = mp->m_log;
> @@ -962,7 +961,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  #ifdef DEBUG
>  	xlog_in_core_t	 *first_iclog;
>  #endif
> -	int		 error;
>  
>  	/*
>  	 * Don't write out unmount record on norecovery mounts or ro devices.
> @@ -971,11 +969,10 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
>  	    xfs_readonly_buftarg(log->l_targ)) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> -		return 0;
> +		return;
>  	}
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> -	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
> +	xfs_log_force(mp, XFS_LOG_SYNC);
>  
>  #ifdef DEBUG
>  	first_iclog = iclog = log->l_iclog;
> @@ -1007,7 +1004,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		iclog = log->l_iclog;
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_want_sync(log, iclog);
> -		error =  xlog_state_release_iclog(log, iclog);
> +		xlog_state_release_iclog(log, iclog);
>  		switch (iclog->ic_state) {
>  		case XLOG_STATE_ACTIVE:
>  		case XLOG_STATE_DIRTY:
> @@ -1019,9 +1016,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  			break;
>  		}
>  	}
> -
> -	return error;
> -}	/* xfs_log_unmount_write */
> +}
>  
>  /*
>   * Empty the log for unmount/freeze.
> -- 
> 2.24.1
> 

