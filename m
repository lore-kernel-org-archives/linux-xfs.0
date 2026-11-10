Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303823;
	b=D4zCDh0c5ZWc1i2ucOp+39KfDzgRyXru6pLnpnIn6TKU9OvX7Wgt+RnnLYjfjsRy0ibt
	 aovI9a1ao7Of1R+fKLNx2Nls/nJYZ1/LZ46Zdzk1U697M+wI6iMVSM3P8aOQKwPEsZc86
	 K+ICN9JMX0k68+QFTgXt8P9Ia/1hh4pTI+6T2eE5zYWjPqy++VO3m9PzoVzBeE2b+krDf
	 xgFinqkVMbbrxFqcXST58jp6iM/mh237X5Qf72nAtZe6lbY6vgKVpcY6eHmTClxRDbji+
	 oKK12eAXl7g0mFAeqOEjQPPly1zDXFxDi4YCpXT8LcKD3Onz9XQnrkrzU+Hm3eOYqKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303823;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BiemyUojj4PkYdH+D6NxAbfQMs1+vHCTq/z761fSwDo=;
	b=w7Rw+knC/VC01UFc0i7T/s+aTJUoT+O71pm+Z3rGciFo5YidoGX89CRU3/pc07XzlVM4
	 Qd7HkcaIvkdcDhoTi/zEY0NRErm6942hlEWJeFYxPtQxOHCFwa3dGKjOnWcKoUXxPJoUD
	 HCiu8YAncU3RwhGNEgqFlQkl6u2y7InVH89wxyDuZxpdRJ6kMUgjKm8KPvRLvErzuCX9Q
	 i2CPiEEUETIG1bDTVKZn40gUAJdPvPxk/QB8ckgxmzcXkvKgSPYGewCnLJ/55438nLM0o
	 c6L3N2XgZrUbBSqoZEx1LHcLDiuTx4V6v7Xhl7C5S+l2mK4HyDxsgkSW5uT773qOMoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lyZWbIWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4207606B14B;
	Tue, 10 Nov 2026 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lyZWbIWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D3D1F0089F;
	Tue, 10 Nov 2026 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794303822;
	bh=BiemyUojj4PkYdH+D6NxAbfQMs1+vHCTq/z761fSwDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lyZWbIWQq9QAv+yY6ndioPYIufEJ0v0SD/02u0GkUtRj010jctOFgCt7tFWikCppO
	 1xBInJlmnApDO0ciiW63E6zSIM/tHzILsCpTIjJSzocPzZo7ZxtRWWfzHnnvaCfe4r
	 4c3s4LJgFmxLQw0MoomI9AnBNAYCvpFnac5Qdybhro5AzEX2nCu9AU/ZWO5i+MAMyd
	 nm89WvAQQxCkqMyMM1NMS5IMy1NU2dTTsQBB7C9RQlLMBY5/uU69UCKiAkX8KoB4c4
	 7q8N6aZ5YcRuayujZqjfj2Atcldd8/zb56T+PXvux+XizvMJ5Q2HoNVOyhkmWeVQTK
	 mUdvqsmx982SA==
Date: Tue, 10 Nov 2026 10:43:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org
Subject: Re: [PATCH v6 04/10] iomap: don't punch delalloc under a dirty EOF
 block
Message-ID: <avLnAe4A6EB8Whyg@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-5-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109235111.14129-5-mason@kernel.org>


Adding Christian directly to the Cc list.

On Mon, Nov 09, 2026 at 06:51:15PM -0500, Chris Mason wrote:
> After a failed buffered write, writeback on XFS can write in place to
> the shared block that contains EOF, and corrupt the other file that
> shares it.
> 
> After a failed buffered write, iomap_write_delalloc_release() punches
> the delalloc reservation of the write, except under dirty folios, which
> still need it. It looks for dirty folios only up to i_size, and punches
> the rest unconditionally. But XFS rounds that punch down to a block
> boundary, so the block that contains EOF loses its COW fork reservation,
> and writeback goes to the shared block:
> 
>     block size 4096, i_size 5000, reservation 4096 to 8192
>     searched for dirty folios:  4096 to 5000
>     punched unconditionally:    5000 to 8192
>     rounded to blocks by XFS:   4096 to 8192
> 
> The fix used here is to look for dirty folios up to the end of the block
> that contains EOF.
> 
> Fixes: f43dc4dc3eff ("iomap: buffered write failure should not truncate the page cache")
> Fixes: f6f91d290c8b ("xfs: punch delalloc extents from the COW fork for COW writes")
> Signed-off-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Christian, is it ok with you if I pull this through xfs tree?

Cheers
> ---
>  fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6e2f1ded5ca..d0980a7f27d1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1495,9 +1495,34 @@ static void iomap_write_delalloc_scan(struct inode *inode,
>   * mapping_seek_hole_data() will return it, and we will skip the punch because
>   * the folio is dirty. THis is incorrect - we always need to punch out delalloc
>   * beyond EOF in this case as writeback will never write back and covert that
> - * delalloc block beyond EOF. Hence we limit the cached data scan range to EOF,
> - * resulting in always punching out the range from the EOF to the end of the
> - * range the iomap spans.
> + * delalloc block beyond EOF. Hence we limit the cached data scan range, and
> + * always punch out the range from the end of the scan to the end of the range
> + * the iomap spans.
> + *
> + * The scan cannot simply end at EOF, because EOF is a byte offset and a
> + * delalloc reservation covers whole blocks. If EOF lies inside a block, it
> + * splits that block in two:
> + *
> + *	[block start, EOF)	File data. If it is dirty it will be written
> + *				back, so the block must keep its delalloc
> + *				backing.
> + *	[EOF, block end)	Beyond EOF. By the rule above, this would always
> + *				be punched out.
> + *
> + * Both parts share one reservation, and it cannot be split: a punch of a part
> + * of a block takes away the reservation for the whole block. If the scan ended
> + * at EOF, we would skip the punch for the first part because it is dirty, and
> + * then punch the second part, which takes the reservation away from under the
> + * dirty data in the first part. On XFS, writeback that has lost a COW fork
> + * reservation like this writes in place, over a block that is shared with
> + * another file.
> + *
> + * Hence we treat the EOF block as a whole, and let the cached data over it
> + * decide: the scan range is rounded up to the end of the block that EOF lies
> + * in. If the data over the EOF block is dirty, the scan moves the punch start
> + * past the block. If it is clean, the block is punched like any other block in
> + * the range. Only blocks that start at or beyond EOF are punched
> + * unconditionally. If EOF is block aligned, the round up changes nothing.
>   *
>   * Intervals are of the form [start_byte, end_byte) (i.e. open ended) because it
>   * matches the intervals returned by mapping_seek_hole_data(). i.e. SEEK_DATA
> @@ -1511,7 +1536,8 @@ void iomap_write_delalloc_release(struct inode *inode, loff_t start_byte,
>  		iomap_punch_t punch)
>  {
>  	loff_t punch_start_byte = start_byte;
> -	loff_t scan_end_byte = min(i_size_read(inode), end_byte);
> +	loff_t scan_end_byte = min_t(u64, end_byte,
> +			round_up((u64)i_size_read(inode), i_blocksize(inode)));
>  
>  	/*
>  	 * The caller must hold invalidate_lock to avoid races with page faults
> -- 
> 2.55.0
> 
> 
