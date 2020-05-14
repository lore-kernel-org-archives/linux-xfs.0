Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A798C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E09720643
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bh0ERX0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgENTUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 15:20:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgENTUp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 15:20:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJHAqo049386;
        Thu, 14 May 2020 19:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QiZ9X0VohvPlptvYwIrv32vXzlXNw1U9irGe8+f++5k=;
 b=Bh0ERX0GJH0s/UzFDG+fRRyNmGFs/DZ0XqjvxV6fb0CJ33DxXJ4QMLIaedoe6KqyN9iU
 eXVJmlgQYO1miqjhI3CwxKnU1J7eUgDpipD9+lozK4vja+4PtaxncbJuNnvLneDhR/eF
 0mo1Gu3M+0tTjVwDUwOzxsiIfuWJzuU0MdYR1eD5VAM86mvYZpf2uJak8GcWwW6KPIjt
 zVsbBAK1mQUqaXLhBTFGvlo3C4IjZt6tsPwANY6tokuSUOnQ/bQt66vmeJafcq/752C0
 LkDvZaBKeQlr7va72XiGhkfsPb6lW5EeOw5/R+FnGoVyiuMxqHDpn0V3ZZ/+CeoLQ3Ny 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwvku8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 19:20:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJI6Iq179524;
        Thu, 14 May 2020 19:20:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100yd8nna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 19:20:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EJKckK032378;
        Thu, 14 May 2020 19:20:38 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 12:20:38 -0700
Date:   Thu, 14 May 2020 12:20:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs_repair: port the online repair newbt structure
Message-ID: <20200514192037.GD6714@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904190713.984305.3298591047333841655.stgit@magnolia>
 <20200514150933.GA50849@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514150933.GA50849@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=5 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 11:09:33AM -0400, Brian Foster wrote:
> On Sat, May 09, 2020 at 09:31:47AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Port the new btree staging context and related block reservation helper
> > code from the kernel to repair.  We'll use this in subsequent patches to
> > implement btree bulk loading.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/libxfs.h         |    1 
> >  libxfs/libxfs_api_defs.h |    2 
> >  repair/Makefile          |    4 -
> >  repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
> >  repair/bload.h           |   79 +++++++++++++
> >  repair/xfs_repair.c      |   17 +++
> >  6 files changed, 377 insertions(+), 2 deletions(-)
> >  create mode 100644 repair/bload.c
> >  create mode 100644 repair/bload.h
> > 
> > 
> ...
> > diff --git a/repair/bload.c b/repair/bload.c
> > new file mode 100644
> > index 00000000..ab05815c
> > --- /dev/null
> > +++ b/repair/bload.c
> > @@ -0,0 +1,276 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#include <libxfs.h>
> > +#include "bload.h"
> > +
> > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > +#define trace_xrep_newbt_reserve_space(...)	((void) 0)
> > +#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
> > +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> > +
> > +int bload_leaf_slack = -1;
> > +int bload_node_slack = -1;
> > +
> > +/* Ported routines from fs/xfs/scrub/repair.c */
> > +
> 
> Any plans to generalize/lift more of this stuff into libxfs if it's
> going to be shared with xfsprogs?

That depends on what the final online repair code looks like.
I suspect it'll be different enough that it's not worth sharing, but I
wouldn't be opposed to sharing identical functions.

> ...
> > +/* Free all the accounting infor and disk space we reserved for a new btree. */
> > +void
> > +xrep_newbt_destroy(
> > +	struct xrep_newbt	*xnr,
> > +	int			error)
> > +{
> > +	struct repair_ctx	*sc = xnr->sc;
> > +	struct xrep_newbt_resv	*resv, *n;
> > +
> > +	if (error)
> > +		goto junkit;
> 
> Could use a comment on why we skip block freeing here..

I wonder what was the original reason for that?

IIRC if we actually error out of btree rebuilds then we've done
something totally wrong while setting up the btree loader, or the
storage is so broken that writes failed.  Repair is just going to call
do_error() to terminate (and leave us with a broken filesystem) so we
could just terminate right there at the top.

> I'm also wondering if we can check error in the primary loop and kill
> the label and duplicate loop, but I guess that depends on whether the
> fields are always valid.

I think they are.

> > +
> > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > +		/* We don't have EFIs here so skip the EFD. */
> > +
> > +		/* Free every block we didn't use. */
> > +		resv->fsbno += resv->used;
> > +		resv->len -= resv->used;
> > +		resv->used = 0;
> > +
> > +		if (resv->len > 0) {
> > +			trace_xrep_newbt_unreserve_space(sc->mp,
> > +					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> > +					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> > +					resv->len, xnr->oinfo.oi_owner);
> > +
> > +			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> > +					&xnr->oinfo, true);

TBH for repair I don't even think we need this, since in theory we
reserved *exactly* the correct number of blocks for the btree.  Hmm.

> > +		}
> > +
> > +		list_del(&resv->list);
> > +		kmem_free(resv);
> > +	}
> > +
> > +junkit:
> > +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> > +		list_del(&resv->list);
> > +		kmem_free(resv);
> > +	}
> > +
> > +	if (sc->ip) {
> > +		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
> > +		xnr->ifake.if_fork = NULL;
> > +	}
> > +}
> > +
> ...
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 9d72fa8e..8fbd3649 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> ...
> > @@ -49,6 +52,8 @@ static char *o_opts[] = {
> >  	[AG_STRIDE]		= "ag_stride",
> >  	[FORCE_GEO]		= "force_geometry",
> >  	[PHASE2_THREADS]	= "phase2_threads",
> > +	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> > +	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
> 
> Why the "debug_" in the option names?

These are debugging knobs; there's no reason why any normal user would
want to override the automatic slack sizing algorithms.  I also
refrained from documenting them in the manpage. :P

However, the knobs have been useful for stress-testing w/ fstests.

--D

> Brian
> 
> >  	[O_MAX_OPTS]		= NULL,
> >  };
> >  
> > @@ -260,6 +265,18 @@ process_args(int argc, char **argv)
> >  		_("-o phase2_threads requires a parameter\n"));
> >  					phase2_threads = (int)strtol(val, NULL, 0);
> >  					break;
> > +				case BLOAD_LEAF_SLACK:
> > +					if (!val)
> > +						do_abort(
> > +		_("-o debug_bload_leaf_slack requires a parameter\n"));
> > +					bload_leaf_slack = (int)strtol(val, NULL, 0);
> > +					break;
> > +				case BLOAD_NODE_SLACK:
> > +					if (!val)
> > +						do_abort(
> > +		_("-o debug_bload_node_slack requires a parameter\n"));
> > +					bload_node_slack = (int)strtol(val, NULL, 0);
> > +					break;
> >  				default:
> >  					unknown('o', val);
> >  					break;
> > 
> 
