Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE9C43462
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CDA6143C
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbhEJNl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 09:41:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346893AbhEJMyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 08:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620651181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IN/Tn0R41rIprAbzj/viX0JVTZevidBcKnoHt2bk4bQ=;
        b=XnMFdfq8GwNImRr6P9dXJX8z6arnzFjM330q8U/b0qmWwUT3hP43SgYd14wfdaZn0WqoFt
        PqpPZgdh5Oj+4U5eYkfHzfagmC7mN2GmRgC5InCSjyNC4wIGyfkljMq3BXfH/Q0BFrpShP
        VPWEuQJT9gmQ6H5+TMvzZipZ2mL8qZ0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-jEmlHEdZPjK86wCN7UdCHA-1; Mon, 10 May 2021 08:52:59 -0400
X-MC-Unique: jEmlHEdZPjK86wCN7UdCHA-1
Received: by mail-qv1-f70.google.com with SMTP id c5-20020a0ca9c50000b02901aede9b5061so12436997qvb.14
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 05:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IN/Tn0R41rIprAbzj/viX0JVTZevidBcKnoHt2bk4bQ=;
        b=JUQ2jNKQe1SHZ2Di4IEFwqQkygvHCQezTUlOILCRR12pme0csarXwK23PTXr68SOCc
         RMYsrPeig0ynZcgoSZ6v/9s+3Jc65dGZ6tro8QRG3EC4ZPGuA2BaEq6Ooy9S4+re14zO
         S3066PXJaOwYJfVrYsD3PUSaXPB/gM7TF4+dxlObAm9ar1qKz7AP7WgJeqZ8oKXYyGMi
         Z/G/oKRJPhllyuFurKYeGOFd+tNSCuoa2prfLe5YIiTexbGjmTj7UOMG9yymDcyft681
         Ow2Qbh7LRSsXDQtkuu0PUNvZgxazBndZgSUv21GBymiBNRR6rjIpWyqXGSlAYNVBlLu+
         IAPQ==
X-Gm-Message-State: AOAM532f0F76+7YzSt4999be1T4XixkpCkvuUjIzD/6LqNzCd7OlJ6eb
        3/sNhkpnpmsjUKAjGg6f2WS1DwDwomcfEdxf2XF3QPs/Z5zLeT/5fZb9NWDdyWbm4DMiXRMqZjW
        TH95m6oioCWz1w1YnpsOv
X-Received: by 2002:a05:622a:11d1:: with SMTP id n17mr21788928qtk.360.1620651179056;
        Mon, 10 May 2021 05:52:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx89gGvJIE5KzKxvu+l3M6wi8RJ9kpKypFYhHDtlJL71ONYTdd+1Rt2BQeMD2zmtwoaBzRQbQ==
X-Received: by 2002:a05:622a:11d1:: with SMTP id n17mr21788904qtk.360.1620651178636;
        Mon, 10 May 2021 05:52:58 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 6sm11369690qkr.94.2021.05.10.05.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 05:52:58 -0700 (PDT)
Date:   Mon, 10 May 2021 08:52:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/22] xfs: move xfs_perag_get/put to xfs_ag.[ch]
Message-ID: <YJksqHGu80qgBImd@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:33PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> They are AG functions, not superblock functions, so move them to the
> appropriate location.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
...
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c68a36688474..2ca31dc46fe8 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -27,6 +27,141 @@
>  #include "xfs_defer.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> +#include "xfs_trace.h"

