Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A031E44F561;
	Thu,  8 Oct 2026 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474081; cv=none; b=ExubuMnShG7gPw6uckHTohoirAVYG02ThKUt8bzdgVBluA/7VgfWz3JU7PX1fusffMQd1+dvlklY5xKesN/IDkxoDaJP+icaFKW/7/7srDGQyr/YhS7kfpRjqs3HpxLvXVuNWMhWWSTkbi0CcLVJAALIMW3nPgh6mUw2Uw2u3qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474081; c=relaxed/simple;
	bh=QmMivWIKRtKZuOtWswj6jEJGaEF90JoIZAS7w9pp494=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVo0B/eYWw4M4vRlEi1wCj7LQETHNlVruXdk7gOVzjicExy+k0MssS7SirgLJ14P3IFEUq121quz0uymHCRe/189Z68Yzza/iTCqR3sGB6whxpJEG/LGXQi3OqN/540d8xZhK2d0Im5UPjKgJRYY/4r7sR80g+20Fvc60430BPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4hNAs8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4hNAs8m"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2592E1F000FF;
	Thu,  8 Oct 2026 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474080;
	bh=+mYJJF5GrDpT0Ob0hVyzUHQ52lbThMrVlBLSi1APaVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l4hNAs8mmXqjXlv1G/EPaWKlgyXFS4/YGPGgW8/PjiR9ZrivKU21p6U1zgWuPIP7D
	 Mgy/yJfR71uYvSeW2+s6Vhsjci1ZU9K9wNj7jSPVaaWWTKFCcdzAy9tbq2en+/9Cag
	 OtT3eCYb4bspbFz5HD0MJtWn1gtDhrQmOU53DdQifSLP2uAyqXBRBm7jI0blXRkPiV
	 m+LRBPRYgmyeOKwSjv7fmOQbDqPEjbj0iGDJrbntRFw9Iq5CzfmhUywmk4uAWVq46v
	 2sWvnFyfwtGAOvQAvuQeTjNuRd1EYrp7Xtezvy0E7gjppfMYRNtx1mZXv+Ff0TZn0c
	 IiwG3WgGE+U3w==
Date: Thu, 8 Oct 2026 08:41:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: daejun7.park@samsung.com
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, Dave Chinner <dgc@kernel.org>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: clamp the pNFS layout range to the maximum file
 size
Message-ID: <20261008154119.GP2705364@frogsfrogsfrogs>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
 <20261008-xfs-nfsd-map-blocks-v1-3-560026cdccb6@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-3-560026cdccb6@samsung.com>

On Thu, Oct 08, 2026 at 10:39:32AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_fs_map_blocks() checks the range of a layout with
> 
> 	if (offset > limit)
> 		goto out_unlock;
> 	if (offset > limit - length)
> 		length = limit - offset;
> 
> limit - length is computed in u64, so a length larger than the limit
> wraps and the length is not clamped. nfsd passes the LAYOUTGET range
> through, and RFC 8881 lets a client ask for NFS4_UINT64_MAX bytes, for
> the rest of the file. offset + length then wraps to offset - 1, end_fsb
> rounds back to offset_fsb, and xfs_bmapi_read() maps nothing. For a read
> layout, xfs_bmbt_to_iomap() then gets an uninitialized imap: with a
> zeroed stack it logs "Access to block zero", marks the data fork sick
> and fails with -EFSCORRUPTED, and otherwise the mapping is whatever was
> on the stack and can reach the client. For a write layout,
> xfs_iomap_write_direct() is called with a count of zero, which trips an
> ASSERT with XFS_DEBUG. An offset of 2^63 or more, which nfsd accepts
> too, becomes negative in the loff_t argument and passes the first check.
> 
> Reject a negative offset and an offset at the limit, and compare the
> length with what is left up to the limit, which cannot wrap once the
> offset is below it.
> 
> With pynfs as the client, a READ LAYOUTGET for NFS4_UINT64_MAX bytes at
> offset 0 got NFS4ERR_IO, as did an RW one, which also made nfsd warn
> about the non-standard errno -63, and a READ LAYOUTGET at offset 2^63
> got NFS4ERR_IO as well. With this patch and the previous one, the one at
> 2^63 gets NFS4ERR_INVAL, the RW one gets NFS4ERR_NOSPC before anything
> is allocated, as the range up to the maximum file size cannot be
> reserved, and the server logs nothing. The READ one gets NFS4ERR_INVAL
> as well: nfsd, which maps a layout one extent at a time since
> commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents per
> LAYOUTGET"), asks again from the maximum file size on. An RW one on a
> file whose first 64 KiB are allocated, with a loga_maxcount that has
> room for one extent, is granted 0+65536.
> 
> This depends on the previous patch. Without it, an RW LAYOUTGET to the
> end of the file, whose length is now clamped instead of wrapping, asks
> xfs_iomap_write_direct() for every block up to the maximum file size,
> which wraps the block reservation and shuts the filesystem down where it
> got NFS4ERR_IO before.
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Looks fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_pnfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index ab38561700..88d9c3c043 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -167,9 +167,9 @@ xfs_fs_map_blocks(
>  	if (!write)
>  		limit = max(limit, round_up(i_size_read(inode),
>  				     inode->i_sb->s_blocksize));
> -	if (offset > limit)
> +	if (offset < 0 || offset >= limit)
>  		goto out_unlock;
> -	if (offset > limit - length)
> +	if (length > limit - offset)
>  		length = limit - offset;
>  
>  	error = filemap_write_and_wait(inode->i_mapping);
> 
> -- 
> 2.43.0
> 
> 
> 
