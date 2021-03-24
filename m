Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6FCC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CAB61580
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhCXOYQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:24:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236201AbhCXOYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616595850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4NY1h6Oe7r3ji0gCW3vDq/3UwvOH5YL7i2nd2M4iAcw=;
        b=b9NjHFwMRMwu4u41Hu5ePr1xRJ1DUFj7nj1GOQYKBT6oE/o10eHb0evAxNPV5sFylIfVaG
        hL9xvjUdqdArYllqJ8R8WrCOjGF4lULgO52Fw0aeUms/RLhfhC2mQRFA0bc4ekShSzb+Q2
        Aw1TgoizM16KSHKgPOJB2dpWJFU9P1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-QiVuUAcJOgup2z8PkWDidg-1; Wed, 24 Mar 2021 10:24:06 -0400
X-MC-Unique: QiVuUAcJOgup2z8PkWDidg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E68E801817;
        Wed, 24 Mar 2021 14:24:05 +0000 (UTC)
Received: from bfoster (ovpn-113-24.rdu2.redhat.com [10.10.113.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E46667128C;
        Wed, 24 Mar 2021 14:24:04 +0000 (UTC)
Date:   Wed, 24 Mar 2021 10:24:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <YFtLg9iIzHbKPjrG@bfoster>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
 <20210319014303.GQ63242@dread.disaster.area>
 <YFS7IbGIyf4VqF59@bfoster>
 <20210323224036.GJ63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323224036.GJ63242@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:40:36AM +1100, Dave Chinner wrote:
> On Fri, Mar 19, 2021 at 10:54:25AM -0400, Brian Foster wrote:
> > On Fri, Mar 19, 2021 at 12:43:03PM +1100, Dave Chinner wrote:
> > > On Fri, Mar 19, 2021 at 12:05:06PM +1100, Dave Chinner wrote:
> > > > On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> > > > > TBH I think the COW recovery and the AG block reservation pieces are
> > > > > prime candidates for throwing at an xfs_pwork workqueue so we can
> > > > > perform those scans in parallel.
> > > > 
> > > > As I mentioned on #xfs, I think we only need to do the AG read if we
> > > > are near enospc. i.e. we can take the entire reservation at mount
> > > > time (which is fixed per-ag) and only take away the used from the
> > > > reservation (i.e. return to the free space pool) when we actually
> > > > access the AGF/AGI the first time. Or when we get a ENOSPC
> > > > event, which might occur when we try to take the fixed reservation
> > > > at mount time...
> > > 
> > > Which leaves the question about when we need to actually do the
> > > accounting needed to fix the bug Brian is trying to fix. Can that be
> > > delayed until we read the AGFs or have an ENOSPC event occur? Or
> > > maybe some other "we are near ENOSPC and haven't read all AGFs yet"
> > > threshold/trigger?
> > > 
> > 
> > Technically there isn't a hard requirement to read in any AGFs at mount
> > time. The tradeoff is that leaves a gap in effectiveness until at least
> > the majority of allocbt blocks have been accounted for (via perag agf
> > initialization). The in-core counter simply folds into the reservation
> > set aside value, so it would just remain at 0 at reservation time and
> > behave as if the mechanism didn't exist in the first place. The obvious
> > risk is a user can mount the fs and immediately acquire reservation
> > without having populated the counter from enough AGs to prevent the
> > reservation overrun problem. For that reason, I didn't really consider
> > the "lazy" init approach a suitable fix and hooked onto the (mostly)
> > preexisting perag res behavior to initialize the appropriate structures
> > at mount time.
> > 
> > If that underlying mount time behavior changes, it's not totally clear
> > to me how that impacts this patch. If the perag res change relies on an
> > overestimated mount time reservation and a fallback to a hard scan on
> > -ENOSPC, then I wonder whether the overestimated reservation might
> > effectively subsume whatever the allocbt set aside might be for that AG.
> > If so, and the perag init effectively transfers excess reservation back
> > to free space at the same time allocbt blocks are accounted for (and set
> > aside from subsequent reservations), perhaps that has a similar net
> > effect as the current behavior (of initializing the allocbt count at
> > mount time)..?
> > 
> > One problem is that might be hard to reason about even with code in
> > place, let alone right now when the targeted behavior is still
> > vaporware. OTOH, I suppose that if we do know right now that the perag
> > res scan will still fall back to mount time scans beyond some low free
> > space threshold, perhaps it's just a matter of factoring allocbt set
> > aside into the threshold somehow so that we know the counter will always
> > be initialized before a user can over reserve blocks.
> 
> Yeah, that seems reasonable to me. I don't think it's difficult to
> handle - just set the setaside to maximum at mount time, then as we
> read in AGFs we replace the maximum setaside for that AG with the
> actual btree block usage. If we hit ENOSPC, then we can read in the
> uninitialised pags to reduce the setaside from the maximum to the
> actual values and return that free space back to the global pool...
> 

Ack. That seems like a generic enough fallback plan if the
overestimation of perag reservation doesn't otherwise cover the gap.

> > As it is, I don't
> > really have a strong opinion on whether we should try to make this fix
> > now and preserve it, or otherwise table it and revisit once we know what
> > the resulting perag res code will look like. Thoughts?
> 
> It sounds like we have a solid plan to address the AG header access
> at mount time, adding this code now doesn't make anything worse,
> nor does it appear to prevent us from fixing the AG header access
> problem in the future. So I'm happy for this fix to go ahead as it
> stands.
> 

Ok, so is that a Rv-b..? ;)

So far after a quick skim back through the discussion, I don't have a
reason for a v4 of this series...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

