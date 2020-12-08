Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1D8C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 17:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9EC23B28
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 17:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgLHRcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 12:32:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730670AbgLHRcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 12:32:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607448665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ryu5/EPoIN5j0k7cs/GZMbaemjRQ405ciCeSOPOTXn8=;
        b=OcoJgT7TTp0WUxdrn1Eei6fVdLYJCXn9RbrnqddV/If6ez0GyD8Qt3lCMS7wlp1JK2idsX
        +O2fW6jczdB0qlRrtnIoHri7lgSQpT4aGOJpAlvkfqRpVSqKaFz3nmLhgCfg6U0Y4qekId
        9JBz1OI5RgTWHHjyCO3GptUQLNqRTJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-Hqlj07uONM-vW0fpEpUeWA-1; Tue, 08 Dec 2020 12:31:03 -0500
X-MC-Unique: Hqlj07uONM-vW0fpEpUeWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FF28DF8AD;
        Tue,  8 Dec 2020 17:30:51 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CF125D6AB;
        Tue,  8 Dec 2020 17:30:50 +0000 (UTC)
Date:   Wed, 9 Dec 2020 01:45:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix the forward progress assertion in
 xfs_iwalk_run_callbacks
Message-ID: <20201208174559.GW14354@localhost.localdomain>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20201208171651.GA1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208171651.GA1943235@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 09:16:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 27c14b5daa82 we started tracking the last inode seen during an
> inode walk to avoid infinite loops if a corrupt inobt record happens to
> have a lower ir_startino than the record preceeding it.  Unfortunately,
> the assertion trips over the case where there are completely empty inobt
> records (which can happen quite easily on 64k page filesystems) because
> we advance the tracking cursor without actually putting the empty record
> into the processing buffer.  Fix the assert to allow for this case.
> 
> Reported-by: zlang@redhat.com
> Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good to me, and I just gave it a test on the same P9 machine which triggered
this bug, test passed.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  fs/xfs/xfs_iwalk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 2a45138831e3..eae3aff9bc97 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
>  	/* Delete cursor but remember the last record we cached... */
>  	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
>  	irec = &iwag->recs[iwag->nr_recs - 1];
> -	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
> +	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
>  
>  	error = xfs_iwalk_ag_recs(iwag);
>  	if (error)
> 

