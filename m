Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BF0C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0028207D4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjQjbX9s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgGBMYp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:24:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728808AbgGBMYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 08:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593692683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7WtTZo3B2Xn+/FGF0zx4B8SxFxx5SAfkQgEe0fWPrKU=;
        b=QjQjbX9sD6hgQvbIoIuYX0tpiikOm8cvs3tvgN/Je4gVbk5WDU8h7STAA0sqIFW1fDuIh7
        YEvYqczf3cAexXYEVtGmTHJBRQW7ZvLBlKIJoqvJt2Ts8RttnjwiCgIzaGPfQ+N47cxsXB
        gxL8/IyDoNz3eaW8fvErvrrUjYbXPdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-D1OEKaNMPju3aKOaYn19bA-1; Thu, 02 Jul 2020 08:24:41 -0400
X-MC-Unique: D1OEKaNMPju3aKOaYn19bA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A8C3805EEE;
        Thu,  2 Jul 2020 12:24:39 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0414479221;
        Thu,  2 Jul 2020 12:24:38 +0000 (UTC)
Date:   Thu, 2 Jul 2020 08:24:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200702122437.GB55314@bfoster>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
 <20200701143121.GB1087@bfoster>
 <20200701221839.GW2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701221839.GW2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:18:39AM +1000, Dave Chinner wrote:
> On Wed, Jul 01, 2020 at 10:31:21AM -0400, Brian Foster wrote:
> > On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently we cache unlinked inode list backrefs through a separate
> > > cache which has to be maintained via memory allocation and a hash
> > > table. When the inode is on the unlinked list, we have an existence
> > > guarantee for the inode in memory.
> > > 
> > > That is, if the inode is on the unlinked list, there must be a
> > > reference to the inode from the core VFS because dropping the last
> > > reference to the inode causes it to be removed from the unlinked
> > > list. Hence if we hold the AGI locked, we guarantee that any inode
> > > on the unlinked list is pinned in memory. That means we can actually
> > > track the entire unlinked list on the inode itself and use
> > > unreferenced inode cache lookups to update the list pointers as
> > > needed.
> > > 
> > > However, we don't use this relationship because log recovery has
> > > no in memory state and so has to work directly from buffers.
> > > However, because unlink recovery only removes from the head of the
> > > list, we can easily fake this in memory state as the inode we read
> > > in from the AGI bucket has a pointer to the next inode. Hence we can
> > > play reference leapfrog in the recovery loop always reading the
> > > second inode on the list and updating pointers before dropping the
> > > reference to the first inode. Hence the in-memory state is always
> > > valid for recovery, too.
> > > 
> > > This means we can tear out the old inode unlinked list cache and
> > > update mechanisms and replace it with a much simpler "insert" and
> > > "remove" functions that use in-memory inode state rather than on
> > > buffer state to track the list. The diffstat speaks for itself.
> > > 
> > > Food for thought: This obliviates the need for the on-disk AGI
> > > unlinked hash - we because we track as a double linked list in
> > > memory, we don't need to keep hash chains on disk short to minimise
> > > previous inode lookup overhead on list removal. Hence we probably
> > > should just convert the unlinked list code to use a single list
> > > on disk...
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Looks interesting, but are you planning to break this up into smaller
> > pieces? E.g., perhaps add the new inode pointers and set them in one
> > patch, then replace the whole backref thing with the in-core pointers,
> > then update the insert/remove, then log recovery, etc.
> 
> Likely, yes.
> 
> > I'm sure there's
> > various ways it can or cannot be split, but regardless this patch looks
> > like it could be a series in and of itself.
> 
> This RFC series is largely centered around this single patch, so
> splitting it out into a separate series makes no sense.
> 

I was just speaking generally that this patch looked quite overloaded. I
don't mean to imply it should be separated from the others.

> FWIW, This is basically the same sort of thing that the inode
> flushing patchset started out as - a single patch that I wrote in
> few hours and got working as a whole. It does need to be split up,
> but given that the inode flushing rework took several months to turn
> a few hours of coding into a mergable patchset, I haven't bothered
> to do that for this patch set yet.
> 

Understood.

> I'd kinda like to avoid having this explode into 30 patches as that
> previous patchset did - this is a very self-contained change, so
> there's really only 4-5 pieces it can be split up into. Trying to
> split it more finely than that is going to make it quite hard to
> find clean places to split it...
> 

I'm not expecting 30 patches. :) The quick flow I noted above, perhaps
with the addition of pushing refactoring changes towards the end, lands
right around 4 or 5 and seems like it would improve reviewability quite
a bit. Of course things change that might lead to more or less once you
get into the details/context of breaking things down...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

