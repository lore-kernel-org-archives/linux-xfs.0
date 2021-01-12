Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E580C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5055923132
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbhALPgR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:36:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390169AbhALPgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 10:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610465691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DnOr9wJARqsCoAcd0pex9SefSCbnuGnZzvR+C8GJHI0=;
        b=BugtlaZyMEaZYUqRVSbE/rFFcGgsAWaoAieX2c6pUbvnYFWboDMrpFLFT7GRqm86O92sFb
        5jfjGbdLK5arE4FHI4la006EdHBXSC/INRg6RtfFTTXo7bTHbyE8TVI49Na6Pys0z7k7yr
        RKXE9VY9Bv2HRlHgHKqsri7UBhWzJs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-Y02uTZE_Nmq2z6f8_5NSQQ-1; Tue, 12 Jan 2021 10:34:48 -0500
X-MC-Unique: Y02uTZE_Nmq2z6f8_5NSQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3255D107ACF7;
        Tue, 12 Jan 2021 15:34:47 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C33365D9D2;
        Tue, 12 Jan 2021 15:34:46 +0000 (UTC)
Date:   Tue, 12 Jan 2021 10:34:44 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210112153444.GC1137163@bfoster>
References: <20210111161544.1414409-1-hch@lst.de>
 <20210111161544.1414409-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161544.1414409-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:15:44PM +0100, Christoph Hellwig wrote:
> If the inode is not pinned by the time fsync is called we don't need the
> ilock to protect against concurrent clearing of ili_fsync_fields as the
> inode won't need a log flush or clearing of these fields.  Not taking
> the iolock allows for full concurrency of fsync and thus O_DSYNC
> completions with io_uring/aio write submissions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

So this changes fsync semantics for when a concurrent modification might
already be in progress (but not yet complete) to essentially skip the
log force rather than serialize/wait and force. This seems.. reasonable
I suppose since nothign has committed at that point, but I feel like
could use more documentation and justification around that and why this
might be acceptable behavior.

Brian

>  fs/xfs/xfs_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 414d856e2e755a..ba02780dee6439 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -200,7 +200,8 @@ xfs_file_fsync(
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
> -	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> +	if (xfs_ipincount(ip))
> +		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
>  
>  	/*
>  	 * If we only have a single device, and the log force about was
> -- 
> 2.29.2
> 

