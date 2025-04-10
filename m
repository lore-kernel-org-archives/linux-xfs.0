Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529BD202989
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266290; cv=none; b=b2L9fzVvtb2Or/zt+3XhIIqcFERYd0+hk+VQ/GzD0WhtAaO+VePVD4EPRv8p6Q99zfLcqeC033GQosPc5TohkSiMbgdsXTeLMDsJw1/32t34QCxBSAnXW9IQBPohoQxVaOILGJDkEvD8TBBToaIeYRpk8JGiccYRLxhkVcgxyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266290; c=relaxed/simple;
	bh=f+sifnQEz0yZu4ci9x5eUCykGLkWxPq4Aym8KwO6gdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJMomLWYHBE3KMEyBEeVOPg+TsEzDv6VTF0k6P+b5HwmXqSQmrBf1uCYan5SVGnoanGh9+WYvlWyjImO9Gd9jiTtRTzvv8Fn5L/dRUm+7Lf1kNxfgj75CPuj+WyqOuWGcGpZVXHHia7qrXQay/z/AFwdUteIXkxHY4EgAynNBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QMXG+x2f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QMXG+x2f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D8Ox9D1wtUJbgBT503OZqaQtfyiurRAT7AIr9Y3SzLM=; b=QMXG+x2feF9nTNxMaaAbP2cRYs
	PwlBTGllLmSYzVIzrDTMgkUhyK9KfD17YLn7NUJxMthgsCvsqhebQDqDpZLtrku/BBryKmtZuzsdG
	T6LbIeSmH+dAI/bF2v8AxDhf0fDUkAf8D3n40a7pJ3U/SNd5Sk0do0F37UwIaFrnLy6SEUL5nFEul
	625pQqvS1cNxP0bNPPbFY8k16TpCJevEm33PYzKV+Kez9XeoHpqb1gszjYHlBSMeM0peQ/2cM0CZy
	yOK8h87fF6hw01aKFVidDLuJlXBxMH5ZUsWy1TqSG/8JnbRVclRKZg6cX6VGMtW4/MaGFUIXwyaXo
	yx5MxUnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2lLD-00000009MJc-12A4;
	Thu, 10 Apr 2025 06:24:47 +0000
Date: Wed, 9 Apr 2025 23:24:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org,
	aalbersh@kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH] man: fix missing cachestat manpage
Message-ID: <Z_dkLwJNTZbXFikf@infradead.org>
References: <20250409160059.GA6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409160059.GA6283@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 09, 2025 at 09:00:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix missing cachestat documentation so that xfs/514 doesn't fail.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

