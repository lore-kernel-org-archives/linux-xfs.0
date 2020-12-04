Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F2CC4167B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 12:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EFA522AAA
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 12:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgLDMmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 07:42:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729117AbgLDMmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 07:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607085640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s7SZkynC9o5pOfPfzahzJ7tLuCrd7IMpN9xI6Jeog8M=;
        b=UtWE4ycpf3+HGKnnCA5pR/43qUZiHgKETn8k0bXa/j/K+pwhe/wI/SBHKcxt65IjwR7jVZ
        3Pk80Aa7WxUBfgzNY1xlPx+y25bS7XSV00seu3Ky7bZCi3JW2TaQUSO3kQn7VOnsIwK0m6
        nkrH9+w3v1wS9EIPUptdDgbAULkm0eA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-5TnPGMTePMCEscrl74V6QQ-1; Fri, 04 Dec 2020 07:40:36 -0500
X-MC-Unique: 5TnPGMTePMCEscrl74V6QQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5605D107ACE6;
        Fri,  4 Dec 2020 12:40:35 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDD1018AD6;
        Fri,  4 Dec 2020 12:40:34 +0000 (UTC)
Date:   Fri, 4 Dec 2020 07:40:33 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201204124033.GB1404170@bfoster>
References: <20201110225924.4031404-1-david@fromorbit.com>
 <20201201140742.GA1205666@bfoster>
 <20201201211557.GL2842436@dread.disaster.area>
 <20201202123006.GA1278877@bfoster>
 <20201204061059.GF3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204061059.GF3913616@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 05:10:59PM +1100, Dave Chinner wrote:
> On Wed, Dec 02, 2020 at 07:30:06AM -0500, Brian Foster wrote:
> > On Wed, Dec 02, 2020 at 08:15:57AM +1100, Dave Chinner wrote:
> > > On Tue, Dec 01, 2020 at 09:07:42AM -0500, Brian Foster wrote:
> > > > On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> > > > For example, might it make sense to implement a policy where move_inode
> > > > simply moves an inode to the first AG the tempdir lands in that is < the
> > > > AG of the source inode? We'd probably want to be careful to make sure
> > > > that we don't attempt to dump the entire set of moved files into the
> > > > same AG, but I assume the temp dir creation logic would effectively
> > > > rotor across the remaining set of AGs we do want to allow.. Thoughts?
> > > 
> > > Yes, we could. But I simply decided that a basic, robust shrink to
> > > the minimum possible size will have to fill the filesystem from AG 0
> > > up, and not move to AG 1 until AG 0 is full.  I also know that the
> > > kernel allocation policies will skip to the next AG if there is lock
> > > contention, space or other allocation setup issues, hence I wanted
> > > to be able to direct movement to the lowest possible AGs first...
> > > 
> > > THere's enough complexity in an optimal shrink implementation that
> > > it will keep someone busy full time for a couple of years. I want to
> > > provide the basic functionality userspace needs only spending a
> > > couple of days a week for a couple of months on it. If we want it
> > > fast and deployable on existing systems, compromises will need to be
> > > made...
> > > 
> > 
> > Yeah, I'm not suggesting we implement the eventual policy here. I do
> > think it would be nice if the userspace command implemented some
> > reasonable default when a target AG is not specified. That could be the
> > "anything less than source AG" logic I described above, a default target
> > of AG 0, or something similarly simple...
> 
> That's the plan. This patch is just a way of testing the mechanism
> in a simple way without involving a full shrink or scanning AGs, or
> anything like that.
> 
> i.e:
> 
> $ ~/packages/xfs_spaceman  -c "help move_inode" -c "help find_owner" -c "help resolve_owner" -c "help relocate" /mnt/scratch
> move_inode -a agno -- Move an inode into a new AG.
> 
> Physically move an inode into a new allocation group
> 
>  -a agno       -- destination AG agno for the current open file
> 
> find_owner -a agno -- Find inodes owning physical blocks in a given AG
> 
> Find inodes owning physical blocks in a given AG.
> 
>  -a agno  -- Scan the given AG agno.
> 
> resolve_owner  -- Resolve paths to inodes owning physical blocks in a given AG
> 
> Resolve inodes owning physical blocks in a given AG.  This requires
> the find_owner command to be run first to populate the table of
> inodes that need to have their paths resolved.
> 
> relocate -a agno [-h agno] -- Relocate data in an AG.
> 
> Relocate all the user data and metadata in an AG.
> 
> This function will discover all the relocatable objects in a single
> AG and move them to a lower AG as preparation for a shrink
> operation.
> 
> 	-a <agno>       Allocation group to empty
> 	-h <agno>       Highest target AG allowed to relocate into
> $
> 

Ah, I see. This relocate command is essentially what I was asking for,
it just wasn't apparent from the move_inode bits alone that this was
covered somewhere. I do think there's value in dropping this in
userspace early, even if it's just a crude/isolated implementation for
now, because that helps motivate keeping the kernel bits as simple as
possible for the broader feature. Thanks for the description.

Brian

> So, essentially, I can test all the bits in one command with
> "relocate", or I can test different types of objects 1 at a time
> with "move_inode", or I can look at what "relocate" failed to move
> with "find_owner" and "resolve_owner"....
> 
> An actual shrink operation will effectively run "relocate" on all
> the AGs that it wants to empty, setting the highest AG that
> relocation is allowed into to the last full AG that will remain in
> the shrunk filesystem, then check the AGs are empty, then run the
> shrink ioctl....
> 
> But to get there, I'm bootstrapping the functionality one testable
> module at a time, then refactoring them to combine them into more
> complex operations...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

