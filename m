Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9CD218589;
	Fri, 27 Jun 2025 07:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751008096; cv=none; b=Y6pp4zSb5L1wcApgqQtiNiDFVek7sefJeGHqXH23GlLpGqTo9ISDT89ajnAi7g+XhJfV57WN4Q1iMnB4a0GxlYLnKU6DYkoo1SDyqjn1gozblvjeByAfohS80wqaKypPHcW00sOZTIGEz6pCGNosGc2CrpjBy3LIwk7w5dVB6ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751008096; c=relaxed/simple;
	bh=Un8FcuM1U0z42K+EfQc8uy+JYqzt90xl0/US58u3YVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPC/5+PvxFa6XMqDspPhGutxI4YOKsWx/jAwZqd1K2TlW5xLcexIknAz3UMyQUNLVJJfFOhm3b+qb3TwyyC84Vbulm5kraif3CRoKy3tzkv/f2Yx7pGfF3w80k2OK136hDbKjONNlU/gm+74IQK4KG8d0zT3h6JbOuxIUYbl5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qC4lNqVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qC4lNqVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21127C4CEE3;
	Fri, 27 Jun 2025 07:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751008096;
	bh=Un8FcuM1U0z42K+EfQc8uy+JYqzt90xl0/US58u3YVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qC4lNqVhAyUtwSJ4iIYbtuihRNK98IFZayk00O8eywof4Q8x+8qvkrPKBe0a6J78T
	 GvBA3HYPzHQvyEMK8YzXSPTDGlh6T/F/FDPSd6aRq7MFl6nJWh5kZ/5P93zVeT4nHE
	 IMxV1su8+B5eh/8M+wSfl/hqoSHb6hvtwi8M6MopK3aimNCQu2B77SMTIl9+zDFZtJ
	 2YF5w/RgT/s4GyQ+rrMk0vtBQuGM75vFT0lqazQUqyEF9pKlP3FsYezV9aka0i1MUm
	 lZ44AsiSgHAKhlfZy37oVBZtD41j8EAmPbl0As9nDPKeDiGb+ggrAUVS0og1mx5re+
	 I0rbvDRFhg/Lg==
Date: Fri, 27 Jun 2025 09:08:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask
Message-ID: <smvidb4nwokhjnh4g5qve3g4cu52nhrh5nslf56bjs6rp7qtug@qkuwln2srtvj>
References: <RRIn7phtOPENw-VOR38lq9hw0cyJbioBOq7lxVO-pHAFmZ2BzH88tnc7V3pUxiT0xvHGo7SY4IJSk7FC31MNbw==@protonmail.internalid>
 <20250627053344.245197-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627053344.245197-1-youling.tang@linux.dev>

On Fri, Jun 27, 2025 at 01:33:44PM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Add FALLOC_FL_ALLOCATE_RANGE to the set of supported fallocate flags in
> XFS_FALLOC_FL_SUPPORTED. This change improves code clarity and maintains
> by explicitly showing this flag in the supported flags mask.
> 
> Note that since FALLOC_FL_ALLOCATE_RANGE is defined as 0x00, this addition
> has no functional modifications.
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> ---
>  fs/xfs/xfs_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 48254a72071b..d7f6b078d413 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1335,7 +1335,8 @@ xfs_falloc_allocate_range(
>  }
> 
>  #define	XFS_FALLOC_FL_SUPPORTED						\
> -		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
> +		(FALLOC_FL_KEEP_SIZE |					\
> +		 FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_PUNCH_HOLE |	\
>  		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
>  		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)

This sounds reasonable. Could you please add it as the first flag to
keep "the right order"?

Other than this nitpick, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --
> 2.34.1
> 
> 
