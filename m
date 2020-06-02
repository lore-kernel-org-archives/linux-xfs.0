Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F533C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ABA120738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJbN7DH3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgFBQqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:46:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726875AbgFBQqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591116362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3EiAsdVu829vC5YNtiFk/wLTuVcy/gRv6TvRWnNW27s=;
        b=TJbN7DH374DPfLQfpBWOreGunHEB4ltoUwLV1c8rqXDD5BDoVen7FsVu2lraUj3yCQnle/
        6X9ml3daaoXINhfG2fDxve/pqjpRTLADQjvuIAZKc5hSX0waoTsUCq1jkcwf/97f0PXdo8
        /AIYBTJgdShthzELSF2/eAuYmYJX/Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-s6jZ6z7NOhavhgIlRXsOLw-1; Tue, 02 Jun 2020 12:46:00 -0400
X-MC-Unique: s6jZ6z7NOhavhgIlRXsOLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6263DA0BD7;
        Tue,  2 Jun 2020 16:45:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9AF161992;
        Tue,  2 Jun 2020 16:45:58 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:45:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/30] xfs: mark log recovery buffers for completion
Message-ID: <20200602164557.GF7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-7-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Log recovery has it's own buffer write completion handler for
> buffers that it directly recovers. Convert these to direct calls by
> flagging these buffers as being log recovery buffers. The flag will
> get cleared by the log recovery IO completion routine, so it will
> never leak out of log recovery.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c                | 10 ++++++++++
>  fs/xfs/xfs_buf.h                |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   |  5 ++---
>  fs/xfs/xfs_dquot_item_recover.c |  2 +-
>  fs/xfs/xfs_inode_item_recover.c |  2 +-
>  fs/xfs/xfs_log_recover.c        |  5 ++---
>  6 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3bffde8640a52..0a69de674af9d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_log_recover.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
> @@ -1207,6 +1208,15 @@ xfs_buf_ioend(
>  	if (read)
>  		goto out_finish;
>  
> +	/*
> +	 * If this is a log recovery buffer, we aren't doing transactional IO
> +	 * yet so we need to let it handle IO completions.
> +	 */
> +	if (bp->b_flags & _XBF_LOGRECOVERY) {
> +		xlog_recover_iodone(bp);
> +		return;
> +	}
> +
>  	if (bp->b_flags & _XBF_INODES) {
>  		xfs_buf_inode_iodone(bp);
>  		return;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index c1d0843206dd6..30dabc5bae96d 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -33,6 +33,7 @@
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1 << 16)/* inode buffer */
>  #define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
> +#define _XBF_LOGRECOVERY	 (1 << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -56,6 +57,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_DQUOTS,		"DQUOTS" }, \
> +	{ _XBF_LOGRECOVERY,		"LOG_RECOVERY" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 04faa7310c4f0..74c851f60eeeb 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -419,8 +419,7 @@ xlog_recover_validate_buf_type(
>  	if (bp->b_ops) {
>  		struct xfs_buf_log_item	*bip;
>  
> -		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
> -		bp->b_iodone = xlog_recover_iodone;
> +		bp->b_flags |= _XBF_LOGRECOVERY;
>  		xfs_buf_item_init(bp, mp);
>  		bip = bp->b_log_item;
>  		bip->bli_item.li_lsn = current_lsn;
> @@ -963,7 +962,7 @@ xlog_recover_buf_commit_pass2(
>  		error = xfs_bwrite(bp);
>  	} else {
>  		ASSERT(bp->b_mount == mp);
> -		bp->b_iodone = xlog_recover_iodone;
> +		bp->b_flags |= _XBF_LOGRECOVERY;
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  	}
>  
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 3400be4c88f08..f9ea9f55aa7cc 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -153,7 +153,7 @@ xlog_recover_dquot_commit_pass2(
>  
>  	ASSERT(dq_f->qlf_size == 2);
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> +	bp->b_flags |= _XBF_LOGRECOVERY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index dc3e26ff16c90..5e0d291835b35 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -376,7 +376,7 @@ xlog_recover_inode_commit_pass2(
>  	xfs_dinode_calc_crc(log->l_mp, dip);
>  
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> +	bp->b_flags |= _XBF_LOGRECOVERY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a..52a65a74208ff 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -287,9 +287,8 @@ xlog_recover_iodone(
>  	if (bp->b_log_item)
>  		xfs_buf_item_relse(bp);
>  	ASSERT(bp->b_log_item == NULL);
> -
> -	bp->b_iodone = NULL;
> -	xfs_buf_ioend(bp);
> +	bp->b_flags &= ~_XBF_LOGRECOVERY;
> +	xfs_buf_ioend_finish(bp);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 

