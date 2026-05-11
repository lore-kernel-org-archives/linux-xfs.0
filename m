Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22240374722;
	Mon, 11 May 2026 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501549; cv=none; b=hI9Gp4hYSdVRxOj/eUEN13MsdoHl3M3COR7GCv182iFfPcSzdepaga6cTVyUPr8cD0YOts4mggyZ6iiXQ/mtSQR6YT8YIz+1J5uTEjIQcHBgUcu+cUWUauiZcvssvR5S3orQVhfFRF9q8B1SLZd3zXAnaWdxBjR2RbItMg6KIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501549; c=relaxed/simple;
	bh=1VYadDhD3eCww6mxNIAf34ISrJjyTw03OfLADFr7z6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKRpEWxjVMQIrORNHVuNQhfouRPggw3mgDiXWPHciGMmSEOfyIfMrQlQ/9MBUP2F6i/jStzbEqREn7yY/o97kH6jAoU2LX/8qZVL2M/OxTePfO9eNsL5u0CdZ4m7/+VLBeCpOfdq0qd1hSHNuXYFICQgh/Ckm66rvz9vwN/QWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmQ5FvMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmQ5FvMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25241C2BCB0;
	Mon, 11 May 2026 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778501548;
	bh=1VYadDhD3eCww6mxNIAf34ISrJjyTw03OfLADFr7z6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TmQ5FvMkDf543ZbA8Y0cKaOZt7JyX+w5KKju50tlNweLTek43Z2DMggSIBq0MTtxe
	 +rlTEqpxQsrk3cb0kmOyuuRi8XzlAIaYI/Bej7QXe7vvbTsFF8wPPLlR7N0n4QAp1y
	 KG26hd85hjQRZVSTjiZbwuF1PDS8cNUg5lZhQJXegYdASU9VMiTYpDV0IHo/8cxxnU
	 /9v6X+80zx1pw6aZwp/MQFA3hJG47Q09RCLrF64BHh1o3DJJqyAljAgKXqZgF6DgF/
	 Wx/olCG1oW55yYsRmXXl3W10WTlfPGHATvurhMuhr22LTxVMJQawIKKpZlxQxhnJsK
	 PEl8jm+8MZaBA==
Date: Mon, 11 May 2026 14:12:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Andres Freund <andres@anarazel.de>, Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org, 
	hch@lst.de, open list <linux-kernel@vger.kernel.org>, 
	pankaj.raghav@linux.dev, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: fix forced iversion increment on lazytime timestamp
 updates
Message-ID: <agHHjm-LZenGBK3H@nidhogg.toxiclabs.cc>
References: <20260511111918.1793689-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511111918.1793689-1-p.raghav@samsung.com>

On Mon, May 11, 2026 at 01:19:18PM +0200, Pankaj Raghav wrote:
> When updating timestamps with lazytime enabled, if only I_DIRTY_TIME is
> set (pure lazytime update), inode_maybe_inc_iversion() should not be
> forced to increment i_version. The force parameter should only be true
> when actual data or metadata changes require an iversion bump.
> 
> The current code uses "!!dirty" which evaluates to true whenever dirty
> has any bits set, including the I_DIRTY_TIME bit alone. This forces an
> iversion increment on every lazytime timestamp update, which then sets
> I_DIRTY_SYNC, triggering expensive log flushes on subsequent fdatasync
> calls. Andres reported this issue when he noticed a perf regression[1].
> 
> Fix this by using "dirty != I_DIRTY_TIME" as the force parameter. This
> passes false for pure lazytime updates (allowing the I_VERSION_QUERIED
> optimization to work), while still forcing the increment when dirty
> contains other flags indicating real changes that require iversion
> updates.
> 
> [1] https://lore.kernel.org/linux-xfs/7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r/
> 
> Fixes: 85c871a02b03 ("fs: add support for non-blocking timestamp updates")
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 6a3cbc7dcd28..62c579a0cf7d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2124,7 +2124,13 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
>  			    inode_iversion_need_inc(inode))
>  				return -EAGAIN;
>  		} else {
> -			if (inode_maybe_inc_iversion(inode, !!dirty))
> +			/*
> +			 * Don't force iversion increment for pure lazytime
> +			 * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
> +			 * dictate whether the increment is needed.
> +			 */
> +			if (inode_maybe_inc_iversion(inode,
> +						     dirty != I_DIRTY_TIME))
>  				dirty |= I_DIRTY_SYNC;
>  		}
>  	}
> 

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> base-commit: 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0
> -- 
> 2.51.2
> 
> 
