Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BE0372049;
	Tue,  7 Jul 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442087; cv=none; b=lLGo/lOgUsSvJpRdkr7TOZSfStC8/7AdCNdn0CLqfA2jzbyx169HmX6+dnd0FTNVaF38QcbPrKDY0DhS1ixaudOOa4Bxe6V6XJrvPHDadoiV2KaSwNdcrwkvJwX2dyWUXInmyDj7Pl28yBURGy4brx3H+0mHNXdglKXihi6rrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442087; c=relaxed/simple;
	bh=bzmmNjWNoByhDI6dgx4tUqhISKbl8qeLsThW83gif74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUgzOGKpqDbzBvnyOrYtMHI5CIhnufe4UExDgep1603m53XcgrQWfhWp3RbK0P0z+gXmMX/GctXixWqVRcfarlw8Ux5thOfS1slMaOKUWrWDxybU0yaC98uXy5pbcTOq+/GpZyhnqRBWyzfSeQhIHtl1Hqiy5Fiv4aUSWKIVpIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFIqNbpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFIqNbpB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BA8901F00A3F;
	Tue,  7 Jul 2026 16:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783442085;
	bh=tZcLryMq0GfqD3hqiAhCR8GgrCu5Cgs8YAQ8kMmo71g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oFIqNbpBqKsrVsL9/BtNdClqZ8yUoL98ab5wnjGZT/Jqb/ojGrzs6r3/MqnXHiGHJ
	 qf+INbOF4kcju9HbZ3GjgwNp4MURvfgyHjQO5d9AOQYTYZRa1QnKTq22YSa8FNGGsU
	 eGY2JK62Pk8BGXJvN49w0J0moi5bMtpmFl9jz4juIRbEdMJCOfy4mRTZPpB/APQqGV
	 aMY7ohl0UBTKewlvBkdJWPYFDT4hfs8ZjNeqLVgOJ6xFBruArA3wIBhZSvYb2tQKJs
	 Z2btYtYN9mZmXSSm+brU0TQ4aMQmSXn847DLn9NGGQmOfqSeZQ8xrh1ObD5zllfK80
	 J/3L9K632qi1w==
Date: Tue, 7 Jul 2026 09:34:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: reject attr leaf blocks with inconsistent usedbytes
Message-ID: <20260707163445.GA9392@frogsfrogsfrogs>
References: <20260703151543.3335583-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703151543.3335583-2-bestswngs@gmail.com>

On Fri, Jul 03, 2026 at 08:15:44AM -0700, Weiming Shi wrote:
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
> equals usedbytes and usedbytes fits in [firstused, blksize).  The online
> scrubber already validates this in xchk_xattr_block(); this brings the
> read/write verifier in line with it so the bad leaf is rejected before any
> reshape can run.
> 
> Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Cc: stable@vger.kernel.org
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
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
> +	if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)

Interesting ... where did this new logic come from?  xchk_xattr_block
doesn't perform this test.

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
