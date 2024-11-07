Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745D9212F11;
	Thu,  7 Nov 2024 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731009940; cv=none; b=ax+T2np4nQthQaq5kZ8NZY0Yb9q70nSTWfrK7v4vEfCG87l662KfkxXesw9k4PWC3oLesTCmr3UqXw+hpYLcHBkOXMKBkrZpWhVo3oDgCWB9m2ITQiqQzjtlT/3soZ+oRbeu13uPtFWWKGOtX3MhA0RE0wC0OhLzRiO9kvhXxbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731009940; c=relaxed/simple;
	bh=VtSPBjwtynb2zR2TTYY3hpwx22AfKfDflkRmWvlYwao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bo9Xvg/OnnN/jlTpCelxinE7nr/bcC5n2SvWdM4Ioi9FUzKsQM99CdFv8bwppZm8uLtQG6jP1XC1a/UgXD90sPWVEHdpwdN2zSc5J9lVLI9ojKRLr/x60DBY9Q6xgPSJs9AW64ReCwV8TcVzBUofxckBxQ5owdaT+VbrNgnp0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rugiL/Lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rugiL/Lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA263C4CECC;
	Thu,  7 Nov 2024 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731009940;
	bh=VtSPBjwtynb2zR2TTYY3hpwx22AfKfDflkRmWvlYwao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rugiL/LoadubHHW6EP7kEybpnMC4bPh8furIhW2AilJXMGmJV9uR7+NSmIb6AKHEb
	 ehtzMNAi6zkZDJw+Uoe4Dw8za7NUgNUSuSRhpUc5r70CRTy1V3Vu29gM9hejb0bjHs
	 vAtaD6x0PZkK+Pf+7Ju5PjReMKfurF6I/co/FukdgO8FI13DQV/r8SfXSyb6UCvfXs
	 H+spD+/Q5oEnre6Ce6zy1UrMbcgf1DzZ3Wg71WhC8W4plSNCC57h2nBqXdcJr89xw/
	 uBmYdSzMf8TeqlI7Grt5z6U/3KQjw7y/E/mY4tgDi33DGgzSDBS5QjYa//09WvCFfG
	 vqcORku10/p7Q==
Date: Thu, 7 Nov 2024 12:05:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: dchinner@redhat.com, cem@kernel.org, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH v2] xfs: check the remaining length of extent after
 roundup
Message-ID: <20241107200539.GR2386201@frogsfrogsfrogs>
References: <20241107084044.182463-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107084044.182463-1-alexjlzheng@tencent.com>

On Thu, Nov 07, 2024 at 04:40:44PM +0800, Jinliang Zheng wrote:
> In xfs_alloc_compute_diff(), ensure that the remaining length of extent
> still meets the wantlen requirements after newbno1 is rounded.

What problem are you observing?

--D

> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
> Changelog:
> 
> V2: Fix the error logic
> 
> V1: https://lore.kernel.org/linux-xfs/20241107070300.13535-1-alexjlzheng@tencent.com/#R
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 22bdbb3e9980..1d4cc75b7318 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -393,7 +393,8 @@ xfs_alloc_compute_diff(
>  	 * grows in the short term.
>  	 */
>  	if (freebno >= wantbno || (userdata && freeend < wantend)) {
> -		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
> +		newbno1 = roundup(freebno, alignment);
> +		if (newbno1 >= freeend || newbno1 > freeend - wantlen)
>  			newbno1 = NULLAGBLOCK;
>  	} else if (freeend >= wantend && alignment > 1) {
>  		newbno1 = roundup(wantbno, alignment);
> @@ -414,6 +415,8 @@ xfs_alloc_compute_diff(
>  				newbno1 = newbno2;
>  		} else if (newbno2 != NULLAGBLOCK)
>  			newbno1 = newbno2;
> +		if (newbno1 > freeend - wantlen)
> +			newbno1 = NULLAGBLOCK;
>  	} else if (freeend >= wantend) {
>  		newbno1 = wantbno;
>  	} else if (alignment > 1) {
> -- 
> 2.41.1
> 
> 
