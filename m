Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1BDC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 14:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D41DE206C3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 14:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwO9Isj+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgGAObd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 10:31:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29404 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730245AbgGAObd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 10:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593613888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eDzgsisIpX3UBoWxs9HAiXFP+mfXK4m5KpbCtx6hRGQ=;
        b=ZwO9Isj+nHFPhHVQBVdFGnXNoaS+K8rNrEgC7q6e1AkK0zVGhzG83sxiJPI5eqog50BMVA
        H7jjmIV0C+X5foifrEHu/fI3YXI+VZzoo3KRfiO0lc0vNPOyviyVWaf0jllfcKDpBYvi2V
        WweUFiu+8xtvxwzbB/Mr+r1YchGTvgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-WFvDiA4ENHycl1g6mWendQ-1; Wed, 01 Jul 2020 10:31:24 -0400
X-MC-Unique: WFvDiA4ENHycl1g6mWendQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C09C1007278;
        Wed,  1 Jul 2020 14:31:23 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F387F8AD1A;
        Wed,  1 Jul 2020 14:31:22 +0000 (UTC)
Date:   Wed, 1 Jul 2020 10:31:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200701143121.GB1087@bfoster>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-4-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we cache unlinked inode list backrefs through a separate
> cache which has to be maintained via memory allocation and a hash
> table. When the inode is on the unlinked list, we have an existence
> guarantee for the inode in memory.
> 
> That is, if the inode is on the unlinked list, there must be a
> reference to the inode from the core VFS because dropping the last
> reference to the inode causes it to be removed from the unlinked
> list. Hence if we hold the AGI locked, we guarantee that any inode
> on the unlinked list is pinned in memory. That means we can actually
> track the entire unlinked list on the inode itself and use
> unreferenced inode cache lookups to update the list pointers as
> needed.
> 
> However, we don't use this relationship because log recovery has
> no in memory state and so has to work directly from buffers.
> However, because unlink recovery only removes from the head of the
> list, we can easily fake this in memory state as the inode we read
> in from the AGI bucket has a pointer to the next inode. Hence we can
> play reference leapfrog in the recovery loop always reading the
> second inode on the list and updating pointers before dropping the
> reference to the first inode. Hence the in-memory state is always
> valid for recovery, too.
> 
> This means we can tear out the old inode unlinked list cache and
> update mechanisms and replace it with a much simpler "insert" and
> "remove" functions that use in-memory inode state rather than on
> buffer state to track the list. The diffstat speaks for itself.
> 
> Food for thought: This obliviates the need for the on-disk AGI
> unlinked hash - we because we track as a double linked list in
> memory, we don't need to keep hash chains on disk short to minimise
> previous inode lookup overhead on list removal. Hence we probably
> should just convert the unlinked list code to use a single list
> on disk...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks interesting, but are you planning to break this up into smaller
pieces? E.g., perhaps add the new inode pointers and set them in one
patch, then replace the whole backref thing with the in-core pointers,
then update the insert/remove, then log recovery, etc. I'm sure there's
various ways it can or cannot be split, but regardless this patch looks
like it could be a series in and of itself.

Brian

