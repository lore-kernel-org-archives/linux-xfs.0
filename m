Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BD6C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 13:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCE920734
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 13:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IDx/NS5J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgENNox (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 09:44:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgENNox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 09:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589463891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5qdVfemB7v9BJXUFfCFzd6TCsvePQNWLAJiuKaDsNU=;
        b=IDx/NS5JsBO2ZKLuoFKUd87ceR2IkSFtNYS5ZrJupWNRgLUA75z1wBHc4DuXigmJvOmPpE
        BuiO9nsfs8jq+RskfxdCMCB07qvqaDwkOgsUOlI08npU1i3H9Q30wvpOP/J9q7XEk7YfII
        hCk9JogR8EJdv9fKIb6er/tDYx48eCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-xkJmqrcRN2WNcTOlo4N-6A-1; Thu, 14 May 2020 09:44:49 -0400
X-MC-Unique: xkJmqrcRN2WNcTOlo4N-6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 459E280183C;
        Thu, 14 May 2020 13:44:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC1A039E;
        Thu, 14 May 2020 13:44:47 +0000 (UTC)
Date:   Thu, 14 May 2020 09:44:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200514134446.GC50441@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
 <20200513170237.GB45326@bfoster>
 <20200513233358.GH2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513233358.GH2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 09:33:58AM +1000, Dave Chinner wrote:
> On Wed, May 13, 2020 at 01:02:37PM -0400, Brian Foster wrote:
> > On Tue, May 12, 2020 at 07:28:10PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Next on the list to getting rid of the xc_cil_lock is making the CIL
> > > itself per-cpu.
> > > 
> > > This requires a trade-off: we no longer move items forward in the
> > > CIL; once they are on the CIL they remain there as we treat the
> > > percpu lists as lockless.
> > > 
> > > XXX: preempt_disable() around the list operations to ensure they
> > > stay local to the CPU.
> > > 
> > > XXX: this needs CPU hotplug notifiers to clean up when cpus go
> > > offline.
> > > 
> > > Performance now increases substantially - the transaction rate goes
> > > from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
> > > for the first time.
> > > 
> > > Using a 32-way concurrent create/unlink on a 32p/16GB virtual
> > > machine:
> > > 
> > > 	    create time     rate            unlink time
> > > unpatched	1m56s      533k/s+/-28k/s      2m34s
> > > patched		1m49s	   523k/s+/-14k/s      2m00s
> > > 
> > > Notably, the system time for the create went up, while variance went
> > > down. This indicates we're starting to hit some other contention
> > > limit as we reduce the amount of time we spend contending on the
> > > xc_cil_lock.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
> > >  fs/xfs/xfs_log_priv.h |  2 +-
> > >  2 files changed, 45 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index 746c841757ed1..af444bc69a7cd 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > ...
> > > @@ -687,7 +689,7 @@ xlog_cil_push_work(
> > >  	 * move on to a new sequence number and so we have to be able to push
> > >  	 * this sequence again later.
> > >  	 */
> > > -	if (list_empty(&cil->xc_cil)) {
> > > +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
> > 
> > It seems reasonable, but I need to think a bit more about the whole
> > percpu list thing. In the meantime, one thing that comes to mind is the
> > more of these list_empty() -> percpu_counter_read() translations I see
> > the less I like it because we're leaking this inherent raciness to
> > different contexts. Whether it's ultimately safe or not, it's subject to
> > change and far too subtle and indirect for my taste. 
> 
> Well, all the critical list_empty(&cil->xc_cil) checks are done
> under the xc_push_lock, so I'd suggest that if we zero the counters
> under the push lock when switching contexts, and put the initial
> zero->non-zero counter transition to under the same lock we'll get
> exact checks without requiring a spinlock/atomic in the fast
> path and have all the right memory barriers in place such that races
> can't happen...
> 

That might work. We'd just have to audit the external checks and provide
clear comments on the purpose of the lock in those cases.

> > Could we replace all of the direct ->xc_cil list checks with an atomic
> > bitop (i.e. XLOG_CIL_EMPTY) or something similar in the xfs_cil? AFAICT,
> > that could be done in a separate patch and we could ultimately reuse it
> > to close the race with the initial ctx reservation (via
> > test_and_set_bit()) because it's otherwise set in the same function. Hm?
> 
> test_and_set_bit() still locks the memory bus and so requires
> exclusive access to the cacheline. Avoiding locked bus ops
> (atomics, spinlocks, etc) in the fast path is the problem
> I'm trying to solve with this patchset. IOWs, this isn't a viable
> solution to a scalability problem caused by many CPUs all trying to
> access the same cacheline exclusively.
> 

Of course I'd expect some hit from the added serialization, but it's not
clear to me it would be as noticeable as an explicit lock in practice.
For example, if we had an XLOG_CIL_EMPTY bit that was set at push time
and had a test_and_clear_bit() in the commit/insert path, would we take
that hit every time through the commit path or only until the cpu clears
it or sees that it's been cleared?

I'm not familiar enough with the bitops implementation to have
expectations one way or the other, but I'd be happy to test it out if
you can share the tests used to produce the documented results. :)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

