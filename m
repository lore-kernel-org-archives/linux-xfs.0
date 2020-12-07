Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA67C0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1C8235E4
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgLGODo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:03:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgLGODo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607349737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2vGQonZJdDbvGDocYv1R+lIWUTAhUH9klieXs8R0PqY=;
        b=aG40T4gfhaxtPYN6u2XHk/VmMZvmfwdwOP3wtJ0scniQjcTeNCnDDPGlTpW2WKXfyuEob/
        YTAPTCWVshTX2PMlc5GDEfevlhew7Ses/wV5wm1oVAXeVuZ2ICOD1yKuOaCe52DLKAy+OG
        3JDsjKvc2R0ocFQx7WIEso0pPO14S3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-zzrhzlrENGC9la4D9KDywA-1; Mon, 07 Dec 2020 09:02:15 -0500
X-MC-Unique: zzrhzlrENGC9la4D9KDywA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AE4E107ACF9;
        Mon,  7 Dec 2020 14:02:14 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 246605C1A1;
        Mon,  7 Dec 2020 14:02:14 +0000 (UTC)
Date:   Mon, 7 Dec 2020 09:02:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
Message-ID: <20201207140212.GB1585352@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435080.734470.11175993745850698818.stgit@magnolia>
 <20201204140036.GK1404170@bfoster>
 <20201206230842.GI629293@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206230842.GI629293@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:08:42PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 04, 2020 at 09:00:36AM -0500, Brian Foster wrote:
> > On Thu, Dec 03, 2020 at 05:12:30PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > The bmap, rmap, and refcount log intent items were added to support the
> > > rmap and reflink features.  Because these features come with changes to
> > > the ondisk format, the log items aren't tied to a log incompat flag.
> > > 
> > > However, the log recovery routines don't actually check for those
> > > feature flags.  The kernel has no business replayng an intent item for a
> > > feature that isn't enabled, so check that as part of recovered log item
> > > validation.  (Note that kernels pre-dating rmap and reflink will fail
> > > the mount on the unknown log item type code.)
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_bmap_item.c     |    4 ++++
> > >  fs/xfs/xfs_refcount_item.c |    3 +++
> > >  fs/xfs/xfs_rmap_item.c     |    3 +++
> > >  3 files changed, 10 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > index 78346d47564b..4ea9132716c6 100644
> > > --- a/fs/xfs/xfs_bmap_item.c
> > > +++ b/fs/xfs/xfs_bmap_item.c
> > > @@ -425,6 +425,10 @@ xfs_bui_validate(
> > >  {
> > >  	struct xfs_map_extent		*bmap;
> > >  
> > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> > > +	    !xfs_sb_version_hasreflink(&mp->m_sb))
> > > +		return false;
> > > +
> > 
> > Took me a minute to realize we use the map/unmap for extent swap if rmap
> > is enabled. That does make me wonder a bit.. had we made this kind of
> > recovery feature validation change before that came around (such that we
> > probably would have only checked _hasreflink() here), would we have
> > created an unnecessary backwards incompatibility?
> 
> Yes.
> 
> I confess to cheating a little here -- technically the bmap intents were
> introduced with reflink in 4.9, whereas rmap was introduced in 4.8.  The
> proper solution is probably to introduce a new log incompat bit for bmap
> intents when reflink isn't enabled, but TBH there were enough other rmap
> bugs in 4.8 (not to mention the EXPERIMENTAL warning) that nobody should
> be running that old of a kernel on a production system.
> 
> (Also we don't enable rmap by default yet whereas reflink has been
> enabled by default since 4.18, so the number of people affected probably
> isn't very high...)
> 

Hmm, so this all has me a a bit concerned over the value proposition for
these particular feature checks. The current reflink/rmap feature
situation may work out Ok in practice, but it sounds like that is partly
due to timing and a little bit of luck around when the implementations
and interdependencies landed. This code will ultimately introduce a
verification pattern that will likely be followed for new features,
associated log item types, etc. and it's not totally clear to me that
we'd always get it right (as opposed to something more granular like
incompat bits for intent formats). Is this addressing a real problem
we've seen in the wild or more of a fuzzing thing?

> Secondary question: should we patch 4.9 and 4.14 to disable rmap and
> reflink support, since they both still have EXPERIMENTAL warnings?
> 

That sounds like an odd thing to do to a stable kernel, but that's just
my .02.

Brian

> --D
> 
> > Brian
> > 
> > >  	/* Only one mapping operation per BUI... */
> > >  	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> > >  		return false;
> > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > index 8ad6c81f6d8f..2b28f5643c0b 100644
> > > --- a/fs/xfs/xfs_refcount_item.c
> > > +++ b/fs/xfs/xfs_refcount_item.c
> > > @@ -423,6 +423,9 @@ xfs_cui_validate_phys(
> > >  	struct xfs_mount		*mp,
> > >  	struct xfs_phys_extent		*refc)
> > >  {
> > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > +		return false;
> > > +
> > >  	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
> > >  		return false;
> > >  
> > > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > > index f296ec349936..2628bc0080fe 100644
> > > --- a/fs/xfs/xfs_rmap_item.c
> > > +++ b/fs/xfs/xfs_rmap_item.c
> > > @@ -466,6 +466,9 @@ xfs_rui_validate_map(
> > >  	struct xfs_mount		*mp,
> > >  	struct xfs_map_extent		*rmap)
> > >  {
> > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > +		return false;
> > > +
> > >  	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
> > >  		return false;
> > >  
> > > 
> > 
> 

