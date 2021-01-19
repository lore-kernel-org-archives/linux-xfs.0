Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16461C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE2A23104
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 20:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391333AbhASUb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbhASUb4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 15:31:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FBB23104;
        Tue, 19 Jan 2021 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611088271;
        bh=DH+vDiAMMKUnwjmDfIKpwtBohTGqyHBpeKRmzRHWfdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBRHku7D18u5OdI5B7T9x4azt71IO2XSMA68YAGP5XnoHVDqgT/xSSLEURAPCoCYU
         F3L+4fDuVcWiFOKltdbvgRDKHAg4EkqQ8UZVaa27/t2WtDUKOZIjUPGikUsvftqJox
         EtPcDGCOAaCdjUmbGEiXmzIFbmFkP+RBD22qkoVPqbKQe9rf4rkFC48GDiXB8PP3CR
         OK8t8oeyKfPcuaFIhqVzg6fMYjy3ZkHe1ZMeJVr4ouCh5e3DgA+lhI94hb/ghvc4+W
         n5X7t29pmWQRYD/xhTqMyh6kzYj3fJaJil9uc4i8mxWXM89sIvtCNExM4P2rlDoFJO
         ATZbJBpEEucEw==
Date:   Tue, 19 Jan 2021 12:31:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210119203110.GT3134581@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
 <20210119143754.GB1646807@bfoster>
 <20210119180318.GP3134581@magnolia>
 <20210119194406.GJ1646807@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119194406.GJ1646807@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 02:44:06PM -0500, Brian Foster wrote:
> On Tue, Jan 19, 2021 at 10:15:49AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 19, 2021 at 09:37:54AM -0500, Brian Foster wrote:
> > > On Fri, Jan 15, 2021 at 05:24:53PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Clear the needsrepair flag, since it's used to prevent mounting of an
> > > > inconsistent filesystem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > Code/errors look much cleaner. Though looking at the repair code again,
> > > I wonder... if we clear the needsrepair bit and dirty/write the sb in
> > > phase 2 and then xfs_repair happens to crash, do we risk clearing the
> > > bit and thus allowing a potential mount before whatever requisite
> > > metadata updates have been made?
> > 
> > [Oh good, now mail.kernel.org is having problems...]
> > 
> > Yes, though I think that falls into the realm of "sysadmins should be
> > sufficiently self-aware not to expect mount to work after repair
> > fails/system crashes during an upgrade".
> > 
> > I've thought about how to solve the general problem of preventing people
> > from mounting filesystems if repair doesn't run to completion.  I think
> > xfs_repair could be modified so that once it finds the primary super, it
> > writes it back out with NEEDSREPAIR set (V5) or inprogress set (V4).
> > Once we've finished the buffer cache flush at the end of repair, we
> > clear needsrepair/inprogress and write the primary super again.
> > 
> 
> That's kind of what I was thinking.. set a global flag if/when we come
> across the bit set on disk and clear it as a final step.

I think if I found it set on the primary sb I would leave it alone, and
if the bit wasn't set then I'd set it and bwrite the buffer immediately.
Probably we're talking about more or less the same thing...

> > An optimization on that would be to find a way to avoid that first super
> > write until we flush the first dirty buffer.
> > 
> > Another way to make repair more "transactional" would be to do it would
> > be to fiddle with the buffer manager so that writes are sent to a
> > metadump file which could be mdrestore'd if repair completes
> > successfully.  But that's a short-circuit around the even bigger project
> > of porting the kernel logging code to userspace and use that in repair.
> > 
> 
> Yeah, I wouldn't want to have clearing a feature bit depend on such a
> significant rework of core functionality. The bit is not going to be set
> in most cases, so I'd suspect an extra superblock write at the end of
> repair wouldn't be much of a problem. In fact, it looks like main()
> already has an unconditional sb write before the final libxfs_unmount()
> call. Perhaps we could just hitch onto that for the primary super
> update (and continue to clear the secondaries earlier as the current
> patch does)..?

Clearing the bit has to happen after the bcache purge and disk flush,
because we need to make sure that everything else we wrote actually made
it to stable storage.

Hm, I guess we could export libxfs_flush_mount so that repair could call
that, clear the fields in the sb, and then go ahead with the
libxfs_umount.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  repair/agheader.c |   15 +++++++++++++++
> > > >  1 file changed, 15 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/repair/agheader.c b/repair/agheader.c
> > > > index 8bb99489..d9b72d3a 100644
> > > > --- a/repair/agheader.c
> > > > +++ b/repair/agheader.c
> > > > @@ -452,6 +452,21 @@ secondary_sb_whack(
> > > >  			rval |= XR_AG_SB_SEC;
> > > >  	}
> > > >  
> > > > +	if (xfs_sb_version_needsrepair(sb)) {
> > > > +		if (!no_modify)
> > > > +			sb->sb_features_incompat &=
> > > > +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > > +		if (i == 0) {
> > > > +			if (!no_modify)
> > > > +				do_warn(
> > > > +	_("clearing needsrepair flag and regenerating metadata\n"));
> > > > +			else
> > > > +				do_warn(
> > > > +	_("would clear needsrepair flag and regenerate metadata\n"));
> > > > +		}
> > > > +		rval |= XR_AG_SB_SEC;
> > > > +	}
> > > > +
> > > >  	return(rval);
> > > >  }
> > > >  
> > > > 
> > > 
> > 
> 
