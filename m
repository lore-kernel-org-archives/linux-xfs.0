Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949474;
	b=3ErqA8uSUfyoqjJB6e22IFtDgQxPSnCrVL1aJNlA0jq1+mpBOnrw63AFGKgJl6l2BDJX
	 pEAskJ4XDSHXYCkRT6mwpKQBgJ96TUknKPYjVltxvWYZ7uXLFjJwKTy69UdquZG+UOrQk
	 hKte8mpzVr4oWHHDAF9eclGQXh29g1nNqIQAez6Or1A1DPSZrkhenrYMlChJRe7cMn+C5
	 2s02NkdGTxIcQW9qUjxS6I1ltAKB6fQz6d+QHqaqETPczohQSOysGgWi+iODFXY4SpN6N
	 Mhvb6Lfk5j2h8F9jx7sgiUkbTW81dXAzWTaHzLBsi5tPIia4nuU0fljZFG/HIiEyVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LA7in417xxsvWeOSI/Y7AtXUJZchmZdeB24NIGGuWuQ=;
	b=R6wCqRswkp2jJC1C+Pz7P45xKzS5IEptlhHu2aiYUP7sX1+gkRFuRwZTJAyMaJnP7xqj
	 1b6h/uVEs8UkYNPwY2BLV1Ei1kuG3VLYp7pSGxvzxk2CgAD/fu6K9zXrf/L0EogR6b0GE
	 SgI+HkIZKkqfXLdhNAAV7529VLuTyklyT4ryHhGJwWyE6HJya2zBsfJljrFKkaNVgrX3j
	 qntRqzBctIQXK8xjrMVFE9vW5NZQDw8awuZMgyYqWi4p6W3MJqU2TmCDGkRziyDXGSvnt
	 74HMq88WzJpoGz3KIfcYwhRVGpl3OdT5CxR5ZHB1yElghSHiVh9IEglbPl6SchSx5Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AxqceAZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CB606A333;
	Fri,  6 Nov 2026 07:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AxqceAZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88DB1F008A3;
	Fri,  6 Nov 2026 07:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793949473;
	bh=LA7in417xxsvWeOSI/Y7AtXUJZchmZdeB24NIGGuWuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxqceAZP8HOAx6X5A6qmSYJDv3HLA99unJTCs9GmMJL++8mJzpOsqMFOH85IZK20+
	 TilQjwaXqCszMmM0yf/zzGN6oHUivfQEBCZArXI+M0exT8O2/bfH4HmEuAGrC+5+mg
	 hFtbKIGZI/OYre49UifOvi4ds7AFyuYJ1MjTWc1Jii1zBn4z5uEZb1lNiXxTRM/A63
	 AobpO6ku9AnkJuh4av0P9D3rG8qwdBfAp+bIkNv/Ko7PBR+WjYMKdA0MK+FVIg+Fz1
	 qcWqIK1kfthD9vteCUVTJ7ZvUuMSJBgvuDclojGHwF/OaENySdgP1u9egi6BQueG6K
	 VfmO/VXfWRWSg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 6.18 0805/1005] xfs: cross-reference the primary superblock
Date: Fri,  6 Nov 2026 08:17:43 +0100
Message-ID: <20261106071743.90363-1-ojeda@kernel.org>
In-Reply-To: <20261104211105.901372401@linuxfoundation.org>
References: <20261104211105.901372401@linuxfoundation.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Nov 2026 16:08:58 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
>  	int			error;

> +	if (agno == 0)
> +		goto out_xref;
> +
>  	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);

> +out_xref:
> +	xchk_superblock_xref(sc);
>  out_pag:
>  	xfs_perag_put(pag);
>  	return error;

In loongarch64, like in 7.13.y, I am also seeing the following due to
the code above:

    fs/xfs/scrub/agheader.c:123:6: warning: variable 'error' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
      123 |         if (agno == 0)
          |             ^~~~~~~~~
    fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
      435 |         return error;
          |                ^~~~~
    fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always false
      123 |         if (agno == 0)
          |         ^~~~~~~~~~~~~~
      124 |                 goto out_xref;
          |                 ~~~~~~~~~~~~~
    fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence this warning
      111 |         int                     error;
          |                                      ^
          |                                       = 0

It seems this happened in mainline too, but `error` got initialized in
a later commit:

  612d2e7506c3 ("xfs: read primary superblock from disk during scrub")

So something needs to be changed for stable.

Cc: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

Cheers,
Miguel
