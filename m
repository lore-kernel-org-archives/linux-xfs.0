Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4005FC64E8A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 12:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21A122203
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 12:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgLBMbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 07:31:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbgLBMbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 07:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606912212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUaN/kxsxDvKSQ9j/ivjUi0oSAWAzH5toCWNTKHEtf4=;
        b=idr6NSTbFj9kDmD9AfiRShlmTOIW2evpyJYiS5fP1Kgpym2yeoWJsujP57VetRXdvn0Ni9
        Kn1ESEQlgzG2BZU4l2i7BeJ2RpewUqjxDe344D6ShR5sJDMk13h8KYjtoJulX/6rICgoiE
        k5raqKag2k8rmzhvxUwrVQBjgQdNE/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-VtBElmzwOpKaKzaW-NXEGw-1; Wed, 02 Dec 2020 07:30:10 -0500
X-MC-Unique: VtBElmzwOpKaKzaW-NXEGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7417F817BA8;
        Wed,  2 Dec 2020 12:30:08 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8B019D9C;
        Wed,  2 Dec 2020 12:30:07 +0000 (UTC)
Date:   Wed, 2 Dec 2020 07:30:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201202123006.GA1278877@bfoster>
References: <20201110225924.4031404-1-david@fromorbit.com>
 <20201201140742.GA1205666@bfoster>
 <20201201211557.GL2842436@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201211557.GL2842436@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 02, 2020 at 08:15:57AM +1100, Dave Chinner wrote:
> On Tue, Dec 01, 2020 at 09:07:42AM -0500, Brian Foster wrote:
> > On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > To be able to shrink a filesystem, we need to be able to physically
> > > move an inode and all it's data and metadata from it's current
> > > location to a new AG.  Add a command to spaceman to allow an inode
> > > to be moved to a new AG.
> > > 
> > > This new command is not intended to be a perfect solution. I am not
> > > trying to handle atomic movement of open files - this is intended to
> > > be run as a maintenance operation on idle filesystem. If root
> > > filesystems are the target, then this should be run via a rescue
> > > environment that is not executing directly on the root fs. With
> > > those caveats in place, we can do the entire inode move as a set of
> > > non-destructive operations finalised by an atomic inode swap
> > > without any needing special kernel support.
> > > 
> > > To ensure we move metadata such as BMBT blocks even if we don't need
> > > to move data, we clone the data to a new inode that we've allocated
> > > in the destination AG. This will result in new bmbt blocks being
> > > allocated in the new location even though the data is not copied.
> > > Attributes need to be copied one at a time from the original inode.
> > > 
> > > If data needs to be moved, then we use fallocate(UNSHARE) to create
> > > a private copy of the range of data that needs to be moved in the
> > > new inode. This will be allocated in the destination AG by normal
> > > allocation policy.
> > > 
> > > Once the new inode has been finalised, use RENAME_EXCHANGE to swap
> > > it into place and unlink the original inode to free up all the
> > > resources it still pins.
> > > 
> > > There are many optimisations still possible to speed this up, but
> > > the goal here is "functional" rather than "optimal". Performance can
> > > be optimised once all the parts for a "empty the tail of the
> > > filesystem before shrink" operation are implemented and solidly
> > > tested.
> > > 
> > 
> > Neat idea. With respect to the shrink use case, what's the reasoning
> > behind userspace selecting the target AG? There's no harm in having the
> > target AG option in the utility of course, but ISTM that shrink might
> > care more about moving some set of inodes from a particular AG as
> > opposed to a specific target AG.
> 
> Oh, that's just a mechanism right now to avoid needing kernel
> allocator policy support for relocating things. Say for example, we
> plan to empty the top six AGs - we don't want the allocator to chose
> any of them for relocation, and in the absence of kernel side policy
> the only way we can direct that is to select an AG outside that
> range manually with a target directory location (as per xfs_fsr).
> 
> IOWs, I'm just trying to implement the move mechanisms without
> having to introduce new kernel API dependencies because I kinda want
> shrink to be possible with minimal kernel requirements. It's also
> not meant to be an optimal implementation at this point, merely a
> generic one. Adding policy hooks for controlling AG allocation can
> be done once we know exactly what the data movement process needs
> for optimal behaviour.
> 

Ok.

> > For example, might it make sense to implement a policy where move_inode
> > simply moves an inode to the first AG the tempdir lands in that is < the
> > AG of the source inode? We'd probably want to be careful to make sure
> > that we don't attempt to dump the entire set of moved files into the
> > same AG, but I assume the temp dir creation logic would effectively
> > rotor across the remaining set of AGs we do want to allow.. Thoughts?
> 
> Yes, we could. But I simply decided that a basic, robust shrink to
> the minimum possible size will have to fill the filesystem from AG 0
> up, and not move to AG 1 until AG 0 is full.  I also know that the
> kernel allocation policies will skip to the next AG if there is lock
> contention, space or other allocation setup issues, hence I wanted
> to be able to direct movement to the lowest possible AGs first...
> 
> THere's enough complexity in an optimal shrink implementation that
> it will keep someone busy full time for a couple of years. I want to
> provide the basic functionality userspace needs only spending a
> couple of days a week for a couple of months on it. If we want it
> fast and deployable on existing systems, compromises will need to be
> made...
> 

Yeah, I'm not suggesting we implement the eventual policy here. I do
think it would be nice if the userspace command implemented some
reasonable default when a target AG is not specified. That could be the
"anything less than source AG" logic I described above, a default target
of AG 0, or something similarly simple...

Brian 

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

