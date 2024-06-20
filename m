Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC01622EED;
	Thu, 20 Jun 2024 04:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718857450; cv=none; b=WTrAGSb5043cj75pz3zNytRS9UgL0+Xflv74kkPKsV4eXxzdYgosGASUZsVMFIrvRm/IgyXMh3/KKqISi4fJC5uE9PKU6/dH5eQDM94kK1J3ktWQVcJ+8WXy2AB+aYWiMKCvS514QDpMMeoKLtMBNnO+Y5tS0UQFP+kZ/GI1oqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718857450; c=relaxed/simple;
	bh=f2DFG6vZJ60Ax7go0aaPBpe1Khb11/hAyDxSM/4OXNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXMk1UFPJoZ2pU2oXe8V/UB0/SxOsX2TFUtJyqAMdnA2I+ssz9HIWTjFPH7M4bPlol2r46+ZNutBlOctjayWiW8nKW+ubcwd7Ghrc6eObi0BVMXMzdFugsVzHTGq++t9m5KLt2ZbDPqOAKA5Cg957KI8F79LS2omTqlILr1FfyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d1hOptpS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d1hOptpS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BxwRK6GeIQ3hYlngKOYsJinxxdBWzFWXM0LA77NIGjE=; b=d1hOptpSckiM61rrpP6Ks92nWb
	UKiBHPeBk0QavI6BazJU+8isFybm4iQVkceYZ8PR8482kib9MkmnT8fNR3nYEGeXD6YM5de8kbr1J
	tkxpMtOS53PGoVCJv/xdatORt33LWP2yTaUil5tE7Gc+e4zJin8SL0l3fMsM9p6v8eKkC2Oib6/jl
	hAOOw1PbA060Ka8CCtfbpuPeR+NjLr0iuKhZgK2xQVrYM0Bbo6FMInglcMYVw7IGcrTF0FTGDhyJu
	+Rt0OO7DS3Rjt8NwGS8ZxO73PnrZYhKwdjIUoVo/LGfghtsJpxduuU7+aEQ6+g3i0kOXitcXRos8e
	0tcFrj3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sK9LD-00000003ZPk-11nv;
	Thu, 20 Jun 2024 04:24:07 +0000
Date: Wed, 19 Jun 2024 21:24:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test scaling of the mkfs concurrency options
Message-ID: <ZnOu537W5S9Ic6dK@infradead.org>
References: <171867144916.793370.13284581064185044269.stgit@frogsfrogsfrogs>
 <171867144932.793370.9007901197841846249.stgit@frogsfrogsfrogs>
 <ZnJ5mfiqfnur5lFc@infradead.org>
 <20240619162808.GL103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619162808.GL103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 19, 2024 at 09:28:08AM -0700, Darrick J. Wong wrote:
> Weird failure case?  If we don't have an output file to link, fstests
> spits out:
> 
> 1842.lba268433408: could not setup output file

Not pretty, but not as weird as I expected it from a quick glance.

