Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC493033F5
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771394163; cv=none; b=FcrjCs97DVVSLKdfJIcfuIkQx1o6HWSxkelK4lCYO6wpwgyMgtrXEDDsUj2Mpyw+2PZIgPgltL3jjjHwLbNxs5uGBJh/6TVWrbCZ3GlmKnJ6zvQQ1iaDaGsP4KJQASENTTu5HidiszXxNi1j6CeTWhqKr6ppACZ/VC4pGkFtyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771394163; c=relaxed/simple;
	bh=OAIS4J4fx7s/3HW2l9N0tgNQIJE8rjj1Xf4KSgy6Feo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ie5z88pafTO4dVEjL17sDATjrPE/KNKaEpn58k1NDPnWCBokEKVWa2DLpgL21pY4o7L8mf64Gs40O93dsfkhcoTKgtV8J2Untde++fFq14j5lRSSsRhUbET0VvuGd6gPVt3nzTG1sZBMsmqCGBu+DfneSmmO+KkuXfppg/nxB2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zaWc9m7X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zaWc9m7X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OAIS4J4fx7s/3HW2l9N0tgNQIJE8rjj1Xf4KSgy6Feo=; b=zaWc9m7X2YTZMk49FOJNHufk1m
	MA2AAOkqIiAoqVZQTfmbGl88hCLG6Um8yea4iDLuCv/wfux620FZdSl8tGRC3EfmDSBEeleZOntjm
	Sjsbq1FunBp76+jRFrkvztlffZYl+9RIBroyRCBVgioaCUJ6j1OxQDRDMWW6Qw/gi6D8ChWInmVdx
	IJJtFLTSAaiUJstBS0bQILYA7Y/g6a9uvw0jpap8GKjYQ4HT/DRh+d10hf60WOcWp+/15mD0BuWiA
	jqre2VWZ7NZX+VEVpMlQmkduP8IR7GOzEdH5iwOz6DyBPwkhGT3T828+QRHlxWRVsa5a8sBSAFng1
	G1YDcTgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaXa-00000009Kwb-0gDk;
	Wed, 18 Feb 2026 05:56:02 +0000
Date: Tue, 17 Feb 2026 21:56:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 4/4] xfs: Add some comments in some macros.
Message-ID: <aZVUcgn_8eKw7j2_@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <96578ab7bc45eced7c4a3de66c7b81fec2f2095d.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96578ab7bc45eced7c4a3de66c7b81fec2f2095d.1770904484.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 12, 2026 at 07:31:47PM +0530, Nirjhar Roy (IBM) wrote:
> Some comments on usage of XFS_IS_CORRUPT() and ASSERT.

"Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()"

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

