Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B24CB47
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710352155; cv=none; b=SJMeoKUNN4EVTnvgldcGjvz8GAOftX2dkot9GcOmzyn2mcZ+KOHRSd4JZI75hIm173R72Ju7qsG6KMLjS4q67hYDg88keyNQy3mwSjGKCnV9gJ0SWZkQJ8N/R0AYGFxaZMcVjvqwOrRz5Ur2KooHzu00j5qD3NgB/ZLDYzjF1WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710352155; c=relaxed/simple;
	bh=GIFUwNkd4YcQYnLKQy36sD0kpwfI4VY3Bgb387g9x6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJzYijGdylY/VB1GDm7pkX8LIns4DdIb+IdVLF46EwFcz7HWhDj1YErLwobJgULoUfbpDWU66kyUz9VjynAfDbAbTy0NHNx8vyqGzyCnxQ+wldVzIFcWNsoO1x2Fd6I/sbyV+T8Fwqd9qXz1JCc0hlZVzCK5Y/NKUY2gc354wx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LMlc1i2W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LMlc1i2W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710352152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xtxW9rhJm6J/ZjYf3PXiZp8m6y4SdNOZ2AEgxHLL4Iw=;
	b=LMlc1i2WM5msQhYFwv1yjpYvlOnakRQyRNZnv+LGK/bkdc8WMCDTDjk2Vm0Su15Kuzh0YD
	06Ynd+zSuWAHfsc4d1UsiZELin4iFK/2cLgMh11ZSymkKuDsWWDO6U15gugp7gR6jm6HSg
	1cXL6Jp+gAJvVNu2By1vCAaxuuBin/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-qrpsMeOyNiSgoAKnLSmExQ-1; Wed, 13 Mar 2024 13:49:06 -0400
X-MC-Unique: qrpsMeOyNiSgoAKnLSmExQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B66581A261;
	Wed, 13 Mar 2024 17:49:06 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8537D492BD1;
	Wed, 13 Mar 2024 17:49:05 +0000 (UTC)
Date: Wed, 13 Mar 2024 12:49:04 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: bulk load records into new btree blocks
Message-ID: <ZfHnEIqJUu8FQ1cC@redhat.com>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
 <171029432531.2063452.98834952088069975.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432531.2063452.98834952088069975.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Mar 12, 2024 at 07:11:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Amortize the cost of indirect calls further by loading a batch of
