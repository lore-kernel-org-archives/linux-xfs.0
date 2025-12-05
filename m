Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E47A30F95C
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925180; cv=none; b=Ta5D8zD6cr/y+2dXh1YCr3N3/DqnCt2JqAkYklYUNEZD3y4+OFedaGr3FFmbQ6Rrh7xuhBeg6ZW1d2kc3fltrN50AzwboygroCetQRxFaGhSXNaHqzYmbJ/ZLHcNpzl1A26c2YUprdgF1F+BuHzlEOsV/VQpk27aNrf5UcfJzZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925180; c=relaxed/simple;
	bh=ruIuaGPcqorsCUZriCCKcARXsIPnSrb4hhF3CtmwbH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awOrslIKFCVs8GQ+KN56qvR2FqWDwzmOwqAxF4W1rXwMzn9KHm2I9n1LjNs1uEZmiB3aswn3al8eYDdAPuy30lW+DDMKdZm/cbfV7i2jjL+6nQ5RIRemrDj8IjOgL7PRgPLXtv7naN1seBcTbg5yrCsPqtY/bk6D9IBrb2oWgEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e7a0CRbZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e7a0CRbZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=X/T8HD8m4NpwnsoCenhhtznFpHEH/t1Iq88YHDLNHAk=; b=e7a0CRbZlelZHgKrAs51+aTIMn
	DaPhXBLSWyjWBwkM2BmLeBmRXNv5gxMTpuurSu1efE53TEz6froDYhye6d0tviHsB9GqpbH3furmp
	MCVr32J81Sm+aRTkNLE9Lu2M4ACi3GNVBOMektg1wmSydxLOs+I91BS12qtFCQBYYV4+x+r8c9eqn
	ziaHIQhge50FxZemmudcSRAsYAjEU22wkRzeBZFsA/WwEVEVVifAseVqVzvr/spb+/eY4HDCLW+/f
	/5ivD1GlX/Cf2CsREAHwQXuUgVUpG1IsDFf0N0Cbp9BsUWjRmr8BMEew+L/w0iAdiUqYvadiMWfue
	z9mgkqdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRRew-00000009Faz-1gmz;
	Fri, 05 Dec 2025 08:59:26 +0000
Date: Fri, 5 Dec 2025 00:59:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix stupid compiler warning
Message-ID: <aTKe7meWtvb78bAq@infradead.org>
References: <20251204214415.GN89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251204214415.GN89472@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 04, 2025 at 01:44:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 14.2 warns about:
> 
> xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
> xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
>   785 |         xfs_trans_ijoin(tp, ip, 0);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> xfs_attr_item.c:740:42: note: ‘ip’ was declared here
>   740 |         struct xfs_inode                *ip;
>       |                                          ^~
> 
> I think this is bogus since xfs_attri_recover_work either returns a real
> pointer having initialized ip or an ERR_PTR having not touched it, but
> the tools are smarter than me so let's just null-init the variable
> anyway.
> 
Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

