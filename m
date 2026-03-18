Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF353A2549
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834287; cv=none; b=kn9c7i3srUGgpPtKkYUYU5EnnxRvMCn+4VIHjEPkGjlvLajb8dDROfN+v3oD69sjHzkVYsz4Jbpiv+E+iOMhM1BlEIhm8TKH+DTdskDpY3E4FyZm9AtH1qw4BL4fvmP8s/nfZgEfaGPmzQqAjc0SCAi2raPCBXcQQw2a1UcWz4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834287; c=relaxed/simple;
	bh=MnnB2YPUhBuztU+MB6IeMx9vtfF+8SffQRsF5EuLw8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHhDvrmiRI9/ZWutKcHx3UGqTDZpgk5Q8zFdbwAGRKW7BrAcM/Ux9wHS327E3G8nwrSgnqKesYAfRalqtdcrk7B5pHNPcj5lvf5E3Q7ulrMXdpkbFzWyMuxvjwVF86J0KQ4Tb9pNX1zgrubPxE7G5XWpA3hqV46eB8ARTBzG1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OBNSjloT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBNSjloT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773834282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r8hOsrzuco3wh7k6MMgwBzXvoJm2wLCgxalWQx1D5/A=;
	b=OBNSjloTX0veG3m64TATEHgCs9eZevMOENi5mUKoFPnZPRDZnfTLu9lCtbUtQxCGrzbXIF
	Qc1/ou5KIpAMcV2RlUzOGKcmbGiNCcXWomyXvIC8e6Cwd0t9wtPvqSKYU4/+8EScTxf/+s
	ASv/QSpngtvcs3PWHn08PqbyDxi3lEw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-x7Jd4HhyOTaktJq93-CVOw-1; Wed,
 18 Mar 2026 07:44:39 -0400
X-MC-Unique: x7Jd4HhyOTaktJq93-CVOw-1
X-Mimecast-MFC-AGG-ID: x7Jd4HhyOTaktJq93-CVOw_1773834278
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5714018005B3;
	Wed, 18 Mar 2026 11:44:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.178])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28A731800351;
	Wed, 18 Mar 2026 11:44:36 +0000 (UTC)
Date: Wed, 18 Mar 2026 07:44:34 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/4] xfs: don't keep a reference for buffers on the LRU
Message-ID: <abqQIrwXzB_FiHFr@bfoster>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 17, 2026 at 02:40:52PM +0100, Christoph Hellwig wrote:
> Currently the buffer cache adds a reference to b_hold for buffers that
> are on the LRU.  This seems to go all the way back and allows releasing
> buffers from the LRU using xfs_buf_rele.  But it makes xfs_buf_rele
> really complicated in differs from how other LRUs are implemented in
> Linux.
> 
> Switch to not having a reference for buffers in the LRU, and use a
> separate negative hold value to mark buffers as dead.  This simplifies
> xfs_buf_rele, which now just deal with the last "real" reference,
> and prepares for using the lockref primitive.
> 
> This also removes the b_lock protection for removing buffers from the
> buffer hash.  This is the desired outcome because the rhashtable is
> fully internally synchronized, and previously the lock was mostly
> held out of ordering constrains in xfs_buf_rele_cached.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf.c | 139 ++++++++++++++++++-----------------------------
>  fs/xfs/xfs_buf.h |   8 +--
>  2 files changed, 53 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d2f3c50d80e7..3cd37f082a69 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
...
> @@ -1610,11 +1564,12 @@ xfs_buftarg_isolate(
>  	struct list_head	*dispose = arg;
>  
>  	/*
> -	 * we are inverting the lru lock/bp->b_lock here, so use a trylock.
> -	 * If we fail to get the lock, just skip it.
> +	 * We are inverting the lru lock vs bp->b_lock order here, so use a
> +	 * trylock. If we fail to get the lock, just skip the buffer.
>  	 */
>  	if (!spin_trylock(&bp->b_lock))
>  		return LRU_SKIP;
> +
>  	/*
>  	 * Decrement the b_lru_ref count unless the value is already
>  	 * zero. If the value is already zero, we need to reclaim the
> @@ -1624,8 +1579,18 @@ xfs_buftarg_isolate(
>  		spin_unlock(&bp->b_lock);
>  		return LRU_ROTATE;
>  	}
> +	

(Trailing) Whitespace damage here ^, JFYI.

Otherwise LGTM. I like Dave's suggestion, but either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	/*
> +	 * If the buffer is in use, remove it from the LRU for now as we can't
> +	 * free it.  It will be freed when the last reference drops.
> +	 */
> +	if (bp->b_hold > 0) {
> +		list_lru_isolate(lru, &bp->b_lru);
> +		spin_unlock(&bp->b_lock);
> +		return LRU_REMOVED;
> +	}
>  
> -	bp->b_state |= XFS_BSTATE_DISPOSE;
> +	bp->b_hold = -1;
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lock);
>  	return LRU_REMOVED;
> @@ -1647,7 +1612,7 @@ xfs_buftarg_shrink_scan(
>  		struct xfs_buf *bp;
>  		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  		list_del_init(&bp->b_lru);
> -		xfs_buf_rele(bp);
> +		xfs_buf_destroy(bp);
>  	}
>  
>  	return freed;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e25cd2a160f3..e7324d58bd96 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -68,11 +68,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_INCORE,		"INCORE" }, \
>  	{ XBF_TRYLOCK,		"TRYLOCK" }
>  
> -/*
> - * Internal state flags.
> - */
> -#define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
> -
>  struct xfs_buf_cache {
>  	struct rhashtable	bc_hash;
>  };
> @@ -159,7 +154,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	unsigned int		b_hold;		/* reference count */
> +	int			b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
> @@ -170,7 +165,6 @@ struct xfs_buf {
>  	 */
>  	struct list_head	b_lru;		/* lru list */
>  	spinlock_t		b_lock;		/* internal state lock */
> -	unsigned int		b_state;	/* internal state flags */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
>  	struct xfs_perag	*b_pag;
> -- 
> 2.47.3
> 
> 

