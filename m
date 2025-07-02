Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944A52E4980;
	Wed,  2 Jul 2025 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751480614; cv=none; b=Qc6aIsm9KpEvX+syO0tOzd/yOlusl10oaZKusB5bNSYqjsYgJz1+uKA0TVwXzk/pZ75Z/PW5FvXWlEAN+NCpGTVLi72LFPwvIe8YJC47uV3nfW4RGKv2CmRfH9ABLjErJn1p+aQaDljfddWXlZNF5KIgBaO5jWObLvU3HOBgUmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751480614; c=relaxed/simple;
	bh=naF17DdHpf2aIqO2cfbGNe1tIcjK3c/ZoDy83iJKkcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNLnyGjEId8fQFPLO+6AshdJKbTuUbEht54XOCtzbIjW92angfLW3SufH0t5xpE1SDwv2/I28ptJ48FftZ3ocTL2b0VbvGs3QzUJK9TD9d/HpuCXWx/GFSFh3+AT56axTzuQkzwrCJyXr4dq186DQGomUg2aUYrpLcl7yvSFMZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiHlljCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiHlljCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CF4C4CEE7;
	Wed,  2 Jul 2025 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751480614;
	bh=naF17DdHpf2aIqO2cfbGNe1tIcjK3c/ZoDy83iJKkcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KiHlljCdjtk0oEUCaqrtwblx0KuDoq7VGgPx2rzkSMxJoU2EV8ViGIHzfGZEtUxUd
	 NbMFIWBi6pJx+hX34y0UD/wOKPGHsHpCR2kIwyEs4RMFJTbP17SMBHM4pFxfosyRC+
	 MopZfQjqB93xERUsf0xTTbJAHsb7wPG/K/MPtsp3g3+9UHB7eBqCYSmTY1Z6paz3hY
	 rvbrjFkScwNUhfBPyD7o7AWgbS8MRf3QCl0P1+QHYAipHOzcuLvuzbUmpp1QWHKFi9
	 2gWUvN7atKCKRhOYAEzfAgJ0k+ciBpqTp1lPc52VKjNmxdr29DtxlwcVhyBR0VJeiu
	 /943BaNSwk2DQ==
Date: Wed, 2 Jul 2025 11:23:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, gfs2@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 02/12] iomap: cleanup the pending writeback tracking in
 iomap_writepage_map_blocks
Message-ID: <20250702182333.GO10009@frogsfrogsfrogs>
References: <20250627070328.975394-1-hch@lst.de>
 <20250627070328.975394-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627070328.975394-3-hch@lst.de>

On Fri, Jun 27, 2025 at 09:02:35AM +0200, Christoph Hellwig wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
> 
> We don't care about the count of outstanding ioends, just if there is one.
> Replace the count variable passed to iomap_writepage_map_blocks with a
> boolean to make that more clear.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> [hch: rename the variable, update the commit message]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

/methinks this also fixes a theoretical logic bug if *count should
ever overflow back to zero so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index b5162e0323d0..ec2f70c6ec33 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1758,7 +1758,7 @@ static int iomap_add_to_ioend(struct iomap_writeback_ctx *wpc,
>  
>  static int iomap_writepage_map_blocks(struct iomap_writeback_ctx *wpc,
>  		struct folio *folio, u64 pos, u64 end_pos, unsigned dirty_len,
> -		unsigned *count)
> +		bool *wb_pending)
>  {
>  	int error;
>  
> @@ -1786,7 +1786,7 @@ static int iomap_writepage_map_blocks(struct iomap_writeback_ctx *wpc,
>  			error = iomap_add_to_ioend(wpc, folio, pos, end_pos,
>  					map_len);
>  			if (!error)
> -				(*count)++;
> +				*wb_pending = true;
>  			break;
>  		}
>  		dirty_len -= map_len;
> @@ -1873,7 +1873,7 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  	u64 pos = folio_pos(folio);
>  	u64 end_pos = pos + folio_size(folio);
>  	u64 end_aligned = 0;
> -	unsigned count = 0;
> +	bool wb_pending = false;
>  	int error = 0;
>  	u32 rlen;
>  
> @@ -1917,13 +1917,13 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  	end_aligned = round_up(end_pos, i_blocksize(inode));
>  	while ((rlen = iomap_find_dirty_range(folio, &pos, end_aligned))) {
>  		error = iomap_writepage_map_blocks(wpc, folio, pos, end_pos,
> -				rlen, &count);
> +				rlen, &wb_pending);
>  		if (error)
>  			break;
>  		pos += rlen;
>  	}
>  
> -	if (count)
> +	if (wb_pending)
>  		wpc->nr_folios++;
>  
>  	/*
> @@ -1945,7 +1945,7 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  		if (atomic_dec_and_test(&ifs->write_bytes_pending))
>  			folio_end_writeback(folio);
>  	} else {
> -		if (!count)
> +		if (!wb_pending)
>  			folio_end_writeback(folio);
>  	}
>  	mapping_set_error(inode->i_mapping, error);
> -- 
> 2.47.2
> 
> 
