Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD21C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 19:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB24820728
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 19:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZCf3DSW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgEOTnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 15:43:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgEOTnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 15:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589571829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k6pAXcI7HcCV/YqptylM5T0nv5jvwo/uHBggMIx7CRY=;
        b=QZCf3DSW6rnwxmCO47KHciqrXtbT7SjlW+wbKmyOLD99BUuxjU2qwxs8CO+UEdCxNNmkYa
        GJ8xw7hnMMNhaTJzIa2LzKVcT+ciN0FRMVHep/HhDRCHQReyE3rfkcTMzDNZdQQp8YrhJF
        fmMiiZR3kxmsDoJQ9GME0yQ+fGX8iBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-kgiOlimoP2euCP4mKeI0hA-1; Fri, 15 May 2020 15:43:47 -0400
X-MC-Unique: kgiOlimoP2euCP4mKeI0hA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F9E6460;
        Fri, 15 May 2020 19:43:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F5F56FDD1;
        Fri, 15 May 2020 19:43:45 +0000 (UTC)
Date:   Fri, 15 May 2020 15:43:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs_repair: port the online repair newbt structure
Message-ID: <20200515194343.GA57267@bfoster>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904190713.984305.3298591047333841655.stgit@magnolia>
 <20200514150933.GA50849@bfoster>
 <20200514192037.GD6714@magnolia>
 <20200515114116.GA54804@bfoster>
 <20200515185239.GN6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515185239.GN6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 11:52:39AM -0700, Darrick J. Wong wrote:
