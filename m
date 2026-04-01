Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF53C73DA;
	Wed,  1 Apr 2026 22:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082440; cv=none; b=ZLR6zJsLlXFxNaO1plFrMSyk1OXR8xfZlC8GR60iAreJV1EKuXsihSozeKTjGtP1lEdDpen2n3TSiH5FwjdNXf7261Svf7/ZLhEvX/M7zt9HkC4NE0C8nENu29WEspK5R2lc56ECX9Uw6FxEMQjpKO0jtKtm3S+FTa8n6p8Wb1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082440; c=relaxed/simple;
	bh=SYq0ujua23qXK/LmWqJZytMbuhwswv6VTuzwYXfuOO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Evz3+cGsWAMbxjqNk5B6Z4gfIzQWRm3SMgR9YdkDo/hSpIRU8gBa8y2V/HkgEeauCHz+tAocT+at6SW+oIY/jWseOtFwVL6FSkKJiFFRX51mjBH4IlcFfjXmXQ2XqPAxC5CMrkYiP+UuNh1L7dkNSZen7Yv/cugc0JYJGBr/Xx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5PXSPnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5PXSPnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65FBC4CEF7;
	Wed,  1 Apr 2026 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775082439;
	bh=SYq0ujua23qXK/LmWqJZytMbuhwswv6VTuzwYXfuOO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5PXSPnM0g7dK54PuwCSAWqQJYwrb9QuFC3fNTXETKKaPEJa0LN6Qb71B1NKfCgkg
	 zJ0YjonIndei8PlYKBNx5dFcfXhWpE+WBZbDACHmNuwim4lfvEmA3bvnNrqmY9fahl
	 Rl9nb+RqNpAaOMAysgc+seVnfv95Xj1Oym+k9JlAwQFods4T+I06Kf50gAfdZgcbkj
	 GbdbrTPPg+Vkh1rA4vuOIcDNMaHtAZoEjic2ruqY4tQldFn4TygR5eXvCGwAXISi6S
	 kJWerpbb33PgwTewr82iGadRDTJWVbaKtQFxcemStEAmZQ7+vEhxTr9EO0FxOa60bl
	 ti4gyubWkuz8Q==
Date: Wed, 1 Apr 2026 15:27:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 03/22] fsverity: generate and store zero-block hash
Message-ID: <20260401222717.GH2466@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-4-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:04PM +0200, Andrey Albershteyn wrote:
> Compute the hash of one filesystem block's worth of zeros. A filesystem
> implementation can decide to elide merkle tree blocks containing only
> this hash and synthesize the contents at read time.
> 
> Let's pretend that there's a file containing six data blocks and whose
> merkle tree looks roughly like this:
> 
> root
>  +--leaf0
>  |   +--data0
>  |   +--data1
>  |   `--data2
>  `--leaf1
>      +--data3
>      +--data4
>      `--data5
> 
> If data[0-2] are sparse holes, then leaf0 will contain a repeating
> sequence of @zero_digest.  Therefore, leaf0 need not be written to disk
> because its contents can be synthesized.
> 
> A subsequent xfs patch will use this to reduce the size of the merkle
> tree when dealing with sparse gold master disk images and the like.
> 
> Add a helper to pre-fill folio with hashes of empty blocks. This will be
> used by iomap to synthesize blocks full of zero hashes on the fly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/fsverity_private.h |  3 +++
>  fs/verity/open.c             |  3 +++
>  fs/verity/pagecache.c        | 22 ++++++++++++++++++++++
>  include/linux/fsverity.h     |  8 ++++++++
>  4 files changed, 36 insertions(+)

Acked-by: Eric Biggers <ebiggers@kernel.org>

The example given in the commit message is a bit misleading, though.
Usually there are actually 128 hashes per block, and a block of hashes
covers 512 KiB.  So this optimization applies only where there is a hole
in the file's data of size (at least) 512 KiB, aligned to the same
amount.

It's also worth noting that this optimization is being done only for the
first level.  The levels above that are still being stored.  So, this
doesn't really enable e.g. exabyte sized sparse regions, as a block will
still be stored for each 64 MiB (instead of every 512 KiB).

I'm okay with this if you want to do this, but I just want to make sure
its limitations are well-understood.

> +	/* the hash of a merkle block-sized buffer of zeroes */
> +	u8 zero_digest[FS_VERITY_MAX_DIGEST_SIZE];

"the hash of an all-zeroes block" would be clearer.  This is the hash
from fsverity_hash_block() which includes the optional salt, not the
hash from fsverity_hash_buffer() which does not include the salt.

> +/**
> + * fsverity_fill_zerohash() - fill folio with hashes of zero data block
> + * @folio:	folio to fill
> + * @poff:	offset in the folio to start
> + * @plen:	length of the range to fill with hashes

Maybe go with (len, offset) for consistency with
fsverity_verify_blocks().  (I assume the "p" prefix stands for "page",
which is misleading since this works with a folio.)

> +void fsverity_fill_zerohash(struct folio *folio, size_t poff, size_t plen,
> +			      struct fsverity_info *vi)
> +{
> +	size_t offset = poff;
> +
> +	WARN_ON_ONCE(!IS_ALIGNED(poff, vi->tree_params.digest_size));
> +	WARN_ON_ONCE(!IS_ALIGNED(plen, vi->tree_params.digest_size));
> +
> +	for (; offset < (poff + plen); offset += vi->tree_params.digest_size)
> +		memcpy_to_folio(folio, offset, vi->tree_params.zero_digest,
> +				vi->tree_params.digest_size);

This could be done more efficiently, especially on HIGHMEM.  Probably
fine for now though, especially since the intersection of anyone wanting
XFS && fsverity && HIGHMEM is likely to be extremely small.

- Eric
