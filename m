Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3E7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6561206E2
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 14:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mdj3nQuh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGGONQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:13:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21646 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726900AbgGGONQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 10:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594131194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MPqCsE7HqxAJ6Im+aZc6PTyD9We/DvyQryMp1kZyf0s=;
        b=Mdj3nQuhSsorWSY4scGZALdm8KpeNpvxWsn1Phh8hPpta4aUn/THdgx6c6I0kRF/e4P30N
        9K+MSBmWRkLHp6KIBTgi+LzrV2auSGGwiOlbN0lwxSpIZQf+7onOk+fVOid6c4IMb20mzs
        /fv6YilfgJDFBqGiekdOinX82x1gEFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472--vH1ABrXOResK8YJRL83kg-1; Tue, 07 Jul 2020 10:13:12 -0400
X-MC-Unique: -vH1ABrXOResK8YJRL83kg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18900107ACCA;
        Tue,  7 Jul 2020 14:13:11 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 813A85C1BB;
        Tue,  7 Jul 2020 14:13:10 +0000 (UTC)
Date:   Tue, 7 Jul 2020 10:13:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: try to fill the AGFL before we fix the
 freelist
Message-ID: <20200707141308.GA55781@bfoster>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362968.3579756.14752877317465395252.stgit@magnolia>
 <20200707125906.GB37141@bfoster>
 <20200707140708.GK7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707140708.GK7606@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 07:07:08AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 07, 2020 at 08:59:06AM -0400, Brian Foster wrote:
> > On Thu, Jul 02, 2020 at 08:27:09AM -0700, Darrick J. Wong wrote:
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
> > > Fix this problem by reserving extra blocks in the bnobt reservation, and
> > > checking that there are enough overages in the bnobt/cntbt fakeroots to
> > > populate the AGFL with the minimum number of blocks it needs to handle a
> > > split in the bno/cnt/rmap btrees.
> > > 
> > > Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> > > of the reservation steps in phase 5, so the extra allocation should not
> > > cause repair to fail if it can't find blocks for btrees.
> > > 
> > > Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  repair/agbtree.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
> > >  1 file changed, 44 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/repair/agbtree.c b/repair/agbtree.c
> > > index de8015ec..9f64d54b 100644
> > > --- a/repair/agbtree.c
> > > +++ b/repair/agbtree.c
> > ...
> > > @@ -268,16 +288,33 @@ _("Unable to compute free space by length btree geometry, error %d.\n"), -error)
> > >  				 btr_cnt->bload.nr_blocks;
> > >  
> > >  		/* We don't need any more blocks, so we're done. */
> > > -		if (delta_bno >= 0 && delta_cnt >= 0) {
> > > +		if (delta_bno >= 0 && delta_cnt >= 0 &&
> > > +		    delta_bno + delta_cnt >= agfl_goal) {
> > >  			*extra_blocks = delta_bno + delta_cnt;
> > >  			break;
> > >  		}
> > >  
> > >  		/* Allocate however many more blocks we need this time. */
> > > -		if (delta_bno < 0)
> > > +		if (delta_bno < 0) {
> > >  			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
> > > -		if (delta_cnt < 0)
> > > +			delta_bno = 0;
> > > +		}
> > > +		if (delta_cnt < 0) {
> > >  			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
> > > +			delta_cnt = 0;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Try to fill the bnobt cursor with extra blocks to populate
> > > +		 * the AGFL.  If we don't get all the blocks we want, stop
> > > +		 * trying to fill the AGFL because the AG is totally out of
> > > +		 * space.
> > > +		 */
> > > +		agfl_wanted = agfl_goal - (delta_bno + delta_cnt);
> > > +		if (agfl_wanted > 0 &&
> > > +		    agfl_wanted != reserve_agblocks(sc->mp, agno, btr_bno,
> > > +						    agfl_wanted))
> > > +			agfl_goal = 0;
> > 
> > Nit: can we split off the function call so it's not embedded in the if
> > condition? With that tweak:
> 
> It occurs to me that we don't care how much we fall short of the
> requested allocation.  I could change reserve_agblocks to return true if
> it got all the blocks it was asked to get, and then that becomes:
> 
> 		if (agfl_wanted > 0 &&
> 		    !reserve_agblocks(sc->mp, agno, btr_bno, agfl_wanted)
> 			agfl_goal = 0;
> 
> How does that sound?
> 

Looks readable enough to me, thanks.

Brian

> --D
> 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > >  
> > >  		/* Ok, now how many free space records do we have? */
> > >  		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> > > 
> > 
> 

