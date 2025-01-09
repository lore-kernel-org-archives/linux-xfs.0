Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2B1EBA19;
	Thu,  9 Jan 2025 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736412588; cv=none; b=q2HtCs0hP0VTzwxGO6C6ANvpQ9Cjj0AiLpSZK07VtO41eV/MtwCo+qtmIK4TejsbZnTbDSbp/kWBzrggjDJLvmG+0oetAVJsTG9qrTA3vA765sp8EVnwH6c1i/F6GtjVhhS006FNESqfsHAVoyzRc9nTzm6/U7KGCFQ3R1bq+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736412588; c=relaxed/simple;
	bh=LUMEQs7/oj8Rerkd59KYQ/bnSrqBgW2zdpEAd2kdomU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mn4R0/zG9TjBFhe1jUxRnnh2ASCynXYIlTXJrneLM21SUDrgdWzEujcvLSH3NnCRZ+PrsnftoRkSkwsZ/F2KDyaM4hn1hbsKsc+ZUAz6PmHkzi8+9duizy9ozFmHmOyYG9y5x6rvaQd5Eus5zXJ8gPdAB5LSw8qK4XN742GLUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kF3DRMo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kF3DRMo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D2C4CED2;
	Thu,  9 Jan 2025 08:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736412588;
	bh=LUMEQs7/oj8Rerkd59KYQ/bnSrqBgW2zdpEAd2kdomU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kF3DRMo31jcM+XtiN+aNs1UkHRX97hWl+Wq3aNXeY33MBjooNR6hx///t4gQT60UB
	 f0umTag5Tn/fY1UhoFaeQbq3q70KTr0Mg5bxs7iDTRP46vtCN22Gcq0tECApX2G5mb
	 JnJaj+0ufdbiibh+9vVzJH4KjRJtsG5Mu3NeDxKlnbZ1XCDADGtB2HCsTPJKH9+Vqt
	 63ZiDwKtK/bKZ88cy1QIeYs3KKrOKLbu9FBbwg2eQ2c4t2gRMA24DbNi+ymS10wrPw
	 u5+etT+xDrCStOAfEN1R9j06B56c8I6jipGzvtarjwRe7DdqkgAw81GgNHz2ViZJo3
	 mm/W9DU5WWhJw==
Date: Thu, 9 Jan 2025 09:49:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	Victor Skvortsov <victor.skvortsov@amd.com>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, "Darrick J. Wong" <djwong@kernel.org>, 
	Chandan Babu R <chandanbabu@kernel.org>, Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 2/3] xfs/libxfs: replace kmalloc() and memcpy() with
 kmemdup()
Message-ID: <mcf4scwistourkahjcnqg5p3c6hagowihuuawah4yo5mwp23t7@fe2kzzucxdgw>
References: <20241217225811.2437150-2-mtodorovac69@gmail.com>
 <20241217225811.2437150-4-mtodorovac69@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241217225811.2437150-4-mtodorovac69@gmail.com>

Hi Mirsad.

Did you send only this patch, or did I miss patch 1 and 3 of the series? I can't
find them anywhere.

Carlos

On Tue, Dec 17, 2024 at 11:58:12PM +0100, Mirsad Todorovac wrote:
> The source static analysis tool gave the following advice:
> 
> ./fs/xfs/libxfs/xfs_dir2.c:382:15-22: WARNING opportunity for kmemdup
> 
>  → 382         args->value = kmalloc(len,
>    383                          GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
>    384         if (!args->value)
>    385                 return -ENOMEM;
>    386
>  → 387         memcpy(args->value, name, len);
>    388         args->valuelen = len;
>    389         return -EEXIST;
> 
> Replacing kmalloc() + memcpy() with kmemdump() doesn't change semantics.
> Original code works without fault, so this is not a bug fix but proposed improvement.
> 
> Link: https://lwn.net/Articles/198928/
> Fixes: 94a69db2367ef ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> Fixes: 384f3ced07efd ("[XFS] Return case-insensitive match for dentry cache")
> Fixes: 2451337dd0439 ("xfs: global error sign conversion")
> Cc: Carlos Maiolino <cem@kernel.org>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Chandan Babu R <chandanbabu@kernel.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
> ---
>  v1:
> 	initial version.
> 
>  fs/xfs/libxfs/xfs_dir2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 202468223bf9..24251e42bdeb 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>  		return -EEXIST;
>  
> -	args->value = kmalloc(len,
> +	args->value = kmemdup(name, len,
>  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
>  	if (!args->value)
>  		return -ENOMEM;
>  
> -	memcpy(args->value, name, len);
>  	args->valuelen = len;
>  	return -EEXIST;
>  }
> -- 
> 2.43.0
> 
> 
