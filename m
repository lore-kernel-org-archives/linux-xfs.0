Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDB74D179A;
	Thu,  8 Oct 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474019; cv=none; b=VBmV8Qg313lY4vAaWr9cF96xk70xHeEgsPjDOtS1Afi2280YJXUY7yb97AvntmPOaRIRySJL5QM2VirDAMZr8EVTEaRgpURgIV171n+fA74WRjwh/lmJm1ry8O6MJmRtlEOrFLdkY/X7AImLbl0DGsntr38sDhAH8SfAmCYoVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474019; c=relaxed/simple;
	bh=hkt9CBC9EWy73tH6jGLMY7YmUbR8Ng6jrYXv8ljt2Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd+b7vscBpv9Wy+H7Ox+FXSiJ69f8h/71nlM9fTe8P5pY0WA92lipXTRmvV+ZeJNeWht/og5H2q+j08LipkalIoFhyKLQwlm4N9ropKvCQsOW5AwtvHkQASZIu25wJSTGrluKiXXhijGKRh2OYeXwvk2xaQvmPqxelN6fez2OdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nn/oQKMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nn/oQKMu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 073891F000FF;
	Thu,  8 Oct 2026 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474018;
	bh=SDkASTJ9FRD3oHMgI63Gz2ZqFSLBdEZmuCHDDzkdsYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nn/oQKMu5bUOZ/Old3XjjvmROumYUrDdjaQ46bkQ2+LEouNK6WGkQ8I+f4r+gCLMX
	 1Ahor7wmXKBLZRs/Y5eEjwihZ/trrYkxHfoMMUucto5JdJs0NDbOIgnKKWjM5eJfBA
	 Sm3HckTLxPgGA3kKSh6EO4kVE/o/UtDKmlvMSejnvFAnbzE5rsThSmV+EnPv1m6dof
	 1tb1J7ErZw2dd3EonbAll9QCpq2orAz0B5a0WXdE4zkpDOpZg3LyBQLIcEolgmDg2h
	 VYVuu9Kzq3gXYe3UfHAFyvErfHGDZiVa2BbaA3P5EAikF48TActZl4p7KvHsWJll5q
	 bmVKzfrsmE3NA==
Date: Thu, 8 Oct 2026 08:40:17 -0700
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
Subject: Re: [PATCH 2/8] xfs: refuse a direct allocation whose block
 reservation would wrap
Message-ID: <20261008154017.GO2705364@frogsfrogsfrogs>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
 <20261008-xfs-nfsd-map-blocks-v1-2-560026cdccb6@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-2-560026cdccb6@samsung.com>

On Thu, Oct 08, 2026 at 10:39:31AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_iomap_write_direct() maps one extent, but it reserves blocks for the
> whole count it is given, in an unsigned int. A count of about 2^32
> blocks or more wraps the reservation. If it wraps to a few blocks, the
> allocation uses more blocks than the transaction reserved, and
> xfs_trans_mod_sb() shuts the filesystem down. If it wraps to nearly 2^32
> blocks, the allocation fails with -ENOSPC.
> 
> Direct I/O, DAX and buffered writes with an extent size hint never ask
> for that much, as xfs_direct_write_iomap_begin() limits them to
> 1024 pages to keep the count below 32 bits. xfs_fs_map_blocks() has no
> such limit: it asks for everything from the start of a hole to the end
> of the range of a pNFS layout, which a client chooses, and an RW
> LAYOUTGET at offset 0 of an empty file for 16 TiB does it.
> 
> Fail such a count with -ENOSPC before anything is reserved, also on a
> filesystem with that much free space, as the transaction cannot take
> it. A count that fits is reserved in full, as before, so a hole longer
> than the free space still fails before it is allocated.
> 
> With pynfs as the client and a 32 GiB XFS, an RW LAYOUTGET at offset 0
> of an empty file for 16 TiB shut the filesystem down: "Corruption of
> in-memory data (0x8) detected at xfs_trans_mod_sb". With this patch it
> gets NFS4ERR_NOSPC and nothing is allocated, as with 100 GiB, and one
> for 16 GiB, which fits, is still granted, in three extents.
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  fs/xfs/xfs_iomap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7c6238fed6..1917e49166 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -287,6 +287,13 @@ xfs_iomap_write_direct(
>  
>  	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
>  					   xfs_get_extsz_hint(ip));
> +	/*
> +	 * The transaction takes the block reservation as an unsigned int.
> +	 * Refuse a count that does not fit rather than reserve too little;
> +	 * only a pNFS layout for a huge range asks for that much.
> +	 */
> +	if (resaligned > UINT_MAX - XFS_DIOSTRAT_SPACE_RES(mp, 0))
> +		return -ENOSPC;

Uh... seeing as extent records can only map 2^21 blocks maximum and
iomap/pnfs can handle xfs returning a mapping of whatever length we
want, why don't we constrain count_fsb to XFS_BMBT_MAX_EXTLEN?

--D

>  	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
>  		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  		rblocks = resaligned;
> 
> -- 
> 2.43.0
> 
> 
> 
