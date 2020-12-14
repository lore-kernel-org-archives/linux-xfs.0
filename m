Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC75C4361B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Dec 2020 15:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 182F922B2C
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Dec 2020 15:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgLNP1V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 10:27:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731228AbgLNP1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Dec 2020 10:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607959553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BVuo9+N4wkZV4vQBB5mg2pB6qcVqLqO/pv0YP16CtIY=;
        b=AxL+J4hWbyOqLE5I0UT3biFJeplAesnaCkz2R/g+BJkpXyfhRcsL0AZDRsvNh9Zh5xC06z
        4ew9mIlA+sKnd/APuDDvZihrbQtGx5CG5jvC4D0WA+5tlUfnaArsl7/14BDUaZLcjxtxor
        F0ZhyHTLL0LFLTwTIqXRQJWHA0e+H0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-M0bQNcwjMk-wx0tiTny_Iw-1; Mon, 14 Dec 2020 10:25:51 -0500
X-MC-Unique: M0bQNcwjMk-wx0tiTny_Iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF1A3AFAB3;
        Mon, 14 Dec 2020 15:25:47 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E96A70478;
        Mon, 14 Dec 2020 15:25:46 +0000 (UTC)
Date:   Mon, 14 Dec 2020 10:25:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201214152545.GA2244296@bfoster>
References: <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
 <20201211233507.GP1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211233507.GP1943235@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 03:35:07PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> > On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
> > > On Thu, Dec 10, 2020 at 09:23:58AM -0500, Brian Foster wrote:
> > > > On Thu, Dec 10, 2020 at 07:51:32AM +1100, Dave Chinner wrote:
> > > > > For changing incompat log flags, covering also provides exactly what
> > > > > we need - an empty log with only a dirty superblock in the journal
> > > > > to recover. All that we need then is to recheck feature flags after
> > > > > recovery (not just clear log incompat flags) because we might need
> > > > > to use this to also set incompat feature flags dynamically.
> > > > > 
> > > > 
> > > > I'd love it if we use a better term for a log isolated to the superblock
> > > > buffer. So far we've discussed an empty log with a dummy superblock, an
> > > > empty log with a dirty superblock, and I suppose we could also have an
> > > > actual empty log. :P "Covered log," perhaps?
> > > 
> > > On terminology: "covered log" has been around for 25 years
> > > in XFS, and it's very definition is "an empty, up-to-date log except
> > > for a dummy object we logged without any changes to update the log
> > > tail". And, by definition, that dummy object is dirty in the log
> 
> Hmm, can we capture in a comment in the logging code the precise meaning
> of "covered log" in whatever patch we end up generating?  I've long
> suspected that's more or less what a covered log meant (the log has one
> item just to prove that head==tail and there's nothing else to see here)
> but it sure would've been nice to confirm that. :)
> 

Yeah, I was asking about proper terminology up front to help make sure
commit logs and whatnot accurately describe what's going on. :)