The corresponding xfs_trace.h include can now be removed from
libxfs/xfs_sb.c. Otherwise looks like a straightforward move:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +/*
> + * Passive reference counting access wrappers to the perag structures.  If the
> + * per-ag structure is to be freed, the freeing code is responsible for cleaning
> + * up objects with passive references before freeing the structure. This is
> + * things like cached buffers.
> + */
> +struct xfs_perag *
> +xfs_perag_get(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_perag	*pag;
> +	int			ref = 0;
> +
> +	rcu_read_lock();
> +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	if (pag) {
> +		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> +		ref = atomic_inc_return(&pag->pag_ref);
> +	}
> +	rcu_read_unlock();
> +	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
> +	return pag;
> +}
> +
> +/*
> + * search from @first to find the next perag with the given tag set.
> + */
> +struct xfs_perag *
> +xfs_perag_get_tag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			found;
> +	int			ref;
> +
> +	rcu_read_lock();
> +	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +					(void **)&pag, first, 1, tag);
> +	if (found <= 0) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	ref = atomic_inc_return(&pag->pag_ref);
> +	rcu_read_unlock();
> +	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
> +	return pag;
> +}
> +
> +void
> +xfs_perag_put(
> +	struct xfs_perag	*pag)
> +{
> +	int	ref;
> +
> +	ASSERT(atomic_read(&pag->pag_ref) > 0);
> +	ref = atomic_dec_return(&pag->pag_ref);
> +	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
> +}
> +
> +/*
> + * xfs_initialize_perag_data
> + *
> + * Read in each per-ag structure so we can count up the number of
> + * allocated inodes, free inodes and used filesystem blocks as this
> + * information is no longer persistent in the superblock. Once we have
> + * this information, write it into the in-core superblock structure.
> + */
> +int
> +xfs_initialize_perag_data(
> +	struct xfs_mount *mp,
> +	xfs_agnumber_t	agcount)
> +{
> +	xfs_agnumber_t	index;
> +	xfs_perag_t	*pag;
> +	xfs_sb_t	*sbp = &mp->m_sb;
> +	uint64_t	ifree = 0;
> +	uint64_t	ialloc = 0;
> +	uint64_t	bfree = 0;
> +	uint64_t	bfreelst = 0;
> +	uint64_t	btree = 0;
> +	uint64_t	fdblocks;
> +	int		error = 0;
> +
> +	for (index = 0; index < agcount; index++) {
> +		/*
> +		 * read the agf, then the agi. This gets us
> +		 * all the information we need and populates the
> +		 * per-ag structures for us.
> +		 */
> +		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> +		if (error)
> +			return error;
> +
> +		error = xfs_ialloc_pagi_init(mp, NULL, index);
> +		if (error)
> +			return error;
> +		pag = xfs_perag_get(mp, index);
> +		ifree += pag->pagi_freecount;
> +		ialloc += pag->pagi_count;
> +		bfree += pag->pagf_freeblks;
> +		bfreelst += pag->pagf_flcount;
> +		btree += pag->pagf_btreeblks;
> +		xfs_perag_put(pag);
> +	}
> +	fdblocks = bfree + bfreelst + btree;
> +
> +	/*
> +	 * If the new summary counts are obviously incorrect, fail the
> +	 * mount operation because that implies the AGFs are also corrupt.
> +	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
> +	 * will prevent xfs_repair from fixing anything.
> +	 */
> +	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
> +		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	/* Overwrite incore superblock counters with just-read data */
> +	spin_lock(&mp->m_sb_lock);
> +	sbp->sb_ifree = ifree;
> +	sbp->sb_icount = ialloc;
> +	sbp->sb_fdblocks = fdblocks;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	xfs_reinit_percpu_counters(mp);
> +out:
> +	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
> +	return error;
> +}
>  
>  static int
>  xfs_get_aghdr_buf(
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4535de1d88ea..cb1bd1c03cd7 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -9,6 +9,16 @@
>  
>  struct xfs_mount;
>  struct xfs_trans;
> +struct xfs_perag;
> +
> +/*
> + * perag get/put wrappers for ref counting
> + */
> +int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> +				   int tag);
> +void	xfs_perag_put(struct xfs_perag *pag);
>  
>  struct aghdr_init_data {
>  	/* per ag data */
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e32a1833d523..2e3dcdfd4984 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -19,7 +19,7 @@
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_ialloc_btree.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 82b7cbb1f24f..dc2b77829915 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -10,7 +10,6 @@
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_btree.h"
> @@ -24,6 +23,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a43e4c50e69b..a540b6e799e0 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_btree_staging.h"
> @@ -19,6 +18,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
> +#include "xfs_ag.h"
>  
>  
>  STATIC struct xfs_btree_cur *
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 556184b63061..aa371d005131 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -27,6 +27,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7e3b9b01431e..2086c55b67bd 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -31,6 +31,7 @@
>  #include "xfs_attr_leaf.h"
>  #include "xfs_filestream.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_refcount.h"
>  #include "xfs_icache.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index eefdb518fe64..8dc9225a5353 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -10,7 +10,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
> @@ -27,6 +26,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Lookup a record by ino in the btree given by cur.
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index a6ac60ae9421..b281f0c674f5 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_btree_staging.h"
> @@ -20,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  static struct xfs_btree_cur *
>  xfs_refcountbt_dup_cursor(
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 10e0cf9949a2..61e8f10436ac 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -21,6 +21,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_inode.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Lookup the first record less than or equal to [bno, len, owner, offset]
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 9f5bcbd834c3..f1fee42dda2d 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_trans.h"
>  #include "xfs_alloc.h"
> @@ -20,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_extent_busy.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index dfbbcbd448c1..cbcfce8cebf1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,67 +30,6 @@
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
>   */
>  
> -/*
> - * Reference counting access wrappers to the perag structures.
> - * Because we never free per-ag structures, the only thing we
> - * have to protect against changes is the tree structure itself.
> - */
> -struct xfs_perag *
> -xfs_perag_get(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno)
> -{
> -	struct xfs_perag	*pag;
> -	int			ref = 0;
> -
> -	rcu_read_lock();
> -	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> -	if (pag) {
> -		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> -		ref = atomic_inc_return(&pag->pag_ref);
> -	}
> -	rcu_read_unlock();
> -	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
> -	return pag;
> -}
> -
> -/*
> - * search from @first to find the next perag with the given tag set.
> - */
> -struct xfs_perag *
> -xfs_perag_get_tag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> -	int			tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			found;
> -	int			ref;
> -
> -	rcu_read_lock();
> -	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> -	if (found <= 0) {
> -		rcu_read_unlock();
> -		return NULL;
> -	}
> -	ref = atomic_inc_return(&pag->pag_ref);
> -	rcu_read_unlock();
> -	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
> -	return pag;
> -}
> -
> -void
> -xfs_perag_put(
> -	struct xfs_perag	*pag)
> -{
> -	int	ref;
> -
> -	ASSERT(atomic_read(&pag->pag_ref) > 0);
> -	ref = atomic_dec_return(&pag->pag_ref);
> -	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
> -}
> -
>  /* Check all the superblock fields we care about when reading one in. */
>  STATIC int
>  xfs_validate_sb_read(
> @@ -841,78 +780,6 @@ xfs_sb_mount_common(
>  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
>  }
>  
> -/*
> - * xfs_initialize_perag_data
> - *
> - * Read in each per-ag structure so we can count up the number of
> - * allocated inodes, free inodes and used filesystem blocks as this
> - * information is no longer persistent in the superblock. Once we have
> - * this information, write it into the in-core superblock structure.
> - */
> -int
> -xfs_initialize_perag_data(
> -	struct xfs_mount *mp,
> -	xfs_agnumber_t	agcount)
> -{
> -	xfs_agnumber_t	index;
> -	xfs_perag_t	*pag;
> -	xfs_sb_t	*sbp = &mp->m_sb;
> -	uint64_t	ifree = 0;
> -	uint64_t	ialloc = 0;
> -	uint64_t	bfree = 0;
> -	uint64_t	bfreelst = 0;
> -	uint64_t	btree = 0;
> -	uint64_t	fdblocks;
> -	int		error = 0;
> -
> -	for (index = 0; index < agcount; index++) {
> -		/*
> -		 * read the agf, then the agi. This gets us
> -		 * all the information we need and populates the
> -		 * per-ag structures for us.
> -		 */
> -		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> -		if (error)
> -			return error;
> -
> -		error = xfs_ialloc_pagi_init(mp, NULL, index);
> -		if (error)
> -			return error;
> -		pag = xfs_perag_get(mp, index);
> -		ifree += pag->pagi_freecount;
> -		ialloc += pag->pagi_count;
> -		bfree += pag->pagf_freeblks;
> -		bfreelst += pag->pagf_flcount;
> -		btree += pag->pagf_btreeblks;
> -		xfs_perag_put(pag);
> -	}
> -	fdblocks = bfree + bfreelst + btree;
> -
> -	/*
> -	 * If the new summary counts are obviously incorrect, fail the
> -	 * mount operation because that implies the AGFs are also corrupt.
> -	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
> -	 * will prevent xfs_repair from fixing anything.
> -	 */
> -	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
> -		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
> -	/* Overwrite incore superblock counters with just-read data */
> -	spin_lock(&mp->m_sb_lock);
> -	sbp->sb_ifree = ifree;
> -	sbp->sb_icount = ialloc;
> -	sbp->sb_fdblocks = fdblocks;
> -	spin_unlock(&mp->m_sb_lock);
> -
> -	xfs_reinit_percpu_counters(mp);
> -out:
> -	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
> -	return error;
> -}
> -
>  /*
>   * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
>   * into the superblock buffer to be logged.  It does not provide the higher
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index f79f9dc632b6..0c1602d9b53d 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -13,15 +13,6 @@ struct xfs_trans;
>  struct xfs_fsop_geom;
>  struct xfs_perag;
>  
> -/*
> - * perag get/put wrappers for ref counting
> - */
> -extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> -extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> -					   int tag);
> -extern void	xfs_perag_put(struct xfs_perag *pag);
> -extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> -
>  extern void	xfs_log_sb(struct xfs_trans *tp);
>  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
>  extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 7a2f9b5f2db5..64a7a30f4ac0 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -14,6 +14,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 23690f824ffa..1cdfbd57f36b 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -20,6 +20,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index aa874607618a..c8da976b50fc 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -12,7 +12,6 @@
>  #include "xfs_btree.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
>  #include "xfs_alloc.h"
> @@ -26,6 +25,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index f1d1a8c58853..453ae9adf94c 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -9,11 +9,11 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_sb.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_health.h"
>  #include "xfs_btree.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index 3de59b5c2ce6..2e61df3bca83 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -8,7 +8,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_btree.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_health.h"
>  #include "scrub/scrub.h"
>  #include "scrub/health.h"
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index c2857d854c83..1308b62a8170 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -22,6 +22,7 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_extent_busy.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_quota.h"
>  #include "scrub/scrub.h"
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 37a1d12762d8..38245c49b1b6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -10,7 +10,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> @@ -19,6 +18,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> +#include "xfs_ag.h"
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f979d0d7e6cd..3bf6dba1a040 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -8,7 +8,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_alloc_btree.h"
> @@ -18,6 +17,7 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  STATIC int
>  xfs_trim_extents(
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ef17c1f6db32..184732aa8674 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -11,13 +11,13 @@
>  #include "xfs_log_format.h"
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  void
>  xfs_extent_busy_insert(
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index db23e455eb91..eed6ca5f8f91 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -9,13 +9,13 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_mru_cache.h"
>  #include "xfs_trace.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans.h"
>  #include "xfs_filestream.h"
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..b79475ea3dbd 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -9,11 +9,11 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trace.h"
>  #include "xfs_health.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Warn about metadata corruption that we detected but haven't fixed, and
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3c81daca0e9a..588ea2bf88bb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> @@ -23,6 +22,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_ag.h"
>  
>  #include <linux/iversion.h>
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 17c2d8b18283..25910b145d70 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -11,7 +11,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
> @@ -35,6 +34,7 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_ag.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e5dd1c0c2f03..fee2a4e80241 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -25,6 +25,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_error.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_ag.h"
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bdfee1943796..21c630dde476 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -32,6 +32,7 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_health.h"
>  #include "xfs_trace.h"
> +#include "xfs_ag.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
>  static int xfs_uuid_table_size;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 4bf949a89d0d..f7baf4dc2554 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -23,6 +23,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_error.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 060695d6d56a..f297d68a931b 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -27,7 +27,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_reflink.h"
>  #include "xfs_iomap.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a2dab05332ac..688309dbe18b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -36,6 +36,7 @@
>  #include "xfs_bmap_item.h"
>  #include "xfs_reflink.h"
>  #include "xfs_pwork.h"
> +#include "xfs_ag.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> -- 
> 2.31.1
> 

