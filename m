Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC4C446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431803; cv=none; b=SegVlQ2niY12eQcFIA/5S1YbJm6GOcnW/PQAIy5+yCDdvkH8QHQJH7cXyG+mjrQGYGaaFvqERHy4RlUci+PfhgiKxWc05j1ke7rlM8Ya7CipDVKiTrZlJqb+N0hRpYPEGqTc5lxcZCGsHudI1CPRJ0ffBDRNiV+Nrfr1zIsAjUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431803; c=relaxed/simple;
	bh=7b2oQK2Q5E5KfmtQ53G1hGyRe6TL9ZfME+1732INNSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttWiS+yUVkrOtxUkK/ZhmLgbujSIiU3UgVvgETnIyl2HXp956eSO5blukHDZl5oMAXv0GCGJAwg51kLsUgs691DyhJoJfvsW4etxJ3oyZbjzYt46LS9/C2nBEdlGBFN7nvMPysgTuA030yu0BFXg4VA+gFL8e1Uyv/zm0Vy79SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E7p2Fy7U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E7p2Fy7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EzuyoCIjRsIhmkDrcsPYhMC2WUZB3CZP2N1mAeACc9w=; b=E7p2Fy7UiSLamwErxEPeU3awOz
	V140dJYmu8eJ1yOPXsSGl7FxVMhVcviFlMr12r6whtQEoT389BIM5crplDFccvYYOygRX7FhE+11x
	nJZqbIWGLyMlr1LPHOQyeVFtiGYliizCFlagdQ3gypvPt57AHPqig86qF0G/EaqhwK08XD1967KFY
	t6viewAj+sQm2v05K91GlEm/1eGNx22qiuuX/ElgbGd01kwWRu7k9jvnm2qU+hgNvzo7KMthD/Vwh
	z3BxJQ5z9acUbOD0jCM5DH+rVMY15dMj8DdFdzSG8mpa73zwQYJhpR05UaBF/xM8frzv0cfV2YFo+
	jUinw7cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozak-00000003AT0-1KAe;
	Tue, 26 Mar 2024 05:43:22 +0000
Date: Mon, 25 Mar 2024 22:43:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_spaceman: report the health of quota counts
Message-ID: <ZgJgeq_yQ8IMMb3n@infradead.org>
References: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
 <171142133994.2218093.3554558564414039858.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142133994.2218093.3554558564414039858.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 08:58:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Report the health of quota counts.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
