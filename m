Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAE6C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F8D208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NRfAABCY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgCSNhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:37:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58694 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727417AbgCSNhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 09:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584625030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F2wp9QoKulzPUYg8DydrECdVgE61KZAiVu0XXoEdAdQ=;
        b=NRfAABCYONEax+X0q25V38f/wiWOkU9ggJ81p8A/mVigDT9pl+8kc6Z745eS6txO1/6QYm
        LWTBS8dW6pJr9C5Y9x77FsDLbdd8+eiFOWVxBXx22T0npPiesXFyoQ0QqswZYF0QDTweU3
        NVN/QKKut8S4q4XqcsHaergbBYnTGKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-9MuchmW0Om-ShbgrsnXLBA-1; Thu, 19 Mar 2020 09:37:08 -0400
X-MC-Unique: 9MuchmW0Om-ShbgrsnXLBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87381DB92;
        Thu, 19 Mar 2020 13:37:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F4835C1D8;
        Thu, 19 Mar 2020 13:37:06 +0000 (UTC)
Date:   Thu, 19 Mar 2020 09:37:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200319133705.GA37713@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-10-hch@lst.de>
 <20200318144825.GB32848@bfoster>
 <20200318163429.GA14701@lst.de>
 <20200319113603.GA37235@bfoster>
 <20200319130536.GA10324@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319130536.GA10324@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 19, 2020 at 02:05:36PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 19, 2020 at 07:36:03AM -0400, Brian Foster wrote:
> > > True.  I think we just need to clear cycled_icloglock in the
> > > shutdown branch.  I prefer that flow over falling through to the
> > > main loop body as that clearly separates out the shutdown case.
> > > 
> > 
> > Sure, but a shutdown can still happen at any point so this is just a
> > duplicate branch to maintain.
> 
> I don't understand.  We are in the inner loop and under l_icloglock.
> The next time a shutdown can come in is when
> xlog_state_do_iclog_callbacks drops l_icloglock.  That is at the end
> of the inner loop, which means we will always go back to the
> force shutdown check quickly.  So how is the branch duplicate?  Yes,
> it also calls xlog_state_do_iclog_callbacks and does the wakeup,
> but in doing that early it avoid a whole lot of complicated logic
> in the previous code base.
> 

We'll get back to the shutdown check for the next iclog, but not the
iclog we're running callbacks on. So basically we can be in CALLBACK, a
shutdown can set IOERROR where _do_iclog_callbacks() cycles the lock,
the callback picks up the shutdown state and aborts, and then the first
thing we do after that function returns is:

	iclog->ic_state = XLOG_STATE_DIRTY;
	xlog_state_activate_iclogs(log, &iclogs_changed);

... and thus finish the loop by reactivating the (IOERROR) iclog. So for
any particular iclog, we might process it for shutdown normally or in
the special shutdown branch based on timing.

> > I think you're misreading me. I'm not suggesting to fake state changes.
> > I'd argue that's actually what the special case shutdown branch does.
> > And to the contrary, this patch already implements what I'm suggesting,
> > it's just not consistent behavior..
> 
> I'm rather confused now.
> 

Sorry. What I'm saying can probably be simplified to the following
question: if we just removed the special shutdown branch and let the
iclogs fall through the normal completion sequence (once IOERROR is out
of the picture) during shutdown, is that actually a problem?

It seems to me it isn't (subject to testing of course). If that is true,
then that is more simple and consistent than what we seem to be doing in
this patch, which to my eyes seems to want to maintain some of the
IOERROR functional cruft even though the state itself is being removed.
Also note I think it would be reasonable to lift it out in a
later/separate patch if that was more straightforward than reworking
these patches.

If it is a problem, I think that's a potential argument for leaving the
IOERROR state around because then the state technically has meaning.

> > First, we basically already go from whatever state we're in to "logical
> > CALLBACK" during shutdown. This is just forcibly implemented via the
> > IOERROR state. With IOERROR eventually removed, this highlights things
> > like whether it's actually safe to make some of those arbitrary
> > transitions. It's actually not, because going from WANT_SYNC -> CALLBACK
> > is a potential use after free vector of the CIL ctx (as soon as the ctx
> > is added to the callback list in the CIL push code). This is yet another
> > functional problem that should be fixed before removing IOERROR, IMO
> > (and is reproducible via kasan splat, btw). At this point I think some
> > of these shutdown checks associated with CALLBACK are simply to ensure
> > IOERROR remains persistent once it's set on an iclog. We don't need to
> > carry that logic around if IOERROR is going away.
> 
> What shutdown check associated with CALLBACK?
> 

The one(s) that issue callbacks on an IOERROR iclog (note that I'm
referring to the mainline code). Specifically the IOERROR check in
_process_iclog() and the following logic in the caller:

                if (iclog->ic_state != XLOG_STATE_CALLBACK &&
                    iclog->ic_state != XLOG_STATE_IOERROR) {
                        iclog = iclog->ic_next;
                        continue;
                }

IOW, the current code treats an IOERROR iclog as if it were CALLBACK
with the sole exception of updating ic_state.

> > SYNCING -> CALLBACK is another hokey transition in the existing code,
> > even if it doesn't currently manifest in a bug that I can see, because
> > we should probably still expect (wait for) an I/O completion despite
> > that the filesystem had shutdown in the meantime. Fixing that one might
> > require tweaks to how the shutdown code actually works (i.e. waiting on
> > an I/O vs. running callbacks while in-flight). It's not immediately
> > clear to me what the best solution is for that, but I suspect it could
> > tie in with fixing the problem noted above.
> 
> True, actually running callbacks on various kinds of "in-flight" iclogs
> seems rather dangerous.  So should I interpret your above comments
> in that we should fix that first before killing of the IOERROR state?
> 

Yes. Note that the WANT_SYNC -> CALLBACK (IOERROR) behavior is
explicitly problematic in the current code as well because the submitter
context still has the ctx while the callbacks could be freeing it.
That's a reproducible use after free in the current code.

Brian

