Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E36DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 17:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB122065D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 17:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IGlBs7It"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgENRo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 13:44:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbgENRo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 13:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589478294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TgCYn+zL68HAWTqWuPDJym6H6ZpbqqJO39V72aiBNf4=;
        b=IGlBs7It0SG38AHXLuZ6P5fy8Nfl/jQKPb9N90dNDk2d2yZasyMIq/tl2fcQWgjFukUIqD
        jO9RX7AmgTz1y7+zSPbjAqzuKj71n56D840ygBNytoKwll0A5PkuA/bV6z0FJ75LjAcX1g
        ut9gVQyhSzZ0aRxyX35oaPZ00qGC1RU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-yDYqEhkIPte_MxSpChsWKQ-1; Thu, 14 May 2020 13:44:52 -0400
X-MC-Unique: yDYqEhkIPte_MxSpChsWKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FC57EC1A1;
        Thu, 14 May 2020 17:44:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B2B55D9CA;
        Thu, 14 May 2020 17:44:50 +0000 (UTC)
Date:   Thu, 14 May 2020 13:44:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200514174448.GE50849@bfoster>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200119204925.GC9407@dread.disaster.area>
 <20200203201445.GA6870@magnolia>
 <20200507103232.GB9003@bfoster>
 <20200514163317.GA6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514163317.GA6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 09:33:17AM -0700, Darrick J. Wong wrote:
