Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3272233EAEA
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007997; cv=none; b=decFLipQgKdLnyrKpZ/seX9FD3puluU47nScLUx+KZ90q2WPRGoDjV59w+flahwhmviKt8tyRi3Zv+dQFec+Pb4alKkWULxi5P9favS27reEBWXPzl8Qq8sNPkwBe1H3LKu9S5CVP6vBz/N1e2NUQGAfDZ38uXSRfpdWMo6b/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007997; c=relaxed/simple;
	bh=Eml8LN76fYKa/eMm5L5X+NmDV1/k3n2BCFphmiVi6gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAbOyGRedHg7HPvoerOhS2gvcEx5JBOrPnTdqGkrNLQbpSFbRZkizKbz0sxXF2dVfOeN2FUql8g5B1Ovl+GXxNGNc5C6DQSjhX955yHFIqt0E6sDN4GyV1ZDQGfNvegJJXkhCh5E8TydjBr69GcdpMgfDPYYs3VRumeifrFfNAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tq8PGqla; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tq8PGqla"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fgbdv51vaUbZNNyUXYuXNricw+YYT4M9oCdjnJBXgw4=; b=tq8PGqlaLYyG0U/uRaYP6+Ww7a
	PJ1FBRIdFrtZQCiTfuCdheKpUym6kvzYRZ8hhAjSXPfVUVjYLsF8kzRj834HizW1DekD3j/tpa5PQ
	BKuopPf/KQh353ipimpNq2w+ChXwsS6ylIy4lCQyEw/bJUnaR1dXMYFaAfPdP03qnY562uUck1eS3
	ELC4n0OSz6JcCwVfLNgVT87Ofv3D8CFWTirG64PNnw9ebyauRJSYgRA2UNCdcOtkuCZqwrNNUddCM
	oKnP898UFDFkp2kMAqPpR/vqNvvnCuCEbv6FoL0YHCBCTN29OPW8kBSkBJx5o1DP4hZ2Phuhp5tVW
	QH8CRkGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZn0-00000005hKC-30tl;
	Wed, 21 Jan 2026 15:06:34 +0000
Date: Wed, 21 Jan 2026 07:06:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: refactor attr3 leaf table size computation
Message-ID: <aXDremhY_3sdlPDY@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695620.202569.7698466645036313818.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695620.202569.7698466645036313818.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:38:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace all the open-coded callsites with a single static inline helper.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

