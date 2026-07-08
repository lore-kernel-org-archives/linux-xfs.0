Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC0C36DA14;
	Wed,  8 Jul 2026 23:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783553197; cv=none; b=IW0UfzOT5yunrkyBGmNv2yU/fQ3VmFyjx6hjeOGcjkHmVXIS1b64IgKRmcGDGeuthQKq+6N3Mbwj1aDvFj6KE5EssVKoVtyVmTCvfGoRKp+FzKTLkHBChzrszZFInKyEuiqOBH4Wp2u+abE/50SpFFbnMWqZsVEqU4okrxtIwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783553197; c=relaxed/simple;
	bh=Y5CdGuK7MUx+xQgtzWCUoAnNDaIbM6/CFvsIMWPxOlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uASuvac9Ehe1DQ9cHLAWx23Db224xFLkLfh2VySD/12rvyoskFKSqM/6k5gFEhJyO+bT7gB8J19RTHaK6ULhrpgZ0jc/Ous74WpJazZIFDKJK0DE92XAyMHpbYtiFKSGQ7zdpyiYFd7syrCjw1wy97asqRCDArCJKiEzlc52UMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8bG1kHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8bG1kHF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 717E11F000E9;
	Wed,  8 Jul 2026 23:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783553195;
	bh=8hnhw8l6Qm33KE+spI9ZQByeqJv2VCvqDGE2V1gF+j4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I8bG1kHFVgAKiYAHFKihBlxXApoBsqhpnRi7RjpXrHkUvuvMfvdOXPxOTMbohGIui
	 buhMbyVS0m8rPfeK77Wu5OOGHgVsmGREFzODr4uCFxe5Lt8cOJOlTvtqm2/RYdHcCK
	 nxo5NeJTN40Y/VGcHEFBfZIj3/NtteSgRF5ZpMtvLgkSi1f5TtNXdWTasKutA8eBGf
	 YRZ71KdbXanThu9GSIyquwNac1Tp8/zWkkCi1q9ycHKN3UpOcZwj2Q42hqx+U+bZJM
	 jutl0neByxqdLABDI4Bs+kP7GUEdPIKlm73+0PvI4xpjrCCO7JOehCl8NJBIDLV1my
	 YI+r3DcHNpF+Q==
Date: Wed, 8 Jul 2026 16:26:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
	joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 4/5] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
Message-ID: <20260708232634.GJ9392@frogsfrogsfrogs>
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
 <20260520030357.679687-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520030357.679687-5-yi.zhang@huaweicloud.com>

On Wed, May 20, 2026 at 11:03:56AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> unsigned subtraction underflows to SIZE_MAX, producing a huge
> last_blk and nr_blks value that causes bitmap_set() to write far
> beyond the ifs->state allocation.
> 
> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> the guard at the top of __iomap_write_end() does not trigger because
> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> with copied == 0.
> 
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
> 
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 27ab33edbdee..76f9a43e283c 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -67,11 +67,13 @@ static bool ifs_set_range_uptodate(struct folio *folio,
>  		struct iomap_folio_state *ifs, size_t off, size_t len)
>  {
>  	struct inode *inode = folio->mapping->host;
> -	unsigned int first_blk = off >> inode->i_blkbits;
> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned int first_blk, last_blk;
>  
> -	bitmap_set(ifs->state, first_blk, nr_blks);
> +	if (len) {
> +		first_blk = off >> inode->i_blkbits;
> +		last_blk = (off + len - 1) >> inode->i_blkbits;
> +		bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
> +	}
>  	return ifs_is_fully_uptodate(folio, ifs);
>  }
>  
> @@ -203,13 +205,17 @@ static void ifs_set_range_dirty(struct folio *folio,
>  {
>  	struct inode *inode = folio->mapping->host;
>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> -	unsigned int first_blk = (off >> inode->i_blkbits);
> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned int first_blk, last_blk;
>  	unsigned long flags;
>  
> +	if (!len)
> +		return;
> +
> +	first_blk = off >> inode->i_blkbits;
> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>  	spin_lock_irqsave(&ifs->state_lock, flags);
> -	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
> +	bitmap_set(ifs->state, first_blk + blks_per_folio,
> +		   last_blk - first_blk + 1);
>  	spin_unlock_irqrestore(&ifs->state_lock, flags);
>  }
>  
> -- 
> 2.52.0
> 
> 
