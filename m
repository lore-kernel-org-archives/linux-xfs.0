Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B527AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 10:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C5420780
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 10:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2jiKqFN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgF3Kwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:52:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24729 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729377AbgF3Kwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 06:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593514364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ptK1iVe6KjW0JodSfQKmL/u3ECZawLvC6hObtB7kkA=;
        b=W2jiKqFNgAxlgLX/efu5m16F8hsAdEo06udmXcldDugpoHanEbI2BpvE/wKVT0kTAzM6N2
        Q1uetw4PAbZJfBL39IoazTgwxYpiVlVS9VsRe/KMUGSN89o2K2Lc2akZDvnPWKEr390pU/
        cfMIriqXJ0G7mMqaFxKjvEzvkB9fanw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-CGQnJitePhKOah7v7TRb3A-1; Tue, 30 Jun 2020 06:52:42 -0400
X-MC-Unique: CGQnJitePhKOah7v7TRb3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFC17193F562;
        Tue, 30 Jun 2020 10:52:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DE6710023A6;
        Tue, 30 Jun 2020 10:52:41 +0000 (UTC)
Date:   Tue, 30 Jun 2020 06:52:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200630105239.GA31056@bfoster>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835912.1065505.9943855193663354771.stgit@magnolia>
 <20200629122228.GB10449@bfoster>
 <20200629232140.GV7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629232140.GV7606@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 29, 2020 at 04:21:40PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 29, 2020 at 08:22:28AM -0400, Brian Foster wrote:
> > On Thu, Jun 25, 2020 at 01:52:39PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > In commit 9851fd79bfb1, we added a slight amount of slack to the free
> > > space btrees being reconstructed so that the initial fix_freelist call
> > > (which is run against a totally empty AGFL) would never have to split
> > > either free space btree in order to populate the free list.
> > > 
> > > The new btree bulk loading code in xfs_repair can re-create this
> > > situation because it can set the slack values to zero if the filesystem
> > > is very full.  However, these days repair has the infrastructure needed
> > > to ensure that overestimations of the btree block counts end up on the
> > > AGFL or get freed back into the filesystem at the end of phase 5.
> > > 
> > > Fix this problem by reserving blocks to a separate AGFL block
> > > reservation, and checking that between this new reservation and any
> > > overages in the bnobt/cntbt fakeroots, we have enough blocks sitting
> > > around to populate the AGFL with the minimum number of blocks it needs
> > > to handle a split in the bno/cnt/rmap btrees.
> > > 
> > > Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> > > of the reservation steps in phase 5, so the extra allocation should not
> > > cause repair to fail if it can't find blocks for btrees.
> > > 
> > > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  repair/agbtree.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
> > >  1 file changed, 68 insertions(+), 10 deletions(-)
> > > 
> > > 
> > > diff --git a/repair/agbtree.c b/repair/agbtree.c
> > > index 339b1489..7a4f316c 100644
> > > --- a/repair/agbtree.c
> > > +++ b/repair/agbtree.c
> > ...
> > > @@ -262,25 +286,59 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
> > ...
> > > +
> > > +		/*
> > > +		 * Now try to fill the bnobt/cntbt cursors with extra blocks to
> > > +		 * populate the AGFL.  If we don't get all the blocks we want,
> > > +		 * stop trying to fill the AGFL.
> > > +		 */
> > > +		wanted = (int64_t)btr_bno->bload.nr_blocks +
> > > +				(min_agfl_len / 2) - bno_blocks;
> > > +		if (wanted > 0 && fill_agfl) {
> > > +			got = reserve_agblocks(sc->mp, agno, btr_bno, wanted);
> > > +			if (wanted > got)
> > > +				fill_agfl = false;
> > > +			btr_bno->bload.nr_blocks += got;
> > > +		}
> > > +
> > > +		wanted = (int64_t)btr_cnt->bload.nr_blocks +
> > > +				(min_agfl_len / 2) - cnt_blocks;
> > > +		if (wanted > 0 && fill_agfl) {
> > > +			got = reserve_agblocks(sc->mp, agno, btr_cnt, wanted);
> > > +			if (wanted > got)
> > > +				fill_agfl = false;
> > > +			btr_cnt->bload.nr_blocks += got;
> > > +		}
> > 
> > It's a little hard to follow this with the nr_blocks sampling and
> > whatnot, but I think I get the idea. What's the reason for splitting the
> > AGFL res requirement evenly across the two cursors? These AGFL blocks
> > all fall into the same overflow pool, right? I was wondering why we
> > couldn't just attach the overflow to one, or check one for the full res
> > and then the other if more blocks are needed.
> 
> I chose to stuff the excess blocks into the bnobt and cntbt bulkload
> cursors to avoid having to initialize a semi-phony "bulkload cursor" for
> the agfl, and I decided to split them evenly between the two cursors so
> that I wouldn't have someday to deal with a bug report about how one
> cursor somehow ran out of blocks but the other one had plenty more.
> 
> > In thinking about it a bit more, wouldn't the whole algorithm be more
> > simple if we reserved the min AGFL requirement first, optionally passed
> > 'agfl_res' to reserve_btblocks() such that subsequent reservations can
> > steal from it (and then fail if it depletes), then stuff what's left in
> > one (or both, if there's a reason for that) of the cursors at the end?
> 
> Hmm.  I hadn't thought about that.  In general I wanted the AGFL
> reservations to go last because I'd rather we set off with an underfull
> AGFL than totally fail because we couldn't get blocks for the
> bnobt/cntbt, but I suppose you're right that we could steal from it as
> needed to prevent repair failure.
> 
> So, uh, I could rework this patch to create a phony agfl bulk load
> cursor, fill it before the loop, steal blocks from it to fill the
> bnobt/cntbt to satisfy failed allocations, and then dump any remainders
> into the bnobt/cntbt cursors afterwards.  How does that sound?
> 

Ok.. the whole phony cursor thing sounds a bit unfortunate. I was
thinking we'd just have a reservation counter or some such, but in
reality we'd need that to pass down into the block reservation code to
acquire actual blocks for one, then we'd need new code to allocate said
blocks from the phony agfl cursor rather than the in-core block lists,
right? Perhaps it's not worth doing that if it doesn't reduce complexity
as much as shuffle it around or even add a bit more... :/

I wonder if a reasonable simplification/tradeoff might be to just
refactor the agfl logic in the current patch into a helper function that
1.) calculates the current overflow across both cursors and the current
total agfl "wanted" requirement based on that 2.) performs a single
reservation to try and accommodate on one of the cursors and 3.) adds a
bit more to the comment to explain that we're just overloading the bnobt
cursor (for example) for extra agfl res. Hm?

Brian

> --D
> 
> > Brian
> > 
> > >  
> > >  		/* Ok, now how many free space records do we have? */
> > >  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > >  	} while (1);
> > > -
> > > -	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> > > -			(cnt_blocks - btr_cnt->bload.nr_blocks);
> > >  }
> > >  
> > >  /* Rebuild the free space btrees. */
> > > 
> > 
> 

