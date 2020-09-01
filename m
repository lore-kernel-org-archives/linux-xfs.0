Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F007C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 12:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4698020767
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 12:38:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aE0iQMjU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIAMin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 08:38:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727906AbgIAMbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 08:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598963496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WujLg4jEHpJ8aQ3/VRb/ZqRMo/dSXu6VgxP1jA7FyWU=;
        b=aE0iQMjULX6NCfDnc5hxb9813ZcFiBflx1STMlG5gUnyCJ9sSYwJzyuFjDOcW3W/CPXj7t
        9Dx1st6GZWwNAEsqNxWKXxYkgTWDtTohJl9YIAaFAiTFZ+0mDHv1fG9sI6GLfQn7uanK9l
        xsdsUZfbs5SVvEiwLF4aPAt7w/4j6ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-mWP76IJqP6CytI3rdMTCMQ-1; Tue, 01 Sep 2020 08:31:34 -0400
X-MC-Unique: mWP76IJqP6CytI3rdMTCMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46118807351;
        Tue,  1 Sep 2020 12:31:33 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0DFE5C1A3;
        Tue,  1 Sep 2020 12:31:32 +0000 (UTC)
Date:   Tue, 1 Sep 2020 08:31:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: disable dmlogwrites tests on XFS
Message-ID: <20200901123130.GA174813@bfoster>
References: <20200827145329.435398-1-bfoster@redhat.com>
 <20200829064850.GC29069@infradead.org>
 <20200831133732.GB2667@bfoster>
 <CAOQ4uxiqtoDTfkDvwL2Vs28reRmgLqg1ZVGoQEk=bkU1o-Mwrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiqtoDTfkDvwL2Vs28reRmgLqg1ZVGoQEk=bkU1o-Mwrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 09:25:42AM +0300, Amir Goldstein wrote:
> On Mon, Aug 31, 2020 at 4:37 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Sat, Aug 29, 2020 at 07:48:50AM +0100, Christoph Hellwig wrote:
> > > On Thu, Aug 27, 2020 at 10:53:29AM -0400, Brian Foster wrote:
> > > > Several generic fstests use dm-log-writes to test the filesystem for
> > > > consistency at various crash recovery points. dm-log-writes and the
> > > > associated replay mechanism rely on discard to clear stale blocks
> > > > when moving to various points in time of the fs. If the storage
> > > > doesn't provide discard zeroing or the discard requests exceed the
> > > > hardcoded maximum (128MB) of the fallback solution to physically
> > > > write zeroes, stale blocks are left around in the target fs. This
> > > > causes issues on XFS if recovery observes metadata from a future
> > > > version of an fs that has been replayed to an older point in time.
> > > > This corrupts the filesystem and leads to spurious test failures
> > > > that are nontrivial to diagnose.
> > > >
> > > > Disable the generic dmlogwrites tests on XFS for the time being.
> > > > This is intended to be a temporary change until a solution is found
> > > > that allows these tests to predictably clear stale data while still
> > > > allowing them to run in a reasonable amount of time.
> > >
> > > As said in the other discussion I don't think this is correct.  The
> > > intent of the tests is to ensure the data can't be read.  You just
> > > happen to trigger over that with XFS, but it also means that tests
> > > don't work correctly on other file systems in that configuration.
> > >
> >
> > Yes, but the goal of this patch is not to completely fix the dmlogwrites
> > infrastructure and set of tests. The goal is to disable a subset of
> > tests that are known to produce spurious corruptions on XFS until that
> > issue can be addressed, so it doesn't result in continued bug reports in
> > the meantime. I don't run these tests routinely on other fs', so it's
> > not really my place to decide that the tradeoff between this problem and
> > the ability of the test to reproduce legitimate bugs justifies disabling
> > the test on those configs.
> >
> 
> Brian,
> 
> Let's not take this course please.
> Please post patches v1 2/4-4/4 without patch v1 1/4
> The only objection was to patch 1/4 and it is not strictly needed
> to solve the problem you care about.
> 

Sure, I'm fine with that approach. I posted this because it was
essentially where I started and there doesn't seem to be much agreement
on a proper fix.  We had precedent to use dm-thinp in generic/482, so it
seemed ideal to at least try to keep the tests active in the near term.
IOW, my approach was to either try for an obvious/simple fix to keep the
tests active or otherwise disable the tests (at least on XFS) until a
more involved fix is agreed on, tested and implemented. That more
involved fix could be anything from genericizing the dm-thin approach to
replacing it such that discard zeroing is not a critical component, but
I don't want to gate addressing the spurious corruption problem on a
nontrivial rework of the test mechanism.

> I had a *concern* about pacthes 2-4, but I can live with that
> concern and it is certainly preferred to disabling the tests.
> 

Agree.

> I can follow up with fixing the dmlogwrites common helpers
> later when I get the time, so they do not rely on discard for
> correctness of replay.
> 
> As I wrote, all it takes is to issue an explicit zero/punch command
> in the beginning of replay halpers. Just need to find the command
> that works correctly and most efficiently with thinp.
> 
> If you have the time to do that (since I believe you already tested
> some commands) that would be great. Otherwise, I'll do that later.
> 

Well, I was testing some of the zeroing commands Christoph mentioned
moreso than punch, particularly with intent to remove the dependency on
dm-thin. The problem with that is I don't think it helps much for
anybody who is testing on devices without hardware offload. The more
efficient in-kernel zeroing is still pretty slow, so I suppose it
depends on how often it must be invoked in a particular test (once? per
recovery point? on-demand buried down in the recovery code?). An obvious
mitigation, at least for the generic tests, is to reduce the size of the
target devices such that the manual zeroing is less noticeable. I don't
see much impact of using a 100MB fs, for example, and the recovery tool
already does the manual zeroing. The tradeoff is that I think we'd want
some kind of _notrun check in situations where we know the zeroing
doesn't occur.

I don't see much difference with zero/punch on dm-thinp. An
fallocate(FL_PUNCH_HOLE|FL_KEEP_SIZE) doesn't work because it explicitly
requests hardware zeroing, which I don't have.
fallocate(FL_ZERO_RANGE|FL_KEEP_SIZE) works, but takes a minute or two
on my 10G device because it falls back to manual zeroing. There is a
NO_HIDE_STALE variant of PUNCH_HOLE, but I don't seem to have any
userspace tools that define NO_HIDE_STALE and it looks like it just
sends discards anyways. Of course, a 'blkdiscard -o 0 -l 10g <thindev>'
unmaps nearly the entire device in ~1s, but then we're back to the
argument of using discard for zeroing. :P

Brian

> Thanks,
> Amir.
> 

