Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA713C4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 13:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C3323E26
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 13:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbgLKNk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 08:40:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388892AbgLKNkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 08:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607693949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ds3lsvG2r58DTYPA7kCN+KsWr6+wnXxeEwWDY3CQGt8=;
        b=fg1F2RrxmX+hVHDsT1OHunjqSiskfCXnVqJdMAZO6pk5erTkMYPm2mj3VnGJ1PXr4RfmIv
        YF+EAQy4081Z8TX/R+DXWq3h1d+4Vpxmyl2+axVkgNRvybwcwCYRe8Lfu934Sa+sZiavp6
        DoE8GTaXWzmEHrpgFOOTjo5OzrwjMNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-4rJEjo3PNkSnyuFa_9bWWQ-1; Fri, 11 Dec 2020 08:39:05 -0500
X-MC-Unique: 4rJEjo3PNkSnyuFa_9bWWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B30780ED9D;
        Fri, 11 Dec 2020 13:39:04 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B9865F729;
        Fri, 11 Dec 2020 13:39:03 +0000 (UTC)
Date:   Fri, 11 Dec 2020 08:39:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201211133901.GA2032335@bfoster>
References: <20201208111906.GA1679681@bfoster>
 <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210215004.GC3913616@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> On Thu, Dec 10, 2020 at 09:23:58AM -0500, Brian Foster wrote:
> > On Thu, Dec 10, 2020 at 07:51:32AM +1100, Dave Chinner wrote:
> > > For changing incompat log flags, covering also provides exactly what
> > > we need - an empty log with only a dirty superblock in the journal
> > > to recover. All that we need then is to recheck feature flags after
> > > recovery (not just clear log incompat flags) because we might need
> > > to use this to also set incompat feature flags dynamically.
> > > 
> > 
> > I'd love it if we use a better term for a log isolated to the superblock
> > buffer. So far we've discussed an empty log with a dummy superblock, an
> > empty log with a dirty superblock, and I suppose we could also have an
> > actual empty log. :P "Covered log," perhaps?
> 
> On terminology: "covered log" has been around for 25 years
> in XFS, and it's very definition is "an empty, up-to-date log except
> for a dummy object we logged without any changes to update the log
> tail". And, by definition, that dummy object is dirty in the log
> even if it contains no actual modifications when it was logged.
> So in this case, "dummy" is directly interchangable with "dirty"
> when looking at the log contents w.r.t. recovery behaviour.
> 
> It's worth looking at a historical change, too. Log covering
> originally used the root inode and not the superblock. That caused
> problems on linux dirtying VFS inode state, so we changed it to the
> superblock in commit 1a387d3be2b3 ("xfs: dummy transactions should
> not dirty VFS state") about a decade ago.  Note the name of the
> function at the time (xfs_fs_log_dummy()) and that it's description
> explicitly mentions that a dummy transaction used for updating the
> log tail when covering it.
> 
> The only difference in this discussion is fact that we may be
> replacing the "dummy" with a modified superblock. Both are still
> dirty superblock objects in the log, and serve the same purpose for
> covering the log, but instead of using a dummy object we update the
> log incompat flags so taht the only thing that gets replayed if we
> crash is the modification to the superblock flags...
> 

Makes sense, thanks.

> Finally, no, we can't have a truly empty log while the filesystem is
> mounted because log transaction records must not be empty. Further,
> we can only bring the log down to an "empty but not quite clean"
> state while mounted, because if the log is actually marked clean and
> we crash then log recovery will not run and so we will not clean up
> files that were open-but-unlinked when the system crashed.
> 

Yeah, I wasn't suggesting to do that, just surmising about terminology.
It sounds like "covered log" refers to the current state logging an
unmodified superblock object.

> 
> > > > > but didn't necessarily clean the log. I wonder if we can fit that state
> > > > > into the existing log covering mechanism by logging the update earlier
> > > > > (or maybe via an intermediate state..)? I'll need to go stare at that
> > > > > code a bit..
> > > 
> > > That's kinda what I'd like to see done - it gives us a generic way
> > > of altering superblock incompat feature fields and filesystem
> > > structures dynamically with no risk of log recovery needing to parse
> > > structures it may not know about.
> > > 
> > 
> > We might have to think about if we want to clear such feature bits in
> > all log covering scenarios (idle, freeze) vs. just unmount.
> 
> I think clearing bits can probably be lazy. Set a state flag to tell
> log covering that it needs to do an update, and so when the covering
> code finally runs the feature bit modification just happens.
> 

That's reasonable on its own, it just means we have to support dynamic
setting of the associated bit(s) at runtime...

> 
> > My previous suggestion in the other sub-thread was to set bits on
> > mount and clear on unmount because that (hopefully) simplifies the
> > broader implementation.  Otherwise we need to manage dynamic
> > setting of bits when the associated log items are active, and that
> > still isn't truly representative because the bits would remain set
> > long after active items fall out of the log, until the log is
> > covered. Either way is possible, but I'm curious what others
> > think.
> 
> I think that unless we are setting a log incompat flag, log covering
> should unconditionally clear the log incompat flags. Because the log
> is empty, and recovery of a superblock buffer should -always- be
> possible, then by definition we have no log incompat state
> present....
> 

It should, but in practice will depend on whether the superblock was
written back or not before a crash while in the covered state. So
recovery may or may not actually work on an older kernel after the log
is covered. I think that is fine from a correctness standpoint because
the important part is to make sure an older kernel will not attempt to
recover incompatible items, and we make that guarantee by covering the
log before clearing the bit. I'm merely pointing this out because I
still think it's more straightforward to just enforce that a kernel with
the associated feature bit be required to recover a dirty log.

> As for a mechanism for dynamically adding log incompat flags?
> Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> flags field into the transaction reservation structure, and if
> xfs_trans_alloc() sees an incompat field set and the superblock
> doesn't have it set, the first thing it does is run a "set log
> incompat flag" transaction before then doing it's normal work...
> 
> This should be rare enough it doesn't have any measurable
> performance overhead, and it's flexible enough to support any log
> incompat feature we might need to implement...
> 

But I don't think that is sufficient. As Darrick pointed out up-thread,
the updated superblock has to be written back before we're allowed to
commit transactions with incompatible items. Otherwise, an older kernel
can attempt log recovery with incompatible items present if the
filesystem crashes before the superblock is written back.

We could do some sync transaction and/or sync write dance at runtime,
but I think the performance/overhead aspect becomes slightly less
deterministic. It's not clear to me how many bits we'd support over
time, and whether users would notice hiccups when running some sustained
workload and happen to trigger sync transaction/write or AIL push
sequences to set internal bits.

My question is how flexible do we really need to make incompatible log
recovery support? Why not just commit the superblock once at mount time
with however many bits the current kernel supports and clear them on
unmount? (Or perhaps consider a lazy setting variant where we set all
supported bits on the first modification..?)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

