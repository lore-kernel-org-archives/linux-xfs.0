Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E27C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C5D64F6E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhBBNTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:19:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232249AbhBBNTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 08:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612271905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JvoD0lP03jUr8ghFuuGJuQQSOnijvVpZ8DO+bgbhj1k=;
        b=N0H7WLQ+KjjLmbRTwYcEo3/o5MMqyLJcP5KVuuslhumJMpVKC6QXaK9hxwDjhhqS9GpDRq
        Qz7LhCWIAWlgdHJqKgThvDr9f7P590ohS2PogYgX+HljrCeU5n24VH6xqdaxu6OkF/Ki/u
        4kBvx4JH1X9pFg7otDg9NxARzU287Ew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-q-OaW6QDNaWJRYQhz7-F3A-1; Tue, 02 Feb 2021 08:13:53 -0500
X-MC-Unique: q-OaW6QDNaWJRYQhz7-F3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EDAB9CDA2;
        Tue,  2 Feb 2021 13:13:52 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB3AC5D763;
        Tue,  2 Feb 2021 13:13:51 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:13:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 16/16] xfs: shut down the filesystem if we screw up quota
 errors
Message-ID: <20210202131350.GF3336100@bfoster>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223148857.491593.12074155866887169690.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223148857.491593.12074155866887169690.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:04:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we ever screw up the quota reservations enough to trip the
> assertions, something's wrong with the quota code.  Shut down the
> filesystem when this happens, because this is corruption.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans_dquot.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index a1a72b7900c5..48e09ea30ee5 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -16,6 +16,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
> +#include "xfs_error.h"
>  
>  STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
>  
> @@ -691,9 +692,11 @@ xfs_trans_dqresv(
>  				    nblks);
>  		xfs_trans_mod_dquot(tp, dqp, XFS_TRANS_DQ_RES_INOS, ninos);
>  	}
> -	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
> -	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
> -	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
> +
> +	if (XFS_IS_CORRUPT(mp, dqp->q_blk.reserved < dqp->q_blk.count) ||
> +	    XFS_IS_CORRUPT(mp, dqp->q_rtb.reserved < dqp->q_rtb.count) ||
> +	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
> +		goto error_corrupt;
>  
>  	xfs_dqunlock(dqp);
>  	return 0;
> @@ -703,6 +706,10 @@ xfs_trans_dqresv(
>  	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
>  		return -ENOSPC;
>  	return -EDQUOT;
> +error_corrupt:
> +	xfs_dqunlock(dqp);
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return -EFSCORRUPTED;
>  }
>  
>  
> 

