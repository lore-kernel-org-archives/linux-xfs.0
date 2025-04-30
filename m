Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84740219A76;
	Wed, 30 Apr 2025 09:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005042; cv=none; b=OV6HNWD9Q2/FDhunsjbDlXAL++mDsawPN2Svd4OZeQ9QM3dtI5D+9Hl2LNiJOOssbk/FNrwfB3519icBTjnn9ELJ0v7sOu8T5i6fvpirdQAGriMxEQ4lsF/IilhQlR6m/UluyZ7aQpx6u4USwLgDSOlZ4OYUNmtHOCKLb67v24k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005042; c=relaxed/simple;
	bh=+MBmnjAAkTJneqn9nzEKfrM8IXb0M6NgDB3rJ9PWOV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlizJXA9nW3mtN3nvadcn9IKy8xmpfnlKq/hhmppaiMJpI94RoEgWpGDfTH0V++eQ0iudOOWYdm19ccj0f002S1kvApgYFxLuZZjop9b/Rj3s1jByJSEa3KXahdtOUd/rxHuzjAkdJKGa2CMrWWdMtpQgwGDHTqUqAatSeG41Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNmNmVnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNmNmVnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F21BC4CEEA;
	Wed, 30 Apr 2025 09:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746005042;
	bh=+MBmnjAAkTJneqn9nzEKfrM8IXb0M6NgDB3rJ9PWOV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YNmNmVnKDfo5SHn9MUhH4Qc2WD96pka4i3NjgbWqXffQPG1xPZb4MNvmpSosmI16c
	 Bcw+0cYEHpY2wIn9bQrcFPn22/HtM9QT8cWxEHcQ8kMfAbJ3fbzSr7RO5m/4qjL2kM
	 4dRYNfduwC9cvAs7Hx6fztOyS3M9gxVM4Ttoud1y2EilmR41jJwePiBLi+ibB2qDBN
	 +guavzbRQ3QqMvHpVML6xbCx54wwNgkwb60KzOxc5SUPaP0xASYGNIfZ6EmGp4A8r1
	 pqr4TvAX56xtm9FS2DUpReT8tmzUuy9fpHXhsxdeXWVu9SzYhw+eonO0fvS3UD7vMX
	 PhQYJWxEpoERw==
Date: Wed, 30 Apr 2025 11:23:57 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Charalampos Mitrodimas <charmitro@posteo.net>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
Message-ID: <dyo3cdnqg3zocge2ygspovdlrjjo2dbwefbvq6w5mcbjgs3bdj@diwkyidcrpjg>
References: <6Fo_nCBU7RijxC1Kg6qD573hCAQBTcddQlb7i0E9C7tbpPIycSQ8Vt3BeW-1DqdayPO9EzyJLyNgxpH6rfts4g==@protonmail.internalid>
 <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>

On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
> The xfs_da3_node_verify() function checks the integrity of directory
> and attribute B-tree node blocks. However, it was missing a check to
> ensure that the hash values of the btree entries within the node are
> strictly increasing, as required by the B-tree structure.
> 
> Add a loop to iterate through the btree entries and verify that each
> entry's hash value is greater than the previous one. If an
> out-of-order hash value is detected, return failure to indicate
> corruption.
> 
> This addresses the "XXX: hash order check?" comment and improves
> corruption detection for DA node blocks.
> 
> Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -247,7 +247,16 @@ xfs_da3_node_verify(
>  	    ichdr.count > mp->m_attr_geo->node_ents)
>  		return __this_address;
> 
> -	/* XXX: hash order check? */
> +	/* Check hash order */
> +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
> +
> +	for (int i = 1; i < ichdr.count; i++) {
> +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
> +
> +		if (curr_hash <= prev_hash)
> +			return __this_address;
> +		prev_hash = curr_hash;
> +	}

Hmmm. Do you have any numbers related to the performance impact of this patch?

IIRC for very populated directories we can end up having many entries here. It's
not uncommon to have filesystems with millions of entries in a single directory.
Now we'll be looping over all those entries here during verification, which could
scale to many interactions on this loop.
I'm not sure if I'm right here, but this seems to add a big performance penalty
for directory writes, so I'm curious about the performance implications of this
patch.

> 
>  	return NULL;
>  }
> 
> ---
> base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
> change-id: 20250412-xfs-hash-check-be7397881a2c
> 
> Best regards,
> --
> Charalampos Mitrodimas <charmitro@posteo.net>
> 
