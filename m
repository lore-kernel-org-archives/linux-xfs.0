Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0782C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E5665090
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhCPOy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231277AbhCPOyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TjcdPLulPVPLqgT21rrns+++8FxSebIR0EUFB5jrlDQ=;
        b=hny9AGUYgJAornrXobtr7npomYHpg7GXmmtlrD6LeUqCw/zHP0RXpvWR8vfx00SriQdrfC
        XNExjMS+zi713MpBXVv2/cQVOdzcMzbe7kdfLIX4gV5x9Lj8JZmuUNHdH5r0LcO7UZsPZ1
        6PMCNPUI7Sh2CqQlEW4XIGQTdDisY50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-DPcg-0GhOF-BroRCbfVf1w-1; Tue, 16 Mar 2021 10:54:33 -0400
X-MC-Unique: DPcg-0GhOF-BroRCbfVf1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DF40800C78;
        Tue, 16 Mar 2021 14:54:32 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C43506091A;
        Tue, 16 Mar 2021 14:54:31 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:54:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <YFDGpVRPksA8HDeY@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-26-david@fromorbit.com>
 <20210309022134.GM3419940@magnolia>
 <20210311032932.GL74031@dread.disaster.area>
 <20210311034114.GD7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311034114.GD7269@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:41:14PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 12, 2021 at 02:29:32PM +1100, Dave Chinner wrote:
> > On Mon, Mar 08, 2021 at 06:21:34PM -0800, Darrick J. Wong wrote:
> > > On Fri, Mar 05, 2021 at 04:11:23PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Current xlog_write() adds op headers to the log manually for every
> > > > log item region that is in the vector passed to it. While
> > > > xlog_write() needs to stamp the transaction ID into the ophdr, we
> > > > already know it's length, flags, clientid, etc at CIL commit time.
> > > > 
> > > > This means the only time that xlog write really needs to format and
> > > > reserve space for a new ophdr is when a region is split across two
> > > > iclogs. Adding the opheader and accounting for it as part of the
> > > > normal formatted item region means we simplify the accounting
> > > > of space used by a transaction and we don't have to special case
> > > > reserving of space in for the ophdrs in xlog_write(). It also means
> > > > we can largely initialise the ophdr in transaction commit instead
> > > > of xlog_write, making the xlog_write formatting inner loop much
> > > > tighter.
> > > > 
> > > > xlog_prepare_iovec() is now too large to stay as an inline function,
> > > > so we move it out of line and into xfs_log.c.
> > > > 
> > > > Object sizes:
> > > > text	   data	    bss	    dec	    hex	filename
> > > > 1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
> > > > 1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after
> > > > 
> > > > So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
> > > > out of line, even though it grew in size itself.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Sooo... if I understand this part of the patchset correctly, the goal
> > > here is to simplify and shorten the inner loop of xlog_write.
> > 
> > That's one of the goals. The other goal is to avoid needing to
> > account for log op headers separately in the high level CIL commit
> > code.
> > 
> > > Callers
> > > are now required to create their own log op headers at the start of the
> > > xfs_log_iovec chain in the xfs_log_vec, which means that the only time
> > > xlog_write has to create an ophdr is when we fill up the current iclog
> > > and must continue in a new one, because that's not something the callers
> > > should ever have to know about.  Correct?
> > 
> > Yes.
> > 
> > > If so,
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Thanks!
> > 
> > > It /really/ would have been nice to have kept these patches separated by
> > > major functional change area (i.e. separate series) instead of one
> > > gigantic 45-patch behemoth to intimidate the reviewers...
> > 
> > How is that any different from sending out 6-7 separate dependent
> > patchsets one immediately after another?  A change to one patch in
> > one series results in needing to rebase at least one patch in each
> > of the smaller patchsets, so I've still got to treat them all as one
> > big patchset in my development trees. Then I have to start
> > reposting patchsets just because another patchset was changed, and
> > that gets even more confusing trying to work out what patchset goes
> > with which version and so on. It's much easier for me to manage them
> > as a single patchset....
> 
> Well, ok, but it would have been nice for the cover letter to give
> /some/ hint as to what's changing in various subranges, e.g.
> 
> "Patches 32-36 reduce the xc_cil_lock critical sections,
>  Patches 37-41 create per-cpu cil structures and move log items and
>        vectors to use them,
>  Patches 42-44 are more cleanups,
>  Patch 45 documents the whole mess."
> 
> So I could see the outlines of where the 45 patches were going.
> 

Agreed. The purpose of separate patch series' is to facilitate upstream
review and patch processing. This series strikes me as not only separate
logical changes, but changes probably with different trajectories toward
merge as well. E.g., do we expect to land this whole series together at
the same time? That would seem... unwise.

If not (or if we don't otherwise want to unnecessarily delay the earlier
parts of the series until the whole percpu cil thing at the end is
worked out), then I think it probably makes sense to split off into
three or so subseries. The first can cover the log flush optimizations
and whatever one off fixes that are all probably close to merge-worthy,
the second can cover this op header formatting rework and associated
cleanups, and the last covers all of the percpu stuff at the end. If
there's a real concern over rebase churn, there's probably no huge need
to respin the entire collection on every review cycle of one of the
earlier subseries.

Brian

> --D
> 
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

