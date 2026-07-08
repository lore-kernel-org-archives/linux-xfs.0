Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73673B9952;
	Wed,  8 Jul 2026 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488538; cv=none; b=Jt5/ROz5CDwbzYbClNvKuqY7HPMWpSWdLVrWkPpbM8Fc+aJfa8tN4onpN5CcA1XEBXG4Vvk/hKngsJFVpc89dY3geZ+eSq5RHMthnb7pi25+Tg2d3DgaOi3lCY+KVxOcJHm7aosiM2xAnjBEFeRWkyVfZw+wuMGMaYQ3DSuCYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488538; c=relaxed/simple;
	bh=1oH3zdJRT67+Fd7BkVParF0bxNkAG1VvaFthl+K2Ykk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKeDHGDhUkFxFfcAGj/5dpSPDzW2N6DrZoUqKf7wAv8PeprsSken0BDkq/9m47Yo2fmeeeYIiDaQn5hZwfvOkM380DujptTA8Xp095nQUox2s20sP99CiTaiMe7qq/4QeJTu2v2AToaJgYJI96g9BYf5TQQdFnhttSga3lknJE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLXPtPj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLXPtPj/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6C1D51F000E9;
	Wed,  8 Jul 2026 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783488536;
	bh=yO8w3gRLyiBN35u0scI5CxYggr9jPH3LU8Xm8lIQNmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DLXPtPj/dnX/EdA7F7vCe+VdDGZiaKccx1olOQ9BAMxRO0/LN4C8uAonp4KKof0Tn
	 QXg4XuVephySKTJ/ZlSorS+bPrq7RjcthvRx0G7H4fEUovVKeiVa1LdsKFS5dMIIt8
	 LZJa+cOZJ8jkjA4ejyzIW9spXgLYAiQduVzI8lG9rzUgSCJjfo1EJCg/BwWafdkrY2
	 oYOfynC+HJ3q6jgwHlnk94IaAhzIG8gT6AAvLgFUrquvk+aoRKihznDSR4+SvrHmPZ
	 Q+5yhPcwu4Zu6NmzCxTm24+LfheBnm3nvJNQHSWnZs77Y5xUOb5nPoIQsTgD61jZPh
	 z2T4cSDglLmYA==
Date: Tue, 7 Jul 2026 22:28:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: reject attr leaf blocks with inconsistent
 usedbytes
Message-ID: <20260708052855.GF9392@frogsfrogsfrogs>
References: <20260707180235.1142581-4-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707180235.1142581-4-bestswngs@gmail.com>

On Tue, Jul 07, 2026 at 11:02:38AM -0700, Weiming Shi wrote:
> xfs_attr3_leaf_verify() checks each attr leaf entry on its own, but never
> checks that the entries' nameval regions are disjoint. A crafted leaf can
> point several entries at overlapping offsets: every entry passes the
> per-entry check, yet the summed entry sizes far exceed the nameval region.
> 
> ichdr.usedbytes is kept as the exact sum of the entries'
> xfs_attr_leaf_entsize() (see xfs_attr3_leaf_add()), so for such a leaf the
> real sum no longer matches usedbytes. When the leaf is later repacked,
> xfs_attr3_leaf_compact() resets firstused to blksize and calls
> xfs_attr3_leaf_moveents(), which subtracts each entry size from firstused;
> the oversized sum underflows the 32-bit firstused and the following memmove
> writes out of bounds. The same repack runs from xfs_attr3_leaf_rebalance()
> and xfs_attr3_leaf_unbalance(). The only guard is an ASSERT, which is
> compiled out on production kernels.
> 
> A single setxattr() on a file with such a leaf, after mounting a crafted
> image, triggers the write:
> 
>   BUG: KASAN: use-after-free in xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
>   Write of size 400 at addr ffff88802b187f98 by task exploit
>    xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
>    xfs_attr3_leaf_compact (fs/xfs/libxfs/xfs_attr_leaf.c:1790)
>    xfs_attr3_leaf_add (fs/xfs/libxfs/xfs_attr_leaf.c:1563)
>    xfs_attr_set_iter (fs/xfs/libxfs/xfs_attr.c:556)
>    xfs_attr_set (fs/xfs/libxfs/xfs_attr.c:1244)
>    xfs_xattr_set (fs/xfs/xfs_xattr.c:186)
>    __vfs_setxattr (fs/xattr.c:218)
>    vfs_setxattr (fs/xattr.c:339)
>    __x64_sys_fsetxattr (fs/xattr.c:774)
> 
> Sum the entry sizes while verifying and reject the leaf unless the sum
> equals usedbytes (so the on-disk usedbytes can be trusted) and that
> usedbytes fits in the nameval region [firstused, blksize) (so the trusted
> value cannot drive firstused below zero).  Both checks are required: the
> first alone can be bypassed by forging usedbytes to equal the real sum, and
> the second alone by forging a small usedbytes, so only together do they
> bound the actual summed entry size against the nameval region and prevent
> the underflow.
> 
> Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Cc: stable@vger.kernel.org
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
> v2: drop the inaccurate scrubber reference; explain why both checks are
>     needed. No code change.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 86c5c09a5db4..9814dcfbd7ac 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -300,7 +300,8 @@ xfs_attr3_leaf_verify_entry(
>  	struct xfs_attr3_icleaf_hdr		*leafhdr,
>  	struct xfs_attr_leaf_entry		*ent,
>  	int					idx,
> -	__u32					*last_hashval)
> +	__u32					*last_hashval,
> +	unsigned int				*usedbytes)
>  {
>  	struct xfs_attr_leaf_name_local		*lentry;
>  	struct xfs_attr_leaf_name_remote	*rentry;
> @@ -344,6 +345,7 @@ xfs_attr3_leaf_verify_entry(
>  	if (name_end > buf_end)
>  		return __this_address;
>  
> +	*usedbytes += namesize;
>  	return NULL;
>  }
>  
> @@ -376,6 +378,7 @@ xfs_attr3_leaf_verify(
>  	char				*buf_end;
>  	uint32_t			end;	/* must be 32bit - see below */
>  	__u32				last_hashval = 0;
> +	unsigned int			usedbytes = 0;
>  	int				i;
>  	xfs_failaddr_t			fa;
>  
> @@ -410,11 +413,21 @@ xfs_attr3_leaf_verify(
>  	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
>  	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
>  		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
> -				ent, i, &last_hashval);
> +				ent, i, &last_hashval, &usedbytes);
>  		if (fa)
>  			return fa;
>  	}
>  
> +	/*
> +	 * usedbytes must equal the summed entry sizes and fit in the
> +	 * nameval region; otherwise a later repack underflows firstused
> +	 * in xfs_attr3_leaf_moveents().
> +	 */
> +	if (usedbytes != ichdr.usedbytes)
> +		return __this_address;

This part is clearly correct.

> +	if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)

This check is still novel to me -- neither online fsck nor xfs_repair
check this explicitly.  It makes sense to me that usedbytes can't exceed
the number of bytes between the start of the nameval data and the end of
the block (the entries array grows up from zero; namevals grow down from
$blocksize).

I wonder, will this make it harder to salvage xattrs from a broken leaf
block since the verifier won't work?  I think it won't because the
salvage operation does an xfs_buf read with null ops, but I wonder if
you've considered this point?  Or run this through the xattr stress
tests?

--D

> +		return __this_address;
> +
>  	/*
>  	 * Quickly check the freemap information.  Attribute data has to be
>  	 * aligned to 4-byte boundaries, and likewise for the free space.
> -- 
> 2.43.0
> 
> 
