Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D602C0F63;
	Tue,  4 Nov 2025 10:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762253833; cv=none; b=StH3ufBLmVNuQIEfkBATVrA2D2Ru4eHZqWom9hYtTAG3977QZNR6fquvxisv16R/EFTyuQalQtAqRWONT2Xt1lQ/7xKIi837sXKvyLLAFCrw/C3Kprh7re+iwvwrYtm4nkqHGrCrQFIZ/GE436UoRQb1sV2UvHcr7bvd59s0olI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762253833; c=relaxed/simple;
	bh=IGXtObbt0pB6eE7EFb8MJymEA/orf4JEVkUBaHbv+ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vo7uWj4krNXJqWkvNVMWgyOLbMobnWKkvzHOIF7URzsAp0vOxyIGSEjZflVz/nohHJ61+hJooKC5uKwfscO2iEHeJbcoEsSZpY8v7u7pqoOw9FLksMpleGpWre+UzcD3Hv94fzzzCZyF/bB4dZcBLxccCg8Czfu+TWxWkDupmbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N2DKPfVZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N2DKPfVZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IGXtObbt0pB6eE7EFb8MJymEA/orf4JEVkUBaHbv+ko=; b=N2DKPfVZhx8168qEPmZUUbIlVb
	U03mxFFDt7SO+UD0kRLiGZRx5GMuG+0+/ETAT0bSS4xjqvjB0y8sn2996lmS2Bq1dUMo9ORhJx8mg
	Zs7Ai17oif5p/r1tva1LyyJQOomViTdckjRKGIIIQlisGqnEE+sSgArz1UPHamWVWuNU+u+ej55UK
	TDQXRYGejP/q37Ebk7+WP1offEVRhStoQ+OKqfZNddHZtsBpE0ryltc8X8qWPF7IBqBabE2vTuDx+
	DaY1vWivtBkfpdlCLAi4Lqvt1DVorro0mTwX5rKFRnjaulZX05hZvQJvo0WAOvosDtqZXSeXXDpCh
	dTdJ65dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEir-0000000BfwS-2njw;
	Tue, 04 Nov 2025 10:57:09 +0000
Date: Tue, 4 Nov 2025 02:57:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: cem@kernel.org, corbet@lwn.net, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	gouhaojake@163.com, guanwentao@uniontech.com
Subject: Re: [PATCH] xfs-doc: Fix typo error
Message-ID: <aQncBRi8WPh7hmqg@infradead.org>
References: <20251104093406.9135-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104093406.9135-1-gouhao@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 04, 2025 at 05:34:06PM +0800, Gou Hao wrote:
> online fsck may take longer than offline fsck...

The o in online should be capitalized.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

