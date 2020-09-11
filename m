Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5D5C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 17:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4116F20735
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 17:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0EPnXSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgIKRmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:42:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725950AbgIKMhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 08:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599827867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KGaLkz2rmPeAgPdYIIRbjQjC/wxNgkVE5S2gqGzCgYw=;
        b=A0EPnXSgGuQUOQgLs3C35y+/EAwqBKoGMoCbidmJMLKDfsXFZYtb9w30r5Lq98N/p/CANb
        nFC4OZMjk28NoElCaB6VBgP4naXYu4VXgpkkT1SmxeTyiP+nIY2lQlMIrc99WWYdVDf6c1
        bts5To3PvkkxXb7it+Xi+ti+VzkWFrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525--XhyxxFSND-YhHpUdsXnxA-1; Fri, 11 Sep 2020 08:37:46 -0400
X-MC-Unique: -XhyxxFSND-YhHpUdsXnxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D18C801FDF;
        Fri, 11 Sep 2020 12:37:45 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B77392C31E;
        Fri, 11 Sep 2020 12:37:44 +0000 (UTC)
Date:   Fri, 11 Sep 2020 08:37:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: EFI recovery needs it's own transaction
 reservation
Message-ID: <20200911123742.GB1194939@bfoster>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-2-david@fromorbit.com>
 <20200909133111.GA765129@bfoster>
 <20200909214455.GQ12131@dread.disaster.area>
 <20200910131810.GA1143857@bfoster>
 <20200910212927.GT12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910212927.GT12131@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 07:29:27AM +1000, Dave Chinner wrote:
> On Thu, Sep 10, 2020 at 09:18:10AM -0400, Brian Foster wrote:
> > On Thu, Sep 10, 2020 at 07:44:55AM +1000, Dave Chinner wrote:
> > > On Wed, Sep 09, 2020 at 09:31:11AM -0400, Brian Foster wrote:
> > > > It looks like extents are only freed when the last
> > > > reference is dropped (otherwise we log a refcount intent), which makes
> > > > me wonder whether we really need 7 log count units if recovery
> > > > encounters an EFI.
> > > 
> > > I don't know if the numbers are correct, and it really is out of
> > > scope for this patch to audit/fix that. I really think we need to
> > > map this whole thing out in a diagram at this point because I now
> > > suspect that the allocfree log count calculation is not correct,
> > > either...
> > 
> > I agree up to the point where it relates to this specific EFI recovery
> > issue. reflink is enabled by default, which means the default EFI
> > recovery reservation is going to have 7 logcount units. Is that actually
> > enough of a reduction to prevent this same recovery problem on newer
> > fs'? I'm wondering if the tr_efi logcount should just be set to 1, for
> > example, at least for the short term fix.
> 
> I spent yesterday mapping out the whole "free extent" chain to
> understand exactly what was necessary, and in discussing this with
> Darrick on #xfs I came to the conclusion that we cannot -ever- have
> a logcount of more than 1 for an intent recovery of any sort.
> 
> That's because the transaction may have rolled enough times to
> exhaust the initial grant of unit * logcount, so the only
> reservation that the runtime kernel has when it crashs is a single
> transaction unit reservation (which gets re-reserved on every roll).
> 
> Hence recovery cannot assume that intent that was being processed has more
> than a single unit reservation of log space available to be used,
> and hence all intent recovery reservations must start with a log
> count of 1.
> 

Makes sense.

> THere are other restrictions we need to deal with, too. multiple
> intents may pin the tail of the log, so we can't just process a
> single intent chain at a time as that will result in using all the
> log space for a single intent chain and reservation deadlocking on
> one of the intents we haven't yet started.
> 
> Hence the first thing we have to do in recovering intents is take an
> active reservation for -all- intents in the log to match the
> reservation state at runtime. Only then can we guarantee that
> intents that pin the tail of the log will have the reservation space
> needed to be able to unpin the log tail.
> 

Which brings up the ordering question when multiple intents pin the
tail...

> Further, because we now may have consumed all the available log
> reservation space to guarantee forwards progress, the first commit
> of the first intent may block trying to regrant space if another
> intent also pins the tail of the log. This means we cannot replay
> intents in a serial manner as we currently do. Each intent chain and it's
> transaction context needs to run in it's own process context so it
> can block waiting for other intents to make progress, just like
> happens at runtime when the system crashed. IOWs, intent replay
> needs to be done with a task context per intent chain (probably via
> a workqueue).
> 

Indeed.

> AFAICT, this is the only way we can make intent recovery deadlock
> free - we have to recreate the complete log reservation state in
> memory before we start recovery of a single intent, we can only
> assume an intent had a single unit reservation of log space assigned
> to it, and intent chain execution needs to run concurrently so
> commits can block waiting for log space to become available as other
> intents commit and unpin the tail of the log...
> 

Ok, so the primary recovery task would either need to acquire and
distribute the initial reservation or otherwise implement some kind of
execution barrier for the intent recovery wq tasks to ensure that every
currently log resident intent acquires a transaction before any other is
allowed to roll. That doesn't seem _too_ limiting a restriction given
that it technically should allow many intents (that don't result in
intent chains) to execute to completion before waiting on others at all,
though it does sound like a complete rework of the current
post-recovery, single threaded intent recovery approach.

I'm kind of wondering if we had some mechanism to freeze/unfreeze all
transaction rolls, if we could then rework recovery to issue intent
recovery wq tasks during pass2 as log records are written back to the
fs. For example, with transaction rolls frozen, pass2 of recovery
completes a particular log record and on I/O completion of all
associated buffers, kicks off workqueue tasks for each unfinished intent
in that particular record. The workqueue tasks will either complete and
exit or unconditionally block on the next transaction roll (regrant).
The main recovery task carries on and repeats for all subsequent records
in the log, unfreezes regrants and waits for all outstanding
tasks/transactions to (hopefully) complete. Hm?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

