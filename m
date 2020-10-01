Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B02C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B629220897
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i9mS8sZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJARdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:33:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732096AbgJARdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601573582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fvt9oWz0oUi1alyD5eJkg/Y8tjfJzr7xC0suBsZZKBE=;
        b=i9mS8sZvUHFk9ms076WJEjHYvbUVWbXPgyWECfCRELX7RKNZ/RE5AOO2X/XW4lj8Ma/QrZ
        j9OYiIJ8xTG8wuB+cRnXojv0hPHOkq4cH9ANkLdcuEenmfEEoMBgCJW4JJ0DpJmEglLrjf
        lwImcZeV3Q8tPVcrYer/UbQaOCgextg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-hJNSORIGOHWugmM2oMJPqw-1; Thu, 01 Oct 2020 13:32:59 -0400
X-MC-Unique: hJNSORIGOHWugmM2oMJPqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90F0C80365A;
        Thu,  1 Oct 2020 17:32:58 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 091D1702E7;
        Thu,  1 Oct 2020 17:32:57 +0000 (UTC)
Date:   Thu, 1 Oct 2020 13:32:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 5/5] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20201001173256.GG112884@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140142459.830233.7194402837807253154.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140142459.830233.7194402837807253154.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:44AM -0700, Darrick J. Wong wrote:
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

Much nicer, and FWIW this is pretty much the approach I was wondering
about wrt to the block reservation in the previous patch..

>  fs/xfs/libxfs/xfs_defer.c |    9 +++++++++
>  fs/xfs/libxfs/xfs_defer.h |    1 +
>  fs/xfs/xfs_log_recover.c  |    4 ++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0cceebb390c4..4caaf5527403 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -579,6 +579,15 @@ xfs_defer_ops_capture(
>  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
>  	tp->t_blk_res = tp->t_blk_res_used;
>  
> +	/*
> +	 * Preserve the transaction reservation type.  The logcount is
> +	 * hardwired to 1 to so that we can make forward progress in recovery
> +	 * no matter how full the log might be, at a cost of more regrants.
> +	 */
> +	dfc->dfc_tres.tr_logres = tp->t_log_res;
> +	dfc->dfc_tres.tr_logcount = 1;
> +	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;

Any real need to allocate these last two fields in every captured chain
when they're basically hardcoded? If not, it might be a bit more
efficient to put an xfs_trans_res on the stack in
xlog_finish_defer_ops() and just save the logres value here.

Brian

> +
>  	return dfc;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index b1c7b761afd5..c447c79bbe74 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -76,6 +76,7 @@ struct xfs_defer_capture {
>  	struct list_head	dfc_dfops;
>  	unsigned int		dfc_tpflags;
>  	unsigned int		dfc_blkres;
> +	struct xfs_trans_res	dfc_tres;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b06c9881a13d..46e750279634 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2442,8 +2442,8 @@ xlog_finish_defer_ops(
>  	int			error = 0;
>  
>  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
> -				0, XFS_TRANS_RESERVE, &tp);
> +		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
> +				XFS_TRANS_RESERVE, &tp);
>  		if (error)
>  			return error;
>  
> 

