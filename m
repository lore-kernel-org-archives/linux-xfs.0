Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0334A18
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 02:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900078; cv=none; b=pvoIgdbf3tgoXR2jIEQAjFvq9NEwK6qULf7LR1HTQlA35KoNUHGRnkpTxldZRURvm3qEHQ9yb3ZgUIFO75NmSfuYXwWCPTxYAeMcoqlYL8O5KFy0vOeNxNwtID59XCJ4kCfHDynaasAIgKhePk9elKsco8ytkuFibSopVIUsnuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900078; c=relaxed/simple;
	bh=6N8J920qxbq5bXeZ0wVB+p6h1qwisCrHZzFpLPyS9sI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSJv4hgDWTAGU/61navxtaMdInYeDL/8hN5SXFVchg3ge6A5V2Pw+e4KhToWkqCh76QcHSNkAfxX0fcP8KqTHf4d/Mf4Vqljsjzdx5R/uGVCcifuuNkNreut+cQenlZSHLXW7mussIedK4abcbyMb+Uqs01J5HosSvXYmtIgFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fFiSLxQ/; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fFiSLxQ/"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3df04cf5135so85917b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 19:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724900075; x=1725504875; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nV5JBlQMSG2Tm7zUUduSIbDQOss7Z01JyzsdZOoAFl0=;
        b=fFiSLxQ/WP/Cu3XKyIHNvIvu9cC74YrE74wyEyESgvHEBJUZ6paAICS7xASynEFNtU
         NOjFMqrZaLx+o+c2tBLCUhWbr6tGZhrydGho590cSV3Lh0YRDUNvow3CRoI/zudx7Q2H
         sZiINLJwTTanex1kFcCE164OCu5+uMIqKMrcpc6HbJG5t7mDAM+z4YMR9yj7fvxHd6rM
         +U+dscbE+bBirMdjlYHHptg1WVMenhmFXOUjoRqX6VweDDePgVuDCm/afYrWUiqi17yS
         GkSlqaqSTLJvawE2uXuAtWuqW4MvQa6Yay2/kO/USjRV2ERKAhIyN9RPTedmgzmoUE9W
         zZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724900075; x=1725504875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nV5JBlQMSG2Tm7zUUduSIbDQOss7Z01JyzsdZOoAFl0=;
        b=fxJGJqQ3m7rCrrVXQT3RskdyyEi18DR7K/pEoeadc6m3UtfaW5cSleCSOanK28/Ga2
         VBDNLmVBngvUc8N1fif1Q5uXZL6LtX3XI4Bit+2YnrfbWe4BuP7vi+B9J+YUZzudkTtO
         vr60lcMZyc76vBtYODQAmMKoQbgxHXo6ZTr63tH4Hm0mztRvPly8YvAOYT8NPrCum8+V
         q8QO8nVj/7i5aePwi2bxB6BpByeM8K8u5lXeFChDx+PYJgMPw4NRneIEJAag8TE6+FhZ
         alatk9Jrn3TrVszsS0rHJFvynRlO15EREFPCiwPmTWNiYhLbwXgsfaaU4DWrLPWID1ZR
         c43w==
X-Gm-Message-State: AOJu0YwpycAObx5SKOI6mgbV5IJFiatiTwlIGahPDdiE6/o/LuxfWqYY
	42Smhah2NRr25zJFW0zcI2NX7ripJ2IJxXJlUv9R5OA+6estxnuT7pHsItitoOKvJJZFVb7uAnG
	c
X-Google-Smtp-Source: AGHT+IGTFRR2K6iIvmNEoSFxFGUEQFr4Bd7zbHH/FE+F+982PL26lPlyrOGP5mkRzvmJ2iXiPJThbA==
X-Received: by 2002:a05:6808:1b06:b0:3d9:dfef:d7b3 with SMTP id 5614622812f47-3df05e3cdcdmr1510926b6e.34.1724900075505;
        Wed, 28 Aug 2024 19:54:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d22e774263sm216262a12.26.2024.08.28.19.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 19:54:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjVIu-00GRUa-1X;
	Thu, 29 Aug 2024 12:54:32 +1000
Date: Thu, 29 Aug 2024 12:54:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/10] xfs: hoist the code that moves the incore inode
 fork broot memory
Message-ID: <Zs/i6JZerKLqTLnt@dread.disaster.area>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 04:35:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Whenever we change the size of the memory buffer holding an inode fork
> btree root block, we have to copy the contents over.  Refactor all this
> into a single function that handles both, in preparation for making
> xfs_iroot_realloc more generic.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c |   87 ++++++++++++++++++++++++++--------------
>  1 file changed, 56 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 60646a6c32ec7..307207473abdb 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -387,6 +387,50 @@ xfs_iroot_free(
>  	ifp->if_broot = NULL;
>  }
>  
> +/* Move the bmap btree root from one incore buffer to another. */
> +static void
> +xfs_ifork_move_broot(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	struct xfs_btree_block	*dst_broot,
> +	size_t			dst_bytes,
> +	struct xfs_btree_block	*src_broot,
> +	size_t			src_bytes,
> +	unsigned int		numrecs)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	void			*dptr;
> +	void			*sptr;
> +
> +	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));

We pass whichfork just for this debug check. Can you pull this up
to the callers?

> +
> +	/*
> +	 * We always have to move the pointers because they are not butted
> +	 * against the btree block header.
> +	 */
> +	if (numrecs) {
> +		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
> +		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
> +		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
> +	}
> +
> +	if (src_broot == dst_broot)
> +		return;

Urk. So this is encoding caller logic directly into this function.
ie. the grow cases uses krealloc() which copies the keys and
pointers but still needs the pointers moved. The buffer is large
enough for that, so it passes src and dst as the same buffer and
this code then jumps out after copying the ptrs (a second time) to
their final resting place.

> +	/*
> +	 * If the root is being totally relocated, we have to migrate the block
> +	 * header and the keys that come after it.
> +	 */
> +	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
> +
> +	/* Now copy the keys, which come right after the header. */
> +	if (numrecs) {
> +		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
> +		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
> +		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
> +	}

And here we do the key copy for the shrink case where we technically
don't need separate buffers but we really want to minimise memory
usage if we can so we reallocate a smaller buffer and free the
original larger one.

Given this, I think this code is more natural by doing all the
allocate/free/copy ourselves instead of using krealloc() and it's
implicit copy for one of the cases.

i.e. rename this function xfs_ifork_realloc_broot() and make it do
this:

{
	struct xfs_btree_block *src = ifp->if_broot;
	struct xfs_btree_block *dst = NULL;

	if (!numrecs)
		goto out_free_src;

	dst = kmalloc(new_size);

	/* copy block header */
	memcpy(dst, src, xfs_bmbt_block_len(mp));

	/* copy records */
	sptr = xfs_bmbt_key_addr(mp, src, 1);
	dptr = xfs_bmbt_key_addr(mp, dst, 1);
	memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));

	/* copy pointers */
	sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
	dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
	memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));

out_free_src:
	kfree(src);
	ifp->if_broot = dst;
	ifp->if_broot_bytes = new_size;
}

And the callers are now both:

	xfs_ifork_realloc_broot(mp, ifp, new_size, old_size, numrecs);

This also naturally handles the "reduce to zero size" without
needing any special case code, it avoids the double pointer copy on
grow, and the operation logic is simple, obvious and easy to
understand...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