> On Fri, May 15, 2020 at 07:41:16AM -0400, Brian Foster wrote:
> > On Thu, May 14, 2020 at 12:20:37PM -0700, Darrick J. Wong wrote:
> > > On Thu, May 14, 2020 at 11:09:33AM -0400, Brian Foster wrote:
> > > > On Sat, May 09, 2020 at 09:31:47AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Port the new btree staging context and related block reservation helper
> > > > > code from the kernel to repair.  We'll use this in subsequent patches to
> > > > > implement btree bulk loading.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  include/libxfs.h         |    1 
> > > > >  libxfs/libxfs_api_defs.h |    2 
> > > > >  repair/Makefile          |    4 -
> > > > >  repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  repair/bload.h           |   79 +++++++++++++
> > > > >  repair/xfs_repair.c      |   17 +++
> > > > >  6 files changed, 377 insertions(+), 2 deletions(-)
> > > > >  create mode 100644 repair/bload.c
> > > > >  create mode 100644 repair/bload.h
> > > > > 
> > > > > 
> > > > ...
> > > > > diff --git a/repair/bload.c b/repair/bload.c
> > > > > new file mode 100644
> > > > > index 00000000..ab05815c
> > > > > --- /dev/null
> > > > > +++ b/repair/bload.c
> > > > > @@ -0,0 +1,276 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > > +/*
> > > > > + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> > > > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > + */
> > > > > +#include <libxfs.h>
> > > > > +#include "bload.h"
> > > > > +
> > > > > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > > > > +#define trace_xrep_newbt_reserve_space(...)	((void) 0)
> > > > > +#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
> > > > > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > > > > +
> > > > > +int bload_leaf_slack = -1;
> > > > > +int bload_node_slack = -1;
> > > > > +
> > > > > +/* Ported routines from fs/xfs/scrub/repair.c */
> > > > > +
> > > > 
> > > > Any plans to generalize/lift more of this stuff into libxfs if it's
> > > > going to be shared with xfsprogs?
> > > 
> > > That depends on what the final online repair code looks like.
> > > I suspect it'll be different enough that it's not worth sharing, but I
> > > wouldn't be opposed to sharing identical functions.
> > > 
> > 
> > Ok, I was just going off the above note around porting existing code
> > from kernel scrub. I think it's reasonable to consider generalizations
> > later once both implementations are solidified.
> > 
> > > > ...
> > > > > +/* Free all the accounting infor and disk space we reserved for a new btree. */
> > > > > +void
> > > > > +xrep_newbt_destroy(
> > > > > +	struct xrep_newbt	*xnr,
> > > > > +	int			error)
> > > > > +{
> > > > > +	struct repair_ctx	*sc = xnr->sc;
> > > > > +	struct xrep_newbt_resv	*resv, *n;
> > > > > +
> > > > > +	if (error)
> > > > > +		goto junkit;
> > > > 
> > > > Could use a comment on why we skip block freeing here..
> > > 
> > > I wonder what was the original reason for that?
> > > 
> > > IIRC if we actually error out of btree rebuilds then we've done
> > > something totally wrong while setting up the btree loader, or the
> > > storage is so broken that writes failed.  Repair is just going to call
> > > do_error() to terminate (and leave us with a broken filesystem) so we
> > > could just terminate right there at the top.
> > > 
> > 
> > Indeed.
> 
> Bah, I just realized that you and I have already reviewed a lot of this
> stuff for the kernel, and apparently I never backported that. :(
> 

Ok, I thought that stuff was actually merged so I'm kind of confused at
this point. :P

> In looking at what's in the kernel now, I realized that in general,
> the xfs_btree_bload_compute_geometry function will estimate the correct
> number of blocks to reserve for the new btree, so all this code exists
> to deal with either (a) overestimates when rebuilding the free space
> btrees; or (b) the kernel encountering a runtime error (e.g. ENOMEM) and
> needing to back out everything it's done.
> 
> For repair, (a) is still a possibility.  (b) is not, since repair will
> abort, but on the other hand it'll be easier to review a patch to unify
> the two implementations if the code stays identical.
> 
> Looking even further ahead, I plan to add two more users of the bulk
> loader: rebuilders for the bmap btrees, and (even later) the realtime
> rmapbt.  It would be helpful to keep as much of the code the same
> between repair and scrub.
> 
> So for now we don't really need the ability to free an over-reservation,
> but in the longer run it will make unification more obvious.
> 

It's also easier to review code that's already been reviewed from the
kernel and is being carted over for reuse, so I think it makes sense to
keep things in sync for that reason as well.

> /me vaguely wonders if we ought to be reviewing both of these patchsets
> in parallel....
> 

Re: above. I thought that stuff was merged and the approach was to move
the code over for reuse between scrub/xfs_repair. In any event, I think
what would facilitate subsequent reviews is some explicit separation
between patches for shared code and repair-specific code as well as some
references in the cover letter for the source of the former if those
bits haven't landed in the kernel yet...

Brian

> > > > I'm also wondering if we can check error in the primary loop and kill
> > > > the label and duplicate loop, but I guess that depends on whether the
> > > > fields are always valid.
> > > 
> > > I think they are.
> > > 
> > > > > +
> > > > > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > > > > +		/* We don't have EFIs here so skip the EFD. */
> > > > > +
> > > > > +		/* Free every block we didn't use. */
> > > > > +		resv->fsbno += resv->used;
> > > > > +		resv->len -= resv->used;
> > > > > +		resv->used = 0;
> > > > > +
> > > > > +		if (resv->len > 0) {
> > > > > +			trace_xrep_newbt_unreserve_space(sc->mp,
> > > > > +					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> > > > > +					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> > > > > +					resv->len, xnr->oinfo.oi_owner);
> > > > > +
> > > > > +			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> > > > > +					&xnr->oinfo, true);
> > > 
> > > TBH for repair I don't even think we need this, since in theory we
> > > reserved *exactly* the correct number of blocks for the btree.  Hmm.
> > > 
> > 
> > Ok, well it would be good to clean up whether we remove it, clean it up
> > or perhaps document why we wouldn't look at the resv fields on error if
> > there turns out to be specific reason for that.
> 
> <nod>
> 
> > > > > +		}
> > > > > +
> > > > > +		list_del(&resv->list);
> > > > > +		kmem_free(resv);
> > > > > +	}
> > > > > +
> > > > > +junkit:
> > > > > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > > > > +		list_del(&resv->list);
> > > > > +		kmem_free(resv);
> > > > > +	}
> > > > > +
> > > > > +	if (sc->ip) {
> > > > > +		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
> > > > > +		xnr->ifake.if_fork = NULL;
> > > > > +	}
> > > > > +}
> > > > > +
> > > > ...
> > > > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > > > index 9d72fa8e..8fbd3649 100644
> > > > > --- a/repair/xfs_repair.c
> > > > > +++ b/repair/xfs_repair.c
> > > > ...
> > > > > @@ -49,6 +52,8 @@ static char *o_opts[] = {
> > > > >  	[AG_STRIDE]		= "ag_stride",
> > > > >  	[FORCE_GEO]		= "force_geometry",
> > > > >  	[PHASE2_THREADS]	= "phase2_threads",
> > > > > +	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> > > > > +	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
> > > > 
> > > > Why the "debug_" in the option names?
> > > 
> > > These are debugging knobs; there's no reason why any normal user would
> > > want to override the automatic slack sizing algorithms.  I also
> > > refrained from documenting them in the manpage. :P
> > > 
> > 
> > Oh, Ok. Perhaps that explains why they aren't in the usage() either. ;)
> 
> Yup.
> 
> --D
> 
> > Brian
> > 
> > > However, the knobs have been useful for stress-testing w/ fstests.
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > >  	[O_MAX_OPTS]		= NULL,
> > > > >  };
> > > > >  
> > > > > @@ -260,6 +265,18 @@ process_args(int argc, char **argv)
> > > > >  		_("-o phase2_threads requires a parameter\n"));
> > > > >  					phase2_threads = (int)strtol(val, NULL, 0);
> > > > >  					break;
> > > > > +				case BLOAD_LEAF_SLACK:
> > > > > +					if (!val)
> > > > > +						do_abort(
> > > > > +		_("-o debug_bload_leaf_slack requires a parameter\n"));
> > > > > +					bload_leaf_slack = (int)strtol(val, NULL, 0);
> > > > > +					break;
> > > > > +				case BLOAD_NODE_SLACK:
> > > > > +					if (!val)
> > > > > +						do_abort(
> > > > > +		_("-o debug_bload_node_slack requires a parameter\n"));
> > > > > +					bload_node_slack = (int)strtol(val, NULL, 0);
> > > > > +					break;
> > > > >  				default:
> > > > >  					unknown('o', val);
> > > > >  					break;
> > > > > 
> > > > 
> > > 
> > 
> 

