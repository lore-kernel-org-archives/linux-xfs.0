Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF4AC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0E4207FB
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mw2tpBwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgIJNVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 09:21:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33049 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730755AbgIJNT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 09:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599743993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TTP5opvf/hWGTgyEmk4OFKElhACu8EIZ8cJ7hNPJPuY=;
        b=Mw2tpBwNLpYqJrvL2SNrI2tff1tAsMEge/ABy0S0wXPpd1EpVqKn8XPpbQ6fk5oFvbvIL9
        0AqigLIrx3EPh13PqA+XHXqlSdcwBk9X/U0596tz/fChm3MtzrWI5JAREPmqB413ZdDXju
        ZqE3KzEkfCM6YPyRGSWeSql3khTtwtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-wCo0MaWDPHqPcJplvfZV-A-1; Thu, 10 Sep 2020 09:19:51 -0400
X-MC-Unique: wCo0MaWDPHqPcJplvfZV-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F98281E20B;
        Thu, 10 Sep 2020 13:19:50 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CFAA7E8C1;
        Thu, 10 Sep 2020 13:19:50 +0000 (UTC)
Date:   Thu, 10 Sep 2020 09:19:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add a free space extent change reservation
Message-ID: <20200910131948.GB1143857@bfoster>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-3-david@fromorbit.com>
 <20200909133525.GB765129@bfoster>
 <20200909225127.GR12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909225127.GR12131@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 08:51:27AM +1000, Dave Chinner wrote:
