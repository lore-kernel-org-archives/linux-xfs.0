Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142B0C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E16205CB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BN1A2+QF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgENPJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 11:09:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgENPJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 11:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589468981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yN1mO46YLzeg66JlNFH1p8eG3vHpjfC/7S5Ou/onxc8=;
        b=BN1A2+QFY9GuKhhYOUqT8tH8K70LA7Fja9GVSKZ1VTUy/3Bw0EW5ARoXxDiyPwjBq+s7IW
        moS6oJFpZWjaA3vkqoqFeu6zhkjfatqYC0uq0rNkclilN3YtaG8L6VAxczS/1EtPFeOIAQ
        rhM3B8dR2kSDMM8h8ofmMtvm/jZ/E7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-PJ_lTEsuPHerMeaHs9cRRg-1; Thu, 14 May 2020 11:09:36 -0400
X-MC-Unique: PJ_lTEsuPHerMeaHs9cRRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADF92107ACF2;
        Thu, 14 May 2020 15:09:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1372E60F8D;
        Thu, 14 May 2020 15:09:34 +0000 (UTC)
Date:   Thu, 14 May 2020 11:09:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs_repair: port the online repair newbt structure
Message-ID: <20200514150933.GA50849@bfoster>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904190713.984305.3298591047333841655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904190713.984305.3298591047333841655.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Port the new btree staging context and related block reservation helper
> code from the kernel to repair.  We'll use this in subsequent patches to
> implement btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/libxfs.h         |    1 
>  libxfs/libxfs_api_defs.h |    2 
>  repair/Makefile          |    4 -
>  repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
>  repair/bload.h           |   79 +++++++++++++
>  repair/xfs_repair.c      |   17 +++
>  6 files changed, 377 insertions(+), 2 deletions(-)
>  create mode 100644 repair/bload.c
>  create mode 100644 repair/bload.h
> 
> 
...
> diff --git a/repair/bload.c b/repair/bload.c
> new file mode 100644
> index 00000000..ab05815c
> --- /dev/null
> +++ b/repair/bload.c
> @@ -0,0 +1,276 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <libxfs.h>
> +#include "bload.h"
> +
> +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> +#define trace_xrep_newbt_reserve_space(...)	((void) 0)
> +#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
> +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> +
> +int bload_leaf_slack = -1;
> +int bload_node_slack = -1;
> +
> +/* Ported routines from fs/xfs/scrub/repair.c */
> +

Any plans to generalize/lift more of this stuff into libxfs if it's
going to be shared with xfsprogs?

...
> +/* Free all the accounting infor and disk space we reserved for a new btree. */
> +void
> +xrep_newbt_destroy(
> +	struct xrep_newbt	*xnr,
> +	int			error)
> +{
> +	struct repair_ctx	*sc = xnr->sc;
> +	struct xrep_newbt_resv	*resv, *n;
> +
> +	if (error)
> +		goto junkit;

Could use a comment on why we skip block freeing here..

I'm also wondering if we can check error in the primary loop and kill
the label and duplicate loop, but I guess that depends on whether the
fields are always valid.

> +
> +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +		/* We don't have EFIs here so skip the EFD. */
> +
> +		/* Free every block we didn't use. */
> +		resv->fsbno += resv->used;
> +		resv->len -= resv->used;
> +		resv->used = 0;
> +
> +		if (resv->len > 0) {
> +			trace_xrep_newbt_unreserve_space(sc->mp,
> +					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> +					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> +					resv->len, xnr->oinfo.oi_owner);
> +
> +			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> +					&xnr->oinfo, true);
> +		}
> +
> +		list_del(&resv->list);
> +		kmem_free(resv);
> +	}
> +
> +junkit:
> +	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +		list_del(&resv->list);
> +		kmem_free(resv);
> +	}
> +
> +	if (sc->ip) {
> +		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
> +		xnr->ifake.if_fork = NULL;
> +	}
> +}
> +
...
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9d72fa8e..8fbd3649 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
...
> @@ -49,6 +52,8 @@ static char *o_opts[] = {
>  	[AG_STRIDE]		= "ag_stride",
>  	[FORCE_GEO]		= "force_geometry",
>  	[PHASE2_THREADS]	= "phase2_threads",
> +	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> +	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",

Why the "debug_" in the option names?

Brian

>  	[O_MAX_OPTS]		= NULL,
>  };
>  
> @@ -260,6 +265,18 @@ process_args(int argc, char **argv)
>  		_("-o phase2_threads requires a parameter\n"));
>  					phase2_threads = (int)strtol(val, NULL, 0);
>  					break;
> +				case BLOAD_LEAF_SLACK:
> +					if (!val)
> +						do_abort(
> +		_("-o debug_bload_leaf_slack requires a parameter\n"));
> +					bload_leaf_slack = (int)strtol(val, NULL, 0);
> +					break;
> +				case BLOAD_NODE_SLACK:
> +					if (!val)
> +						do_abort(
> +		_("-o debug_bload_node_slack requires a parameter\n"));
> +					bload_node_slack = (int)strtol(val, NULL, 0);
> +					break;
>  				default:
>  					unknown('o', val);
>  					break;
> 

