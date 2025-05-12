Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF80279330
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747049874; cv=none; b=QESp3st/W1jqiltgVzgCAGoAv+aAKZiz784DiI1t+z+VUSf39wbHHxtCyZSc9phV48rDRiaOfazohQ/9bpj5W0voiGukqa6skPIelDLjA3pZu/MjBMD0hZhWPImJvzC91sXJ61ciI9tDb4Uxmzxcww+OOWAFaRAcZzBbiDI9pRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747049874; c=relaxed/simple;
	bh=H+k/iRfVrrllINq5cXYjkHCg0H2bIP7UEByuL3JbtO4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXVQch+jeSUmNVr1CYzQ+G9VYBs9Roq+v5AsqzkyNqgvgpf8TuYAVNBRDKr6FQoUAWL2lVH8LcuYxtAbDKvrSUivoifnMZ9DSljkUW33Xnc/j4Sr0KPlPInt4KnYsEAgApFeifyzzChwhoRxFIVZheDO4XNV4D1s+CxVIm+vyqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhOSyije; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhOSyije"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87900C4CEED
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747049874;
	bh=H+k/iRfVrrllINq5cXYjkHCg0H2bIP7UEByuL3JbtO4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=mhOSyije4q6wO7WxONsl1p153nzAG913dtnL5FM0hg3s10yQ64bxIvDP703Cue1zR
	 ba2Mpx4R0SrHReTNQajTLUgHSzHai24VXjt8nyxnynIXr4cO+O7yf1V4NQwKz9Eu9D
	 KTWqaAH/erpFKLtLoQsjEQ0oT4/V1btOhofz+wRO/Wu0nZ2HvPatHWAD/EgjQ0iyma
	 GgpW5i5eWSgXTOrkWz/BBejlBQUjcNXg3raFm6LMlXGI/ZXJHfOgUTCGa6J4HuQyDA
	 fb0gTygdE/aPz4bg1b64k1hGQRPl82pr/X6cPcbsZ0BgkaeG0mnMSJJRukS0xyEscf
	 BGwGy7mJlBbZg==
Date: Mon, 12 May 2025 13:37:49 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 0/2] Fix a couple comments
Message-ID: <w44fbfuzzofpm575tfdyv4z7jnn62kvtcioy2k3lr4scw5xyi5@oyfv45vmiwah>
References: <O2n8IuL9MZ_hcgsWRW9TFpQ9a7D3-qMevZdysgrNSRsX7WAzpWSdwhE3xfPcl3s7oVGkcplSPPImo2jPO0OYgQ==@protonmail.internalid>
 <20250512113031.658062-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512113031.658062-1-cem@kernel.org>

On Mon, May 12, 2025 at 01:30:21PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 

Please ignore this patch, git-send-email crashed on the middle and didn't send
everything, I'll submit it again.

Sorry the noise.

> Fix a couple comments in xfs ail code
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Carlos Maiolino (2):
>   xfs: Fix a comment on xfs_ail_delete
>   xfs: Fix comment on xfs_trans_ail_update_bulk()
> 
>  fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> --
> 2.49.0
> 
> 
