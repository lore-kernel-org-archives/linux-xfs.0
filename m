Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5B6C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 18:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095B0206D8
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 18:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t0C4j2S7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgEOSwy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 14:52:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgEOSwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 14:52:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FIlcie153954;
        Fri, 15 May 2020 18:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZdbzBNFDKLAF0DynVLdZpZt3Dfdl2YoAXOojS2TmhVI=;
 b=t0C4j2S7Cli3ey4bMFcdaaOt2l+JE+R0afNZlR55D8mh/407lgk3V37yLVeNfSmDVlZ4
 OvYd5b6i2lVOVKh8LLDaH2L+2bdlusIM/xMri5vO4q/VJhCQ75RM6Ck4tAyKA/pEAjdu
 uplNw9OR1xYI6OjSMyirFKfV4HtqhMRhPs0m+5q9G/GPlsBRZsdVgJae5NK5yBnaEC71
 jLAXZa260aeXKWGFZS9vPHsMvhFPper+F0ND1SWoK86wQQL3EMEHKr1XK9RF6LXPVBtN
 cxSkLYc2bF5XJufOcWnlr2jqeHlh/ay4umV84d5XQQck/3KuE3r7d/BoSyo4GWpMfxQk eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xww515-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 18:52:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FImol5073782;
        Fri, 15 May 2020 18:52:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3100ys36gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 18:52:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04FIqke8026588;
        Fri, 15 May 2020 18:52:46 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 11:52:40 -0700
