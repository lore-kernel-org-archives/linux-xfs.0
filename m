Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C4A4F896
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710883925; cv=none; b=r5lXyuHZB8pxNRRsRLpQoDz+KAmX9zKTE0PtbbPY8mr29qKwnbCdvnR548i1FiubYshl3mGQilVELo2t+xi/cwdVZmGCXp7yZ6KOfSzidFm0s4OqDmlTfxNHKU1wpphSEK4lMliUC9vFsatk+QEBZ3j0ORqRWqBcY2Ni+a4iYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710883925; c=relaxed/simple;
	bh=z40jZnZahVwqQ1IIxU9YWrLIyS+y6FzcW/rLsE10fRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEKbEWgj1J7XuKdbYl1AuBtztpOxpI0LsYuFDAThKK/w6GkUeUoNPLC+1yiSltTuNsXjsXKbtzsq48L/Cc2ZlDzIyeQxzQE4spBtQsbo/FKysWvDo0at74yIeOXl/x/PLJbCJ6jCvevFHL7a4QHi1p2drL6tMp6Xp7laaxzLWy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HTjZNlyd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HTjZNlyd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z40jZnZahVwqQ1IIxU9YWrLIyS+y6FzcW/rLsE10fRo=; b=HTjZNlydWgce86hSmDO6gWfWkV
	2PHYzVMjw/PoV7/RxisM+x4Mh+LuBQo2Bk6oc+7hbA7bsdU/Dh0borScjyij1phCiEQgv/FWwJv4P
	4CgKkrwCW6Gz0YMhZd0s0kn4fTp0TL/KTn4Il8Hxk0lQ+En6rZvInnSDf81GGDVdxwh5/1H7bM2gj
	fmvxbrfFXH/LVIRnDC12+Z/Lc/uVggqISZb4vrZdF6BUNzCt+hCwwn/vOCu5CYqs+GA/cjA9YhUWU
	gaj9FVDZC3m7isXgQ9Fn+Q/7CWBB7UKXf9B4lYrXrhZELfSJSN16tDggE9qwF0xUXZ5RzZBNdDT5o
	b491SK0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmh40-0000000EItQ-0FqS;
	Tue, 19 Mar 2024 21:32:04 +0000
Date: Tue, 19 Mar 2024 14:32:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfoEVAxVyPxqzapN@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319172909.GP1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 10:29:09AM -0700, Darrick J. Wong wrote:
> So.... does that mean a 128K folio for a 68k xattr remote value buffer?

I though 64k was the maximum xattr size?

> I've been noticing the 4k merkle tree blobs consume 2 fsb in the xattr
> tree, which isn't awesome.

Maybe that's a question for the fsverity thread, but how do we end
up with these weird sizes?

