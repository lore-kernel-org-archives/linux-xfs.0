Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3772726FDAC;
	Tue,  1 Jul 2025 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381628; cv=none; b=o5Xm7QNovY3HkfrvL9u/Q4yA7ZtbYX7OwesVrShs09mae+04zocjRPVl4doWxQW3xP7r6ADxJpTahnpjB3w4M1/ja/eln+5xtW09zZAveX6A2DzGuqfci78p+MWJHJyfmFkExYRlmmsTlDJMu2UqcykGWXdE99KmfTV7yzPnHW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381628; c=relaxed/simple;
	bh=8+Wv0OlytKZIaT42+LGdm7t+KCuQk6vUKLUTvIlXl9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tkxn4xg15u5izrcZCvC/3YGs51aWi3ONtR6qURNw/RO36E97I9gr9wdnu9YZWL49aNUl2Gj39w63HCDW5MQ2YHmdq+iXSc32r2p70jPmnuw599G3sIi7+GRvtNwRGUPjMhFoqDnRR/zAriNFXMUIextqqgxcCXt70UlO+Fv92YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pM+J/P2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pM+J/P2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9637BC4CEEB;
	Tue,  1 Jul 2025 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751381627;
	bh=8+Wv0OlytKZIaT42+LGdm7t+KCuQk6vUKLUTvIlXl9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pM+J/P2obW+0ZPc8hQTckt/NwIfT9aKfSAWixJVSseNuAycRxhqRmIw03BTm8Fa+l
	 uiu/DrXT3x5xeRSLvzx2z/1fKcWBS1CG1YLyE4SiFonAvgSwM9TtIPl9x2R1kk1Vxr
	 6Jc0coJEQtWzNCqk9bIcJxjpPSpz1cjS1VLnvahUjPM4hAMy2iQixNAfjTFRDJkMxp
	 ZNB5PQi30aDp6hIlOT9KG6ZuXZ0yRPTZKrTaxf5YYSIsQxIDETVsx7xOgiFD/h5Tg2
	 OVlNEysBlIIonXWXuGNKr8Cq4eD08+1Teo/WI4qmS+pFLcPd4zWtNynsMSsmGrhnBZ
	 uMr55K83KzXWw==
Date: Tue, 1 Jul 2025 07:53:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 0/6] xfs: cleanup key comparing routines
Message-ID: <20250701145347.GC10009@frogsfrogsfrogs>
References: <20250612102455.63024-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612102455.63024-1-pchelkin@ispras.ru>

On Thu, Jun 12, 2025 at 01:24:44PM +0300, Fedor Pchelkin wrote:
> Key comparing routines are currently opencoded with extra casts and
> subtractions which is error prone and can be replaced with a neat
> cmp_int() helper which is now in a generic header file.
> 
> Started from:
> https://lore.kernel.org/linux-xfs/20250426134232.128864-1-pchelkin@ispras.ru/T/#u
> 
> Thanks Darrick for suggestion!

For patches 1-5,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Fedor Pchelkin (6):
>   xfs: rename diff_two_keys routines
>   xfs: rename key_diff routines
>   xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
>   xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
>   xfs: use a proper variable name and type for storing a comparison
>     result
>   xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()
> 
>  fs/xfs/libxfs/xfs_alloc_btree.c      | 52 +++++++++------------
>  fs/xfs/libxfs/xfs_bmap_btree.c       | 32 +++++--------
>  fs/xfs/libxfs/xfs_btree.c            | 31 ++++++-------
>  fs/xfs/libxfs/xfs_btree.h            | 41 +++++++++--------
>  fs/xfs/libxfs/xfs_ialloc_btree.c     | 24 +++++-----
>  fs/xfs/libxfs/xfs_refcount_btree.c   | 18 ++++----
>  fs/xfs/libxfs/xfs_rmap_btree.c       | 67 ++++++++++------------------
>  fs/xfs/libxfs/xfs_rtrefcount_btree.c | 18 ++++----
>  fs/xfs/libxfs/xfs_rtrmap_btree.c     | 67 ++++++++++------------------
>  fs/xfs/scrub/rcbag_btree.c           | 38 +++++-----------
>  10 files changed, 156 insertions(+), 232 deletions(-)
> 
> -- 
> 2.49.0
> 
> 
