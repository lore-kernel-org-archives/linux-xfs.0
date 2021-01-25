Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E55C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 03:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C113D230FF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbhAYNR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 08:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728742AbhAYNRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 08:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611580583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Rf/zmDx3KbTAWfh7isQuBh9MORfky0bg2e0fYoTGQw=;
        b=WhMWtI3gl+hrI5qIQAfif3wVyFkK1Qso7yvy1G6EV85JFre/GcGUmaLdLg/bPT4nNfY7uo
        1Xlu3Ltjd7RHV3IWZIJug9dZyl8hxZrP6nAxhVshwf2SSeu0dOu7YiI6T6CohYyCN1QSEM
        vM+5RVTh2XytwKk1ZfWtq1bgNP3yyFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-2rtBcTY8PKG3Q55ObeW0Iw-1; Mon, 25 Jan 2021 08:16:21 -0500
X-MC-Unique: 2rtBcTY8PKG3Q55ObeW0Iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EFED1005504;
        Mon, 25 Jan 2021 13:16:20 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32D065C1C5;
        Mon, 25 Jan 2021 13:16:19 +0000 (UTC)
Date:   Mon, 25 Jan 2021 08:16:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210125131618.GA2047559@bfoster>
References: <20210122164643.620257-1-hch@lst.de>
 <20210122164643.620257-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122164643.620257-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 22, 2021 at 05:46:43PM +0100, Christoph Hellwig wrote:
> If the inode is not pinned by the time fsync is called we don't need the
> ilock to protect against concurrent clearing of ili_fsync_fields as the
> inode won't need a log flush or clearing of these fields.  Not taking
> the iolock allows for full concurrency of fsync and thus O_DSYNC
> completions with io_uring/aio write submissions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 588232c77f11e0..ffe2d7c37e26cd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -200,7 +200,14 @@ xfs_file_fsync(
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
> -	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> +	/*
> +	 * Any inode that has dirty modifications in the log is pinned.  The
> +	 * racy check here for a pinned inode while not catch modifications

s/while/will/ ?

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	 * that happen concurrently to the fsync call, but fsync semantics
> +	 * only require to sync previously completed I/O.
> +	 */
> +	if (xfs_ipincount(ip))
> +		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
>  
>  	/*
>  	 * If we only have a single device, and the log force about was
> -- 
> 2.29.2
> 

