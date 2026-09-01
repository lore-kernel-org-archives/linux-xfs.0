Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAAA372B2B;
	Tue,  1 Sep 2026 07:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246414; cv=none; b=fslxQ5z3WBTrixXkGQm9WkHMCCLyQpQIT9CWNUHO+cEuBRFym5RSDCM/ImgVFgWiBKaozBmXwLgoiDH1uBF6NrT/rzULGTzsxQrcv+ASew0p0wDdqgzDgbuDSr5sd11vkGJtuK6J+AC8n62n+fFaT9P/B/glUtCHpc4X3zRn+IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246414; c=relaxed/simple;
	bh=E65v9oUUNN9u65itT6y44XxBw0vXoJXqefMY4PW+60Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTecL2/cX9NRVzQjNBj55w8mnZnYeO2tSin0VQYwTZbSlmgMIzqVjiX0da6xSy+NXBzJiB8fAlyvKqxfp6O23rf7n+8slGZ/dKJZ2QlNMNaj7AQSg0Hze0CZDAd5eCtQeWl/hQlQ2S8A/CPPkuM0Kb7iFVzTHiJgWaNX+vY0pZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4hjbeiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4hjbeiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFA21F000E9;
	Tue,  1 Sep 2026 07:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788246412;
	bh=p8PGSLBXvbkCoZ8/6vFG3zwXKzKpmIfjRA7/1UlyVWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S4hjbeiYKlGdJZuOKvN40AeJxJFaRNNhHywzhtyTM6zaIy8pbWCoZrfixqpYwdwbH
	 0i884CUn7svmUJ2RK435cihGzB/plIacqfrvJhUNTdPnLsh/i126ik7pniwPkdA/VW
	 LhDkagBH8s9Wz/sP3Sv9omj7BkhX/oIPWVNed5ztQzmxinQecsBINHnQQS+ueSSUku
	 ikI2oEJn6sahNXC0sCpN2NLNqdppCXD79FkX+y+Ux7XIYXstyVIqgqkpX4PYHSMULL
	 NoUP3m327koe4tNYTDPI5nN21cSLsAVXByyViJqp2zwnZu0KP3B8QTsaJ7OWQandT6
	 0sDCswgXJnAFw==
Date: Tue, 1 Sep 2026 09:06:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: darrick.wong@oracle.com, chandanrlinux@gmail.com, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, zhongling0719@126.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix array bounds checking in log recovery
Message-ID: <apZ5UptiKsVGgPHZ@andromeda.toxiclabs.cc>
References: <20260824094535.219503-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824094535.219503-1-zenghongling@kylinos.cn>

On Mon, Aug 24, 2026 at 05:45:35PM +0800, Hongling Zeng wrote:
> The log recovery code increments array indices based on bits set in
> blf_data_map without verifying that the indices stay within the bounds
> of the item->ri_buf array.
> 
> Since blf_data_map is from untrusted log data, a malicious log could set
> many bits while ri_total is small, causing array index overflow.
> 
> This can result in an out-of-bounds access during log recovery, causing
> a kernel crash or memory corruption.
> 
> This patch adds array bounds checking for ri_buf access in
> xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer().
> 
> The check in xlog_recover_do_inode_buffer() is placed right before the
> actual array access, not after incrementing the index, to avoid false
> positives when processing the last valid region.
> 
> Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Hi,

is this a re-send? A v2? Please specify why you are sending the same
patche again. This saves a lot of time trying to understand why there
are two patches with the same subject in the list.

> ---
>  fs/xfs/xfs_buf_item_recover.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 57929f115055..7148716366ba 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -485,6 +485,19 @@ xlog_recover_do_reg_buffer(
>  			break;
>  		nbits = xfs_contig_bits(buf_f->blf_data_map,
>  					buf_f->blf_map_size, bit);
> +
> +		/*
> +		 * The bitmap can have more bits set than there are regions
> +		 * in ri_buf, so we must check array bounds before using the
> +		 * index to access ri_buf[i].
> +		 */
> +		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
> +			xfs_alert(mp,
> +		"Buffer log item index (%d) exceeds allocated regions (%d).",
> +					i, item->ri_total);
> +			return -EFSCORRUPTED;
> +		}
> +
>  		ASSERT(nbits > 0);
>  		ASSERT(item->ri_buf[i].iov_base != NULL);
>  		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
> @@ -688,6 +701,19 @@ xlog_recover_do_inode_buffer(
>  		if (next_unlinked_offset < reg_buf_offset)
>  			continue;
>  
> +		/*
> +		 * Check array bounds here (right before accessing ri_buf)
> +		 * rather than after incrementing item_index. This avoids
> +		 * incorrectly rejecting logs when item_index reaches
> +		 * ri_total after processing the final valid region.
> +		 */
> +		if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
> +			xfs_alert(mp,
> +		"Inode buffer log item index (%d) exceeds allocated regions (%d).",
> +				item_index, item->ri_total);
> +			return -EFSCORRUPTED;
> +		}
> +
>  		ASSERT(item->ri_buf[item_index].iov_base != NULL);
>  		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
>  		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
> -- 
> 2.25.1
> 
> 
