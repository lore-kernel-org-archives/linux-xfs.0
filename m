Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DBA2DC344
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 01:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766195646; cv=none; b=aJy+pUtROh06a/DnpRilPPan+eQftUw7Kg38Q6kvysuVZPEnqdwHjdTFZzAGs1u7eCxMruYz9CYjGxOLwU6Y0zqenyYz+TZOIu9k55o9f/MwKpz+TI9l8gMqe6dNaxtJZT6T19BCDHKUVzm8PKlTJe83fwiQ6gdHIQPLma0zheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766195646; c=relaxed/simple;
	bh=QM5wf2vu2iA4ADyhl4xFRp+C+BdPRiaDVE085gOYTek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CrmHOt7fpgccJmgS1Ctr/29R5bWOUXiVmQ9biCLo2RZNCsWTcLO73Oxkb9IZbQL8u+g1wnFwpY8q9TMaHd+3lU/s7JupS1wW0p0WadHyyw+vWuvzGelxofraGnVX19xvZZ9KlUZgrSiTjAAe3U9RT4pViWZ6Or7M8yB9hHLL0Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sP3rrgYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sP3rrgYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E3C4CEF1;
	Sat, 20 Dec 2025 01:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766195644;
	bh=QM5wf2vu2iA4ADyhl4xFRp+C+BdPRiaDVE085gOYTek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sP3rrgYuMd3KgAKgQ4jbkMHzNOaQTMMDERYcLevfn77l4W9J4Sxf8NVHgNWbnGlTL
	 Uc0yC0657+kgegegHze+a+BSKqO8Ns9z4Gv8Er+O7hOKh/uI30rBoj4SgqmXf67Vh3
	 C+1McuSLLty+qxfnDiFTfApeGJu5AUhTnVhBCqhvzMA/+qg4C9bq2EnvhqdebcixzJ
	 cobHroWTzjQ9ViTtEm2EMcScBJi5CfcoBtGc7KR/8DTeAiONp8t/Ou1Q7PYpiuULEr
	 t1HCtza5T4XDNBSYDGymFxY0GYMiIdiV2/X2EYUUlb+Uyuss9nRXs2hkl+0aR1zXii
	 hQMgNU3lyObUw==
Date: Fri, 19 Dec 2025 17:54:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v2 0/3] Enable cached zone report
Message-ID: <20251220015404.GB1390736@frogsfrogsfrogs>
References: <20251219093810.540437-1-dlemoal@kernel.org>
 <20251219235602.GG7725@frogsfrogsfrogs>
 <1f635a17-adf3-424f-b504-71a97562d226@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f635a17-adf3-424f-b504-71a97562d226@kernel.org>

On Sat, Dec 20, 2025 at 09:00:10AM +0900, Damien Le Moal wrote:
> On 12/20/25 08:56, Darrick J. Wong wrote:
> > On Fri, Dec 19, 2025 at 06:38:07PM +0900, Damien Le Moal wrote:
> >> Enable cached zone report to speed up mkfs and repair on a zoned block
> >> device (e.g. an SMR disk). Cached zone report support was introduced in
> >> the kernel with version 6.19-rc1.  This was co-developped with
> >> Christoph.
> > 
> > Just out of curiosity, do you see any xfsprogs build problems with
> > BLK_ZONE_COND_ACTIVE if the kernel headers are from 6.18?
> 
> Nope, I do not, at least not with my Fedora 6.17.12 headers (which do not have
> BLK_ZONE_COND_ACTIVE defined). Do you see any problem ?

I see it, but only if I ./tools/libxfs-apply the 6.19-rc libxfs/ changes
to the xfsprogs codebase first.  I came up with an ugly workaround:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=libxfs-6.19-sync&id=a448911c20ec0d3482361b2287266abd76d9f979

that sloppily #defines it if it doesn't exist.

> > 
> >> Darrick,
> >>
> >> It may be cleaner to have a common report zones helper instead of
> >> repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
> >> However, I am not sure where to place such helper. In libxfs/ or in
> >> libfrog/ ? Please advise.
> > 
> > libfrog/, please.
> 
> OK. Will add a helper there then. libfrog/zone.c is OK ?

Yep.

--D

> -- 
> Damien Le Moal
> Western Digital Research
