Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F53033F8;
	Sun, 12 Jul 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783873630; cv=none; b=ISDCBzq5gLBDUGzbvrJCu7u0ywdnn/SQcpJth+ZsM0CFV6e3XjkY0JDkzqS2bjTXDVee+4/wWW81D2EZ0LKFTjGg3NmGT9bZ+457bv1g+AOMMTh6uerejaIXr5ORFHjUrk/i0WCHhm7TOt72xK45x9fEeSzFbhsvmXGzHH/wB7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783873630; c=relaxed/simple;
	bh=+EciH/6Rpxc1clbCZYUbGwXv1njlqenAAgyceY56NUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sa3mfVjUVUXOe9PkC82G4ZZq7tJ4Nvh3j8ET/a46h1sdwkvIHmaOCZLtoSF+2v8ahVU06Id/3bMO/gnJDG/2W6yg0lzyxo+tznOQMDRJyzaagWKzegD01T/83ovvvYQ1s8mHb9aDFeKrapsiDchhY5+YcWQG9abjR1LuL23ZuNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdX23S1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdX23S1T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5C7101F000E9;
	Sun, 12 Jul 2026 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783873629;
	bh=RC/THiJpZp8/jjGKO8rwcQkaq7cloWYIYmJuHz3s7Uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SdX23S1TYYHQeFPE+6dlea+rvtWuzYiPIZAIXfHa+A/CeMtupU5bJXMSaKW+TxQOC
	 WcZmh1W8y4qiYBSQmV76YxDRkYlkmRWesGIGQKEirFt05QuSjRnj37phYc6HPRErgJ
	 LhD/DYT4wZfCklypJuyHvVQbCG5Gk8BN5x3dUj5kYLhxroqsJrDwKz1lijF8tnmo3x
	 gw18Ip21U8yzLbKVyY0cnXrsnpdVpvbR8ck+9QKtcmGfXBukUhik0ggSP0UeJP0Yki
	 GxNKJbYj7e38lSfiNnsEcEOZmikQInNEiomBfNBdsXd8JT07oUoxaPz7MJIYfk267o
	 IuntJxlnCBe9A==
Date: Sun, 12 Jul 2026 09:27:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH] xfs: fix off-by-one in rtrefcount btree root level
 validation
Message-ID: <20260712162709.GA7195@frogsfrogsfrogs>
References: <20260712002644.2519804-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712002644.2519804-1-xmei5@asu.edu>

On Sat, Jul 11, 2026 at 05:26:44PM -0700, Xiang Mei wrote:
> xfs_rtrefcountbt_compute_maxlevels() sets
> 
> 	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
> 
> where the trailing "+ 1" already accounts for the inode-root level, so the
> deepest valid on-disk root level is m_rtrefc_maxlevels - 1 and a cursor must
> satisfy bc_nlevels <= bc_maxlevels (= m_rtrefc_maxlevels).
> 
> The two on-disk validation paths, xfs_rtrefcountbt_verify() and
> xfs_iformat_rtrefcount(), check the root level with ">" instead of ">=", so a
> crafted rtreflink (metadir + realtime + reflink) image whose
> /rtgroups/N.refcount inode has bb_level == m_rtrefc_maxlevels is accepted on
> mount. xfs_rtrefcountbt_init_cursor() then sets bc_nlevels = bb_level + 1,
> exceeding bc_maxlevels by one. Since the xfs_rtrefcountbt_cur slab object is
> sized for exactly bc_maxlevels entries, the first btree op on such a cursor
> indexes bc_levels[m_rtrefc_maxlevels] past the end of the object. This is
> reached by the first rtrefcount cursor built after mount, via log/CoW
> recovery (xfs_reflink_recover_cow() during xfs_mountfs()) or an
> FS_IOC_GETFSMAP over the realtime device.
> 
> Reject a root level equal to m_rtrefc_maxlevels, matching the ">=" form
> already used by the sibling data-device refcount/rmap verifiers and the
> in-memory rtrmap verifier.
> 
>   BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
>   Write of size 2 at addr ffff888018391658 by task exploit/144
>    xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
>    xfs_btree_query_range (fs/xfs/libxfs/xfs_btree.c:5308)
>    xfs_refcount_recover_cow_leftovers (fs/xfs/libxfs/xfs_refcount.c:2113)
>    xfs_reflink_recover_cow (fs/xfs/xfs_reflink.c:1085)
>    xlog_recover_finish (fs/xfs/xfs_log_recover.c:3551)
>    xfs_mountfs (fs/xfs/xfs_mount.c:1158)
>    xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
>    get_tree_bdev_flags (fs/super.c:1634)
>    vfs_get_tree (fs/super.c:1694)
>    path_mount (fs/namespace.c:4161)
>    __x64_sys_mount (fs/namespace.c:4367)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>   The buggy address belongs to the cache xfs_rtrefcountbt_cur of size 216
>   The buggy address is located 8 bytes to the right of
>    allocated 216-byte region [ffff888018391578, ffff888018391650)
>   Kernel panic - not syncing: Fatal exception
> 
> Fixes: 9abe03a0e4f9 ("xfs: introduce realtime refcount btree ondisk definitions")

Just one fixes tag is fine, thanks.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")

> Fixes: f0415af60f48 ("xfs: wire up a new metafile type for the realtime refcount")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

I think this is correct, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtrefcount_btree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> index f27b80a199ba..22acc1411aac 100644
> --- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
> @@ -201,7 +201,7 @@ xfs_rtrefcountbt_verify(
>  	if (fa)
>  		return fa;
>  	level = be16_to_cpu(block->bb_level);
> -	if (level > mp->m_rtrefc_maxlevels)
> +	if (level >= mp->m_rtrefc_maxlevels)
>  		return __this_address;
>  
>  	return xfs_btree_fsblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
> @@ -651,7 +651,7 @@ xfs_iformat_rtrefcount(
>  	numrecs = be16_to_cpu(dfp->bb_numrecs);
>  	level = be16_to_cpu(dfp->bb_level);
>  
> -	if (level > mp->m_rtrefc_maxlevels ||
> +	if (level >= mp->m_rtrefc_maxlevels ||
>  	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
>  		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
>  		return -EFSCORRUPTED;
> -- 
> 2.43.0
> 
> 
