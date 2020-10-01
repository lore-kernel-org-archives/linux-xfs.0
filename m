Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE80C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 16:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1314208C7
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 16:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKtvNcQh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgJAQDE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732588AbgJAQDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 12:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601568182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsrkwmjGvtUVfp2m2SGNCdKwSmt2zl2yplp24M9nZ4A=;
        b=IKtvNcQhyikh4ewRbFrzy/PjaACuJEOmJR4hK9EzwYl2qCvp2uxiMxrZ4qjhxM11YFxNuw
        ieqWsEt4RU0GeWjrzTeTTP1PetzdPbWmGCmyqvv0MW/UFtyFjmBOZ14AncxVFZR0ODuJqU
        /d4gwEqkLgXRsRavTC6admgKcTcBWzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-STEzPzaXOei7kUPPQYlxYA-1; Thu, 01 Oct 2020 12:03:00 -0400
X-MC-Unique: STEzPzaXOei7kUPPQYlxYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11EE1101FFAA;
        Thu,  1 Oct 2020 16:02:59 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BC595D9DD;
        Thu,  1 Oct 2020 16:02:58 +0000 (UTC)
Date:   Thu, 1 Oct 2020 12:02:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: only relog deferred intent items if free space
 in the log gets low
Message-ID: <20201001160256.GB112884@bfoster>
References: <160140144925.831337.14031530940286104610.stgit@magnolia>
 <160140147498.831337.5344692693382121188.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140147498.831337.5344692693382121188.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:44:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have the ability to ask the log how far the tail needs to be
> pushed to maintain its free space targets, augment the decision to relog
> an intent item so that we only do it if the log has hit the 75% full
> threshold.  There's no point in relogging an intent into the same
> checkpoint, and there's no need to relog if there's plenty of free space
> in the log.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 554777d1069c..2ba02f2e59a1 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -356,7 +356,10 @@ xfs_defer_relog(
>  	struct xfs_trans		**tpp,
>  	struct list_head		*dfops)
>  {
> +	struct xlog			*log = (*tpp)->t_mountp->m_log;
>  	struct xfs_defer_pending	*dfp;
> +	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
> +
>  
>  	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
> @@ -372,6 +375,19 @@ xfs_defer_relog(
>  		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
>  			continue;
>  
> +		/*
> +		 * Figure out where we need the tail to be in order to maintain
> +		 * the minimum required free space in the log.  Only sample
> +		 * the log threshold once per call.
> +		 */
> +		if (threshold_lsn == NULLCOMMITLSN) {
> +			threshold_lsn = xlog_grant_push_threshold(log, 0);
> +			if (threshold_lsn == NULLCOMMITLSN)
> +				break;
> +		}

FWIW, this looks slightly different from the referenced repo again. :P
It might be good practice to create a -v# branch for patches sent to the
list and to keep that one stable for the associated review cycle.

That aside, I'm not quite clear where we stand with this patch. My
preference was to keep it unless there was some fundamental correctness
issue that I'm not aware of. I think your and Dave's preference was to
drop it. So either way, for posterity:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		if (XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
> +			continue;
> +
>  		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
>  		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
>  		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> 