Date:   Fri, 15 May 2020 11:52:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs_repair: port the online repair newbt structure
Message-ID: <20200515185239.GN6714@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904190713.984305.3298591047333841655.stgit@magnolia>
 <20200514150933.GA50849@bfoster>
 <20200514192037.GD6714@magnolia>
 <20200515114116.GA54804@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515114116.GA54804@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=5
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 07:41:16AM -0400, Brian Foster wrote:
> On Thu, May 14, 2020 at 12:20:37PM -0700, Darrick J. Wong wrote:
> > On Thu, May 14, 2020 at 11:09:33AM -0400, Brian Foster wrote:
> > > On Sat, May 09, 2020 at 09:31:47AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Port the new btree staging context and related block reservation helper
> > > > code from the kernel to repair.  We'll use this in subsequent patches to
> > > > implement btree bulk loading.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  include/libxfs.h         |    1 
> > > >  libxfs/libxfs_api_defs.h |    2 
> > > >  repair/Makefile          |    4 -
> > > >  repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  repair/bload.h           |   79 +++++++++++++
> > > >  repair/xfs_repair.c      |   17 +++
> > > >  6 files changed, 377 insertions(+), 2 deletions(-)
> > > >  create mode 100644 repair/bload.c
> > > >  create mode 100644 repair/bload.h
> > > > 
> > > > 
> > > ...
> > > > diff --git a/repair/bload.c b/repair/bload.c
> > > > new file mode 100644
> > > > index 00000000..ab05815c
> > > > --- /dev/null
> > > > +++ b/repair/bload.c
> > > > @@ -0,0 +1,276 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > +/*
> > > > + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> > > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > + */
> > > > +#include <libxfs.h>
> > > > +#include "bload.h"
> > > > +
> > > > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > > > +#define trace_xrep_newbt_reserve_space(...)	((void) 0)
> > > > +#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
> > > > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > > > +
> > > > +int bload_leaf_slack = -1;
> > > > +int bload_node_slack = -1;
> > > > +
> > > > +/* Ported routines from fs/xfs/scrub/repair.c */
> > > > +
> > > 
> > > Any plans to generalize/lift more of this stuff into libxfs if it's
> > > going to be shared with xfsprogs?
> > 
> > That depends on what the final online repair code looks like.
> > I suspect it'll be different enough that it's not worth sharing, but I
> > wouldn't be opposed to sharing identical functions.
> > 
> 
> Ok, I was just going off the above note around porting existing code
> from kernel scrub. I think it's reasonable to consider generalizations
> later once both implementations are solidified.
> 
> > > ...
> > > > +/* Free all the accounting infor and disk space we reserved for a new btree. */
> > > > +void
> > > > +xrep_newbt_destroy(
> > > > +	struct xrep_newbt	*xnr,
> > > > +	int			error)
> > > > +{
> > > > +	struct repair_ctx	*sc = xnr->sc;
> > > > +	struct xrep_newbt_resv	*resv, *n;
> > > > +
> > > > +	if (error)
> > > > +		goto junkit;
> > > 
> > > Could use a comment on why we skip block freeing here..
> > 
> > I wonder what was the original reason for that?
> > 
> > IIRC if we actually error out of btree rebuilds then we've done
> > something totally wrong while setting up the btree loader, or the
> > storage is so broken that writes failed.  Repair is just going to call
> > do_error() to terminate (and leave us with a broken filesystem) so we
> > could just terminate right there at the top.
> > 
> 
> Indeed.

Bah, I just realized that you and I have already reviewed a lot of this
stuff for the kernel, and apparently I never backported that. :(

In looking at what's in the kernel now, I realized that in general,
the xfs_btree_bload_compute_geometry function will estimate the correct
number of blocks to reserve for the new btree, so all this code exists
to deal with either (a) overestimates when rebuilding the free space
btrees; or (b) the kernel encountering a runtime error (e.g. ENOMEM) and
needing to back out everything it's done.

For repair, (a) is still a possibility.  (b) is not, since repair will
abort, but on the other hand it'll be easier to review a patch to unify
the two implementations if the code stays identical.

Looking even further ahead, I plan to add two more users of the bulk
loader: rebuilders for the bmap btrees, and (even later) the realtime
rmapbt.  It would be helpful to keep as much of the code the same
between repair and scrub.

So for now we don't really need the ability to free an over-reservation,
but in the longer run it will make unification more obvious.

/me vaguely wonders if we ought to be reviewing both of these patchsets
in parallel....

> > > I'm also wondering if we can check error in the primary loop and kill
> > > the label and duplicate loop, but I guess that depends on whether the
> > > fields are always valid.
> > 
> > I think they are.
> > 
> > > > +
> > > > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > > > +		/* We don't have EFIs here so skip the EFD. */
> > > > +
> > > > +		/* Free every block we didn't use. */
> > > > +		resv->fsbno += resv->used;
> > > > +		resv->len -= resv->used;
> > > > +		resv->used = 0;
> > > > +
> > > > +		if (resv->len > 0) {
> > > > +			trace_xrep_newbt_unreserve_space(sc->mp,
> > > > +					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> > > > +					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> > > > +					resv->len, xnr->oinfo.oi_owner);
> > > > +
> > > > +			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> > > > +					&xnr->oinfo, true);
> > 
> > TBH for repair I don't even think we need this, since in theory we
> > reserved *exactly* the correct number of blocks for the btree.  Hmm.
> > 
> 
> Ok, well it would be good to clean up whether we remove it, clean it up
> or perhaps document why we wouldn't look at the resv fields on error if
> there turns out to be specific reason for that.

<nod>

> > > > +		}
> > > > +
> > > > +		list_del(&resv->list);
> > > > +		kmem_free(resv);
> > > > +	}
> > > > +
> > > > +junkit:
> > > > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > > > +		list_del(&resv->list);
> > > > +		kmem_free(resv);
> > > > +	}
> > > > +
> > > > +	if (sc->ip) {
> > > > +		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
> > > > +		xnr->ifake.if_fork = NULL;
> > > > +	}
> > > > +}
> > > > +
> > > ...
> > > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > > index 9d72fa8e..8fbd3649 100644
> > > > --- a/repair/xfs_repair.c
> > > > +++ b/repair/xfs_repair.c
> > > ...
> > > > @@ -49,6 +52,8 @@ static char *o_opts[] = {
> > > >  	[AG_STRIDE]		= "ag_stride",
> > > >  	[FORCE_GEO]		= "force_geometry",
> > > >  	[PHASE2_THREADS]	= "phase2_threads",
> > > > +	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> > > > +	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
> > > 
> > > Why the "debug_" in the option names?
> > 
> > These are debugging knobs; there's no reason why any normal user would
> > want to override the automatic slack sizing algorithms.  I also
> > refrained from documenting them in the manpage. :P
> > 
> 
> Oh, Ok. Perhaps that explains why they aren't in the usage() either. ;)

Yup.

--D

> Brian
> 
> > However, the knobs have been useful for stress-testing w/ fstests.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  	[O_MAX_OPTS]		= NULL,
> > > >  };
> > > >  
> > > > @@ -260,6 +265,18 @@ process_args(int argc, char **argv)
> > > >  		_("-o phase2_threads requires a parameter\n"));
> > > >  					phase2_threads = (int)strtol(val, NULL, 0);
> > > >  					break;
> > > > +				case BLOAD_LEAF_SLACK:
> > > > +					if (!val)
> > > > +						do_abort(
> > > > +		_("-o debug_bload_leaf_slack requires a parameter\n"));
> > > > +					bload_leaf_slack = (int)strtol(val, NULL, 0);
> > > > +					break;
> > > > +				case BLOAD_NODE_SLACK:
> > > > +					if (!val)
> > > > +						do_abort(
> > > > +		_("-o debug_bload_node_slack requires a parameter\n"));
> > > > +					bload_node_slack = (int)strtol(val, NULL, 0);
> > > > +					break;
> > > >  				default:
> > > >  					unknown('o', val);
> > > >  					break;
> > > > 
> > > 
> > 
> 
