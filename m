Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641F4396585
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314644; cv=none; b=PAzzolLIscm55lbZ4e5M9CZZdAnTUEyvw8n2u8jn8XXvLJ+sDncJQDIUEXozAB0zObo5tX/BrYcT8i3et6dDcxCEMlKLqeAd4Y1aR925vhB5FgL33AKWljv919cbXZZDEslPuOXbQmg+OPe4M4Am9iWMwmiuLUHTE4wEb7wevlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314644; c=relaxed/simple;
	bh=tg66jRy5IutISnHsIMLaFJIZ/PeRLGdsaXkXNyZSK1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErVwzRcO9Ku+sEzmtdNOs7LdVASRjkRkwVnh9suw8B6z3roZcVQDwI6/V5+BwQ44rWpSt7qZsxRuxB/eH0unRLXeOseEn9t9TE0YL+b5EkaM0eUH+xmrPruTC1hRsDWMoL4ntaMfSzRS94gns1VIgtZtLatgi8yJNojMSy91aHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DlsLbfIl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DlsLbfIl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pot34shEBffc6Gp4mA0uDNWEYiPuqUmO9sBJie7ltCk=; b=DlsLbfIlmLSDHzOt+fmOiscEvr
	pgXgcmw87tP7w92LX/6XCpTO+TD8k1CnagrCwWtElAaXuQlWXnOBsQ6iML+sRvmKwXEBc6LpgQlNa
	PgnL97qEuZ2Ie9M2VlCF9S/DQnec0bWd4PoP6hWZ/m0/FEf0V0VI2ZejKXoIJxDqYKA0BYaM5iif0
	T4ZM49zv7xYGZRSUi+SIISYWuU7ALWYD7ZyCechVWKUGnQI1TeYsAM9LBIHeSXCjHbWAyKLiuP9Jp
	W2OxS3JuNb/g5O8G7gm+Ro6Cr1aRSVx6Q6+GOS5vY1u9zFtk43QayMIOnNZqF9lX64M6pPfZRI9K5
	OP90W4gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9ycc-0000000Chof-3dXh;
	Fri, 25 Sep 2026 05:37:22 +0000
Date: Thu, 24 Sep 2026 22:37:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: read rt superblock from disk during scrub
Message-ID: <arYIkq05t1ecTLNL@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932176.3344850.5822434207780341943.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932176.3344850.5822434207780341943.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:12:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The rtgroup superblock scrubber isn't that useful right now because the
> disk contents could have been corrupted after mount time.  Perform an
> uncached re-read of the rtsuper buffer to perform a fresh verification,
> and schedule a repair if it doesn't pass muster.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
