Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C032C4361B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Dec 2020 16:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C442253D
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Dec 2020 16:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438915AbgLNQAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgLNQAJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Dec 2020 11:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607961519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/wXEqpbMdOuPjOxh1ccII+wA9rf3poaEeQgJi5uZDsc=;
        b=NrWyWs6J6JcQVme3Sdh4lKO6k1jeQqMUPnneObfg0BMmD7wOuMxeBeLsBUHEsKMteD8Cu/
        q9anMYS9BKL3AhAmYHYJzpe0zMuSsSbBaV7cAnduClhekfHDrSVJXfkk9xZXwDGQLd10O0
        YYCIvPkAJk9TioiNWMOiBq7PJRlnm6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-LF5LW_dHPHOsUD5448H3SQ-1; Mon, 14 Dec 2020 10:58:35 -0500
X-MC-Unique: LF5LW_dHPHOsUD5448H3SQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47CA759;
        Mon, 14 Dec 2020 15:58:34 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0D526085D;
        Mon, 14 Dec 2020 15:58:33 +0000 (UTC)
Date:   Mon, 14 Dec 2020 10:58:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201214155831.GB2244296@bfoster>
References: <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster>
 <20201212211439.GC632069@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212211439.GC632069@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 13, 2020 at 08:14:39AM +1100, Dave Chinner wrote:
> On Fri, Dec 11, 2020 at 08:39:01AM -0500, Brian Foster wrote:
> > On Fri, Dec 11, 2020 at 08:50:04AM +1100, Dave Chinner wrote:
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
> 
> Sure, that's what the hook in xfs_trans_alloc() would do. It can do
> the work in the context that is going to need it, and set a wait
> flag for all incoming transactions that need a log incompat flag to
> wait for it do it's work.  Once it's done and the flag is set, it
> can continue and wake all the waiters now that the log incompat flag
> has been set. Anything that doesn't need a log incompat flag can
> just keep going and doesn't ever get blocked....
> 

It would have to be a sync transaction plus sync AIL force in
transaction allocation context if we were to log the superblock change,
which sounds a bit hairy...

> > We could do some sync transaction and/or sync write dance at runtime,
> > but I think the performance/overhead aspect becomes slightly less
> > deterministic. It's not clear to me how many bits we'd support over
> > time, and whether users would notice hiccups when running some sustained
> > workload and happen to trigger sync transaction/write or AIL push
> > sequences to set internal bits.
> 
> I don't think the number of bits is ever going to be a worry.  If we
> do it on a transaction granularlity, it will only block transactions
> taht need the log incomapt bit, and only until the bit is set.
> 

... until it's cleared again. Granted, that would only occur once the
log idles.

> I suspect this is one of the rare occasions where an unlogged
> modification makes an awful lot of sense: we don't even log that we
> are adding a log incompat flag, we just do an atomic synchronous
> write straight to the superblock to set the incompat flag(s). The
> entire modification can be done under the superblock buffer lock to
> serialise multiple transactions all trying to set incompat bits, and
> we don't set the in-memory superblock incompat bit until after it
> has been set and written to disk. Hence multiple waits can check the
> flag after they've got the sb buffer lock, and they'll see that it's
> already been set and just continue...
> 

Agreed. That is a notable simplification and I think much more
preferable than the above for the dynamic approach.

That said, note that dynamic feature bits might introduce complexity in
more subtle ways. For example, nothing that I can see currently
serializes idle log covering with an active transaction (that may have
just set an incompat bit via some hook yet not committed anything to the
log subsystem), so it might not be as simple as just adding a hook
somewhere.

> This gets rid of the whole "what about a log containing an item that
> sets the incompat bit" problem, and it provides a simple means of
> serialising and co-ordinating setting of a log incompat flag....
> 
> > My question is how flexible do we really need to make incompatible log
> > recovery support? Why not just commit the superblock once at mount time
> > with however many bits the current kernel supports and clear them on
> > unmount? (Or perhaps consider a lazy setting variant where we set all
> > supported bits on the first modification..?)
> 
> We don't want to set the incompat bits if we don't need to. That
> just guarantees user horror stories that start with "boot system
> with new kernel, crash, go back to old kernel, can't mount root
> filesystem anymore".
> 

Indeed, that is a potential wart with just setting bits on mount. I do
think this is likely to be the case with or without dynamic feature
bits, because at least in certain cases we'll be setting incompat bits
in short order anyways. E.g., one of the primary use cases here is for
xattrs, which is likely to be active on any root filesystem via things
like SELinux, etc. Point being, all it takes is one feature bit
associated with some core operation to introduce this risky update
scenario in practice.

I dunno... I'm just trying to explore whether we can simplify this whole
concept to something more easily managed and less likely to cause us
headache. I'm a bit concerned that we're disregarding other tradeoffs
like the complexity noted above, the risk and cost of bugs in the
mechanism itself (because log recovery has historically been so well
tested.. :P) or whether the idea of new kernels immediately delivering
new incompat log formats is a robust/reliable solution in the first
place. IIRC, the last time we did this was ICREATE and that was hidden
behind the v5 update. IOW, for certain things like the xattr rework, I'd
think that kind of experimental stabilization cycle is warranted before
we'd consider enabling such a feature, even dynamically (which means a
revertible kernel should be available in common/incremental upgrade
cases).

Anyways, it sounds like both you and Darrick still prefer this approach
so this is just my .02 for the time being..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

