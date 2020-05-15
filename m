Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046ECC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 17:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD07F20727
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 17:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qi/vClou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEOR1M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 13:27:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30995 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgEOR1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 13:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589563629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cHYbcabvG4WCO3nWBr2JrGu5uZEc9ABO6rA2brXlLaY=;
        b=Qi/vClouZr7yxuRxWFlBuOdqrcVNH8XErFwujsCUcVi4BTPWG9QGjBttE4SAhhSv31zPU4
        DlkSuF1+sRVklpS6LeMzz+PfKRKXwaRGXg4XAtF7tJFbWbcreVU92TIYJLPWpuOZULJKQq
        UuEp6pvHBeravpW9wjq6+tzytEunNMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-8BqUGP18M06nF9Z9eZWaRQ-1; Fri, 15 May 2020 13:27:07 -0400
X-MC-Unique: 8BqUGP18M06nF9Z9eZWaRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 703FB1B18BE9;
        Fri, 15 May 2020 17:26:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 299DE6E70D;
        Fri, 15 May 2020 17:26:51 +0000 (UTC)
Date:   Fri, 15 May 2020 13:26:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200515172649.GA55234@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
 <20200513170237.GB45326@bfoster>
 <20200513233358.GH2040@dread.disaster.area>
 <20200514134446.GC50441@bfoster>
 <20200514224638.GM2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514224638.GM2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 08:46:38AM +1000, Dave Chinner wrote:
> On Thu, May 14, 2020 at 09:44:46AM -0400, Brian Foster wrote:
> > On Thu, May 14, 2020 at 09:33:58AM +1000, Dave Chinner wrote:
> > > On Wed, May 13, 2020 at 01:02:37PM -0400, Brian Foster wrote:
> > > > On Tue, May 12, 2020 at 07:28:10PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Next on the list to getting rid of the xc_cil_lock is making the CIL
> > > > > itself per-cpu.
> > > > > 
> > > > > This requires a trade-off: we no longer move items forward in the
> > > > > CIL; once they are on the CIL they remain there as we treat the
> > > > > percpu lists as lockless.
> > > > > 
> > > > > XXX: preempt_disable() around the list operations to ensure they
> > > > > stay local to the CPU.
> > > > > 
> > > > > XXX: this needs CPU hotplug notifiers to clean up when cpus go
> > > > > offline.
> > > > > 
> > > > > Performance now increases substantially - the transaction rate goes
> > > > > from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
> > > > > for the first time.
> > > > > 
> > > > > Using a 32-way concurrent create/unlink on a 32p/16GB virtual
> > > > > machine:
> > > > > 
> > > > > 	    create time     rate            unlink time
> > > > > unpatched	1m56s      533k/s+/-28k/s      2m34s
> > > > > patched		1m49s	   523k/s+/-14k/s      2m00s
> > > > > 
> > > > > Notably, the system time for the create went up, while variance went
> > > > > down. This indicates we're starting to hit some other contention
> > > > > limit as we reduce the amount of time we spend contending on the
> > > > > xc_cil_lock.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
> > > > >  fs/xfs/xfs_log_priv.h |  2 +-
> > > > >  2 files changed, 45 insertions(+), 23 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > > index 746c841757ed1..af444bc69a7cd 100644
> > > > > --- a/fs/xfs/xfs_log_cil.c
> > > > > +++ b/fs/xfs/xfs_log_cil.c
> > > > ...
> > > > > @@ -687,7 +689,7 @@ xlog_cil_push_work(
> > > > >  	 * move on to a new sequence number and so we have to be able to push
> > > > >  	 * this sequence again later.
> > > > >  	 */
> > > > > -	if (list_empty(&cil->xc_cil)) {
> > > > > +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
> > > > 
> > > > It seems reasonable, but I need to think a bit more about the whole
> > > > percpu list thing. In the meantime, one thing that comes to mind is the
> > > > more of these list_empty() -> percpu_counter_read() translations I see
> > > > the less I like it because we're leaking this inherent raciness to
> > > > different contexts. Whether it's ultimately safe or not, it's subject to
> > > > change and far too subtle and indirect for my taste. 
> > > 
> > > Well, all the critical list_empty(&cil->xc_cil) checks are done
> > > under the xc_push_lock, so I'd suggest that if we zero the counters
> > > under the push lock when switching contexts, and put the initial
> > > zero->non-zero counter transition to under the same lock we'll get
> > > exact checks without requiring a spinlock/atomic in the fast
> > > path and have all the right memory barriers in place such that races
> > > can't happen...
> > > 
> > 
> > That might work. We'd just have to audit the external checks and provide
> > clear comments on the purpose of the lock in those cases.
> 
> It does work. And there's only one external check and that's an
> ASSERT that falls into the case of "we just added to the CIL, so the
> counter must be non-zero because we haven't dropped the xc_ctx_lock
> yet" so we don't need to hold the push lock here.
> 

Thinking about it again, that still seems way overengineered. All the
percpu batching stuff does is perform a global counter update behind a
spinlock and invoke a lockless read of that counter. AFAICT we can do
the same kind of lockless check on a flag or boolean in the CIL and use
an existing spinlock (as opposed to burying the percpu locks under our
own). Then we don't have to abuse special percpu interfaces at all to
obscurely provide serialization and indirect state.

> > > > Could we replace all of the direct ->xc_cil list checks with an atomic
> > > > bitop (i.e. XLOG_CIL_EMPTY) or something similar in the xfs_cil? AFAICT,
> > > > that could be done in a separate patch and we could ultimately reuse it
> > > > to close the race with the initial ctx reservation (via
> > > > test_and_set_bit()) because it's otherwise set in the same function. Hm?
> > > 
> > > test_and_set_bit() still locks the memory bus and so requires
> > > exclusive access to the cacheline. Avoiding locked bus ops
> > > (atomics, spinlocks, etc) in the fast path is the problem
> > > I'm trying to solve with this patchset. IOWs, this isn't a viable
> > > solution to a scalability problem caused by many CPUs all trying to
> > > access the same cacheline exclusively.
> > > 
> > 
> > Of course I'd expect some hit from the added serialization, but it's not
> > clear to me it would be as noticeable as an explicit lock in practice.
> 
> It's an atomic. They have less overhead than a spin lock, but that
> means it just requires a few more CPUs banging on it before it goes
> into exponential breakdown like a spinlock does. And contention on
> atomics is a lot harder to see in profiles.
> 
> > For example, if we had an XLOG_CIL_EMPTY bit that was set at push time
> > and had a test_and_clear_bit() in the commit/insert path, would we take
> > that hit every time through the commit path or only until the cpu clears
> > it or sees that it's been cleared?
> 
> Every time it goes through the commit path. The x86 implementation:
> 
> static __always_inline bool
> arch_test_and_set_bit(long nr, volatile unsigned long *addr)
> {
>         return GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, c, "Ir", nr);
> }
> 
> It is a single instruction that always locks the bus to perform the
> operation atomically.
> 

Ok, that might prohibit using a bitop in the commit path. I'd still like
to see actual numbers on that, though, just to see where on the spectrum
it lands. I'm also wondering if the fast path logic mentioned above
could be implemented like the following (using bitops instead of the
spinlock):

	if (test_bit(XLOG_CIL_EMPTY, ...) &&
	    test_and_clear_bit(XLOG_CIL_EMPTY, ...)) {
		<steal CIL res>
	}

That type of pattern seems to be used in at least a few other places in
the kernel (e.g. filemap_check_errors(), wb_start_writeback(),
__blk_mq_tag_busy()), presumably for similar reasons.

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