> > > even if it contains no actual modifications when it was logged.
> > > So in this case, "dummy" is directly interchangable with "dirty"
> > > when looking at the log contents w.r.t. recovery behaviour.
> > > 
> > > It's worth looking at a historical change, too. Log covering
> > > originally used the root inode and not the superblock. That caused
> > > problems on linux dirtying VFS inode state, so we changed it to the
> > > superblock in commit 1a387d3be2b3 ("xfs: dummy transactions should
> > > not dirty VFS state") about a decade ago.  Note the name of the
> > > function at the time (xfs_fs_log_dummy()) and that it's description
> > > explicitly mentions that a dummy transaction used for updating the
> > > log tail when covering it.
> > > 
> > > The only difference in this discussion is fact that we may be
> > > replacing the "dummy" with a modified superblock. Both are still
> > > dirty superblock objects in the log, and serve the same purpose for
> > > covering the log, but instead of using a dummy object we update the
> > > log incompat flags so taht the only thing that gets replayed if we
> > > crash is the modification to the superblock flags...
> > > 
> > 
> > Makes sense, thanks.
> > 
> > > Finally, no, we can't have a truly empty log while the filesystem is
> > > mounted because log transaction records must not be empty. Further,
> > > we can only bring the log down to an "empty but not quite clean"
> > > state while mounted, because if the log is actually marked clean and
> > > we crash then log recovery will not run and so we will not clean up
> > > files that were open-but-unlinked when the system crashed.
> 
> Whatever happened to Eric's patchset to make us process unlinked inodes
> at mount time so that freeze images wouldn't require recovery?
> 
> > Yeah, I wasn't suggesting to do that, just surmising about terminology.
> > It sounds like "covered log" refers to the current state logging an
> > unmodified superblock object.
> > 
> > > 
> > > > > > > but didn't necessarily clean the log. I wonder if we can fit that state
> > > > > > > into the existing log covering mechanism by logging the update earlier
> > > > > > > (or maybe via an intermediate state..)? I'll need to go stare at that
> > > > > > > code a bit..
> > > > > 
> > > > > That's kinda what I'd like to see done - it gives us a generic way
> > > > > of altering superblock incompat feature fields and filesystem
> > > > > structures dynamically with no risk of log recovery needing to parse
> > > > > structures it may not know about.
> > > > > 
> > > > 
> > > > We might have to think about if we want to clear such feature bits in
> > > > all log covering scenarios (idle, freeze) vs. just unmount.
> > > 
> > > I think clearing bits can probably be lazy. Set a state flag to tell
> > > log covering that it needs to do an update, and so when the covering
> > > code finally runs the feature bit modification just happens.
> > > 
> > 
> > That's reasonable on its own, it just means we have to support dynamic
> > setting of the associated bit(s) at runtime...
> 
> The one downside of clearing the log incompat flags when the log goes
> idle is that right now I print a big EXPERIMENTAL warning whenever we
> turn on the atomic swapext feature, and doing this will cause that
> message to cycle over and over...
> 
> That's kind of a minor point though.  Either we add a superblock flag to
> remember that we've already warned about the experimental feature, or we
> just don't bother at all.
> 
> Next time I have spare cycles I'll look into adapting this patch to make
> it clear log incompat flags at unmount and/or covering time, assuming
> nobody beats me to it.
> 
> > > > My previous suggestion in the other sub-thread was to set bits on
> > > > mount and clear on unmount because that (hopefully) simplifies the
> > > > broader implementation.  Otherwise we need to manage dynamic
> > > > setting of bits when the associated log items are active, and that
> > > > still isn't truly representative because the bits would remain set
> > > > long after active items fall out of the log, until the log is
> > > > covered. Either way is possible, but I'm curious what others
> > > > think.
> > > 
> > > I think that unless we are setting a log incompat flag, log covering
> > > should unconditionally clear the log incompat flags. Because the log
> > > is empty, and recovery of a superblock buffer should -always- be
> > > possible, then by definition we have no log incompat state
> > > present....
> > > 
> > 
> > It should, but in practice will depend on whether the superblock was
> > written back or not before a crash while in the covered state. So
> > recovery may or may not actually work on an older kernel after the log
> > is covered. I think that is fine from a correctness standpoint because
> > the important part is to make sure an older kernel will not attempt to
> > recover incompatible items, and we make that guarantee by covering the
> > log before clearing the bit. I'm merely pointing this out because I
> > still think it's more straightforward to just enforce that a kernel with
> > the associated feature bit be required to recover a dirty log.
> 
> <nod>
> 
> > > As for a mechanism for dynamically adding log incompat flags?
> > > Perhaps we just do that in xfs_trans_alloc() - add an log incompat
> > > flags field into the transaction reservation structure, and if
> > > xfs_trans_alloc() sees an incompat field set and the superblock
> > > doesn't have it set, the first thing it does is run a "set log
> > > incompat flag" transaction before then doing it's normal work...
> > > 
> > > This should be rare enough it doesn't have any measurable
> > > performance overhead, and it's flexible enough to support any log
> > > incompat feature we might need to implement...
> > > 
> > 
> > But I don't think that is sufficient. As Darrick pointed out up-thread,
> > the updated superblock has to be written back before we're allowed to
> > commit transactions with incompatible items. Otherwise, an older kernel
> > can attempt log recovery with incompatible items present if the
> > filesystem crashes before the superblock is written back.
> > 
> > We could do some sync transaction and/or sync write dance at runtime,
> > but I think the performance/overhead aspect becomes slightly less
> > deterministic. It's not clear to me how many bits we'd support over
> > time, and whether users would notice hiccups when running some sustained
> > workload and happen to trigger sync transaction/write or AIL push
> > sequences to set internal bits.
> 
> Probably few, since I imagined that most new log items are going to get
> built on behalf of new disk format features.  OTOH Allison and I are
> both building features that don't change the disk format...
> 

Right..

> > My question is how flexible do we really need to make incompatible log
> > recovery support? Why not just commit the superblock once at mount time
> > with however many bits the current kernel supports and clear them on
> > unmount? (Or perhaps consider a lazy setting variant where we set all
> > supported bits on the first modification..?)
> 
> I don't think setting it at mount (or first mod) time is a good idea
> either, since that means that the fs cannot be recovered on an old
> kernel even if we never actually used the new log items.
> 

Indeed, that's the primary tradeoff. I think it's worth the tradeoff for
simplicity because I don't think users will know or understand the
difference between when the bit is set and cleared dynamically or just
set by default. I suppose that is less of a concern if a bit is tied to
some exclusive operation like extent swap and nothing else, but with
something like xattrs I think the reality is that a writeable filesystem
will mostly likely require recovery on a feature bit enabled kernel
regardless.

That said, I do see value in clearing the bit when the log idles and
thus obviously that requires bits to be set again at runtime. I'm just
not clear on how much value that brings in practice, given the above.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > 
> 

