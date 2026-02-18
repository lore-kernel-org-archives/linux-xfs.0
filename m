Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB802F616B;
	Wed, 18 Feb 2026 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771455905; cv=none; b=aOdCo+g8rJQAOzSbwT/flWiT/kD5FpZKNlychUBNnGffP8+YKNWkv0g5oO0TwK+JD0ECT43ua7fbV341PPSH8eMkyHiUUvOL2ZkT2VEqwXX8ps07TdKVn34WWV6Fk4fY2rViRlrAVXLaRKn4HqN2qNZMMzekkHX2w1xXTb0hWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771455905; c=relaxed/simple;
	bh=m0Ge09sJIPzxExUr5refscakKrrITkNwyVfeS2JWhXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKEqnqRrkvkGadbv+wxZZ/6srja80dktYOu5wQqfc6apsVSZyFw1j/wwDuXj1nLP0PV0M9vrguSPzSGXmhVw6DYvQY3YwIAPK4x1NzfXaZb+/eclqXJzmU9Zi7REzv/tn5wkMFEjOjJZbKM6+nJwoTpwYEk4V2sAPDdRDldxocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6+A3jbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6+A3jbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA43FC116D0;
	Wed, 18 Feb 2026 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771455904;
	bh=m0Ge09sJIPzxExUr5refscakKrrITkNwyVfeS2JWhXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h6+A3jbMjxE1FkuoJXtX6lkJ5bI19axbGH+t2WCl5FpaTRcdzzXPgPiwbM9PrPWtw
	 /8maKDauEt+20Yp4Ql8x1Ylkw8UOMuDregpljmx8drOQFin44E/foQUrdInoj4K4a4
	 neu/l3QihXseyCrkrUD1hUEyuMJZlpJLS3f2V5SzNhK8HVitWkvPnJhyhgUw4GFQua
	 /7gFGqO9zCh67kDN7hdi5CDONhlj8qtT3yTQSSrhnm2j+RLWNRP8PkUQbQCJJQ+sNX
	 I4CmCG464ET0R6piXNYf0ZM+0iW7A3CFtvvYzFa1hbJoED0hGcszGdHiVy34b2jlw9
	 spHuhPWvXnltQ==
Date: Wed, 18 Feb 2026 15:05:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 08/35] iomap: don't limit fsverity metadata by EOF in
 writeback
Message-ID: <20260218230504.GG6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-9-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-9-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:08AM +0100, Andrey Albershteyn wrote:
> fsverity metadata is stored at the next folio after largest folio
> containing EOF.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

I think this should be in the previous patch since writeback is part of
pagecache writes.

Also, should there be a (debug) check somewhere that an IOMAP_F_FSVERITY
mapping gets mapped to a folio that's entirely above EOF?

--D

> ---
>  fs/iomap/buffered-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 4cf9d0991dc1..a95f87b4efe1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1817,7 +1817,8 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  
>  	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
>  
> -	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
> +	if (!(wpc->iomap.flags & IOMAP_F_FSVERITY) &&
> +	    !iomap_writeback_handle_eof(folio, inode, &end_pos))
>  		return 0;
>  	WARN_ON_ONCE(end_pos <= pos);
>  
> -- 
> 2.51.2
> 
> 