> records into a new btree block instead of one record per ->get_record
> call.  On a rmap btree with 3.9 million records, this reduces the
> runtime of xfs_btree_bload by 3% for xfsprogs.  For the upcoming online
> repair functionality, this will reduce runtime by 6% when spectre
> mitigations are enabled in the kernel.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/agbtree.c |  161 ++++++++++++++++++++++++++++++------------------------
>  1 file changed, 90 insertions(+), 71 deletions(-)
> 
> 
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index 981d8e340bf2..e014e216e0a5 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
> @@ -220,15 +220,19 @@ get_bnobt_records(
>  	struct bt_rebuild		*btr = priv;
>  	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
>  	union xfs_btree_rec		*block_rec;
> +	unsigned int			loaded;
>  
> -	btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
> -	arec->ar_startblock = btr->bno_rec->ex_startblock;
> -	arec->ar_blockcount = btr->bno_rec->ex_blockcount;
> -	btr->freeblks += btr->bno_rec->ex_blockcount;
> +	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
> +		btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
> +		arec->ar_startblock = btr->bno_rec->ex_startblock;
> +		arec->ar_blockcount = btr->bno_rec->ex_blockcount;
> +		btr->freeblks += btr->bno_rec->ex_blockcount;
>  
> -	block_rec = libxfs_btree_rec_addr(cur, idx, block);
> -	cur->bc_ops->init_rec_from_cur(cur, block_rec);
> -	return 1;
> +		block_rec = libxfs_btree_rec_addr(cur, idx, block);
> +		cur->bc_ops->init_rec_from_cur(cur, block_rec);
> +	}
> +
> +	return loaded;
>  }
>  
>  void
> @@ -388,65 +392,72 @@ get_inobt_records(
>  {
>  	struct bt_rebuild		*btr = priv;
>  	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
> -	struct ino_tree_node		*ino_rec;
> -	union xfs_btree_rec		*block_rec;
> -	int				inocnt = 0;
> -	int				finocnt = 0;
> -	int				k;
> -
> -	btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
> -
> -	/* Transform the incore record into an on-disk record. */
> -	irec->ir_startino = ino_rec->ino_startnum;
> -	irec->ir_free = ino_rec->ir_free;
> -
> -	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
> -		ASSERT(is_inode_confirmed(ino_rec, k));
> -
> -		if (is_inode_sparse(ino_rec, k))
> -			continue;
> -		if (is_inode_free(ino_rec, k))
> -			finocnt++;
> -		inocnt++;
> -	}
> +	unsigned int			loaded = 0;
> +
> +	while (loaded < nr_wanted) {
> +		struct ino_tree_node	*ino_rec;
> +		union xfs_btree_rec	*block_rec;
> +		int			inocnt = 0;
> +		int			finocnt = 0;
> +		int			k;
> +
> +		btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
>  
> -	irec->ir_count = inocnt;
> -	irec->ir_freecount = finocnt;
> -
> -	if (xfs_has_sparseinodes(cur->bc_mp)) {
> -		uint64_t		sparse;
> -		int			spmask;
> -		uint16_t		holemask;
> -
> -		/*
> -		 * Convert the 64-bit in-core sparse inode state to the
> -		 * 16-bit on-disk holemask.
> -		 */
> -		holemask = 0;
> -		spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
> -		sparse = ino_rec->ir_sparse;
> -		for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
> -			if (sparse & spmask) {
> -				ASSERT((sparse & spmask) == spmask);
> -				holemask |= (1 << k);
> -			} else
> -				ASSERT((sparse & spmask) == 0);
> -			sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
> +		/* Transform the incore record into an on-disk record. */
> +		irec->ir_startino = ino_rec->ino_startnum;
> +		irec->ir_free = ino_rec->ir_free;
> +
> +		for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
> +			ASSERT(is_inode_confirmed(ino_rec, k));
> +
> +			if (is_inode_sparse(ino_rec, k))
> +				continue;
> +			if (is_inode_free(ino_rec, k))
> +				finocnt++;
> +			inocnt++;
>  		}
>  
> -		irec->ir_holemask = holemask;
> -	} else {
> -		irec->ir_holemask = 0;
> -	}
> +		irec->ir_count = inocnt;
> +		irec->ir_freecount = finocnt;
>  
> -	if (btr->first_agino == NULLAGINO)
> -		btr->first_agino = ino_rec->ino_startnum;
> -	btr->freecount += finocnt;
> -	btr->count += inocnt;
> +		if (xfs_has_sparseinodes(cur->bc_mp)) {
> +			uint64_t		sparse;
> +			int			spmask;
> +			uint16_t		holemask;
> +
> +			/*
> +			 * Convert the 64-bit in-core sparse inode state to the
> +			 * 16-bit on-disk holemask.
> +			 */
> +			holemask = 0;
> +			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
> +			sparse = ino_rec->ir_sparse;
> +			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
> +				if (sparse & spmask) {
> +					ASSERT((sparse & spmask) == spmask);
> +					holemask |= (1 << k);
> +				} else
> +					ASSERT((sparse & spmask) == 0);
> +				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
> +			}
> +
> +			irec->ir_holemask = holemask;
> +		} else {
> +			irec->ir_holemask = 0;
> +		}
> +
> +		if (btr->first_agino == NULLAGINO)
> +			btr->first_agino = ino_rec->ino_startnum;
> +		btr->freecount += finocnt;
> +		btr->count += inocnt;
> +
> +		block_rec = libxfs_btree_rec_addr(cur, idx, block);
> +		cur->bc_ops->init_rec_from_cur(cur, block_rec);
> +		loaded++;
> +		idx++;
> +	}
>  
> -	block_rec = libxfs_btree_rec_addr(cur, idx, block);
> -	cur->bc_ops->init_rec_from_cur(cur, block_rec);
> -	return 1;
> +	return loaded;
>  }
>  
>  /* Initialize both inode btree cursors as needed. */
> @@ -585,13 +596,17 @@ get_rmapbt_records(
>  	struct xfs_rmap_irec		*rec;
>  	struct bt_rebuild		*btr = priv;
>  	union xfs_btree_rec		*block_rec;
> +	unsigned int			loaded;
>  
> -	rec = pop_slab_cursor(btr->slab_cursor);
> -	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
> +	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
> +		rec = pop_slab_cursor(btr->slab_cursor);
> +		memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
>  
> -	block_rec = libxfs_btree_rec_addr(cur, idx, block);
> -	cur->bc_ops->init_rec_from_cur(cur, block_rec);
> -	return 1;
> +		block_rec = libxfs_btree_rec_addr(cur, idx, block);
> +		cur->bc_ops->init_rec_from_cur(cur, block_rec);
> +	}
> +
> +	return loaded;
>  }
>  
>  /* Set up the rmap rebuild parameters. */
> @@ -663,13 +678,17 @@ get_refcountbt_records(
>  	struct xfs_refcount_irec	*rec;
>  	struct bt_rebuild		*btr = priv;
>  	union xfs_btree_rec		*block_rec;
> +	unsigned int			loaded;
>  
> -	rec = pop_slab_cursor(btr->slab_cursor);
> -	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
> +	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
> +		rec = pop_slab_cursor(btr->slab_cursor);
> +		memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
>  
> -	block_rec = libxfs_btree_rec_addr(cur, idx, block);
> -	cur->bc_ops->init_rec_from_cur(cur, block_rec);
> -	return 1;
> +		block_rec = libxfs_btree_rec_addr(cur, idx, block);
> +		cur->bc_ops->init_rec_from_cur(cur, block_rec);
> +	}
> +
> +	return loaded;
>  }
>  
>  /* Set up the refcount rebuild parameters. */
> 
> 

