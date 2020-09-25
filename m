Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36468C4363D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 11:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B7F221E5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 11:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4bIB2x2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgIYLPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 07:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgIYLPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 07:15:20 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601032519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KwQifF0EEbGBnq2JcV+2TZVNKkBIjg5mcHkf0NJR6Rg=;
        b=G4bIB2x2bwnCL7zRdH1n4fHfKWBNaJXKQXYxai8zK1mH16v6/zE+omlp3AxU9W0EqjsKGs
        KW/VPD62Q5h51S2+aewVf+ySKdGrd2NAqAHh3NBdwtDPUi3UTSPP32GWWqLSdwLDdn7T9h
        otqTI3wNTDgGGKFYpOM/rjy0SQ+iUcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-OacAWxMeOyK3jEggnEcndw-1; Fri, 25 Sep 2020 07:15:15 -0400
X-MC-Unique: OacAWxMeOyK3jEggnEcndw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 092EE1007474;
        Fri, 25 Sep 2020 11:15:14 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86BE55C1C7;
        Fri, 25 Sep 2020 11:15:13 +0000 (UTC)
Date:   Fri, 25 Sep 2020 07:15:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: expose the log push threshold
Message-ID: <20200925111511.GA2646051@bfoster>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919333.1401135.1467785318303966214.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160083919333.1401135.1467785318303966214.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 10:33:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Separate the computation of the log push threshold and the push logic in
> xlog_grant_push_ail.  This enables higher level code to determine (for
> example) that it is holding on to a logged intent item and the log is so
> busy that it is more than 75% full.  In that case, it would be desirable
> to move the log item towards the head to release the tail, which we will
> cover in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c |   41 +++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_log.h |    2 ++
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ad0c69ee8947..62c9e0aaa7df 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1475,14 +1475,15 @@ xlog_commit_record(
>  }
>  
>  /*
> - * Push on the buffer cache code if we ever use more than 75% of the on-disk
> - * log space.  This code pushes on the lsn which would supposedly free up
> - * the 25% which we want to leave free.  We may need to adopt a policy which
> - * pushes on an lsn which is further along in the log once we reach the high
> - * water mark.  In this manner, we would be creating a low water mark.
> + * Compute the LSN push target needed to push on the buffer cache code if we
> + * ever use more than 75% of the on-disk log space.  This code pushes on the
> + * lsn which would supposedly free up the 25% which we want to leave free.  We
> + * may need to adopt a policy which pushes on an lsn which is further along in
> + * the log once we reach the high water mark.  In this manner, we would be
> + * creating a low water mark.
>   */

Probably no need to duplicate so much of the original comment between
the two functions. I'd just put something like "calculate the AIL push
target based on the provided log reservation requirement ..." or
otherwise just remove it. That aside, LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -STATIC void
> -xlog_grant_push_ail(
> +xfs_lsn_t
> +xlog_grant_push_threshold(
>  	struct xlog	*log,
>  	int		need_bytes)
>  {
> @@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
>  	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
>  	free_threshold = max(free_threshold, 256);
>  	if (free_blocks >= free_threshold)
> -		return;
> +		return NULLCOMMITLSN;
>  
>  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
>  						&threshold_block);
> @@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
>  	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
>  		threshold_lsn = last_sync_lsn;
>  
> +	return threshold_lsn;
> +}
> +
> +/*
> + * Push on the buffer cache code if we ever use more than 75% of the on-disk
> + * log space.  This code pushes on the lsn which would supposedly free up
> + * the 25% which we want to leave free.  We may need to adopt a policy which
> + * pushes on an lsn which is further along in the log once we reach the high
> + * water mark.  In this manner, we would be creating a low water mark.
> + */
> +STATIC void
> +xlog_grant_push_ail(
> +	struct xlog	*log,
> +	int		need_bytes)
> +{
> +	xfs_lsn_t	threshold_lsn;
> +
> +	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> +	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> +		return;
> +
>  	/*
>  	 * Get the transaction layer to kick the dirty buffers out to
>  	 * disk asynchronously. No point in trying to do this if
>  	 * the filesystem is shutting down.
>  	 */
> -	if (!XLOG_FORCED_SHUTDOWN(log))
> -		xfs_ail_push(log->l_ailp, threshold_lsn);
> +	xfs_ail_push(log->l_ailp, threshold_lsn);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 1412d6993f1e..58c3fcbec94a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  bool	xfs_log_in_recovery(struct xfs_mount *);
>  
> +xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> +
>  #endif	/* __XFS_LOG_H__ */
> 