> On Wed, Sep 09, 2020 at 09:35:25AM -0400, Brian Foster wrote:
> > On Wed, Sep 09, 2020 at 06:19:11PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Lots of the transaction reservation code reserves space for an
> > > extent allocation. It is inconsistently implemented, and many of
> > > them get it wrong. Introduce a new function to calculate the log
> > > space reservation for adding or removing an extent from the free
> > > space btrees.
> > > 
> > > This function reserves space for logging the AGF, the AGFL and the
> > > free space btrees, avoiding the need to account for them seperately
> > > in every reservation that manipulates free space.
> > > 
> > > Convert the EFI recovery reservation to use this transaction
> > > reservation as EFI recovery only needs to manipulate the free space
> > > index.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_trans_resv.c | 19 ++++++++++++++++++-
> > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > > index da2ec052ac0a..621ddb277dfa 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > @@ -79,6 +79,23 @@ xfs_allocfree_log_count(
> > >  	return blocks;
> > >  }
> > >  
> > > +/*
> > > + * Log reservation required to add or remove a single extent to the free space
> > > + * btrees.  This requires modifying:
> > > + *
> > > + * the agf header: 1 sector
> > > + * the agfl header: 1 sector
> > > + * the allocation btrees: 2 trees * (max depth - 1) * block size
> > 
> > Nit, but the xfs_allocfree_log_count() helper this uses clearly
> > indicates reservation for up to four trees. It might be worth referring
> > to that here just to minimize spreading details all over the place that
> > are likely to become stale or inconsistent over time.
> 
> Yup, but now I think of it, xfs_allocfree_log_count() doesn't seem
> right for freeing, and I need to check how allocation works again
> because stuff gets deferred.
> 
> i.e. on freeing, AFAICT we don't modify the freespace trees, the reflink
> tree and the rmap trees all in the same transaction. We do a cycle
> that looks like this:
> 
> log new intent, commit, execute the intent, log the intent done,
> log new intent, commit, execute the intent, log the intent done,
> log new intent, commit, ....
> 
> And so I'm not sure that we are modifying the reflink, rmap and free
> space trees all in the same transaction and commit.
> 

Indeed.

> > 
> > > + */
> > > +uint
> > > +xfs_allocfree_extent_res(
> > > +	struct xfs_mount *mp)
> > > +{
> > > +	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> > > +	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> > 
> > Why calculate for a single extent when an EFI can refer to multiple
> > extents?
> 
> This isn't anything to do with an EFI at this point. It's just the
> reservation needed to remove a single extent from a single AG in
> isolation. I wanted to isolate this reservation completely from the
> rest of the transaction reservations and how it ends up being used.
> 

Sure, but this is used as the reservation size for tr_efi. The current
itruncate reservation is clearly more than is required for EFI recovery,
but my point is that the current itruncate code means recovery must
handle EFIs with at least a couple extents (perhaps more based on your
analysis below). Recovery currently processes efi_nextents all in a
single transaction. The current recovery reservation seems to
accommodate current runtime behavior, but does the new reservation based
on this helper satisfy EFIs with >1 extents? I haven't tested it, but it
seems potentially deficient based on inspection...

> This deadlock surprised me, and so reflection and insight has lead
> me to think that we actually need our reservations to reflect the
> specific operations that will be performed by the transaction rather
> than an aggregation of things that get modified.
> 
> Then each reservation can contain the reservations for each
> operation it performance (e.g. free an extent) 
> 
> That's kinda what this "intent needs it's own reservation"
> 

Ack.

> > I thought the max was 2, but the extent free portion of the
> > itruncate calculation actually uses an op count of 4. The reason for
> > that is not immediately clear to me.
> 
> THe reason is that itruncate used to allow 4 extents to be freed in
> a single transaction. i.e. XFS_ITRUNC_MAX_EXTENTS used to be defined
> to 4, it is now 2.
> 

Ok, well that's a simple enough explanation.. :P

> However, if you want to relate this to EFIs, I think this
> reservation is completely bogus. If all the extents freed a single
> BMBT extent free are packed into a single EFI (i.e. all the BMBT
> blocks freed and the data extent) then we'll overrun the reservation
> extent count of 4. The max extents being freed in a single
> BMBT extent free operations is a full bmbt merge + the data extent.
> i.e. XFS_BM_MAXLEVELS + 1 extents in a single EFI. Except that
> we're allowed to pack two data extent frees into a single EFI, and
> that means it is, worst case, a full BMBT merge + a BMBT merge up to
> level below root + 2 data extents, or:
> 

All I want to do wrt to this patch is make sure the recovery reservation
is large enough to process the EFIs it might see in the log based on the
current code.

> = (XFS_BM_MAXLEVELS + 1) + ((XFS_BM_MAXLEVELS - 1 - 1) + 1)
> = XFS_BM_MAXLEVELS * 2 extents
> 
> And then we try to free all those extents in a single itruncate unit
> reservation. We probably don't hit this often because the maximum
> BMBT level is bound by filesystem size, and it's rare to have a >=
> 4-level BMBT tree needed to make this problematic.  We do not have a
> reservation large enough to do that as a single transaction, and we
> don't want to have a reservation that large, either.
> 

Agreed.

> This is not a limitation of the EFI/EFD construct - that can
> effectively be unbound. The limitation is that we don't roll and
> relog the EFD between each extent in the EFI that we free. The
> itruncate reservation has a bound limit for freeing extents, the
> EFI reservation does not define that.
> 

Sure.

> So, really, I think our extent free reservations and some of the
> intent execution behaviour needs a serious audit and rework, and we
> need to decouple the extent allocation and freeing reservations as
> extent allocation is now a fundamentally different operation to
> freeing an extent. i.e. Allocation does BMBT, refcount, rmap and
> freespace tree mods all in one transaction, while freeing does
> multiple individual transactional modifications linked by chained
> intents.
> 

I don't think an allocation transaction is so overloaded as compared to
freeing. I thought reflink was more of a separate remap operation vs
being tied to block allocation, not to say that a remap might depend on
block allocs or not, but both remaps and refcount updates look like
individual intents (along with rmapbt updates associated with block
mappings/allocations). Regardless, I agree that the current transaction
(and associated reservation) situation is a mess, particularly now with
more use of intents, complex chains thereof, and certain transactions
(tr_itruncate/tr_write) being overloaded to the point where they're huge
or simply too difficult to reason about..

Brian

> > Either way, multiple extents are factored into the current freeing
> > reservation and the extent freeing code at runtime (dfops) and during
> > recovery both appear to iterate on an extent count (potentially > 1) per
> > transaction. The itruncate comment, for reference (I also just noticed
> > that the subsequent patch modifies this comment, so you're presumably
> > aware of this mess):
> > 
> > /*
> >  * ...
> >  * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
> >  *    the agf for each of the ags: 4 * sector size
> >  *    the agfl for each of the ags: 4 * sector size
> >  *    the super block to reflect the freed blocks: sector size
> >  *    worst case split in allocation btrees per extent assuming 4 extents:
> >  *              4 exts * 2 trees * (2 * max depth - 1) * block size
> >  * ...
> >  */
> 
> Oh, yeah, I'm well aware of it - ISTR commenting on it past
> discussions about the transaction reservation sizes being much
> larger than necessary....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

