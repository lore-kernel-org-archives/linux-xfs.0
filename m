Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35581C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 12:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CFFC206F1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 12:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3+xvjqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389935AbgE1M5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 08:57:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34673 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389884AbgE1M5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 May 2020 08:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590670628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RPxvEcG7+Wcbxo4jCZheNSj88o4BbiOC7rUPzZj8W/M=;
        b=M3+xvjqTVdx10KU58qx2AFKlyPQibTTnkMb59yzN7Lp1NTYc9qhoQ6xZaNZU1qUXGVYQCO
        gOGh5GC0O/QFbKXjO9E+LNYWhRiT+ScalOfl0+O7T9lRujOk4iJl9VpIvAFNRnPVL22Y1P
        xY9WwqZmTONAv8Nr4L3KqgxoHWYXfzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-gmgLo7fWNfuW3HHxP1SZBw-1; Thu, 28 May 2020 08:57:06 -0400
X-MC-Unique: gmgLo7fWNfuW3HHxP1SZBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99ADA835B41;
        Thu, 28 May 2020 12:57:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 166025D9F3;
        Thu, 28 May 2020 12:57:04 +0000 (UTC)
Date:   Thu, 28 May 2020 08:57:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200528125703.GB16657@bfoster>
References: <20200527184858.GM8230@magnolia>
 <20200528000351.GA2040@dread.disaster.area>
 <20200528024410.GM252930@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528024410.GM252930@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 27, 2020 at 07:44:10PM -0700, Darrick J. Wong wrote:
> On Thu, May 28, 2020 at 10:03:51AM +1000, Dave Chinner wrote:
> > On Wed, May 27, 2020 at 11:48:58AM -0700, Darrick J. Wong wrote:
> > > Hi everyone,
> > > 
> > > Many of you have complained (both publicly and privately) about the
> > > heavy cost of rebasing your development trees, particularly when you're
> > > getting close to sending a series out for review.  I get it, there have
> > > been a lot of large refactoring patchsets coming in the past few kernel
> > > cycles, and this has caused a lot of treewide churn.  I don't mind
> > > cleanups of things that have been weird and wonky about XFS for years,
> > > but, frankly, rebasing is soul-grinding.
> > > 
> > > To that end, I propose reducing the frequency of (my own) for-next
> > > pushes to reduce how often people feel compelled to rebase when they're
> > > trying to get a series ready for review.
> > > 
> > > Specifically, I would like to make an informal for-next push schedule as
> > > follows:
> > > 
> > >  1 Between -rc1 and -rc4, I'll collect critical bug fixes for the
> > >    merge window that just closed.  These should be small changes, so
> > >    I'll put them out incrementally with the goal of landing everything
> > >    in -rc4, and they shouldn't cause major disruptions for anyone else
> > >    working on a big patchset.  This is more or less what I've been doing
> > >    up till now -- if it's been on the list for > 24h and someone's
> > >    reviewed it, I'll put it in for-next for wider testing.
> > > 
> > >  2 A day or two after -rc4 drops.  This push is targeted for the next
> > >    merge window.  Coming three weeks after -rc1, I hope this will give
> > >    everyone enough time for a round of rebase, review, and debugging of
> > >    large changesets after -rc1.  IOWs, the majority of patchsets should
> > >    be ready to go in before we get halfway to the next merge window.
> > > 
> > >  3 Another push a day or two after -rc6 drops.  This will hopefully give
> > >    everyone a second chance to land patchsets that were nearly ready but
> > >    didn't quite make it for -rc4; or other cleanups that would have
> > >    interfered with the first round.  Once this is out, we're more or
> > >    less finished with the big patchsets.
> > 
> > This seems like a reasonable compromise - knowing when updates are
> > expected goes a long way to being able to plan development and
> > schedule dev tree updates to avoid repeated rebasing.
> > 
> > >  4 Perhaps another big push a day or two after -rc8 drops?  I'm not keen
> > >    on doing this.  It's not often that the kernel goes beyond -rc6 and I
> > >    find it really stressful when the -rc's drag on but people keep
> > >    sending large new patchsets.  Talk about stumbling around in the
> > >    dark...
> > 
> > IMO it's too late at -rc8 to be including big new changes for the
> > merge window. Bug fixes are fine, but not cleanups or features at
> > this point because there's too little test and soak time to catch
> > brown paper bag bugs before it's in the mainline tree and in much
> > more widespread use.
> 
> Fair enough.  I didn't really like this #4 anyway.  Withdrawn. :)
> 
> > Same goes for merging new stuff during the merge window - last time
> > around we had updates right up to the merge window, then an update
> > during the merge window for a second pull request. There just wasn't
> > any time when the tree wasn't actively moving forward.
> 
> Urk, sorry about that... I was hoping to land a fix for $largeclient
> but then the crazy just kept coming.  Never gonna do /that/ again. :/
> 
> > From my perspective, an update from for-next after the -rc6 update
> > gets me all the stuff that will be in the next release. That's the
> > major rebase for my work, and everything pulled in from for-next
> > starts getting test coverage a couple of weeks out from the merge
> > window.  Once the merge window closes, another local update to the
> > -rc1 kernel (which should be a no-op for all XFS work) then gets
> > test coverage for the next release. -rc1 to -rc4 is when
> > review/rework for whatever I want merged in -rc4/-rc6 would get
> > posted to the list....
> 
> <nod>
> 
> My workflow is rather different -- I rebase my dev tree off the latest
> rc every week, and when a series is ready I port it to a branch off of
> for-next.  Occasionally I'll port a refactoring from for-next into my
> dev tree to keep the code bases similar.  Both trees get run through
> fstests and $whatnot whenever they change, which mean that most mornings
> I'm looking at nightlies.
> 
> > This means there's a single rebase event a cycle at -rc6, and the
> > rest of the time the tree is pretty stable and the base tree I'm
> > testing is almost always the tree that we need to focus dev testing
> > on. That is, just before the merge window everyone should be testing
> > for-next on a -rc6/-rc7 base, and once -rc1 is out, everyone should
> > be testing that kernel through to ~-rc4 at which point it has
> > largely stabilised and the cycle starts again....
> > 
> > >  5 Obviously, I wouldn't hold back on critical bug fixes to things that
> > >    are broken in for-next, since the goal is to promote testing, not
> > >    hinder it.
> > 
> > *nod*
> > 
> > > Hopefully this will cut down on the "arrrgh I was almost ready to send
> > > this but then for-next jumped and nggghghghg" feelings. :/
> > > 
> > > Thoughts?  Flames?
> > 
> > Perhaps:
> > 
> > - each patch set that is posted should start with "this is aimed at
> >   a 5.x.y-rc4/-rc6 merge" or "still work in progress" so that
> >   everyone has some expectation of when changes are likely to land.
> 
> <nod> This would probably help with peoples' ability to distinguish
> djwong patchbombs for submission vs. making backups on NYE. ;)
> 