>  fs/xfs/libxfs/xfs_inode_buf.c |   1 +
>  fs/xfs/xfs_icache.c           |   2 +
>  fs/xfs/xfs_inode.c            | 672 ++++++++++------------------------
>  fs/xfs/xfs_inode.h            |   5 +-
>  fs/xfs/xfs_log_recover.c      | 166 +++++----
>  fs/xfs/xfs_mount.c            |   5 -
>  6 files changed, 297 insertions(+), 554 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6b6f67595bf4..74f713e4a6b5 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -225,6 +225,7 @@ xfs_inode_from_disk(
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
> +	ip->i_next_unlinked = be32_to_cpu(from->di_next_unlinked);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 1c744dbb313f..dadf417fb9b4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -71,6 +71,8 @@ xfs_inode_alloc(
>  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
>  	INIT_LIST_HEAD(&ip->i_ioend_list);
>  	spin_lock_init(&ip->i_ioend_lock);
> +	ip->i_next_unlinked = NULLAGINO;
> +	ip->i_prev_unlinked = NULLAGINO;
>  
>  	return ip;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ba86d27b5226..1f1c8819330b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1876,211 +1876,123 @@ xfs_inactive(
>  }
>  
>  /*
> - * In-Core Unlinked List Lookups
> - * =============================
> - *
> - * Every inode is supposed to be reachable from some other piece of metadata
> - * with the exception of the root directory.  Inodes with a connection to a
> - * file descriptor but not linked from anywhere in the on-disk directory tree
> - * are collectively known as unlinked inodes, though the filesystem itself
> - * maintains links to these inodes so that on-disk metadata are consistent.
> - *
> - * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
> - * header contains a number of buckets that point to an inode, and each inode
> - * record has a pointer to the next inode in the hash chain.  This
> - * singly-linked list causes scaling problems in the iunlink remove function
> - * because we must walk that list to find the inode that points to the inode
> - * being removed from the unlinked hash bucket list.
> - *
> - * What if we modelled the unlinked list as a collection of records capturing
> - * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
> - * have a fast way to look up unlinked list predecessors, which avoids the
> - * slow list walk.  That's exactly what we do here (in-core) with a per-AG
> - * rhashtable.
> - *
> - * Because this is a backref cache, we ignore operational failures since the
> - * iunlink code can fall back to the slow bucket walk.  The only errors that
> - * should bubble out are for obviously incorrect situations.
> - *
> - * All users of the backref cache MUST hold the AGI buffer lock to serialize
> - * access or have otherwise provided for concurrency control.
> - */
> -
> -/* Capture a "X.next_unlinked = Y" relationship. */
> -struct xfs_iunlink {
> -	struct rhash_head	iu_rhash_head;
> -	xfs_agino_t		iu_agino;		/* X */
> -	xfs_agino_t		iu_next_unlinked;	/* Y */
> -};
> -
> -/* Unlinked list predecessor lookup hashtable construction */
> -static int
> -xfs_iunlink_obj_cmpfn(
> -	struct rhashtable_compare_arg	*arg,
> -	const void			*obj)
> -{
> -	const xfs_agino_t		*key = arg->key;
> -	const struct xfs_iunlink	*iu = obj;
> -
> -	if (iu->iu_next_unlinked != *key)
> -		return 1;
> -	return 0;
> -}
> -
> -static const struct rhashtable_params xfs_iunlink_hash_params = {
> -	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
> -	.key_len		= sizeof(xfs_agino_t),
> -	.key_offset		= offsetof(struct xfs_iunlink,
> -					   iu_next_unlinked),
> -	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
> -	.automatic_shrinking	= true,
> -	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
> -};
> -
> -/*
> - * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
> - * relation is found.
> + * Find an inode on the unlinked list. This does not take references to the
> + * inode, we have existence guarantees by holding the AGI buffer lock and
> + * that only unlinked, referenced inodes can be on the unlinked inode list.
> + * If we don't find the inode in cache, then let the caller handle the
> + * situation.
>   */
> -static xfs_agino_t
> -xfs_iunlink_lookup_backref(
> +static struct xfs_inode *
> +xfs_iunlink_ilookup(
>  	struct xfs_perag	*pag,
>  	xfs_agino_t		agino)
>  {
> -	struct xfs_iunlink	*iu;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*ip;
>  
> -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> -			xfs_iunlink_hash_params);
> -	return iu ? iu->iu_agino : NULLAGINO;
> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +
> +	/* Inode not in memory, nothing to do */
> +	if (!ip) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino) ||
> +	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
> +		/* Uh-oh! */
> +		ip = NULL;
> +	}
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
> +	return ip;
>  }
>  
>  /*
> - * Take ownership of an iunlink cache entry and insert it into the hash table.
> - * If successful, the entry will be owned by the cache; if not, it is freed.
> - * Either way, the caller does not own @iu after this call.
> + * Return the inode before @ip on the unlinked list without taking a reference
> + * to it. Caller must hold the AGI buffer locked to guarantee existence of the
> + * inode. Returns the inode or NULL if at the head of the list.
> + * If a lookup fails, return corruption error.
>   */
> -static int
> -xfs_iunlink_insert_backref(
> +static struct xfs_inode *
> +xfs_iunlink_lookup_prev(
>  	struct xfs_perag	*pag,
> -	struct xfs_iunlink	*iu)
> +	struct xfs_inode	*ip)
>  {
> -	int			error;
> -
> -	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> -			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> -	/*
> -	 * Fail loudly if there already was an entry because that's a sign of
> -	 * corruption of in-memory data.  Also fail loudly if we see an error
> -	 * code we didn't anticipate from the rhashtable code.  Currently we
> -	 * only anticipate ENOMEM.
> -	 */
> -	if (error) {
> -		WARN(error != -ENOMEM, "iunlink cache insert error %d", error);
> -		kmem_free(iu);
> -	}
> -	/*
> -	 * Absorb any runtime errors that aren't a result of corruption because
> -	 * this is a cache and we can always fall back to bucket list scanning.
> -	 */
> -	if (error != 0 && error != -EEXIST)
> -		error = 0;
> -	return error;
> +	struct xfs_inode	*prev_ip;
> +
> +	if (ip->i_prev_unlinked == NULLAGINO)
> +		return NULL;
> +	prev_ip = xfs_iunlink_ilookup(pag, ip->i_prev_unlinked);
> +	if (!prev_ip)
> +		return ERR_PTR(-EFSCORRUPTED);
> +	return prev_ip;
>  }
>  
> -/* Remember that @prev_agino.next_unlinked = @this_agino. */
> -static int
> -xfs_iunlink_add_backref(
> +static struct xfs_inode *
> +xfs_iunlink_lookup_next(
>  	struct xfs_perag	*pag,
> -	xfs_agino_t		prev_agino,
> -	xfs_agino_t		this_agino)
> +	struct xfs_inode	*ip)
>  {
> -	struct xfs_iunlink	*iu;
> -
> -	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
> -		return 0;
> -
> -	iu = kmem_zalloc(sizeof(*iu), KM_NOFS);
> -	iu->iu_agino = prev_agino;
> -	iu->iu_next_unlinked = this_agino;
> -
> -	return xfs_iunlink_insert_backref(pag, iu);
> +	struct xfs_inode	*next_ip;
> +
> +	if (ip->i_next_unlinked == NULLAGINO)
> +		return NULL;
> +	next_ip = xfs_iunlink_ilookup(pag, ip->i_next_unlinked);
> +	if (!next_ip)
> +		return ERR_PTR(-EFSCORRUPTED);
> +	return next_ip;
>  }
>  
> -/*
> - * Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked.
> - * If @next_unlinked is NULLAGINO, we drop the backref and exit.  If there
> - * wasn't any such entry then we don't bother.
> - */
> -static int
> -xfs_iunlink_change_backref(
> -	struct xfs_perag	*pag,
> +/* Set an on-disk inode's next_unlinked pointer. */
> +STATIC void
> +xfs_iunlink_update_dinode(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
>  	xfs_agino_t		agino,
> -	xfs_agino_t		next_unlinked)
> +	struct xfs_buf		*ibp,
> +	struct xfs_dinode	*dip,
> +	struct xfs_imap		*imap,
> +	xfs_agino_t		next_agino)
>  {
> -	struct xfs_iunlink	*iu;
> -	int			error;
> -
> -	/* Look up the old entry; if there wasn't one then exit. */
> -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> -			xfs_iunlink_hash_params);
> -	if (!iu)
> -		return 0;
> -
> -	/*
> -	 * Remove the entry.  This shouldn't ever return an error, but if we
> -	 * couldn't remove the old entry we don't want to add it again to the
> -	 * hash table, and if the entry disappeared on us then someone's
> -	 * violated the locking rules and we need to fail loudly.  Either way
> -	 * we cannot remove the inode because internal state is or would have
> -	 * been corrupt.
> -	 */
> -	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
> -			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> -	if (error)
> -		return error;
> -
> -	/* If there is no new next entry just free our item and return. */
> -	if (next_unlinked == NULLAGINO) {
> -		kmem_free(iu);
> -		return 0;
> -	}
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	int			offset;
>  
> -	/* Update the entry and re-add it to the hash table. */
> -	iu->iu_next_unlinked = next_unlinked;
> -	return xfs_iunlink_insert_backref(pag, iu);
> -}
> +	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
>  
> -/* Set up the in-core predecessor structures. */
> -int
> -xfs_iunlink_init(
> -	struct xfs_perag	*pag)
> -{
> -	return rhashtable_init(&pag->pagi_unlinked_hash,
> -			&xfs_iunlink_hash_params);
> -}
> +	trace_xfs_iunlink_update_dinode(mp, agno, agino,
> +			be32_to_cpu(dip->di_next_unlinked), next_agino);
>  
> -/* Free the in-core predecessor structures. */
> -static void
> -xfs_iunlink_free_item(
> -	void			*ptr,
> -	void			*arg)
> -{
> -	struct xfs_iunlink	*iu = ptr;
> -	bool			*freed_anything = arg;
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = imap->im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
>  
> -	*freed_anything = true;
> -	kmem_free(iu);
> +	/* need to recalc the inode CRC if appropriate */
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
>  }
>  
> -void
> -xfs_iunlink_destroy(
> -	struct xfs_perag	*pag)
> +/* Set an in-core inode's unlinked pointer and return the old value. */
> +static int
> +xfs_iunlink_update_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
>  {
> -	bool			freed_anything = false;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*ibp;
> +	int			error;
>  
> -	rhashtable_free_and_destroy(&pag->pagi_unlinked_hash,
> -			xfs_iunlink_free_item, &freed_anything);
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> +	if (error)
> +		return error;
>  
> -	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
> +	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			ibp, dip, &ip->i_imap, ip->i_next_unlinked);
> +	return 0;
>  }
>  
>  /*
> @@ -2122,120 +2034,25 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> -/* Set an on-disk inode's next_unlinked pointer. */
> -STATIC void
> -xfs_iunlink_update_dinode(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_buf		*ibp,
> -	struct xfs_dinode	*dip,
> -	struct xfs_imap		*imap,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			offset;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> -
> -	trace_xfs_iunlink_update_dinode(mp, agno, agino,
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = imap->im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	/* need to recalc the inode CRC if appropriate */
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -}
> -
> -/* Set an in-core inode's unlinked pointer and return the old value. */
> -STATIC int
> -xfs_iunlink_update_inode(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		next_agino,
> -	xfs_agino_t		*old_next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_dinode	*dip;
> -	struct xfs_buf		*ibp;
> -	xfs_agino_t		old_value;
> -	int			error;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> -
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> -	if (error)
> -		return error;
> -
> -	/* Make sure the old pointer isn't garbage. */
> -	old_value = be32_to_cpu(dip->di_next_unlinked);
> -	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Since we're updating a linked list, we should never find that the
> -	 * current pointer is the same as the new value, unless we're
> -	 * terminating the list.
> -	 */
> -	*old_next_agino = old_value;
> -	if (old_value == next_agino) {
> -		if (next_agino != NULLAGINO) {
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -					dip, sizeof(*dip), __this_address);
> -			error = -EFSCORRUPTED;
> -		}
> -		goto out;
> -	}
> -
> -	/* Ok, update the new pointer. */
> -	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			ibp, dip, &ip->i_imap, next_agino);
> -	return 0;
> -out:
> -	xfs_trans_brelse(tp, ibp);
> -	return error;
> -}
> -
>  /*
> - * This is called when the inode's link count has gone to 0 or we are creating
> - * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> - *
> - * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> - * list when the inode is freed.
> + * Always insert at the head, so we only have to do a next inode lookup to
> + * update it's prev pointer. The AGI bucket will point at the one we are
> + * inserting.
>   */
> -STATIC int
> -xfs_iunlink(
> +static int
> +xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
> -	xfs_agino_t		next_agino;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_agi		*agi = agibp->b_addr;
> +	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		next_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> -	trace_xfs_iunlink(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		return error;
> -	agi = agibp->b_addr;
> -
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
>  	 * go on.  Make sure the pointer isn't garbage and that this inode
> @@ -2248,27 +2065,24 @@ xfs_iunlink(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	if (next_agino != NULLAGINO) {
> -		struct xfs_perag	*pag;
> -		xfs_agino_t		old_agino;
> +	ip->i_prev_unlinked = NULLAGINO;
> +	ip->i_next_unlinked = next_agino;
> +	if (ip->i_next_unlinked != NULLAGINO) {
> +		struct xfs_inode	*nip;
>  
> -		/*
> -		 * There is already another inode in the bucket, so point this
> -		 * inode to the current head of the list.
> -		 */
> -		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
> -				&old_agino);
> -		if (error)
> -			return error;
> -		ASSERT(old_agino == NULLAGINO);
> +		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
> +		if (IS_ERR_OR_NULL(nip))
> +			return -EFSCORRUPTED;
>  
> -		/*
> -		 * agino has been unlinked, add a backref from the next inode
> -		 * back to agino.
> -		 */
> -		pag = xfs_perag_get(mp, agno);
> -		error = xfs_iunlink_add_backref(pag, agino, next_agino);
> -		xfs_perag_put(pag);
> +		if (nip->i_prev_unlinked != NULLAGINO) {
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +						NULL, 0, __this_address);
> +			return -EFSCORRUPTED;
> +		}
> +		nip->i_prev_unlinked = agino;
> +
> +		/* update the on disk inode now */
> +		error = xfs_iunlink_update_inode(tp, ip);
>  		if (error)
>  			return error;
>  	}
> @@ -2277,118 +2091,110 @@ xfs_iunlink(
>  	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
>  }
>  
> -/* Return the imap, dinode pointer, and buffer for an inode. */
> -STATIC int
> -xfs_iunlink_map_ino(
> +/*
> + * Remove can be from anywhere in the list, so we have to do two adjacent inode
> + * lookups here so we can update list pointers. We may be at the head or the
> + * tail of the list, so we have to handle those cases as well.
> + */
> +static int
> +xfs_iunlink_remove_inode(
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp)
> +	struct xfs_buf		*agibp,
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_agi		*agi = agibp->b_addr;
> +	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		next_agino = ip->i_next_unlinked;
> +	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	imap->im_blkno = 0;
> -	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap returned error %d.",
> -				__func__, error);
> -		return error;
> +	if (ip->i_prev_unlinked == NULLAGINO) {
> +		/* remove from head of list */
> +		if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino) {
> +			xfs_buf_mark_corrupt(agibp);
> +			return -EFSCORRUPTED;
> +		}
> +		if (next_agino == agino ||
> +		    !xfs_verify_agino_or_null(mp, agno, next_agino))
> +			return -EFSCORRUPTED;
> +
> +		error = xfs_iunlink_update_bucket(tp, agno, agibp,
> +					bucket_index, next_agino);
> +		if (error)
> +			return -EFSCORRUPTED;
> +	} else {
> +		/* lookup previous inode and update to point at next */
> +		struct xfs_inode	*pip;
> +
> +		pip = xfs_iunlink_lookup_prev(agibp->b_pag, ip);
> +		if (IS_ERR_OR_NULL(pip))
> +			return -EFSCORRUPTED;
> +
> +		if (pip->i_next_unlinked != agino) {
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +						NULL, 0, __this_address);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		/* update the on disk inode now */
> +		pip->i_next_unlinked = next_agino;
> +		error = xfs_iunlink_update_inode(tp, pip);
> +		if (error)
> +			return error;
>  	}
>  
> -	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> -				__func__, error);
> -		return error;
> +	/* lookup the next inode and update to point at prev */
> +	if (ip->i_next_unlinked != NULLAGINO) {
> +		struct xfs_inode	*nip;
> +
> +		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
> +		if (IS_ERR_OR_NULL(nip))
> +			return -EFSCORRUPTED;
> +
> +		if (nip->i_prev_unlinked != agino) {
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +						NULL, 0, __this_address);
> +			return -EFSCORRUPTED;
> +		}
> +		/* in memory update only */
> +		nip->i_prev_unlinked = ip->i_prev_unlinked;
>  	}
>  
> -	return 0;
> +	/* now clear prev/next from this inode and update on disk */
> +	ip->i_prev_unlinked = NULLAGINO;
> +	ip->i_next_unlinked = NULLAGINO;
> +	return xfs_iunlink_update_inode(tp, ip);
>  }
>  
>  /*
> - * Walk the unlinked chain from @head_agino until we find the inode that
> - * points to @target_agino.  Return the inode number, map, dinode pointer,
> - * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
> - *
> - * @tp, @pag, @head_agino, and @target_agino are input parameters.
> - * @agino, @imap, @dipp, and @bpp are all output parameters.
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
>   *
> - * Do not call this function if @target_agino is the head of the list.
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
>   */
>  STATIC int
> -xfs_iunlink_map_prev(
> +xfs_iunlink(
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		head_agino,
> -	xfs_agino_t		target_agino,
> -	xfs_agino_t		*agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp,
> -	struct xfs_perag	*pag)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_agino_t		next_agino;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	int			error;
>  
> -	ASSERT(head_agino != target_agino);
> -	*bpp = NULL;
> -
> -	/* See if our backref cache can find it faster. */
> -	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
> -	if (*agino != NULLAGINO) {
> -		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
> -		if (error)
> -			return error;
> -
> -		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
> -			return 0;
> -
> -		/*
> -		 * If we get here the cache contents were corrupt, so drop the
> -		 * buffer and fall back to walking the bucket list.
> -		 */
> -		xfs_trans_brelse(tp, *bpp);
> -		*bpp = NULL;
> -		WARN_ON_ONCE(1);
> -	}
> -
> -	trace_xfs_iunlink_map_prev_fallback(mp, agno);
> -
> -	/* Otherwise, walk the entire bucket until we find it. */
> -	next_agino = head_agino;
> -	while (next_agino != target_agino) {
> -		xfs_agino_t	unlinked_agino;
> -
> -		if (*bpp)
> -			xfs_trans_brelse(tp, *bpp);
> -
> -		*agino = next_agino;
> -		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
> -				bpp);
> -		if (error)
> -			return error;
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +	trace_xfs_iunlink(ip);
>  
> -		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
> -		/*
> -		 * Make sure this pointer is valid and isn't an obvious
> -		 * infinite loop.
> -		 */
> -		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
> -		    next_agino == unlinked_agino) {
> -			XFS_CORRUPTION_ERROR(__func__,
> -					XFS_ERRLEVEL_LOW, mp,
> -					*dipp, sizeof(**dipp));
> -			error = -EFSCORRUPTED;
> -			return error;
> -		}
> -		next_agino = unlinked_agino;
> -	}
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
> +	if (error)
> +		return error;
>  
> -	return 0;
> +	return xfs_iunlink_insert_inode(tp, agibp, ip);
>  }
>  
>  /*
> @@ -2400,16 +2206,8 @@ xfs_iunlink_remove(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
>  	struct xfs_buf		*agibp;
> -	struct xfs_buf		*last_ibp;
> -	struct xfs_dinode	*last_dip = NULL;
> -	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	xfs_agino_t		next_agino;
> -	xfs_agino_t		head_agino;
> -	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
>  	trace_xfs_iunlink_remove(ip);
> @@ -2418,84 +2216,8 @@ xfs_iunlink_remove(
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
>  		return error;
> -	agi = agibp->b_addr;
> -
> -	/*
> -	 * Get the index into the agi hash table for the list this inode will
> -	 * go on.  Make sure the head pointer isn't garbage.
> -	 */
> -	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> -	if (!xfs_verify_agino(mp, agno, head_agino)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -				agi, sizeof(*agi));
> -		return -EFSCORRUPTED;
> -	}
> -
> -	/*
> -	 * Set our inode's next_unlinked pointer to NULL and then return
> -	 * the old pointer value so that we can update whatever was previous
> -	 * to us in the list to point to whatever was next in the list.
> -	 */
> -	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If there was a backref pointing from the next inode back to this
> -	 * one, remove it because we've removed this inode from the list.
> -	 *
> -	 * Later, if this inode was in the middle of the list we'll update
> -	 * this inode's backref to point from the next inode.
> -	 */
> -	if (next_agino != NULLAGINO) {
> -		pag = xfs_perag_get(mp, agno);
> -		error = xfs_iunlink_change_backref(pag, next_agino,
> -				NULLAGINO);
> -		if (error)
> -			goto out;
> -	}
> -
> -	if (head_agino == agino) {
> -		/* Point the head of the list to the next unlinked inode. */
> -		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> -				next_agino);
> -		if (error)
> -			goto out;
> -	} else {
> -		struct xfs_imap	imap;
> -		xfs_agino_t	prev_agino;
> -
> -		if (!pag)
> -			pag = xfs_perag_get(mp, agno);
> -
> -		/* We need to search the list for the inode being freed. */
> -		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> -				&prev_agino, &imap, &last_dip, &last_ibp,
> -				pag);
> -		if (error)
> -			goto out;
>  
> -		/* Point the previous inode on the list to the next inode. */
> -		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> -				last_dip, &imap, next_agino);
> -
> -		/*
> -		 * Now we deal with the backref for this inode.  If this inode
> -		 * pointed at a real inode, change the backref that pointed to
> -		 * us to point to our old next.  If this inode was the end of
> -		 * the list, delete the backref that pointed to us.  Note that
> -		 * change_backref takes care of deleting the backref if
> -		 * next_agino is NULLAGINO.
> -		 */
> -		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> -		if (error)
> -			goto out;
> -	}
> -
> -out:
> -	if (pag)
> -		xfs_perag_put(pag);
> -	return error;
> +	return xfs_iunlink_remove_inode(tp, agibp, ip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 991ef00370d5..c3fb62fbdeb1 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -56,6 +56,8 @@ typedef struct xfs_inode {
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> +	xfs_agino_t		i_prev_unlinked;
> +	xfs_agino_t		i_next_unlinked;
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
> @@ -463,9 +465,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
> -int xfs_iunlink_init(struct xfs_perag *pag);
> -void xfs_iunlink_destroy(struct xfs_perag *pag);
> -
>  void xfs_end_io(struct work_struct *work);
>  
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 52a65a74208f..d47eea31c165 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2682,15 +2682,13 @@ xlog_recover_clear_agi_bucket(
>  	return;
>  }
>  
> -STATIC xfs_agino_t
> -xlog_recover_process_one_iunlink(
> +static struct xfs_inode *
> +xlog_recover_get_one_iunlink(
>  	struct xfs_mount		*mp,
>  	xfs_agnumber_t			agno,
>  	xfs_agino_t			agino,
>  	int				bucket)
>  {
> -	struct xfs_buf			*ibp;
> -	struct xfs_dinode		*dip;
>  	struct xfs_inode		*ip;
>  	xfs_ino_t			ino;
>  	int				error;
> @@ -2698,45 +2696,20 @@ xlog_recover_process_one_iunlink(
>  	ino = XFS_AGINO_TO_INO(mp, agno, agino);
>  	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
>  	if (error)
> -		goto fail;
> -
> -	/*
> -	 * Get the on disk inode to find the next inode in the bucket.
> -	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
> -	if (error)
> -		goto fail_iput;
> +		return NULL;
>  
>  	xfs_iflags_clear(ip, XFS_IRECOVERY);
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  
> -	/* setup for the next pass */
> -	agino = be32_to_cpu(dip->di_next_unlinked);
> -	xfs_buf_relse(ibp);
> -
>  	/*
>  	 * Prevent any DMAPI event from being sent when the reference on
>  	 * the inode is dropped.
>  	 */
>  	ip->i_d.di_dmevmask = 0;
>  
> -	xfs_irele(ip);
> -	return agino;
> +	return ip;
>  
> - fail_iput:
> -	xfs_irele(ip);
> - fail:
> -	/*
> -	 * We can't read in the inode this bucket points to, or this inode
> -	 * is messed up.  Just ditch this bucket of inodes.  We will lose
> -	 * some inodes and space, but at least we won't hang.
> -	 *
> -	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> -	 * clear the inode pointer in the bucket.
> -	 */
> -	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> -	return NULLAGINO;
>  }
>  
>  /*
> @@ -2762,56 +2735,107 @@ xlog_recover_process_one_iunlink(
>   * scheduled on this CPU to ensure other scheduled work can run without undue
>   * latency.
>   */
> -STATIC void
> -xlog_recover_process_iunlinks(
> -	struct xlog	*log)
> +static int
> +xlog_recover_iunlink_ag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
>  {
> -	xfs_mount_t	*mp;
> -	xfs_agnumber_t	agno;
> -	xfs_agi_t	*agi;
> -	xfs_buf_t	*agibp;
> -	xfs_agino_t	agino;
> -	int		bucket;
> -	int		error;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	int			bucket;
> +	int			error;
>  
> -	mp = log->l_mp;
> +	/*
> +	 * Find the agi for this ag.
> +	 */
> +	error = xfs_read_agi(mp, NULL, agno, &agibp);
> +	if (error) {
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		/*
> -		 * Find the agi for this ag.
> +		 * AGI is b0rked. Don't process it.
> +		 *
> +		 * We should probably mark the filesystem as corrupt after we've
> +		 * recovered all the ag's we can....
>  		 */
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Unlock the buffer so that it can be acquired in the normal course of
> +	 * the transaction to truncate and free each inode.  Because we are not
> +	 * racing with anyone else here for the AGI buffer, we don't even need
> +	 * to hold it locked to read the initial unlinked bucket entries out of
> +	 * the buffer. We keep buffer reference though, so that it stays pinned
> +	 * in memory while we need the buffer.
> +	 */
> +	agi = agibp->b_addr;
> +	xfs_buf_unlock(agibp);
> +
> +	/*
> +	 * The unlinked inode list is maintained on incore inodes as a double
> +	 * linked list. We don't have any of that state in memory, so we have to
> +	 * create it as we go. This is simple as we are only removing from the
> +	 * head of the list and that means we only need to pull the current
> +	 * inode in and the next inode.  Inodes are unlinked when their
> +	 * reference count goes to zero, so we can overlap the xfs_iget() and
> +	 * xfs_irele() calls so we always have the first two inodes on the list
> +	 * in memory. Hence we can fake up the necessary in memory state for the
> +	 * unlink to "just work".
> +	 */
> +	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> +		struct xfs_inode	*ip, *prev_ip = NULL;
> +		xfs_agino_t		agino, prev_agino = NULLAGINO;
> +
> +		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +		while (agino != NULLAGINO) {
> +			ip = xlog_recover_get_one_iunlink(mp, agno, agino,
> +							  bucket);
> +			if (!ip) {
> +				/*
> +				 * something busted, but still got to release
> +				 * prev_ip, so make it look like it's at the end
> +				 * of the list before it gets released.
> +				 */
> +				error = -EFSCORRUPTED;
> +				if (prev_ip)
> +					prev_ip->i_next_unlinked = NULLAGINO;
> +				break;
> +			}
> +			if (prev_ip) {
> +				ip->i_prev_unlinked = prev_agino;
> +				xfs_irele(prev_ip);
> +			}
> +			prev_agino = agino;
> +			prev_ip = ip;
> +			agino = ip->i_next_unlinked;
> +			cond_resched();
> +		}
> +		if (prev_ip)
> +			xfs_irele(prev_ip);
>  		if (error) {
>  			/*
> -			 * AGI is b0rked. Don't process it.
> -			 *
> -			 * We should probably mark the filesystem as corrupt
> -			 * after we've recovered all the ag's we can....
> +			 * We can't read an inode this bucket points to, or an
> +			 * inode is messed up.  Just ditch this bucket of
> +			 * inodes.  We will lose some inodes and space, but at
> +			 * least we won't hang.
>  			 */
> -			continue;
> -		}
> -		/*
> -		 * Unlock the buffer so that it can be acquired in the normal
> -		 * course of the transaction to truncate and free each inode.
> -		 * Because we are not racing with anyone else here for the AGI
> -		 * buffer, we don't even need to hold it locked to read the
> -		 * initial unlinked bucket entries out of the buffer. We keep
> -		 * buffer reference though, so that it stays pinned in memory
> -		 * while we need the buffer.
> -		 */
> -		agi = agibp->b_addr;
> -		xfs_buf_unlock(agibp);
> -
> -		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> -			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> -			while (agino != NULLAGINO) {
> -				agino = xlog_recover_process_one_iunlink(mp,
> -							agno, agino, bucket);
> -				cond_resched();
> -			}
> +			xlog_recover_clear_agi_bucket(mp, agno, bucket);
> +			break;
>  		}
> -		xfs_buf_rele(agibp);
>  	}
> +	xfs_buf_rele(agibp);
> +	return error;
> +}
> +
> +STATIC void
> +xlog_recover_process_iunlinks(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +	xfs_agnumber_t		agno;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> +		xlog_recover_iunlink_ag(mp, agno);
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c8ae49a1e99c..031e96ff022d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -146,7 +146,6 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> -		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
> @@ -223,9 +222,6 @@ xfs_initialize_perag(
>  		/* first new pag is fully initialized */
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
> -		error = xfs_iunlink_init(pag);
> -		if (error)
> -			goto out_hash_destroy;
>  		spin_lock_init(&pag->pag_state_lock);
>  	}
>  
> @@ -248,7 +244,6 @@ xfs_initialize_perag(
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> -		xfs_iunlink_destroy(pag);
>  		kmem_free(pag);
>  	}
>  	return error;
> -- 
> 2.26.2.761.g0e0b3e54be
> 

