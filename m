Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB8DC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 10:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3670120708
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 10:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UiaBpoKr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgJBKjy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 06:39:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgJBKjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 06:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601635193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RMDWoXuhjmtvNLJSjMUAFDWElheLWoxMVXFqWIgqNPE=;
        b=UiaBpoKrJM0rD+34s4v+D/b8nhKa6Ye85k8WcF+Z0BoomsSiXQlJ3DgsmMynWchY4g7dHO
        Rd+/SGDnPlzSUDnpusPAATdlwYPl+3j3vp8uiZyu7yBLNU/C/AZ238IfvUK7+JfvICB/X+
        HcVhmV/PTNIMx3cPB99ZTiQ8nqcGuxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-K5NLTWYwM_qU9PPw3PNsIA-1; Fri, 02 Oct 2020 06:39:49 -0400
X-MC-Unique: K5NLTWYwM_qU9PPw3PNsIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AEEF1019627;
        Fri,  2 Oct 2020 10:39:48 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB14973677;
        Fri,  2 Oct 2020 10:39:47 +0000 (UTC)
Date:   Fri, 2 Oct 2020 06:39:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v4.2 5/5] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20201002103946.GB193265@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140142459.830233.7194402837807253154.stgit@magnolia>
 <20201002042103.GU49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002042103.GU49547@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:21:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should record the transaction reservation type
> from the old transaction so that when we continue the dfops chain, we
> still use the same reservation parameters.
> 
> Doing this means that the log item recovery functions get to determine
> the transaction reservation instead of abusing tr_itruncate in yet
> another part of xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4.2: save only the log reservation, and hardcode logcount and flags.
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c |    3 +++
>  fs/xfs/libxfs/xfs_defer.h |    3 +++
>  fs/xfs/xfs_log_recover.c  |   17 ++++++++++++++---
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 10aeae7353ab..e19dc1ced7e6 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -579,6 +579,9 @@ xfs_defer_ops_capture(
>  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
>  	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
>  
> +	/* Preserve the log reservation size. */
> +	dfc->dfc_logres = tp->t_log_res;
> +
>  	return dfc;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 5c0e59b69ffa..6cde6f0713f7 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -79,6 +79,9 @@ struct xfs_defer_capture {
>  	/* Block reservations for the data and rt devices. */
>  	unsigned int		dfc_blkres;
>  	unsigned int		dfc_rtxres;
> +
> +	/* Log reservation saved from the transaction. */
> +	unsigned int		dfc_logres;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1be5208e2a2f..001e1585ddc6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2442,9 +2442,20 @@ xlog_finish_defer_ops(
>  	int			error = 0;
>  
>  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> -				dfc->dfc_blkres, dfc->dfc_rtxres,
> -				XFS_TRANS_RESERVE, &tp);
> +		struct xfs_trans_res	resv;
> +
> +		/*
> +		 * Create a new transaction reservation from the captured
> +		 * information.  Set logcount to 1 to force the new transaction
> +		 * to regrant every roll so that we can make forward progress
> +		 * in recovery no matter how full the log might be.
> +		 */
> +		resv.tr_logres = dfc->dfc_logres;
> +		resv.tr_logcount = 1;
> +		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +
> +		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
> +				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
>  		if (error)
>  			return error;
>  
> 

