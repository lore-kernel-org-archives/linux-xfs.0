Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF8A37B02D;
	Tue, 13 Oct 2026 07:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791877003; cv=none; b=jy0igXC6JgWt9WZDr+fBg07vCar7eVys+1Wp8wyj3NlA5MgeHN52PC4EQhbF0qYrQt/pLUb+t+cmLQ7C7G4+3qIWJvucqTuj/FZsqbBTYp79sEq8PCDjYjAmLQoZMlN/rjeVPAgNmWyuHryk8X+XuaaRybyLJdj63GFz7D5cAXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791877003; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwtkRFoQ0wHE4bUDDeC1GAe6RwjmziA++yu09iKYD31avB9z6xsnnmzFgFiu29/WXXYhDhBJpoWv25rO5h5sEpaBvlkrAxy3a+egTobWuJwC9EsyDJgKIY6FcffM6Ub88INMX5HQ/s6dW+E3E68rnKfcGHQxOkyhvnPzT8Rq1oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xT9+7gXr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xT9+7gXr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xT9+7gXrXOB4waXqgDd8XLYw/a
	r600CAoMG/8UEbMAiYDe1vh5ZjP1MShitdfMJQSExnHiVIxta9Yx5MLeOgQMbDH0KMVkA+D4bkaV7
	dd5LD2/rNDZBJWsM8OR5Gkxgo6aN2Jgxn3HWwB6jcBAxmKDLO+hqOm+FxXL8kAQC3kAwhPdFLZVtB
	b7VZG84LBgiQjzkLAGsH5q3RIvmLK10tAajTHmY5hWHKP4P343lgOxKa32E3xWdSxISeejdfVcbgN
	Plns8Hcjo6/dx19IW/909o9FC4zNccGGE0uLou2WhoT213t/i9+JQMUsdehsi59d+u0RvLG+t5WPg
	33v0jpdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX3y-0000000CEFX-1Yn0;
	Tue, 13 Oct 2026 07:36:42 +0000
Date: Tue, 13 Oct 2026 00:36:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: opportunistically skip btree block checks
Message-ID: <as3fiu8MLx9GFqph@infradead.org>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107354.1898400.14963103476075928588.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107354.1898400.14963103476075928588.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
