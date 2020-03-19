Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536D3C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 11:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D7132071C
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 11:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3GtPu+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCSLgJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 07:36:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22684 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgCSLgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 07:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584617768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJwj1Iuiaz7Wugzh28GJw6P3r3pueMpnpODwCa2q82k=;
        b=B3GtPu+OyJ79kFUJvSyOwtCcJWX0IPzh92d8GybU5rWP8D6qH1IFv8Nd7FTpwcAKRRxzVT
        lL5Y7YNtmWj3vCPyzA4LK5RssogRSD7J3kwQGWuOjMkSM7wcjxDcLa4fmbphMvybTlW17y
        ncae2UvivPrF0/A4V1nBb2ynkQA/KlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-BI9elf79NpWhzhhIUTcZTg-1; Thu, 19 Mar 2020 07:36:06 -0400
X-MC-Unique: BI9elf79NpWhzhhIUTcZTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B14E68017CC;
        Thu, 19 Mar 2020 11:36:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E0425D9CD;
        Thu, 19 Mar 2020 11:36:05 +0000 (UTC)
Date:   Thu, 19 Mar 2020 07:36:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200319113603.GA37235@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-10-hch@lst.de>
 <20200318144825.GB32848@bfoster>
 <20200318163429.GA14701@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318163429.GA14701@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 05:34:29PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 18, 2020 at 10:48:25AM -0400, Brian Foster wrote:
> > >  		do {
> > > -			if (xlog_state_iodone_process_iclog(log, iclog,
> > > -							&ioerror))
> > > +			if (XLOG_FORCED_SHUTDOWN(log)) {
> > > +				xlog_state_do_iclog_callbacks(log, iclog);
> > > +				wake_up_all(&iclog->ic_force_wait);
> > > +				continue;
> > > +			}
> > > +
> > 
> > Why do we need to change the flow here? The current code looks like it
> > proceeds with the _do_iclog_callbacks() call below..
> >
> > As it is, I also don't think this reflects the comment above because if
> > we catch the shutdown partway through a loop, the outer loop will
> > execute one more time through. That doesn't look like a problem at a
> > glance, but I think we should try to retain closer to existing behavior
> > by folding the shutdown check into the ic_state check below as well as
> > the outer loop conditional.
> 
> True.  I think we just need to clear cycled_icloglock in the
> shutdown branch.  I prefer that flow over falling through to the
> main loop body as that clearly separates out the shutdown case.
> 

Sure, but a shutdown can still happen at any point so this is just a
duplicate branch to maintain.

> > This (and the next patch) also raises the issue of whether to maintain
> > state validity once the iclog ioerror state goes away. Currently we see
> > the IOERROR state and kind of have free reign on busting through the
> > normal runtime logic to clear out callbacks, etc. on the iclog
> > regardless of what the pre-error state was. It certainly makes sense to
> > continue to do that based on XLOG_FORCED_SHUTDOWN(), but the iclog state
> > sort of provides a platform that allows us to do that because any
> > particular context can see it and handle an iclog with care. With
> > IOERROR replaced with the (potentially racy) log flag check, I think we
> > should try to maintain the coherence of other states wherever possible.
> > IOW, XLOG_FORCED_SHUTDOWN() means we can run callbacks and abort and
> > whatnot, but we should probably still consider and update the iclog
> > state as we progress (as opposed to leaving it in the DONE_SYNC state,
> > for example) because there's no guarantee some other context will
> > (always) behave just as it did with IOERROR.
> 
> I actually very much disagree with that, and this series moves into
> the other direction.  We only really changes the states when
> writing to iclogs, syncing them to disk, and I/O completion.  And
> all the paths just error out at a high level when the log is shut
> down, so there is no need to move the state along.  Faking state
> changes when they don't correspond to the actual I/O just seems like
> a really bad idea.
> 

I think you're misreading me. I'm not suggesting to fake state changes.
I'd argue that's actually what the special case shutdown branch does.
And to the contrary, this patch already implements what I'm suggesting,
it's just not consistent behavior..

First, we basically already go from whatever state we're in to "logical
CALLBACK" during shutdown. This is just forcibly implemented via the
IOERROR state. With IOERROR eventually removed, this highlights things
like whether it's actually safe to make some of those arbitrary
transitions. It's actually not, because going from WANT_SYNC -> CALLBACK
is a potential use after free vector of the CIL ctx (as soon as the ctx
is added to the callback list in the CIL push code). This is yet another
functional problem that should be fixed before removing IOERROR, IMO
(and is reproducible via kasan splat, btw). At this point I think some
of these shutdown checks associated with CALLBACK are simply to ensure
IOERROR remains persistent once it's set on an iclog. We don't need to
carry that logic around if IOERROR is going away.

SYNCING -> CALLBACK is another hokey transition in the existing code,
even if it doesn't currently manifest in a bug that I can see, because
we should probably still expect (wait for) an I/O completion despite
that the filesystem had shutdown in the meantime. Fixing that one might
require tweaks to how the shutdown code actually works (i.e. waiting on
an I/O vs. running callbacks while in-flight). It's not immediately
clear to me what the best solution is for that, but I suspect it could
tie in with fixing the problem noted above.

With regard to this patch, consider that shutdown can happen at any
point and xlog_state_do_iclog_callbacks() cycles icloglock. That means
that as of this patch, we actually can go from IOERROR -> DIRTY and
possibly from DIRTY -> ACTIVE depending on where the iclog lies in the
list. Removing IOERROR will subtley change that behavior yet again to
make the latter transition potentially more likely.

Note that I think that's probably fine. What I'm suggesting is to just
drop the duplicate shutdown branch and instead lets evaluate whether
some of the code these checks intend to avoid is really problematic. I
don't think it is in the completion path since we're just resetting
in-core headers and such. That means we could probably just let the
iclogs fall through those state transitions naturally, reduce the number
of shutdown checks splattered throughout the code and simplify the
overall error handling logic in the process by handling all iclogs
consistently during shutdown.

> Also if you look at what state checks are left, the are all (except
> for the debug check in xfs_log_unmount_verify_iclog) under
> l_icloglock and guarded by a shutdown check.
> 

That's not quite enough IMO. I think the whole IOERROR problem is not
primarily a matter of mechanically factoring it out. It's fragile
functionality that should be fixed/simplified first before there's any
real value to removing IOERROR.

Brian

