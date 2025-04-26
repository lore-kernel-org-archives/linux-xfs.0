Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A10253F3D;
	Sat, 26 Apr 2025 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745679842; cv=none; b=YbcbyH0C/coxk1+LBUYStpQNT6Vtfeh1tBkSyVoNiDGhFuhHd/E6R0quc0JKJhgul2cl4c5+mYQPiAYjBM231ODbvU3P4edkgXLV+TTuAOvGgZ7CWk6Anlk0YBPiFMe84YoaDfde954I1t3O4DQJpYReEl8elCIS/wiTnb3Mm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745679842; c=relaxed/simple;
	bh=EsdfWq/03VH/7vUnJi9OSrJooU9ae5/pyus4e935ACw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLtIIB5175AD97/AmFXw7Gl+y4KEfOnf6PAl678eFidq+o7M8wjFCpoj7VBMW6rHrC7J7XL8jikJYB2bCaLtTdEVyT1ImICzFVaSkwWXxUrQ+556qQV16jdmiKqcof/eGeyHCwy7/b1DBZ/xSppwCFd1QJE/T71+c72hIpcyB+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3EuQCHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3EuQCHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88541C4CEE2;
	Sat, 26 Apr 2025 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745679840;
	bh=EsdfWq/03VH/7vUnJi9OSrJooU9ae5/pyus4e935ACw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q3EuQCHMRYSPpqegHCYU2IFPfFXdS6YSAHrM1gpGedw9q8zDrIge4QyAiScxBkko6
	 pP6Ba8SvJAigshqWctLxy49l/mYDV7A1zzC/7Ek5Dxpb1hBRGUg6wrMIH2axI6r7pM
	 /JMy8Go8XCRn8Il297fPsNJlf5C9Juo+vewGDjSTbFHTpHJRKoNBwgwhXtrsjR7Wqu
	 tAdP1ftPicSjrl7OAMi22fbOJJjvM08Cef5VL32tXZp9qiqJ0PODyiUSlkx2EILF1V
	 +MdEFdsyjGFTYBW9GX5/xxuyPzrwk1IK9TjtpXQG3FInkdzbRrJ7IFiunIdaX6ZaJB
	 oMrf5pZatoUbA==
Date: Sat, 26 Apr 2025 08:03:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Carlos Maiolino <cem@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	Alexey Nepomnyashih <sdl@nppct.ru>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix diff_two_keys calculation for cnt btree
Message-ID: <20250426150359.GQ25675@frogsfrogsfrogs>
References: <20250426134232.128864-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426134232.128864-1-pchelkin@ispras.ru>

On Sat, Apr 26, 2025 at 04:42:31PM +0300, Fedor Pchelkin wrote:
> Currently the difference is computed on 32-bit unsigned values although
> eventually it is stored in a variable of int64_t type. This gives awkward
> results, e.g. when the diff _should_ be negative, it is represented as
> some large positive int64_t value.
> 
> Perform the calculations directly in int64_t as all other diff_two_keys
> routines actually do.
> 
> Found by Linux Verification Center (linuxtesting.org) with Svace static
> analysis tool.
> 
> Fixes: 08438b1e386b ("xfs: plumb in needed functions for range querying of the freespace btrees")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a4ac37ba5d51..b3c54ae90e25 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -238,13 +238,13 @@ xfs_cntbt_diff_two_keys(
>  	ASSERT(!mask || (mask->alloc.ar_blockcount &&
>  			 mask->alloc.ar_startblock));
>  
> -	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
> -		be32_to_cpu(k2->alloc.ar_blockcount);
> +	diff = (int64_t)be32_to_cpu(k1->alloc.ar_blockcount) -
> +			be32_to_cpu(k2->alloc.ar_blockcount);

Perhaps it's time to hoist cmp_int to include/ and refactor all these
things to use it?

#define cmp_int(l, r)          ((l > r) - (l < r))

--D

>  	if (diff)
>  		return diff;
>  
> -	return  be32_to_cpu(k1->alloc.ar_startblock) -
> -		be32_to_cpu(k2->alloc.ar_startblock);
> +	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
> +			be32_to_cpu(k2->alloc.ar_startblock);
>  }
>  
>  static xfs_failaddr_t
> -- 
> 2.49.0
> 
> 
