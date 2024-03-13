Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5226C59149
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367368; cv=none; b=jDvXToMakE6NAX1XewiEJTVgq7qZKBhYM75k3EkL5Vsm5zgW/naDA2ZXe2uTsyjcRyfeJHlZeI0KgxIrbsQTMfFnYBBNUIvMzsHw23b2IXzPEEy9vX4ccfb4X158cjHsqbar3Rud3azQNUSwM9CHkBqdC3mEdaeA4Gq3J3s3Z2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367368; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gk+diwQ9aBr1dtZPKH1dYou4iHCbQajyr4C6dpdCfGj1nGyuyrjUz+wgcemjvjfEMXqOkYylt8Fvwqjlnw+M6cUZIZBud6WLgmTalVoQ7i1hYVTKBdumSxQHZgzz+WW/0KzMogwDXXO4W0A36vc1YyU78YKU4GyfkZ0IVNz3zzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DpxiVZGb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DpxiVZGb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DpxiVZGbblkr9lza7Chg4X7bQO
	UV5ajHGlSSCmcQlgeoMXwhq2hoOXhC4Ww4TrjIXcd7Ud/aBxikQ4gj6PMp2inGrLCi0/nmKl2Bt8Y
	i7HstEnQR+WhuY4bDx4jtbihJNZqiVrJNuMrMaLOLmVytePxKGOqrA7nyyPdKugyIS8UoWtVLPiQo
	ZwTWBMxq1NNYQjNtRmr/Y8B5jM/PWGw4OH33fi3/JPamhTQRWYRgKRaSbElKht40qxYv9a6WDSIqH
	WhbWkPdGEwvc4aV8hm74xMgNE8BuedDk35yzyIPus2KavF4QARI3pNiMM/6FMfYfxuMaELA8wdsKB
	TkuHDmgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWgQ-0000000C41n-3p74;
	Wed, 13 Mar 2024 22:02:46 +0000
Date: Wed, 13 Mar 2024 15:02:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs_{db,repair}: use accessor functions for
 summary info words
Message-ID: <ZfIihoeUbwQODUFH@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430729.2061422.5208647528969145275.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430729.2061422.5208647528969145275.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
