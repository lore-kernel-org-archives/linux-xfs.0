Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CEE188A23
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726597903; cv=none; b=a3oMEk2biPoNFwUO3+Q8bsOa+Z7qzccF6mm8bpEcy3MseM5tjIb609hlyjGqja3FanMMZdrFCtLtTcYOqSQNHI6MURCMXJSxo795M9nFPIGxvGFykii3taa6Q293UOluJhqP6i5Fp8+kTv/Gs50ORx9EoolbZN64nNj8AUX5eqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726597903; c=relaxed/simple;
	bh=OFkmp8k6kiWae3zcsCkN+xkWcQG5BEXjU0Z0X5ecOQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLv19Femse5TaA05xnz2wDAP2+QWwoOtYG0xD4+3j6L6ksWIUGZJ6V8AbBGBlHnDiySJhWf+Kr5+3B8+gpXcTFgyXgbw3bWvsCJ8ckrUGvqb05GCxbkxy0/DxX9tHPeIbCrgSvOb7TVatrkjrTnYN4ya4IhrzJTRmxBXzlckjjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCZrj9mD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCZrj9mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43247C4CEC5;
	Tue, 17 Sep 2024 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726597903;
	bh=OFkmp8k6kiWae3zcsCkN+xkWcQG5BEXjU0Z0X5ecOQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCZrj9mDAH9hcEgE4wwSek1ZGeah3pCcoPLoDmv8d4P4rzfqD3HXhd284/yA0CAaA
	 gCKnzVbBTcLtf4LPW08LLUaLmSBlwrY6r6gahV39+TQQESjXMxpdsVlYKdT7hFrkIB
	 Yl3WuAVQ4VeXLaXZZ3JtO9hKwGWuK6vFDe1uDV8g8ALRkCGz5+X1E3BaZYjbGYvelK
	 UZAsZMEpRhgenSEN8JV0oZz9aKOMG0t/fBOR68shbUTlERkCE31hGOgZgsoL/hs6k9
	 qp83UgHY4CEaM4GbMX0u5yJ481UXAJfNXoUM5DqGiVaqJnyEE5/v33fCjET6och5Fs
	 MUmxnlHwfI1YQ==
Date: Tue, 17 Sep 2024 11:31:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/1] xfs: don't free cowblocks from under dirty pagecache
 on unshare
Message-ID: <20240917183142.GI182194@frogsfrogsfrogs>
References: <20240903124713.23289-1-bfoster@redhat.com>
 <20240906114051.120743-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906114051.120743-1-bfoster@redhat.com>

On Fri, Sep 06, 2024 at 07:40:51AM -0400, Brian Foster wrote:
> fallocate unshare mode explicitly breaks extent sharing. When a
> command completes, it checks the data fork for any remaining shared
> extents to determine whether the reflink inode flag and COW fork
> preallocation can be removed. This logic doesn't consider in-core
> pagecache and I/O state, however, which means we can unsafely remove
> COW fork blocks that are still needed under certain conditions.
> 
> For example, consider the following command sequence:
> 
> xfs_io -fc "pwrite 0 1k" -c "reflink <file> 0 256k 1k" \
> 	-c "pwrite 0 32k" -c "funshare 0 1k" <file>
> 
> This allocates a data block at offset 0, shares it, and then
> overwrites it with a larger buffered write. The overwrite triggers
> COW fork preallocation, 32 blocks by default, which maps the entire
> 32k write to delalloc in the COW fork. All but the shared block at
> offset 0 remains hole mapped in the data fork. The unshare command
> redirties and flushes the folio at offset 0, removing the only
> shared extent from the inode. Since the inode no longer maps shared
> extents, unshare purges the COW fork before the remaining 28k may
> have written back.
> 
> This leaves dirty pagecache backed by holes, which writeback quietly
> skips, thus leaving clean, non-zeroed pagecache over holes in the
> file. To verify, fiemap shows holes in the first 32k of the file and
> reads return different data across a remount:
> 
> $ xfs_io -c "fiemap -v" <file>
> <file>:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    ...
>    1: [8..511]:        hole               504
>    ...
> $ xfs_io -c "pread -v 4k 8" <file>
> 00001000:  cd cd cd cd cd cd cd cd  ........
> $ umount <mnt>; mount <dev> <mnt>
> $ xfs_io -c "pread -v 4k 8" <file>
> 00001000:  00 00 00 00 00 00 00 00  ........
> 
> To avoid this problem, make unshare follow the same rules used for
> background cowblock scanning and never purge the COW fork for inodes
> with dirty pagecache or in-flight I/O.
> 
> Fixes: 46afb0628b ("xfs: only flush the unshared range in xfs_reflink_unshare")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Question: Does xfs_repair report orphaned cow staging blocks after this?
There's a longstanding bug that I've seen in the long soak xfs/286 VM
where we slowly leak cow fork blocks (~80 per ~1 billion fsxops over 7
days).

Anyhow this looks correct on its own so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Here's another COW issue I came across via some unshare testing. A quick
> hack to enable unshare in fsx uncovered it. I'll follow up with a proper
> patch for that.
> 
> I'm sending this as a 2/1 here just to reflect patch order in my local
> tree. Also note that I haven't explicitly tested the fixes commit, but a
> quick test to switch back to the old full flush behavior on latest
> master also makes the problem go away, so I suspect that's where the
> regression was introduced.
> 
> Brian
> 
>  fs/xfs/xfs_icache.c  |  8 +-------
>  fs/xfs/xfs_reflink.c |  3 +++
>  fs/xfs/xfs_reflink.h | 19 +++++++++++++++++++
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 900a6277d931..a1b34e6ccfe2 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1278,13 +1278,7 @@ xfs_prep_free_cowblocks(
>  	 */
>  	if (!sync && inode_is_open_for_write(VFS_I(ip)))
>  		return false;
> -	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> -	    atomic_read(&VFS_I(ip)->i_dio_count))
> -		return false;
> -
> -	return true;
> +	return xfs_can_free_cowblocks(ip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 6fde6ec8092f..5bf6682e701b 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1595,6 +1595,9 @@ xfs_reflink_clear_inode_flag(
>  
>  	ASSERT(xfs_is_reflink_inode(ip));
>  
> +	if (!xfs_can_free_cowblocks(ip))
> +		return 0;
> +
>  	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
>  	if (error || needs_flag)
>  		return error;
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index fb55e4ce49fa..4a58e4533671 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -6,6 +6,25 @@
>  #ifndef __XFS_REFLINK_H
>  #define __XFS_REFLINK_H 1
>  
> +/*
> + * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
> + * to do so when an inode has dirty cache or I/O in-flight, even if no shared
> + * extents exist in the data fork, because outstanding I/O may target blocks
> + * that were speculatively allocated to the COW fork.
> + */
> +static inline bool
> +xfs_can_free_cowblocks(struct xfs_inode *ip)
> +{
> +	struct inode *inode = VFS_I(ip);
> +
> +	if ((inode->i_state & I_DIRTY_PAGES) ||
> +	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
> +	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> +	    atomic_read(&inode->i_dio_count))
> +		return false;
> +	return true;
> +}
> +
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared);
>  int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> -- 
> 2.45.0
> 
> 
