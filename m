Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6814885D
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736744182; cv=none; b=ig2scU5JypWW+CSm5woheah7m7Kdn2dg4YiGvLfI9QydiEo88du2Z//o6fPJ/rqhvUvRQ/oBStkKI9N7TbYCR7NMd4rGamcMYjgzZNhqqyI5xKEHuMcqfrl5BsxKQDyiQGIY4J+Qb7Z1gW6cpsPLlIgOh0r1dwZhjzpYWk0JF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736744182; c=relaxed/simple;
	bh=W5MM/9ST8BCx7WDjX8FxLSolq6T2xq/5YjNY8aT+iZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=je+zgN2oUO0S8XkLU6tTZrjG/wiSTkHIvuwqD6x+pbtgQ+/weBIGv96goajR2UkLHxsTcOfs1Wpi2ROpp6ZmEgOPFxei0miGYba/IR5jSsLQH+efPwfr2VUlDVdz+NDNS/jhRzygzG/sLt1Q/dinQv6+5FLhFU+6b9lZOWQesoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnMZewIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnMZewIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB25C4CED6;
	Mon, 13 Jan 2025 04:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736744182;
	bh=W5MM/9ST8BCx7WDjX8FxLSolq6T2xq/5YjNY8aT+iZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AnMZewIez0yQBzA4slbjI8E1H+RmBiqcp9ZhuZB5o7//ZZOtuTd+7ql2e4Uh52zaO
	 +WuLWJOXL/pRkV9m8GC/vNteq8hVKMI796/vNziUgxul26YaHmzHZ20DefLb4hVFnv
	 1wosOdLZyJkH8WDTjqaaD1Vq5fZ1hCaMz2TfFXZ7ta1UzB3loFuy+VRMrbgqlAoY1M
	 /HKiTW1568/SJlfUqXCjVzih3ruchtnHfwN2Q0+OTc/aUMow1f7cZ1gQT5V9WfRVJA
	 Pybxr075/vVlkG7yqax5G4yqYOLRYk63nwKvz3o74tJfiKLMLE+9HyySlJpgcn42Sp
	 4psnZqXlnDjHA==
Date: Sun, 12 Jan 2025 20:56:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: check for dead buffers in xfs_buf_find_insert
Message-ID: <20250113045621.GR1387004@frogsfrogsfrogs>
References: <20250113042542.2051287-1-hch@lst.de>
 <20250113042542.2051287-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113042542.2051287-2-hch@lst.de>

On Mon, Jan 13, 2025 at 05:24:26AM +0100, Christoph Hellwig wrote:
> Commit 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting
> new buffers") converted xfs_buf_find_insert to use
> rhashtable_lookup_get_insert_fast and thus an operation that returns the
> existing buffer when an insert would duplicate the hash key.  But this
> code path misses the check for a buffer with a reference count of zero,
> which could lead to reusing an about to be freed buffer.  Fix this by
> using the same atomic_inc_not_zero pattern as xfs_buf_insert.
> 
> Fixes: 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting new buffers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Cc: <stable@vger.kernel.org> # v6.0

and with that added,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6f313fbf7669..f80e39fde53b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -664,9 +664,8 @@ xfs_buf_find_insert(
>  		spin_unlock(&bch->bc_lock);
>  		goto out_free_buf;
>  	}
> -	if (bp) {
> +	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
>  		/* found an existing buffer */
> -		atomic_inc(&bp->b_hold);
>  		spin_unlock(&bch->bc_lock);
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)
> -- 
> 2.45.2
> 
