Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD67128374
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432607; cv=none; b=jDK0ZxB1YMglfxijaTVEfTzWO4hVSKogpOoTPFZxBBzd1ZtrShp07LZA/hRvOHG7qJBlonxoqxtWCwdPzLQR879EPEshU1QqUD+iwtNCveKl8d8SdfTZvcom6dOCxiNtvXh+s/8P71TXdSVfyo9UJHTE8A0iYWEvr76afyyYTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432607; c=relaxed/simple;
	bh=ybfiCgG9WK4zfHi9BLl5dXDfin3FMKF81AZlWRq3DRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9gIU96iOd3iryqzV04S7aLi/OW+vTBG3WLOrKom/1ZvSzDYQNp4JN/Fx37D2OSf/PnXWneYDEFIpxNZCaNeFdAAgSjnrtaLEduxNJUU80w8iD2C3iXufw74EGsNPeioQhy0xxcGsc4ciz9VGOhjNg0z3B1G1ofHNdDjoVrMIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FNhK/hwV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FNhK/hwV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0I/V3BKw0oceJ2uj//XWF4/VrK+GUjbizUz9AoCjRZw=; b=FNhK/hwVFDiy/MZaeZuUS7Ng/W
	QTFGPihC/mn3Qsd0DJ+q6nZ0jzV1h73yo1RSi1BJp5F1DBhNPRIUNOXvDbkmVnK9S8Hr6nxdIrHa8
	yS2B2lODk7S3z5BVNuZK4QHHLeweyPpyscqbkq1sRu1jbyzvRtldwY5qmcCQmQWdHfoxVrcyQY9sJ
	32IiVWC46lEvsBE4X48H5YoeyOszUAKrASviPPB1ScV4bIKHXMMf784jnLOhRnPKpM4YrKi7Hb3/9
	8c46FVmjpHHEuWCmAYNH4kSawmGswq7FBXheykPdixv/3j7NG+kcpbqpZ2Vn00KoxCTEDNYgPLnMy
	nLbVxkJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roznh-00000003CI4-1xjV;
	Tue, 26 Mar 2024 05:56:45 +0000
Date: Mon, 25 Mar 2024 22:56:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] mkfs: use libxfs to create symlinks
Message-ID: <ZgJjnY8iFD26xYUQ@infradead.org>
References: <171142135429.2220355.9379791574025871779.stgit@frogsfrogsfrogs>
 <171142135444.2220355.14042313671341548069.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142135444.2220355.14042313671341548069.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 09:02:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've grabbed the kernel-side symlink writing function, use it
> to create symbolic links from protofiles.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
>  2 files changed, 39 insertions(+), 34 deletions(-)

Not really a huge saving :(  But the changes looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
