Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA97C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF4520752
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCSNFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:05:39 -0400
Received: from verein.lst.de ([213.95.11.211]:41803 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgCSNFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BD5E568BEB; Thu, 19 Mar 2020 14:05:36 +0100 (CET)
Date:   Thu, 19 Mar 2020 14:05:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200319130536.GA10324@lst.de>
References: <20200316144233.900390-1-hch@lst.de> <20200316144233.900390-10-hch@lst.de> <20200318144825.GB32848@bfoster> <20200318163429.GA14701@lst.de> <20200319113603.GA37235@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319113603.GA37235@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 19, 2020 at 07:36:03AM -0400, Brian Foster wrote:
> > True.  I think we just need to clear cycled_icloglock in the
> > shutdown branch.  I prefer that flow over falling through to the
> > main loop body as that clearly separates out the shutdown case.
> > 
> 
> Sure, but a shutdown can still happen at any point so this is just a
> duplicate branch to maintain.

I don't understand.  We are in the inner loop and under l_icloglock.
The next time a shutdown can come in is when
xlog_state_do_iclog_callbacks drops l_icloglock.  That is at the end
of the inner loop, which means we will always go back to the
force shutdown check quickly.  So how is the branch duplicate?  Yes,
it also calls xlog_state_do_iclog_callbacks and does the wakeup,
but in doing that early it avoid a whole lot of complicated logic
in the previous code base.

> I think you're misreading me. I'm not suggesting to fake state changes.
> I'd argue that's actually what the special case shutdown branch does.
> And to the contrary, this patch already implements what I'm suggesting,
> it's just not consistent behavior..

I'm rather confused now.

> First, we basically already go from whatever state we're in to "logical
> CALLBACK" during shutdown. This is just forcibly implemented via the
> IOERROR state. With IOERROR eventually removed, this highlights things
> like whether it's actually safe to make some of those arbitrary
> transitions. It's actually not, because going from WANT_SYNC -> CALLBACK
> is a potential use after free vector of the CIL ctx (as soon as the ctx
> is added to the callback list in the CIL push code). This is yet another
> functional problem that should be fixed before removing IOERROR, IMO
> (and is reproducible via kasan splat, btw). At this point I think some
> of these shutdown checks associated with CALLBACK are simply to ensure
> IOERROR remains persistent once it's set on an iclog. We don't need to
> carry that logic around if IOERROR is going away.

What shutdown check associated with CALLBACK?

> SYNCING -> CALLBACK is another hokey transition in the existing code,
> even if it doesn't currently manifest in a bug that I can see, because
> we should probably still expect (wait for) an I/O completion despite
> that the filesystem had shutdown in the meantime. Fixing that one might
> require tweaks to how the shutdown code actually works (i.e. waiting on
> an I/O vs. running callbacks while in-flight). It's not immediately
> clear to me what the best solution is for that, but I suspect it could
> tie in with fixing the problem noted above.

True, actually running callbacks on various kinds of "in-flight" iclogs
seems rather dangerous.  So should I interpret your above comments
in that we should fix that first before killing of the IOERROR state?
