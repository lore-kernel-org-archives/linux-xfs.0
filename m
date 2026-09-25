Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B82397920;
	Fri, 25 Sep 2026 05:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314534; cv=none; b=c7E3a6w/1dDwpJi8bvUmcW8P4+tHd8AzIybdZexNe6Ys61nVI01iqijul4dWMHkkvriQ3JLXZjvAJ7zjVs/XKS5rl6neBasYsG7ZfJI61Uqhi4NYCoeSnnwD5MyfnX0AloVTz7CNafnfo6XsWR54JxF5PTA2sN3yARI46bgQvYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314534; c=relaxed/simple;
	bh=Ei87Fnhbw3JN3y4DNa3FmsIUVOPlXVFJ1cvsT2LKspo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9onsSKXC6qK8Pt+ICUr+ljkYO1Y6hYziznmc8TnKFFcTQ8+Lv2PnL32OoKiFOq09xea+i7iaSl9ryyzg4jTGa00hQg3e8+2+qSrtiU/xCZP5jvQZ1YjoT3XkbF3cQOQR5e7zxsp0I9R7xdPy9aAsjoCxWLyjoEzv9bpVkmg2VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D8+W933Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D8+W933Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iuDTFVqzfgfeJNkxU8psUVkypHr9w6j2eX/uMFoVyeM=; b=D8+W933YZLYn9z3Bzt65sUXnbM
	z71UwmYWOjKTjyICOhDsgJ+5AjrrtAS/jZ4QmjgFVhquw6xUlEpGh8rBj1IJ5Ss8I0GNikUAJ8aB3
	n9NBmZVWufH1YQU24mhOEqP5B5RZqsNUfOP1pzddfCdDTLbyiPIQ4Spi/tKyJCevouW/UKZ5XDs5d
	KIGvBGj2u03CcdLMAU04qMW4UOyoExP8XOr/hT8QQat5zNPGAIHgeY9+3/h2VRaEakwHB98ghFbj6
	1JV96EdV9tf3BeX6My38QbbG17jhkCloF53F+HGRbdTPYvIrI6NyyzXjY4P3CVw60LEYf/3imYDsT
	Pe9TDP/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yaq-0000000Chgx-2VIv;
	Fri, 25 Sep 2026 05:35:32 +0000
Date: Thu, 24 Sep 2026 22:35:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: cross-reference the primary superblock
Message-ID: <arYIJL3S0qKCnO8R@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932134.3344850.5609886284054108098.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932134.3344850.5609886284054108098.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:11:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we cross-reference the primary superblock against the rest of
> the AG 0 space metadata.  Drop the unused @bp parameter of
> xchk_superblock_xref to avoid complaints about uninitialized variables.

Who complains about unused function paramters?  That's not going to end
up well for methods tables..

But the patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
