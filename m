Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879CC07548
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEDC2145D
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKXy8ldg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgIJNVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 09:21:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726059AbgIJNVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 09:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599744065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4uY8YmS8Kot3ewyasKE6CO9JxNZvXhJbikWnvBqu2aE=;
        b=FKXy8ldgFOMYRnSDBm4sj6+Y2002L9xrNhXcqnT43PZbWeryLbeaBXdYmMFSN56R315a2q
        dENviZ5kyces8obRbBcn5vK7aHdHV5s+qhzH8ml0ACbaFvsE34OgYa+wvT1U+p+yB15EIq
        0RYW4jR94fAejxLjsYv7oNZjUoL8M8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-xwV8A4a5M9efDhIVc9Jfvg-1; Thu, 10 Sep 2020 09:21:02 -0400
X-MC-Unique: xwV8A4a5M9efDhIVc9Jfvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2761800D41;
        Thu, 10 Sep 2020 13:21:01 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 172CE7E731;
        Thu, 10 Sep 2020 13:21:01 +0000 (UTC)
Date:   Thu, 10 Sep 2020 09:20:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200910132059.GC1143857@bfoster>
References: <20200904155949.GF529978@bfoster>
 <20200904222936.GH12131@dread.disaster.area>
 <20200908155602.GB721341@bfoster>
 <20200908210720.GP12131@dread.disaster.area>
 <20200909150035.GC765129@bfoster>
 <20200909225937.GS12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909225937.GS12131@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 08:59:37AM +1000, Dave Chinner wrote:
> On Wed, Sep 09, 2020 at 11:00:35AM -0400, Brian Foster wrote:
> > On Wed, Sep 09, 2020 at 07:07:20AM +1000, Dave Chinner wrote:
> > > On Tue, Sep 08, 2020 at 11:56:02AM -0400, Brian Foster wrote:
> > > > - xfs_trans_mod_dquot_byino() (via xfs_bmapi_write() -> ... -> xfs_bmap_btalloc() ->
> > > >   xfs_bmap_btalloc_accounting()) skips accounting the allocated blocks
> > > >   to the group dquot because it is not enabled
> > > 
> > > Right, the reservation functions need to do the same thing as
> > > xfs_trans_mod_dquot_byino(). I simply missed that for the
> > > reservation functions. i.e. Adding the same style of check like:
> > > 
> > > 	if (XFS_IS_UQUOTA_ON(mp) && udq)
> > > 
> > > before doing anything with user quota will avoid this problem as
> > > we are already in transaction context and the UQUOTA on or off state
> > > will not change until the transaction ends.
> > > 
> > > > concept itself. It seems like we should be able to head this issue off
> > > > somewhere in this sequence (i.e., checking the appropriate flag before
> > > > the dquot is attached), but it also seems like the quotaoff start/end
> > > > plus various quota flags all fit together a certain way and I feel like
> > > > some pieces of the puzzle are still missing from a design standpoint...
> > > 
> > > I can't think of anything that is missing - the quota off barrier
> > > gives us an atomic quota state change w.r.t. running transactions,
> > > so we just need to make sure we check the quota state before joining
> > > anything quota related to a transaction rather than assume that the
> > > presence of a dquot attached to an inode means that quotas are on.
> > > 
> > 
> > This gets back to my earlier questions around the various quota flags.
> > If I trace through the code of some operations, it seems like this
> > approach should work (once this logging issue is addressed, and more
> > testing required of course). However if I refer back to the runtime
> > macro comment:
> > 
> > /*
> >  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
> >  * quota will be not be switched off as long as that inode lock is held.
> >  */
> > 
> > This will technically no longer be the case because the updated quotaoff
> > will clear all of the flags before cycling any ilocks and detaching
> > dquots. I'm aware it will drain the transaction subsystem, but does
> > anything else depend on not seeing such a state change with an inode
> > lock held? I haven't seen anything so far that would conflict, but the
> > comment here is rather vague on details.
> 
> Not that I know of. I would probably rewrite the above comment as:
> 
> /*
>  * Checking XFS_IS_*QUOTA_ON() while inside an active quota modifying
>  * transaction context guarantees quota will be not be switched until after the
>  * entire rolling transaction chain is completed.
>  */
> 
> To clarify the situation. Having the inode locked will now only
> guarantee that the dquot will not go away while the inode is locked,
> it doesn't guarantee that quota will not switch off any more.
> 

Ok, that makes more sense.

> > Conversely, if not, I'm wondering whether there's a need for an ACTIVE
> > flag at all if we'd clear it at the same time as the ACCT|ENFD flags
> > during quotaoff anyways. It sounds like the answer to both those
> > questions is no based on your previous responses, perhaps reason being
> > that the transaction drain on the quotaoff side effectively replaces the
> > need for this rule on the general transaction side. Hm? Note that I
> > wouldn't remove the ACTIVE flag immediately anyways, but I want to make
> > sure the concern is clear..
> 
> Yes, I think you are right - the ACTIVE flag could probably away as
> it doesn't really play a part in the quota-off dance anymore. We'd
> still need the IS_QUOTA_ON() checks, but they'd look at ACCT|ENFD
> instead...
> 

Ack. Thanks for the sanity check.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

