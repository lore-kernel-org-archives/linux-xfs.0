Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C420C3D0C18;
	Mon, 20 Jul 2026 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537874; cv=none; b=FHG993vyaYWnWrnyB6WEJfmNC+N2SbOQp2Wi2/BhMGo1mLQ+76nKbHM8YZicJRST7V83SVK/d9FrFG22ynOcsTLlDp2wDiwt+5J3TkTMGznode+2O1UCLOrfpppqqR1Wdrr+/h4y3b2qrF9HqK6WUMFo1BTKD8ZF4VRfpywt3Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537874; c=relaxed/simple;
	bh=6hNCSyRvRW7vxf3Tfr5jEs0DfRVy1KPfYJ0fsrRhKwc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=b60jB5hUkIIWfm8gt1TedTHyErqsfzJ2X+IsGJwZI836lU5Nftg0I3nPeISBH8WZbc90iPQ7nZmdYetrXRNyOmMUeoj1jagi/zQfr/DJZcaVJ57ld6u+YFEOotuO0m9xiGd6PxyE6mpyZLkDjp/cLYLNIamB6otHuaZQ0HRlEps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2vu5h8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2vu5h8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08031F00A3A;
	Mon, 20 Jul 2026 08:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784537873;
	bh=mW+OfYcdoxLnmCLkRwN5l38LwssYMHdPVP8MaxEsQx0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=d2vu5h8qEGTPem3LDvryHiDSccVIJkznZ6GmESw4907zhKFaLXP1+Y13DDk0C3x6c
	 TI45ktMZwtF+W0PMjFxJRoO0AJozb3h5CnsWRE2NWI06T11DwnMiwSjnrBWARXGiZt
	 vqsjhQJgQnZYPNGIA8ROhWdyOesVTCKSSrzls1qqi12McCeoHxUO2Wod2B1oKLhoyX
	 Bx2DmtahTagnQUoNNVKTR0YFjXTdDHijLOY9fQESEHcNWqyyaONGP21T382f1urTJD
	 uWCDIxcK471xBjeAxn7TIxVnjyx6jrVlmUwUxX8LReFGubN7fZg/FVdp51/9LFMUzi
	 QoVAFD4yhT8XA==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v3 1/2] xfs: LLM-inspired bug fixes, part 1
Message-Id: <178453787243.7428.11269855391412671050.b4-ty@b4>
Date: Mon, 20 Jul 2026 10:57:52 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 13 Jul 2026 23:03:57 -0700, Darrick J. Wong wrote:
> Someone gave me a pretty generous license for a large language model, so
> I pointed it at every single file under fs/xfs and told it to find bugs.
> After personally filtering out the errors and garbage, here are fixes
> for the real bugs that I think it found.
> 
> Most of these fixes target the online fsck code because I'm most
> familiar with it, but the LLM will read other parts of the xfs codebase
> so there are miscellaneous bug fixes.
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: don't replace the wrong part of the cow fork
      commit: a1caeeadbf57ff86dfc3454398c46de86056a74e
[2/8] xfs: make cow repair somewhat flaky when debugging knob enabled
      commit: bcb0621204e6999bb8f3a6c7deb5c6abfe0f197b
[3/8] xfs: move cow_replace_mapping to xfs_bmap_util.c
      commit: 60a1dde9d28948a88ed5a06cf0b6179b1d487f85
[4/8] xfs: don't wrap around quota ids in dqiterate
      commit: d766e4e5e85d829629c3ba503802fe1303d7b591
[5/8] xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
      commit: ee248157da501f0c02688fb64e5359f2832b0b01
[6/8] xfs: use the rt version of the cow staging checker
      commit: 881f2eb0fcdea2f46a50fa6a892fe9e3ccf19e01
[7/8] xfs: write the rg superblock when fixing it
      commit: 9af789fa274bc14b907f811f79fa988a6fc6d4e7
[8/8] xfs: grab rtrmap btree when checking rgsuper
      commit: ea6e2d9de25d2095845e0cdf2274e581fd40d636

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

