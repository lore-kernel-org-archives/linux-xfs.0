Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632954;
	b=YOPjEwMPUaqkvSzBUaaE4JHspKBChtbeSLDmq/B4LId6HbwpGWk6mnTvlIK6y5ezqvrw
	 jC/m4SdZlobayrh0VMh0jU20AC2vdTj3ODvXl2QdEEvWaYbafdvry7QgdjogVJpEhmbmg
	 kwIgQRD0FGBCELgWgRfnzskzRaCW6h8cwGmY++Hdjf3i1iLlNSb6GTVWV1A8NW0NUz8dF
	 lSA4ToygR3h8ygVk1cr+rMvZxZR88Y/rd0WVCuzr4Q1oVHZR46Ds0fNUUVD0oyFUtiAOA
	 4KAC0aBSUn8xx5vgkfzy8iFbN8RQSvmJnY2oYLu1duIfvGzZuIMXaVzuemfwBUVTK2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632954;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f5654+7smVr1CQ7aQob1YSWPvrXVlsZxaqT0g4gybBw=;
	b=ST4acMT2ka8omrOMB+2rdKcZ+rF0lG7SVGB5SIHuBmGp+4wSbARznmErM4scAtwTwJOE
	 MwH+LU6dFj1ZZ6pPxaTBgBNBcyTAKPRLviAPcMhR49HoQyT/MZexASVPDKqEF0HaRMATK
	 DE2eyZ/wRCVR1Km1VfMnVHcwnOBzivZvtAjvlQu/c/kujZT4G4iGjJOPBK2ebKYcVIqVb
	 kKX42MlCnMoCzxa2jKg27ULO5V8q13/FDPnm5mhorFGzpVF/DvL/qh0ZEE7rav9r0WjfJ
	 hR7xsAE6xcmpv1HlJttATMfjGrKChqJbzWtfIDoUmR3hoPEg+xTzeVAHmy+jz+R+oig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e6Wm1xtR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E10A6081CEF;
	Mon,  2 Nov 2026 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e6Wm1xtR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1501F00AD9;
	Mon,  2 Nov 2026 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632954;
	bh=f5654+7smVr1CQ7aQob1YSWPvrXVlsZxaqT0g4gybBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e6Wm1xtRAG1e5mMhVVIAzVQ4WKf8zJG2askyQigi8iO9flMS26oahDyQgxR/OzRGp
	 BB0E4odaNdF4K+4OagVF4vJtGby8De4NdtycOwEERIkErgd7q+bB579XXl4Gmbe2Ya
	 LekkuZ+rw+DbPKsY50/w4h8s1COCdDDVdQuGO9rLLjb/CPiNhcksjrU9vjMG3oW9s/
	 Y6X3uBWQF71cVoJV5pXEtJ/O4PpgAD2NbV8j/tVb13S1sbg5bMMWOKgFGyjnIlwEVX
	 KA2PABVr3pymM0ugB6v03DEGY1rBRTFLvfxN0TcYjICf4UBPZCzeObX1EeSwzIYIza
	 DiLmLoFw0BAbQ==
Date: Mon, 2 Nov 2026 16:22:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Viktor Malik <vmalik@redhat.com>, 
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, Bill O'Donnell <billodo@sgi.com>, 
	David Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix temporary cursor leak in btree shift corruption
 paths
Message-ID: <auiqHYgyi6_7-EOa@nidhogg.toxiclabs.cc>
References: <20261102150146.19777-1-jianyungao89@gmail.com>
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
In-Reply-To: <20261102150146.19777-1-jianyungao89@gmail.com>

On Mon, Nov 02, 2026 at 11:01:41PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
> an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
> successfully allocated a temporary cursor, the error path jumps to
> error0 which returns without freeing tcur.  This leaks the cursor
> memory, the xfs_group reference, and the per-level buffer references
> held by the duplicated cursor.  Jump to error1 instead, which calls
> xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
> resources.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Yup, that's leaking the duplicated cursor

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_btree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 7effebe297ea..d706f59b0301 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2567,7 +2567,7 @@ xfs_btree_lshift(
>  		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
>  			xfs_btree_mark_sick(cur);
>  			error = -EFSCORRUPTED;
> -			goto error0;
> +			goto error1;
>  		}
>  
>  		error = xfs_btree_decrement(tcur, level, &i);
> @@ -2737,7 +2737,7 @@ xfs_btree_rshift(
>  	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
>  		xfs_btree_mark_sick(cur);
>  		error = -EFSCORRUPTED;
> -		goto error0;
> +		goto error1;
>  	}
>  
>  	error = xfs_btree_increment(tcur, level, &i);
> -- 
> 2.34.1
> 
