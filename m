Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8A9C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 14:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AC9206C3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 14:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJ5rdkT+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgGAOdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 10:33:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40559 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730852AbgGAOdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 10:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593613991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+Ns4BsuKMkh+pQgHV37u1JSNUjg2XjsW7Sq4yALyUI=;
        b=BJ5rdkT+S41Bu08WxXDBhoBc040Dh17Z8huu2azX9RltcbLRq5Xg05i1oD3Qm6AyJuxW1q
        L8lD+2xEN1JoMRJ3Rq+l9A17QPMBeDQZpx8pBRn3rxHsKHGuDZWI1Am6wDEmM2gPDRNK6s
        VuKzma1MmOVa2b9BnLEUl3zgW9lKfjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-hPLMmx8uMHmClPejj1nIQQ-1; Wed, 01 Jul 2020 10:33:10 -0400
X-MC-Unique: hPLMmx8uMHmClPejj1nIQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4FB881EDFD;
        Wed,  1 Jul 2020 14:32:21 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5230374191;
        Wed,  1 Jul 2020 14:32:21 +0000 (UTC)
Date:   Wed, 1 Jul 2020 10:32:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200701143219.GC1087@bfoster>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Tracking dirty inodes via cluster buffers creates lock ordering
> issues with logging unlinked inode updates direct to the cluster
> buffer. The unlinked inode list is unordered, so we can lock cluster
> buffers in random orders and that causes deadlocks.
> 
> To solve this problem, we really want to dealy locking the cluster
> buffers until the pre-commit phase where we can order the buffers
> correctly along with all the other inode cluster buffers that are
> locked by the transaction. However, to do this we need to be able to
> tell the transaction which inodes need to have there unlinked list
> updated and what it should be updated to.
> 
> We can delay the buffer update to the pre-commit phase based on the
> fact taht all unlinked inode list updates are serialised by the AGI
> buffer. It will be locked into the transaction before the list
> update starts, and will remain locked until the transaction commits.
> Hence we can lock and update the cluster buffers safely any time
> during the transaction and we are still safe from other racing
> unlinked list updates.
> 
> The iunlink log item currently only exists in memory. we need a log
> item to attach information to the transaction, but it's context
> is completely owned by the transaction. Hence it is never formatted
> or inserted into the CIL, nor is it seen by the journal, the AIL or
> log recovery.
> 
> This makes it a very simple log item, and the changes makes results
> in adding addition buffer log items to the transaction. Hence once
> the iunlink log item has run it's pre-commit operation, it can be
> dropped by the transaction and released.
> 
> The creation of this in-memory intent does not prevent us from
> extending it in future to the journal to replace buffer based
> logging of the unlinked list. Changing the format of the items we
> write to the on disk journal is beyond the scope of this patchset,
> hence we limit it to being in-memory only.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/xfs_inode.c        |  70 +++----------------
>  fs/xfs/xfs_inode_item.c   |   3 +-
>  fs/xfs/xfs_iunlink_item.c | 141 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iunlink_item.h |  24 +++++++
>  fs/xfs/xfs_super.c        |  10 +++
>  6 files changed, 189 insertions(+), 60 deletions(-)
>  create mode 100644 fs/xfs/xfs_iunlink_item.c
>  create mode 100644 fs/xfs/xfs_iunlink_item.h
> 
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0494b907c63d..bc1970c37edc 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -488,8 +488,9 @@ xfs_inode_item_push(
>  	ASSERT(iip->ili_item.li_buf);
>  
>  	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> -	    (ip->i_flags & XFS_ISTALE))
> +	    (ip->i_flags & XFS_ISTALE)) {
>  		return XFS_ITEM_PINNED;
> +	}

Spurious change..?

>  
>  	/* If the inode is already flush locked, we're already flushing. */
>  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> new file mode 100644
> index 000000000000..83f1dc81133b
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -0,0 +1,141 @@
...
> +
> +static const struct xfs_item_ops xfs_iunlink_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.iop_release	= xfs_iunlink_item_release,

Presumably we need the release callback for transaction abort, but the
flag looks unnecessary. That triggers a release on commit to the on-disk
log, which IIUC should never happen for this item.

> +	.iop_sort	= xfs_iunlink_item_sort,
> +	.iop_precommit	= xfs_iunlink_item_precommit,
> +};
> +
> +
> +/*
> + * Initialize the inode log item for a newly allocated (in-core) inode.
> + *
> + * Inode extents can only reside within an AG. Hence specify the starting
> + * block for the inode chunk by offset within an AG as well as the
> + * length of the allocated extent.
> + *
> + * This joins the item to the transaction and marks it dirty so
> + * that we don't need a separate call to do this, nor does the
> + * caller need to know anything about the iunlink item.
> + */

Looks like some copy/paste remnants in the comment.

Brian

> +void
> +xfs_iunlink_log(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_iunlink_item	*iup;
> +
> +	iup = kmem_zone_zalloc(xfs_iunlink_zone, 0);
> +
> +	xfs_log_item_init(tp->t_mountp, &iup->iu_item, XFS_LI_IUNLINK,
> +			  &xfs_iunlink_item_ops);
> +
> +	iup->iu_ino = ip->i_ino;
> +	iup->iu_next_unlinked = ip->i_next_unlinked;
> +	iup->iu_imap = ip->i_imap;
> +
> +	xfs_trans_add_item(tp, &iup->iu_item);
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &iup->iu_item.li_flags);
> +}
> diff --git a/fs/xfs/xfs_iunlink_item.h b/fs/xfs/xfs_iunlink_item.h
> new file mode 100644
> index 000000000000..c9e58acf4ccf
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.h
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020, Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef XFS_IUNLINK_ITEM_H
> +#define XFS_IUNLINK_ITEM_H	1
> +
> +struct xfs_trans;
> +struct xfs_inode;
> +
> +/* in memory log item structure */
> +struct xfs_iunlink_item {
> +	struct xfs_log_item	iu_item;
> +	struct xfs_imap		iu_imap;
> +	xfs_ino_t		iu_ino;
> +	xfs_agino_t		iu_next_unlinked;
> +};
> +
> +extern kmem_zone_t *xfs_iunlink_zone;
> +
> +void xfs_iunlink_log(struct xfs_trans *tp, struct xfs_inode *ip);
> +
> +#endif	/* XFS_IUNLINK_ITEM_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a5d9453cf51..a36dfb0e7e5b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -35,6 +35,7 @@
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
>  #include "xfs_reflink.h"
> +#include "xfs_iunlink_item.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -1955,8 +1956,16 @@ xfs_init_zones(void)
>  	if (!xfs_bui_zone)
>  		goto out_destroy_bud_zone;
>  
> +	xfs_iunlink_zone = kmem_cache_create("xfs_iul_item",
> +					     sizeof(struct xfs_iunlink_item),
> +					     0, 0, NULL);
> +	if (!xfs_iunlink_zone)
> +		goto out_destroy_bui_zone;
> +
>  	return 0;
>  
> + out_destroy_bui_zone:
> +	kmem_cache_destroy(xfs_bui_zone);
>   out_destroy_bud_zone:
>  	kmem_cache_destroy(xfs_bud_zone);
>   out_destroy_cui_zone:
> @@ -2003,6 +2012,7 @@ xfs_destroy_zones(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_cache_destroy(xfs_iunlink_zone);
>  	kmem_cache_destroy(xfs_bui_zone);
>  	kmem_cache_destroy(xfs_bud_zone);
>  	kmem_cache_destroy(xfs_cui_zone);
> -- 
> 2.26.2.761.g0e0b3e54be
> 

