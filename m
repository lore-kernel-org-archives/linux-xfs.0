Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485E1C3038
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 20:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736801736; cv=none; b=Q2tss0y32BHyfnTW/0LLq1Hxx9d9sb/PNY4NiMoV01pLRNHVwNO1DLu2oNlAxK29lLrE5If5ryfyquOXJs3Ei8Uf/1JzPT0LIoh/nw2wzT9gNvOhBxzTHOep8rvoKPzF+5KaTmHVVXzNanDkI6YtBx4saOaJh/yqjfRqmsyMp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736801736; c=relaxed/simple;
	bh=e/TKNQUFj7IGJHDfBvSTj9IFrGa0HlpGxivuYX+4Bgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azgyzZ4l5IPOLKCxKwCs1HPA9eMp6Ox0puqGSKIixbIRw+Fk8Ttv58JG9bkxdg0AhZ76U5cEkWcl6UraP2aK346fETOlMVvkA/Tn0hXo7pAk8QEJgrqMlKOlowu5Oz0bNHsWCldac4lVHCocB0TuwaBE96QP6RyJUynvMXryxuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ke/+UMws; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ke/+UMws"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso6358029a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 12:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736801734; x=1737406534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/tm2sVCRf0+D51M7cMUhtQGhQka3dVaFYAUAqAbsrg8=;
        b=ke/+UMwspfKuwFWcJgOXEdY59jYCxwsJ8dn2ZjL52KpOY75PxbgDasd7ktCUyD8RH5
         t/crj3YByjPaJlmEjj14BALVoTYlu4dgxZCrttwlX//p91tbcdy9Vd1KsrYDG1ZzULOI
         uYVGP0BRhru7MM+S+QGAdMK+ZK0FDZDY2dM2vizTxsNOh6NWdpOsFX8qnf/jVJ+CMYUQ
         mHG1JIgmugHsTGa6EPWGsvdBwWy0SEx3/2rDIR3baKV189IVpJuJ2OyJT6+0uoa/yqKx
         t1iladYTY2c/9Ta7VYx9CXFlMkLJuSxRt6YVn2zbnhXLT9enUD9TRU8DcrdKBN7QJbG6
         7agQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736801734; x=1737406534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tm2sVCRf0+D51M7cMUhtQGhQka3dVaFYAUAqAbsrg8=;
        b=Hsp4R4p//kcByUloamhAPoo7Id9DzDffzy/tCznefFElIBAcByt+xFjDJozawjs0YK
         VPe2AjTi02m3ZXGznd2mfeK9RCW5xV/C/Hx9dJ1WXK6xafGHx314vuloqDHUeg+5XbL1
         /I7DkFmzA0nMXPzurJnlrdpRMlINaQAlpkvaI5x4IFLKh0obBIgKQVGx29bnYpOMNv+i
         VBkJed57g2H3GUV1blL/fGOtGXmF+akcTcLkGjJ61b9KOkpJRvLjhLo3YwmfDqsHVjL0
         wwtnXnv32j2d2HVzXPd34XEXUfJkI061wfkMGJjGSEHvHMWqKzcdhWQn26mbUr+pO7XW
         iR3w==
X-Forwarded-Encrypted: i=1; AJvYcCXUxw//YazvSog2LbBAt+jGS3D/Ssoj5NKhoZOZgsk+Dz2Wirn29CRfWmTBi7+I+eNDd58VmT0eCyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC/vn0V71gsaiKfGIpou+vMHRbY9L566FrFyjg79u5vdKFQ04O
	i/AZWiFe7E/VMBdLU8ulbUoysToBKGcYCweNt48joSzkICHo43rBr5V/atHdB+c=
X-Gm-Gg: ASbGncuseT3IWToQpiWJj/lgYUCCBzP06+LxLYaxaPANXjzrO5exlmWW17X4dKgTVR7
	9HzVkKoKVk7nuI7xAuIrlrkYUrCtPdkCG9pI2GJe6VL+eYEvxdaR7cg7UAW23A4RgHw0acOvGN8
	ycrKnvMN2j2r/Dxcb4XRcbtPV3RNHyWvZPx6M2zmRoIJmfjS9iCArdRjHYKU3yvrCEUOfHAtCu1
	7el7EJziT5RAuWUXbnwAUzyvxfj5udleo2vb2BJw1BvciVLxLzSz89LhzyQiaXqLtpzCYPMGUxP
	X57CjGjskHysz9TSCF02XhhiuQBGOqH7
X-Google-Smtp-Source: AGHT+IFbyLaraLVvEQjbdnsVHpFkggCR1bYiwo100XPqOb1bYPqJ0Z/ITIRyiqJaGDUe9KrthOHVEQ==
X-Received: by 2002:a17:90b:2483:b0:2f6:d266:f462 with SMTP id 98e67ed59e1d1-2f6d266fa06mr13176761a91.35.1736801734405;
        Mon, 13 Jan 2025 12:55:34 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f2524ddsm56499415ad.209.2025.01.13.12.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 12:55:33 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXRT8-00000005USV-3eQ8;
	Tue, 14 Jan 2025 07:55:30 +1100
Date: Tue, 14 Jan 2025 07:55:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix buffer lookup vs release race
Message-ID: <Z4V9wg8dbLXvq8hy@dread.disaster.area>
References: <20250113042542.2051287-1-hch@lst.de>
 <20250113042542.2051287-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113042542.2051287-3-hch@lst.de>

On Mon, Jan 13, 2025 at 05:24:27AM +0100, Christoph Hellwig wrote:
> Since commit 298f34224506 ("xfs: lockless buffer lookup") the buffer
> lookup fastpath is done without a hash-wide lock (then pag_buf_lock, now
> bc_lock) and only under RCU protection.  But this means that nothing
> serializes lookups against the temporary 0 reference count for buffers
> that are added to the LRU after dropping the last regular reference,
> and a concurrent lookup would fail to find them.
> 
> Fix this by doing all b_hold modifications under b_lock.  We're already
> doing this for release so this "only" ~ doubles the b_lock round trips.
> We'll later look into the lockref infrastructure to optimize the number
> of lock round trips again.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Logic changes look ok, but...


> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3d56bc7a35cc..cbf7c2a076c7 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -172,7 +172,8 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	atomic_t		b_hold;		/* reference count */
> +	spinlock_t		b_lock;		/* internal state lock */
> +	unsigned int		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
> @@ -182,7 +183,6 @@ struct xfs_buf {
>  	 * bt_lru_lock and not by b_sema
>  	 */
>  	struct list_head	b_lru;		/* lru list */
> -	spinlock_t		b_lock;		/* internal state lock */
>  	unsigned int		b_state;	/* internal state flags */
>  	int			b_io_error;	/* internal IO error state */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */

... I think this is misguided.

The idea behind the initial cacheline layout is that it should stay
read-only as much as possible so that cache lookups can walk the
buffer without causing shared/exclusive cacheline contention with
existing buffer users.

This was really important back in the days when the cache used a
rb-tree (i.e. the rbnode pointers dominated lookup profiles), and
it's still likely important with the rhashtable on large caches.

i.e. Putting a spinlock in that first cache line will result in
lookups and shrinker walks having cacheline contention as the
shrinker needs exclusive access for the spin lock, whilst the lookup
walk needs shared access for the b_rhash_head, b_rhash_key and
b_length fields in _xfs_buf_obj_cmp() for lookless lookup
concurrency.

Hence I think it would be better to move the b_hold field to the
same cacheline as the b_state field rather than move it to the
initial cacheline that cache lookups walk...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
