Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AF2280A5B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 09:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770714083; cv=none; b=GJmHQ2CVQqMXMNsKux/PYm4oJ90Q/TstHIiCLXK54i1MAl39p3joyr0+VQtjwfApbSUqLKVzKY/7bwQ1Y62NkPOUapmOCKtNLyeSxLPRSctT4JZRE0Yrd2ZJTbV/dBNbF937TvtdYrFXG0HKMrd8iQCxL2pn8lKCb7fD0tGCwYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770714083; c=relaxed/simple;
	bh=yujpcq4LQyHA6E4lRuoyMxVf0lHp7bZ9F1gG/Zay4rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=da5Bk/wTdOtEyE46ucQbAozEtv5BHK1Tq1/tG1Y+QfkRe84bMVkyJlPkr9OU/McGlw62Sy0SkpsFxJihQq128/b7/zR8WkYOTB82EHK3ahaak5TOStPYxjQ58Iux96Ij9luJFWG1NSM1SAisv6AKwOfjgXsbQps7QZoL86jYEsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivZQBC+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivZQBC+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2F4C19424;
	Tue, 10 Feb 2026 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770714083;
	bh=yujpcq4LQyHA6E4lRuoyMxVf0lHp7bZ9F1gG/Zay4rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivZQBC+6EqYrRyvIUoscChVanjj13UYnBMZ7aiqEPF1tuoLYFNwv5hRrdc5LGZH2x
	 E/jzq4lIRfv7YXFpiuWc1BDTPZ6THgRJjpTgcCLCvM6Wu3M4bA4pwFWU8LCZ8bE0Uc
	 CO1r0thYre9nGxD/mgfk0KMlwMUkx0xW6k7+5bTsD8jjmpvFCDNGgvjBw342MdsRc8
	 HMkYCreGS15OcgibReuymgiSRGu4eIgt7DqZvk3HWD4j/hTuFzPXkdtrqx//6iftjl
	 afUTSsvzjHwxT97Aj4MWXI9VWk3Vo3dcJUeDslwMyNwW6Lr9H1VI5PKAvptX/QUiZz
	 cL/h7KM16AOrA==
Date: Tue, 10 Feb 2026 10:01:17 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v1 0/2]  Misc refactoring in XFS
Message-ID: <aYrztKTqOo6SL-Cm@nidhogg.toxiclabs.cc>
References: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>

On Fri, Feb 06, 2026 at 09:07:59PM +0530, Nirjhar Roy (IBM) wrote:
> This patchset contains 2 refactorings. Details are in the patches.
> Please note that the RB for patch 1 was given in [1].
> 
> [1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/
> 
> Nirjhar Roy (IBM) (2):
>   xfs: Refactoring the nagcount and delta calculation
>   xfs: Use rtg_group() wrapper in xfs_zone_gc.c

I can only see a single patch in this series, same in lore.kernel. I'm
assuming you made some mistake when sending it.

> 
>  fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  3 +++
>  fs/xfs/xfs_fsops.c     | 17 ++---------------
>  fs/xfs/xfs_zone_gc.c   |  4 ++--
>  4 files changed, 35 insertions(+), 17 deletions(-)
> 
> -- 
> 2.43.5
> 