ISTM that anything posted that isn't intended to go through the typical
review -> merge cycle should simply be tagged RFC. That includes things
with obvious implementation gaps, prototypes looking for design
discussion, patchbomb backups, etc. The details can always be described
in the cover letter, but RFC helps reviewers prioritize based on that
information and immediately indicates to the maintainer that this isn't
on the merge track.

That's a bit different than an explicit release target, which I
personally find a bit dubious given that I think it could discourage
wider review on patches. IOW, I'd be a little concerned that patches
would start being merged ASAP after meeting some minimum criteria for
the current release (i.e. 24 hours + a review, noted above) as opposed
to more common sense behavior where more reviews might be ideal (and/or
likely based on time on list) based on the complexity of a particular
feature, etc. Just my .02, though.

Do note that I personally rarely ever know or care at what point in a
release we're at when posting patches to the list. I post patches when
ready for review, acknowledge that merge is dependent on review and
expect further review feedback can come at any time (not immediately)
and lead to any number of releases for a particular series. Therefore, I
ultimately care more about getting something merged into the pipeline
such that release is imminent vs. whether it lands in this release or
the next. IMO, the purpose of the rolling release cycle is to separate
the development process from the release process as such. That aside, my
main point here is to indicate that if I do happen to post something
"last minute" as such, I most likely have no idea, have no expectation
beyond hitting the next "reasonable deadline" and thus do not intend to
put implicit pressure on the maintainer. :)

Brian

> > or:
> > 
> > - aim to land features and complex bug fixes in -rc4 and cleanups in
> >   -rc6, that way we naturally minimise the rebase work for the
> >   features/bug fixes that are being landed. This may mean that -rc4
> >   is a small merge if there are no features/bug fixes that meet the
> >   -rc4 merge criteria...
> 
> I like that idea.
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

