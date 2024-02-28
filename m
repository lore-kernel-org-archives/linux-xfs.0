Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C3A79B85
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146400; cv=none; b=YsnTK/n01Amm16v/n5wVPrkN+bnRdr1llOIeaLTfzxVNo5BPwCSwfOmK1T5gYlPK7tCmITnBZTVxlqC8g9h3ZopXbM2mCNgbq1H/NAB5iPfSXVfGcM0beexDs0NGRVQyKe8ACzUGCw8WX2bl+OSa/Crlwh6bAOYHiSM4TO7aZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146400; c=relaxed/simple;
	bh=G5PrXEsQW5f68Zc8lEuXmdCWU7NsLc5+ciqQVzyJnZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bx0D+pnBtfA3iicxLksWjZ01vVaASbJ7unbwQ6cseuTutNEN7RFopdwHZcNpz7+EJi86W9V7mOPa9oUxKB02AUXUTFCHUeuBCsB7y0ixQFRS9/su4ZqukjdiYkFEdvlc5elho1/IPrd6OajJv+TU9Nx96P5U23ABd0buDmcn8LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2OPGWAtz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2OPGWAtz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kpSW9BOWUMqwN1dFZ+95THw+WfbCtkciazFIn2Uxilk=; b=2OPGWAtz9Jqc33+cBAsTbyyNL6
	5EDbVwbCG3Km90FIPdT446YZh7YY+K/UGFjMua4iCCZM9FC2jac3bNSgYcUW4JTU7SW8oujX3wktL
	ukmh5EEq/EzODnpHzs0AHVeRCLpJAWblobNoeMrbozau0tdcdb/fpxeB6SWqli4WgLeKuszVx1sxn
	TwSl/gf9arwgUjUmWhtYlkHDB3KXRFUIhe4qXLopenD/DXymaCh+UE7N0BAZCX1VWpxOVN68eWYdQ
	+YUePK0gkYAfv/ma3e+BZoN6ROqqAfRilfC1HnGxinez1vUCkFQrXtG+EptqQ/wM0GBGSwpxiEbP/
	xAe8nBAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfP3O-0000000AZp0-1tgw;
	Wed, 28 Feb 2024 18:53:18 +0000
Date: Wed, 28 Feb 2024 10:53:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <Zd-BHo96SoY4Camr@infradead.org>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228183740.GO1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 10:37:40AM -0800, Darrick J. Wong wrote:
> Going back to [1] from last year, I finally /did/ find a magic symlink
> target that actually does trip EIO.  That solution is to set the buffer
> contents to a string that is so long that it exceeds NAME_MAX.
> Userspace can readlink this string, but it will never resolve anywhere
> in the directory tree.
> 
> What if this unconditionally set the link target to DUMMY_TARGET instead
> of salvaging partial targets?

Sounds good to me.
