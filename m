Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95151C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 13:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2E420760
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 13:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RliDIdIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgFKN42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 09:56:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59038 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726157AbgFKN41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jun 2020 09:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591883785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bBACAuR7+rA3fA+GIu2CvqhjM84mMdiReNvu3A8NGiY=;
        b=RliDIdIf42AzPfwwilKo+ogNMuaUBgeP2REOSVYPxyIkFR8+YimPWGOnjXF+G8wqt7goph
        u7lINc/jmJkPFidU41nThwTMSFRPen6WEU/3nR4S3HfsaNszPsZ3wgOlf29C8WpxWfqXFA
        R1BMJCrXs/qwevDxamBEYkoImGkktvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Icf-Os9-MIGYgPj9wmkwsw-1; Thu, 11 Jun 2020 09:56:21 -0400
X-MC-Unique: Icf-Os9-MIGYgPj9wmkwsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CF9919057A0;
        Thu, 11 Jun 2020 13:56:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42C781002395;
        Thu, 11 Jun 2020 13:56:20 +0000 (UTC)
Date:   Thu, 11 Jun 2020 09:56:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200611135618.GA56572@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-29-david@fromorbit.com>
 <20200609131155.GB40899@bfoster>
 <20200609220139.GJ2040@dread.disaster.area>
 <20200610130628.GA50747@bfoster>
 <20200610234008.GM2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610234008.GM2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 09:40:08AM +1000, Dave Chinner wrote:
> On Wed, Jun 10, 2020 at 09:06:28AM -0400, Brian Foster wrote:
> > On Wed, Jun 10, 2020 at 08:01:39AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 09, 2020 at 09:11:55AM -0400, Brian Foster wrote:
> > > > On Thu, Jun 04, 2020 at 05:46:04PM +1000, Dave Chinner wrote:
> > > > > -		 * check is not sufficient.
> > > > > +		 * If we are shut down, unpin and abort the inode now as there
> > > > > +		 * is no point in flushing it to the buffer just to get an IO
> > > > > +		 * completion to abort the buffer and remove it from the AIL.
> > > > >  		 */
> > > > > -		if (!cip->i_ino) {
> > > > > -			xfs_ifunlock(cip);
> > > > > -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> > > > > +		if (XFS_FORCED_SHUTDOWN(mp)) {
> > > > > +			xfs_iunpin_wait(ip);
> > > > 
> > > > Note that we have an unlocked check above that skips pinned inodes.
> > > 
> > > Right, but we could be racing with a transaction commit that pinned
> > > the inode and a shutdown. As the comment says: it's a quick and
> > > dirty check to avoid trying to get locks when we know that it is
> > > unlikely we can flush the inode without blocking. We still have to
> > > recheck that state once we have the ILOCK....
> > > 
> > 
> > Right, but that means we can just as easily skip the shutdown processing
> > (which waits for unpin) if a particular inode is pinned. So which is
> > supposed to happen in the shutdown case?
> >
> > ISTM that either could happen. As a result this kind of looks like
> > random logic to me.
> 
> Yes, shutdown is racy, so it could be either. However, I'm not
> changing the shutdown logic or handling here. If the shutdown race
> could happen before this patchset (and it can), it can still happen
> after the patchset, and this patchset does not change the way we
> handle the shutdown race at all.
> 
> IOWs, while this shutdown logic may appear "random", that's not a
> result of this patchset - it a result of design decisions made in
> the last major shutdown rework/cleanup that required checks to be
> added to places that could hang waiting for an event that would
> never occur because shutdown state prevented it from occurring.
> 

It's not so much the shutdown check that I find random as much as how it
intends to handle pinned inodes.

> There's already enough complexity in this patchset that adding
> shutdown logic changes is just too much to ask for.  If we want to
> change how various shutdown logics work, lets do it as a separate
> set of changes so all the subtle bugs that result from the changes
> bisect to the isolated shutdown logic changes...
> 

The fact that shutdown is racy is just background context. My point is
that this patch appears to introduce special shutdown handling for a
condition where it 1.) didn't previously exist and 2.) doesn't appear to
be necessary.

The current push/flush code only incorporates a shutdown check
indirectly via mapping the buffer, which simulates an I/O failure and
causes us to abort the flush (and shutdown if the I/O failure happened
for some other reason). If the shutdown happened sometime after we
acquired the buffer, then there's no real impact on this code path. We
flush the inode(s) and return success. The shutdown will be handled
appropriately when xfsaild attempts to submit the buffer.

The new code no longer maps the buffer because that is done much
earlier, but for some reason incorporates a new check to abort the flush
if the fs is already shutdown. The problem I have with this is that
these checks tend to be brittle, untested and a maintenance burden. As
such, I don't think we should ever add new shutdown checks for cases
that aren't required for functional correctness. That way we hopefully
move to a state where we have the minimum number of shutdown checks with
broadest coverage to ensure everything unwinds correctly, but don't have
to constantly battle with insufficiently tested logic in obscure
contexts that silently break as surrounding code changes over time and
leads to random fstests hangs and shutdown logic cleanouts every couple
of years.

So my question for any newly added shutdown check is: what problem does
this check solve? If there isn't an explicit functional problem and it's
intended more as convenience/efficiency logic (which is what the comment
implies), then I don't think it's justified. If there is one, then
perhaps it is justified, but should be more clearly documented (and I do
still think the pin check logic should be cleaned up, but that's a very
minor tweak).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

