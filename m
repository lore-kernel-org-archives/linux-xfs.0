Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424F6C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBEE20658
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZTl32g4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgCFRMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:12:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgCFRMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 12:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583514726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/GUW9CcI96lFGfpcIa5ZwgP0u8NZJRc+ef1XxjdTgCg=;
        b=BZTl32g4KCGo0BEvL24LSsPBsTkvxklmSm31Lcoywrg/MY3wGLNkSA3wfMlyGBIVSt9nUF
        tCqFooKu6H7/cpBhVpN6fYAl0rsoR1/UlnT3l7cstTynVH3JIxP4RJ/yYYkJ9XzV+cuiSS
        9tMYzPb9IZI78H6nSnQg/F8ukYif0oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-QGQ_DNpZPiODSmZtp9BfeQ-1; Fri, 06 Mar 2020 12:12:04 -0500
X-MC-Unique: QGQ_DNpZPiODSmZtp9BfeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6DA7184C804;
        Fri,  6 Mar 2020 17:12:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38BD673892;
        Fri,  6 Mar 2020 17:12:03 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:12:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: remove the aborted parameter to
 xlog_state_done_syncing
Message-ID: <20200306171201.GG2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:34AM -0700, Christoph Hellwig wrote:
> We can just check for a shut down log all the way down in
> xlog_cil_committed instead of passing the parameter.  This means a
> slight behavior change in that we now also abort log items if the
> shutdown came in halfway into the I/O completion processing, which
> actually is the right thing to do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 48 +++++++++++++++-----------------------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c | 11 +++++-----
>  3 files changed, 22 insertions(+), 39 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..b5c4a45c208c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -878,7 +877,7 @@ xlog_cil_push(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, true);
> +	xlog_cil_committed(ctx);

Error paths like this might warrant an assert. It's not really clear
that we expect to be shutdown based on the context. Otherwise looks Ok.

Brian

>  	return -EIO;
>  }
>  
> -- 
> 2.24.1
> 

