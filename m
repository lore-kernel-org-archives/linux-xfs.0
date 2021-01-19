Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071DDC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC9323107
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390516AbhASTqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:46:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729360AbhASTpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 14:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611085452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2dVKrYYx1pvlMGXNDtreQcY0OEeX98/bN1choIxBHNM=;
        b=UbNSvOJ7KoM9srELOyXThs+rf5iko8G8uz2pwB4xLnovdni8vUUENtiy2U6sw5WDFX0Zau
        thvjDevK6/AcKiUF8jTVTrJ34WwOGA20A9fCaqJeujFKLnyrD+E0qJqXCaRrHagyEP9f0F
        lIn5KQ+IESiOTyqPeNPcdc9PUUgH51M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-DTL3jiHbOXO4VhS6xBMiKg-1; Tue, 19 Jan 2021 14:44:10 -0500
X-MC-Unique: DTL3jiHbOXO4VhS6xBMiKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF51C107ACE3;
        Tue, 19 Jan 2021 19:44:08 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6311660D06;
        Tue, 19 Jan 2021 19:44:08 +0000 (UTC)
Date:   Tue, 19 Jan 2021 14:44:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210119194406.GJ1646807@bfoster>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
 <20210119143754.GB1646807@bfoster>
 <20210119180318.GP3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119180318.GP3134581@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 10:15:49AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 19, 2021 at 09:37:54AM -0500, Brian Foster wrote:
> > On Fri, Jan 15, 2021 at 05:24:53PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Clear the needsrepair flag, since it's used to prevent mounting of an
> > > inconsistent filesystem.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Code/errors look much cleaner. Though looking at the repair code again,
> > I wonder... if we clear the needsrepair bit and dirty/write the sb in
> > phase 2 and then xfs_repair happens to crash, do we risk clearing the
> > bit and thus allowing a potential mount before whatever requisite
> > metadata updates have been made?
> 
> [Oh good, now mail.kernel.org is having problems...]
> 
> Yes, though I think that falls into the realm of "sysadmins should be
> sufficiently self-aware not to expect mount to work after repair
> fails/system crashes during an upgrade".
> 
> I've thought about how to solve the general problem of preventing people
> from mounting filesystems if repair doesn't run to completion.  I think
> xfs_repair could be modified so that once it finds the primary super, it
> writes it back out with NEEDSREPAIR set (V5) or inprogress set (V4).
> Once we've finished the buffer cache flush at the end of repair, we
> clear needsrepair/inprogress and write the primary super again.
> 

That's kind of what I was thinking.. set a global flag if/when we come
across the bit set on disk and clear it as a final step.

> An optimization on that would be to find a way to avoid that first super
> write until we flush the first dirty buffer.
> 
> Another way to make repair more "transactional" would be to do it would
> be to fiddle with the buffer manager so that writes are sent to a
> metadump file which could be mdrestore'd if repair completes
> successfully.  But that's a short-circuit around the even bigger project
> of porting the kernel logging code to userspace and use that in repair.
> 

Yeah, I wouldn't want to have clearing a feature bit depend on such a
significant rework of core functionality. The bit is not going to be set
in most cases, so I'd suspect an extra superblock write at the end of
repair wouldn't be much of a problem. In fact, it looks like main()
already has an unconditional sb write before the final libxfs_unmount()
call. Perhaps we could just hitch onto that for the primary super
update (and continue to clear the secondaries earlier as the current
patch does)..?

Brian

> --D
> 
> > Brian
> > 
> > >  repair/agheader.c |   15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > > 
> > > 
> > > diff --git a/repair/agheader.c b/repair/agheader.c
> > > index 8bb99489..d9b72d3a 100644
> > > --- a/repair/agheader.c
> > > +++ b/repair/agheader.c
> > > @@ -452,6 +452,21 @@ secondary_sb_whack(
> > >  			rval |= XR_AG_SB_SEC;
> > >  	}
> > >  
> > > +	if (xfs_sb_version_needsrepair(sb)) {
> > > +		if (!no_modify)
> > > +			sb->sb_features_incompat &=
> > > +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > +		if (i == 0) {
> > > +			if (!no_modify)
> > > +				do_warn(
> > > +	_("clearing needsrepair flag and regenerating metadata\n"));
> > > +			else
> > > +				do_warn(
> > > +	_("would clear needsrepair flag and regenerate metadata\n"));
> > > +		}
> > > +		rval |= XR_AG_SB_SEC;
> > > +	}
> > > +
> > >  	return(rval);
> > >  }
> > >  
> > > 
> > 
> 

