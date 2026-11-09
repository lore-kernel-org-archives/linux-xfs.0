Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244200;
	b=YFYpJ6+IilPF/1L1QFnvYNYmDEYoVxefGH6zGuOa2hrrWFQB0vnNnWTxd7UJEKQwzQq6
	 qht2Bqc4j2EOB7CwB9eBhmZGZFnzU6UrHeTNYU9VJgaSW7e0ZOio5E8a+2VP7J0+TEgua
	 JGcX4yWuBNeCsEQOgXlRVF/dr8aswfnYF36zsnR74Gk046IAdtxLs1Eki/1KTfMl1oW7M
	 9FlSrWOs4nL26Cm2/qZDfoOa0aXp/+OkRPLO94kY0ZHXDEQ+TUkFIKL517UPpJi0sBiwZ
	 mIIOEqTOqsz1eR+OyC8p0jTTpn2dfTq3ccbkYFsRUOv1GAc7UGepmfiT+BSwmHS2jVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244200;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0MjNTh09fB02xvZARX+Z4TAHBb6ZpanKCZRK2ApbDtI=;
	b=SAF5vh9FOXU/syqa8q+hN32PI6hLuKM6Sy9u1gE2VBR2caTfhgMD5lk9effFebLKcFh1
	 VBUnrN9uVQ1Pps1btaXQo4GG3eIL5mpSgQM9Xuf5BjFYkpFV7JDyVIA9dE/+GkxadnObn
	 x1rUJ7/uSulZnLEs4/eSJUpRIztDmk4C1xvKEefcNfLqlqafBavfLwB/IAov1iRcA5qqQ
	 JBXXIRrDpvl1j8d7BqSuiV9Wyz7cRw4yW/nQ3FYOBKcV7PbctHL+o8qS38wQiUMLyOhBL
	 u7KxxoMYrNmOswdE/PG4hiWXEFpRPJQTCnKEX8me1donOe/4quL0XqGq6FonruyXjBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQAzKD45;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2B4606A31C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQAzKD45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1321F0089F;
	Mon,  9 Nov 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244199;
	bh=0MjNTh09fB02xvZARX+Z4TAHBb6ZpanKCZRK2ApbDtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fQAzKD45TyKB6fI3Wb6EhgJSrbOYb55NQ3MgwXy9sNVq9sMuPGIRFWQhOLeUA33e3
	 wtAar61P/3iXs/z9EN4bHadP8jq5OoVI/SZQhOGjs3d8YZlBQ/xBacWhxY9i132LLx
	 CnhNd9/bC2LbkdMGZWmyDHJ19ta+mbqQCcvCteKMi4hy/+cjil0kbRZjRG8DDhcHob
	 i28nUtODj45/BiwzxYZb3utHnYTLuM0BQ574myDcSz2YPFPFxDInr22yKoYkDUFY6/
	 Q2OhZwt49bBUwJaMT8IPPBxGETt7FXduQ9uKnHhSmzlMkrKzDzz1x0LOi53kGxQEqc
	 JEJw34jIRUAMw==
Date: Mon, 9 Nov 2026 18:09:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Guikun Yang <yangguikun19@qq.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check the region index against ri_total in buffer
Message-ID: <avH-JslaJ4xlof4c@cronus.toxiclabs.cc>
References: <tencent_ADBE1F465A9C5A4CFBA28A7D6AA39C527509@qq.com>
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
In-Reply-To: <tencent_ADBE1F465A9C5A4CFBA28A7D6AA39C527509@qq.com>

On Tue, Nov 10, 2026 at 02:00:00PM +0800, Guikun Yang wrote:
> Both xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer()
> walk the buffer data map run by run and index item->ri_buf[] with a
> counter that is advanced once per run. The number of runs in the
> on-disk bitmap has no relationship to the number of regions the log
> item actually carries (ri_total, from blf_size), and the only bound
> on the index is an ASSERT - either the mid-loop ASSERT on ri_buf[i]
> or the trailing ASSERT(i == item->ri_total) - both of which compile
> away on production kernels.

Great... Your patch does not even apply to the tree...

> 
> A crafted buffer log item with a data map that contains more runs
> than blf_size claims regions walks the index past the end of ri_buf[]
> and reads ri_buf[i].iov_base out of bounds. The destination side of
> do_reg_buffer() is already validated for real since the CVE-2026-80536
> fix ("... the only thing bounding the copy is an ASSERT(), which
> compiles away on production kernels"); the source index was left to
> the ASSERTs in both functions.
> 
> Validate the index before each ri_buf[] use, in both functions:
> 
>   xlog_recover_do_reg_buffer(): i >= item->ri_total at the top of the
>   loop body, reported as a bad buffer log item.
> 
>   xlog_recover_do_inode_buffer(): item_index >= item->ri_total right
>   after the run-advance loop.
> 
> Tested with two crafted dirty-log images (mount(2) alone): one hits
> do_reg_buffer (16 runs, blf_size 2), one hits do_inode_buffer
> (alternating map, blf_size 2). Both previously produced
> KASAN: slab-out-of-bounds; with this patch both fail recovery with
> the new message, and the unmodified images still mount.
> 
> Reported-by: Guikun Yang <yangguikun19@qq.com>  (bug reports of 2026-11-09, <c40-xfs-inodebuf-item-index-20261109@qq.com> and <c41-xfs-regbuf-run-index-20261109@qq.com>)
> Signed-off-by: Guikun Yang <yangguikun19@qq.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 1111111..2222222 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -479,6 +479,13 @@ xlog_recover_do_reg_buffer(
>  		nbits = xfs_contig_bits(buf_f->blf_data_map,
>  					buf_f->blf_map_size, bit);
>  		ASSERT(nbits > 0);
> +		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
> +			xfs_alert(mp,
> +"Bad buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%llx.",
> +				i, item->ri_total, xfs_buf_daddr(bp));
> +			return -EFSCORRUPTED;
> +		}
>  		ASSERT(item->ri_buf[i].iov_base != NULL);
>  		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
>  		/*
> @@ -688,6 +695,13 @@ xlog_recover_do_inode_buffer(
>  			nbits = xfs_contig_bits(buf_f->blf_data_map,
>  						buf_f->blf_map_size, bit);
>  			ASSERT(nbits > 0);
> +			if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
> +				xfs_alert(mp,
> +"Bad inode buffer log item dirty bitmap (region %d, %d regions) at daddr 0x%llx.",
> +					item_index, item->ri_total,
> +					xfs_buf_daddr(bp));
> +				return -EFSCORRUPTED;
> +			}
>  			reg_buf_offset = bit << XFS_BLF_SHIFT;
>  			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
>  			item_index++;
> 
> Fixes: 658fa68b6f34 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
> --
> 2.43.0
> 
