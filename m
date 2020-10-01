Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AA5C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A29C20872
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmgqXPWV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbgJARap (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732609AbgJARap (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601573444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFAd8PwGgi1/WjC2zmLklwOPsi/UeunMnDfLSOub+rk=;
        b=GmgqXPWVPIZY1HAD8yBeSd0/3xyMp294pdGZjynQKYsehx7lIWb/dosx92XywX0PgXP2dk
        rWNnAOhYiV4IM67eL+IkLwji8lnQN5Wlu0gqfQI81ZxX4ZzOBaOzEoXeU6gUL+rqw25nj8
        crwM2qKQsIekQIf4qqZEu+wN2mznhDM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-gnkDAvFCMUijXIvBXN_Hnw-1; Thu, 01 Oct 2020 13:30:43 -0400
X-MC-Unique: gnkDAvFCMUijXIvBXN_Hnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAA791891E86;
        Thu,  1 Oct 2020 17:30:41 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 432905C896;
        Thu,  1 Oct 2020 17:30:41 +0000 (UTC)
Date:   Thu, 1 Oct 2020 13:30:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 2/5] xfs: remove XFS_LI_RECOVERED
Message-ID: <20201001173039.GD112884@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140140527.830233.8494766872686671838.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140140527.830233.8494766872686671838.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The ->iop_recover method of a log intent item removes the recovered
> intent item from the AIL by logging an intent done item and committing
> the transaction, so it's superfluous to have this flag check.  Nothing
> else uses it, so get rid of the flag entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c |    8 +++-----
>  fs/xfs/xfs_trans.h       |    4 +---
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e0675071b39e..84f876c6d498 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2539,11 +2539,9 @@ xlog_recover_process_intents(
>  		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
> -		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
> -			spin_unlock(&ailp->ail_lock);
> -			error = lip->li_ops->iop_recover(lip, parent_tp);
> -			spin_lock(&ailp->ail_lock);
> -		}
> +		spin_unlock(&ailp->ail_lock);
> +		error = lip->li_ops->iop_recover(lip, parent_tp);
> +		spin_lock(&ailp->ail_lock);
>  		if (error)
>  			goto out;
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a71b4f443e39..ced62a35a62b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -55,14 +55,12 @@ struct xfs_log_item {
>  #define	XFS_LI_ABORTED	1
>  #define	XFS_LI_FAILED	2
>  #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
> -#define	XFS_LI_RECOVERED 4	/* log intent item has been recovered */
>  
>  #define XFS_LI_FLAGS \
>  	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
>  	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
>  	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> -	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
> -	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }
> +	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
>  
>  struct xfs_item_ops {
>  	unsigned flags;
> 

