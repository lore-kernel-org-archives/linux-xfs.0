Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21211187
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848263; cv=none; b=MjmX4USyETOfWERluZy/t7sfZRtoubXgwUPXQX0WKn1uvLqnJVgA0NLyqDV9+w0MeU5l1sT2mWLYzN0XxSmItNw3fkWuoqcam10gsGqw8Ikm7CtY2L+LpD4NOPiYp0Dbc0Ov2esxkbgZjCYAsZC5UsHHFhHsul17HFZnw5NaJIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848263; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrlKrnSCYxTAmbYOczEPSrMAVGzNKrjKvE4Wx1RzY2OTQAgEyknrzZLNxl8podR3BAK7QIaF4JRAOGopxXuf2v1kU/H4Ydz4DCoSz9pnc7NITTADbj8P3jIqCAujtTbFI7phzMdGwLngvLzzPk5kLvqkgJbFTDvlYEILi1nhJQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u5ckm/5Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u5ckm/5Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u5ckm/5Z9nSsG+UndCWf2sK1kH
	On+SCOpJ2+kftv0sGL6spvgYEUQRcYx+QpwiaR9gUcXrHjFnGeFcBTvXm/5G5zfeZ3FjQrGovfJ9L
	S5O56pkifxKyh5QQehKt6AFyBC9tfRLU2BjrnpxhUV5uenWJfaqoDCwNjElf9pp0hJNduIRc6WxAL
	NvWrSFeweEuhGUAn6pcaIAUivHDawbTL366shgiCqQ9x8qjraLsZOd5bg7KEDpeQkBrxi5kmhsV1u
	V4CJTq9lAnQ0RxnYJ90zuZPWqHIDUIFzq8Wo3+dZ9GDhYu+Yq6xcYHz3fmhijgo7Yjp91yG9iQCMr
	/f4Cp+og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsGM-00000004s2i-0HAB;
	Wed, 02 Oct 2024 05:51:02 +0000
Date: Tue, 1 Oct 2024 22:51:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/64] libxfs: remove libxfs_dir_ialloc
Message-ID: <ZvzfRhQYe8X4ZLnq@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783102067.4036371.13779727724559423333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783102067.4036371.13779727724559423333.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

