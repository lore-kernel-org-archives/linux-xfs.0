Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3053EC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 10:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C630022283
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 10:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0YJNbkF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393195AbgJTKiu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393144AbgJTKiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Oct 2020 06:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603190329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSTsesIBzJQZb/lbzbzwgMUNZuTKjGzoKrb7YV1NSyM=;
        b=O0YJNbkFTK3tzeXwnj0GvVfJdvt9W8Q6C0aVbW+HA9gntX2doPGfU99CrKn80aMKw8Ywoa
        w4QWeoBg4zwBOBL/HOo+4pLzf2kmKU3zM4Ulz/7eBvDrQjdInQvjKsWG9h3M4bovGeVKtG
        hqCuJ7+9Ia7s2++l5tBcN/wwHSYDBCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-qzh9NhaVMmqi6fTX404n3g-1; Tue, 20 Oct 2020 06:38:47 -0400
X-MC-Unique: qzh9NhaVMmqi6fTX404n3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4509D107AD96;
        Tue, 20 Oct 2020 10:38:46 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E71A461983;
        Tue, 20 Oct 2020 10:38:45 +0000 (UTC)
Date:   Tue, 20 Oct 2020 06:38:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: cancel intents immediately if process_intents fails
Message-ID: <20201020103844.GC1263949@bfoster>
References: <20201019162917.GJ9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019162917.GJ9832@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 19, 2020 at 09:29:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If processing recovered log intent items fails, we need to cancel all
> the unprocessed recovered items immediately so that a subsequent AIL
> push in the bail out path won't get wedged on the pinned intent items
> that didn't get processed.
> 
> This can happen if the log contains (1) an intent that gets and releases
> an inode, (2) an intent that cannot be recovered successfully, and (3)
> some third intent item.  When recovery of (2) fails, we leave (3) pinned
> in memory.  Inode reclamation is called in the error-out path of
> xfs_mountfs before xfs_log_cancel_mount.  Reclamation calls
> xfs_ail_push_all_sync, which gets stuck waiting for (3).
> 
> Therefore, call xlog_recover_cancel_intents if _process_intents fails.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a8289adc1b29..87886b7f77da 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3446,6 +3446,14 @@ xlog_recover_finish(
>  		int	error;
>  		error = xlog_recover_process_intents(log);
>  		if (error) {
> +			/*
> +			 * Cancel all the unprocessed intent items now so that
> +			 * we don't leave them pinned in the AIL.  This can
> +			 * cause the AIL to livelock on the pinned item if
> +			 * anyone tries to push the AIL (inode reclaim does
> +			 * this) before we get around to xfs_log_mount_cancel.
> +			 */
> +			xlog_recover_cancel_intents(log);
>  			xfs_alert(log->l_mp, "Failed to recover intents");
>  			return error;
>  		}
> 

