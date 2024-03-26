Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE4A95B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711470968; cv=none; b=Z08SDqZ/tvUg08Lc/2KqOEcRpa6f7jQkJUwUaDK9fAb5bfpbHLLhh7d3HkPve39YPerP1PhiNWjgsdW0P42Gx3Q6xqPJrnLCnVol+yD08wLijSLhbSQ024zx+T9ShhOqMHmOOd+CgSMT+U9t2sN4jFoAeYdA1iRtTBrQZeEwPeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711470968; c=relaxed/simple;
	bh=x4+f6PCUUDGsMmOoJmynKe9p/xT/2BcZ/UieM3aYGoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNNuwarVeD7f/bn4ZL7MYtzBzIrFc6MTjkUgDCl/mQPEnzworYBAdYzBal6P/8Fp0auWQ9WyQ3MxINt41EqXKiG2lKpGG7VDRHnZjRGqPyz/Q3aKYMHH8wc3bfl4T+AsRoip1iizgUtYYPIdI5ZYof/aP8gw8V0rvkLOfRnVpEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RPR8rg4p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RPR8rg4p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LvsRPvhwwVHTGncCq7Se1cvwafuA6QcpZqPdzUJ+TTY=; b=RPR8rg4pfKKLrK9H2ZIdeaYYIM
	r2Z9q/gAjJi1D1mZwEyLqUzlBcrvyczLcEZOYsEcM5ZLgPibI4dnfAWIKPeFVPPGpW1YzoLm7oXMO
	PgvpbTCtFOCZL6UGW96pZK13h1BK1IsbCqHuYE8mhDAjk04msipgLxFnlGM7x2cY2C5NXzMcuoZXg
	3Ol/7s1locmrBehbVuJAUa1pJo6vUwYqJakW9dtswn+L0Ugncl03IUC03WTlpjY2kLq2xibENr2NP
	1Xr4rJJ60LKi5k5op2Lcn1+P/MvGxThuFh1v6GF4pllIyUArANb5no0wZqD1r83ZHcTb2LGoQl33B
	DqS/45rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rp9mO-00000005V0j-31n1;
	Tue, 26 Mar 2024 16:36:04 +0000
Date: Tue, 26 Mar 2024 09:36:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_db: fix alignment checks in getbitval
Message-ID: <ZgL5dH2AIIlz5N0h@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
 <ZgJZzSMIWDFBzADm@infradead.org>
 <20240326162821.GI6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326162821.GI6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 09:28:21AM -0700, Darrick J. Wong wrote:
> Well we could still use the regular ones for aligned access, e.g.

We could, but is it worth the effort?  The few xfs_db command that
do this bit en/decoding are ery much the definition of a slow path.