> On Thu, May 07, 2020 at 06:32:32AM -0400, Brian Foster wrote:
> > On Mon, Feb 03, 2020 at 12:14:45PM -0800, Darrick J. Wong wrote:
> > > On Mon, Jan 20, 2020 at 07:49:25AM +1100, Dave Chinner wrote:
> > > > On Wed, Jan 15, 2020 at 10:15:50PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > When writing to a delalloc region in the data fork, commit the new
> > > > > allocations (of the da reservation) as unwritten so that the mappings
> > > > > are only marked written once writeback completes successfully.  This
> > > > > fixes the problem of stale data exposure if the system goes down during
> > > > > targeted writeback of a specific region of a file, as tested by
> > > > > generic/042.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
> > > > >  1 file changed, 17 insertions(+), 11 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > > index 4544732d09a5..220ea1dc67ab 100644
> > > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > > @@ -4190,17 +4190,7 @@ xfs_bmapi_allocate(
> > > > >  	bma->got.br_blockcount = bma->length;
> > > > >  	bma->got.br_state = XFS_EXT_NORM;
> > > > >  
> > > > > -	/*
> > > > > -	 * In the data fork, a wasdelay extent has been initialized, so
> > > > > -	 * shouldn't be flagged as unwritten.
> > > > > -	 *
> > > > > -	 * For the cow fork, however, we convert delalloc reservations
> > > > > -	 * (extents allocated for speculative preallocation) to
> > > > > -	 * allocated unwritten extents, and only convert the unwritten
> > > > > -	 * extents to real extents when we're about to write the data.
> > > > > -	 */
> > > > > -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> > > > > -	    (bma->flags & XFS_BMAPI_PREALLOC))
> > > > > +	if (bma->flags & XFS_BMAPI_PREALLOC)
> > > > >  		bma->got.br_state = XFS_EXT_UNWRITTEN;
> > > > >  
> > > > >  	if (bma->wasdel)
> > > > > @@ -4608,8 +4598,24 @@ xfs_bmapi_convert_delalloc(
> > > > >  	bma.offset = bma.got.br_startoff;
> > > > >  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
> > > > >  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> > > > > +
> > > > > +	/*
> > > > > +	 * When we're converting the delalloc reservations backing dirty pages
> > > > > +	 * in the page cache, we must be careful about how we create the new
> > > > > +	 * extents:
> > > > > +	 *
> > > > > +	 * New CoW fork extents are created unwritten, turned into real extents
> > > > > +	 * when we're about to write the data to disk, and mapped into the data
> > > > > +	 * fork after the write finishes.  End of story.
> > > > > +	 *
> > > > > +	 * New data fork extents must be mapped in as unwritten and converted
> > > > > +	 * to real extents after the write succeeds to avoid exposing stale
> > > > > +	 * disk contents if we crash.
> > > > > +	 */
> > > > >  	if (whichfork == XFS_COW_FORK)
> > > > >  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> > > > > +	else
> > > > > +		bma.flags = XFS_BMAPI_PREALLOC;
> > > > 
> > > > 	bma.flags = XFS_BMAPI_PREALLOC;
> > > > 	if (whichfork == XFS_COW_FORK)
> > > > 		bma.flags |= XFS_BMAPI_COWFORK;
> > > > 
> > > > However, I'm still not convinced that this is the right/best
> > > > solution to the problem. It is the easiest, yes, but the down side
> > > > on fast/high iops storage and/or under low memory conditions has
> > > > potential to be extremely significant.
> > > > 
> > > > I suspect that heavy users of buffered O_DSYNC writes into sparse
> > > > files are going to notice this the most - there are databases out
> > > > there that work this way. And I suspect that most of the workloads
> > > > that use buffered O_DSYNC IO heavily won't see this change for years
> > > > as enterprise upgrade cycles are notoriously slow.
> > > > 
> > > > IOWs, all I see this change doing is kicking the can down the road
> > > > and guaranteeing that we'll still have to solve this stale data
> > > > exposure problem more efficiently in the future. And instead of
> > > > doing it now when we have the time and freedom to do the work, it
> > > > will have to be done urgently under high priority escalation
> > > > pressures...
> > > 
> > > FWIW I'm *already* under urgent high priority GA blocker escalation
> > > pressure, which is why this came up again.
> > > 
> > > Granted it did take 12 days of losing the battle with the distro folks
> > > that this really isn't a release blocker (but teh sekuritehs!!) but...oh
> > > right, I forgot that xfs actually /does/ crash more than once per day in
> > > our environment.
> > > 
> > > I guess *we* will find out how much performance really disappears if you
> > > do it this way. :P
> > > 
> > 
> > Sorry for resurrecting an old thread here, but I was thinking about this
> > problem a bit and realized I didn't have a great handle on the concerns
> > with using unwritten extents for delalloc writeback. Dave calls out the
> > O_DSYNC buffered writes into sparse files case above. I don't see any
> > numbers posted here so I ran some quick tests using a large ramdisk to
> > get low latency I/O.
> > 
> > I only seem to require a couple threads to max out single file, random
> > 4k dsync buffered write iops in this particular setup. I see ~30.6k iops
> > from a baseline 5.7.0-rc1 kernel and that drops to ~25.7k iops when
> > using unwritten extents for delalloc conversion. However, note that the
> > same workload through single threaded aio+dio (qd 32) runs at ~63.7k
> > iops. That's already using unwritten extents for dio so it's unaffected
> > by this patch. Also note that using a 10MB extent size hint puts the
> > dsync buffered write case at ~27k iops (again for both kernels because
> > we're already using unwritten extents in that case as well).
> > 
> > For reference, full file preallocation (i.e. no allocs, unwritten
> > extents) runs at ~27k iops for the buffered write case and ~87k iops for
> > aio+dio. The overwrite (no unwritten, no alloc) case gets to ~250k iops
> > with the same couple dsync buffered write threads and close to 300k iops
> > with single threaded aio+dio (which I think is maxing out my memory
> > bandwidth).
> > 
> > Altogether, this has me wondering whether it's really worth the
> > complexity of trying to avoid the overhead of unwritten extents for
> > delalloc conversion. There is a noticeable hit, but it's an already slow
> > path compared to async I/O mechanisms. Further, it's a workload that
> > typically comes with a recommendation to use extent size hints to avoid
> > fragmentation issues and minimize allocation overhead, and that feature
> > already bypasses delalloc extents in favor of unwritten extents.
> > Thoughts? Suggestions for other tests?
> 
> 4-5 months ago I ran more or less the same benchmark (albeit with
> $someproduct) and came to the same conclusion -- if you're really doing
> scattershot buffered O_DSYNC writes to a file, you'll lose about 15-20%
> with this patch added.  Then apparently I ... got buried in xmas and
> other bugs and forgot to send the results. :/
> 

Heh. :P Thanks for following up..

> Granted, you had to /force/ $someproduct to do this because it would
> typically do either synchronous aio+dio, or it could do async writes
> with an fsync at the important parts, or it could set an extent hint,
> or (the default) it writes zeroes ahead of time so that XFS will stay
> out of the way when checkpoints need to get done asap.
> 

Right, all of which already utilize unwritten extents except for the
explicit zeroing case.

> I could say (glibly) that I'm so buried in bug triage that what's a few
> more? but maybe the rest of you have other opinions? :)
> 

In dwelling on this a bit more since my previous reply, I also realized
that holding off this particular patch has kind of distorted the
problem. For example, I'd been trying to think of clever ways to prevent
stale data exposure on buffered writes, but that leads to ideas that
tend to be specific to delayed allocation and thus of limited benefit
for other write paths.

IOW, it's not really the delayed allocation case we should be so focused
on improving as much as the performance hit of unwritten extents in
general. We've already accepted the corresponding performance hit in
more common I/O paths in the name of correctness. The (preexisting)
impact of preallocated unwritten extents in more efficient write paths
vs. pure overwrites is far more prominent than the impact of unwritten
extents on buffered writes.

ISTM that the right thing to do here is merge this patch, finally fix
the last known stale data exposure vector, and then perhaps step back
and think about how we might improve performance of unwritten extents
(or whatever alternate scheme to avoid stale data exposure we might
think up) regardless of allocation policy or write path. That might even
make a decent side topic associated with the SSD allocation policy topic
proposal Dave recently posted.

It looks like Christoph already reviewed the patch. I'm not sure if his
opinion changed it all after the subsequent discussion, but otherwise
that just leaves Dave's objection. Dave, any thoughts on this given the
test results and broader context? What do you think about getting this
patch merged and revisiting the whole unwritten extent thing
independently?

Brian

> --D
> 
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > 
> > 
> 

