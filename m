Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BF3B7B83;
	Mon, 10 Aug 2026 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786356769; cv=none; b=r2r1GBGWbvzNSFtENvS+Gg0+zLik00585BpG8KRsSDzLXl0KjuA0ITK7Yo2rFun2QCvvIv9q4JCNkf0LmzQxMXXsq5MXAoiPYIxaMxse+pyziFp8sksHcB2UG7h3IjnMYPQy4oD6p/cFYxhVddrY42aKtYaJpVzaUrg5Y59g0eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786356769; c=relaxed/simple;
	bh=GrZ8dRaX4CGvnnPEv3Sqhk3CJxc8qPR0U1fcyWIFmSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPu/sRN/fLHwCz4Y+TFIYsRknEIYaB7KTP8z3MM9PmruNQGIKoEmcYCubQPwNMBw54j+yxmA6Cj9dlAkG6mumFD0soz365KXkvACbFwmlgfTCtiXa0rBFZ20dy4RRruSalIWdMh0IMW0fOjUyBM2NO/segZxO+bAU8pnIhv2jQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3ldmIoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3ldmIoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471EC1F000E9;
	Mon, 10 Aug 2026 10:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786356768;
	bh=KIkTN4JuGGt2D84FopRqoncsNtDcRU7XvHnOV8Ppu3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a3ldmIoKJ6aS5oeOn84dX5cdaAdUlxjON2Cz6km02r68v6qDkiC8xv0L0bfso8OUK
	 RyL6Ly09Kum8k5G294rHf+YoybJYRqyVkrF7hTg+DIKOEmWrnYOkMEU4GsSvI08DeI
	 vKlAxuLHt+1OZ1Dm4X1zSScvaN3vyy/Zo9+M/lShAWEfe4imjyqHLqVsyfRGFRL5sc
	 sZQTqxrdUpASVcG9+5fJu1UA8Mly6+XaM3Wq/JCc5RC/DhFJThjEkgmb88zSZsHZa6
	 g7c7egKZP582k71IyUvIJN+Zmmx7CJuqrY/wB9hQsQYVysrWY7poiYKBtqZ5AC7owl
	 wxwG0zCPtlSeA==
Date: Mon, 10 Aug 2026 12:12:42 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
Cc: hch@lst.de, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <anmhwrqO45H-oEl4@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-6-aalbersh@kernel.org>

On 2026-08-03 22:07:55, Andrey Albershteyn wrote:
> The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> systems. Open code folio mapping and flushing to copy all digests at
> once.
> 
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

I will drop this patch

-- 
- Andrey
