Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1077A724;
	Thu, 18 Jul 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721316466; cv=none; b=XsMNhf9kZUWeOeBR7oDLcRaF9XvoZI7tFZeASW9vbOGfm+fMjczbrTk7irExopaYX3EdYVRnqGWWtllb4MpWWQDlrP8yb2qU2zehYWQrdn6NK0iNnF3aUh5kAA5kL3EyNGC1iPoWx11c+ueEUEQegiu3Cvk+rLA9lcQrN7ThaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721316466; c=relaxed/simple;
	bh=MNuv/64sX1eBSSghfyrFppwQrHkrxDLg53KR0a/wozM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDLFNx4aUwP+bdA1P69uQxaGHltu969B2pDSiB2ZtKyEb/xQGD+mIPd7+neGJNIBSTdauyTbg1vpaeVZ+mG26k1PeepvnXTPhiguy6wbrLVDyFOzr2VgKfWQLhC6CgHmNO7jGmsMrAK0vGp3zYVYbT52BjwZTjSceTULCsOolC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcUF2b+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcUF2b+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B984DC116B1;
	Thu, 18 Jul 2024 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721316465;
	bh=MNuv/64sX1eBSSghfyrFppwQrHkrxDLg53KR0a/wozM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WcUF2b+y/SctQbri2BuPEHRPC9C7LIdukH21x2N5n4pzaKtKi5UIMgjQu1OO6CEzk
	 fxrdBajZGpFNyKH+YEOOA6yZu6GN1FoxOTB/JFhSm5NshkqwSbHMs0pvHtWjbV7OTP
	 i9gk6XsMYL7Sx4EYJ50GxfyDeGLqhLw61Fiw5ccg8hwPpruYfuknHmp34NzY32SomM
	 /gnvTffz7kofZMOIBGuhfWCF0VCyYIB3lWQkQkVXadafRhzqlePkvfGAbn7nT8GPMm
	 /MJhZ5GOuKd47VurVMU8iqlH89FSJjIA8Z/DDQpqiuoaoDMQj+BDczarPuprFIP4U1
	 lKOnTkD62EIdQ==
Date: Thu, 18 Jul 2024 08:27:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert comma to semicolon
Message-ID: <20240718152745.GK612460@frogsfrogsfrogs>
References: <20240716080112.969170-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716080112.969170-1-nichen@iscas.ac.cn>

On Tue, Jul 16, 2024 at 04:01:12PM +0800, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Fixes: 178b48d588ea ("xfs: remove the for_each_xbitmap_ helpers")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/agheader_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 0dbc484b182f..2f98d90d7fd6 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -696,7 +696,7 @@ xrep_agfl_init_header(
>  	 * step.
>  	 */
>  	xagb_bitmap_init(&af.used_extents);
> -	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
> +	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
>  	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
>  	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
>  	if (error)
> -- 
> 2.25.1
> 
> 
