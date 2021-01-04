Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9C8C433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 16:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F5822473
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 16:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbhADQZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbhADQZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 11:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609777439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vnb+cRxFTp9jgAwyYpJAnJI7PWnz4qiNqMQb5deCY4A=;
        b=hUqSiK6tKUhmY8v/aoJboELQBzmMtWry/YlXpe/gB9/J+Jt1T3cAt4RSq0fKxDGhvVkIqc
        ZBS5lhWjVSuxxM8oR8y9Mni0GHuotnuEjfdQh7Wp1sNXSnoO2R4UUenLram7sqJh9sj1zx
        U+HeLi8xvScSadH2KAPf8hgdaK8RYUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-Nd8t6xyPMRG_Mq5LmxPa3A-1; Mon, 04 Jan 2021 11:23:57 -0500
X-MC-Unique: Nd8t6xyPMRG_Mq5LmxPa3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FB06107ACE4;
        Mon,  4 Jan 2021 16:23:56 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B4BD71C88;
        Mon,  4 Jan 2021 16:23:55 +0000 (UTC)
Date:   Mon, 4 Jan 2021 11:23:53 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210104162353.GA254939@bfoster>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230221611.GC164134@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 31, 2020 at 09:16:11AM +1100, Dave Chinner wrote:
> On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> > Threads, which committed items to the CIL, wait in the xc_push_wait
> > waitqueue when used_space in the push context goes over a limit. These
> > threads need to be woken when the CIL is pushed.
> > 
> > The CIL push worker tries to avoid the overhead of calling wake_all()
> > when there are no waiters waiting. It does so by checking the same
> > condition which caused the waits to happen. This, however, is
> > unreliable, because ctx->space_used can actually decrease when items are
> > recommitted.
> 
> When does this happen?
> 
> Do you have tracing showing the operation where the relogged item
> has actually gotten smaller? By definition, relogging in the CIL
> should only grow the size of the object in the CIL because it must
> relog all the existing changes on top of the new changed being made
> to the object. Hence the CIL reservation should only ever grow.
> 
> IOWs, returning negative lengths from the formatting code is
> unexpected and probably a bug and requires further investigation,
> not papering over the occurrence with broadcast wakeups...
> 

I agree that this warrants a bit more explanation and analysis before
changing the current code...

> > If the value goes below the limit while some threads are
> > already waiting but before the push worker gets to it, these threads are
> > not woken.
> > 
> > Always wake all CIL push waiters. Test with waitqueue_active() as an
> > optimization. This is possible, because we hold the xc_push_lock
> > spinlock, which prevents additions to the waitqueue.
> > 
> > Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
> > ---
> >  fs/xfs/xfs_log_cil.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index b0ef071b3cb5..d620de8e217c 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -670,7 +670,7 @@ xlog_cil_push_work(
> >  	/*
> >  	 * Wake up any background push waiters now this context is being pushed.
> >  	 */
> > -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> > +	if (waitqueue_active(&cil->xc_push_wait))
> >  		wake_up_all(&cil->xc_push_wait);
> 
> That just smells wrong to me. It *might* be correct, but this
> condition should pair with the sleep condition, as space used by a
> CIL context should never actually decrease....
> 

... but I'm a little confused by this assertion. The shadow buffer
allocation code refers to the possibility of shadow buffers falling out
that are smaller than currently allocated buffers. Further, the
_insert_format_items() code appears to explicitly optimize for this
possibility by reusing the active buffer, subtracting the old size/count
values from the diff variables and then reformatting the latest
(presumably smaller) item to the lv.

Of course this could just be implementation detail. I haven't dug into
the details in the remainder of this thread and I don't have specific
examples off the top of my head, but perhaps based on the ability of
various structures to change formats and the ability of log vectors to
shrink in size, shouldn't we expect the possibility of a CIL context to
shrink in size as well? Just from poking around the CIL it seems like
the surrounding code supports it (xlog_cil_insert_items() checks len > 0
for recalculating split res as well)...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

