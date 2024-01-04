Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175081D54A
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uCIXqKdq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kRu43Mk/z64MlEzYdRa5Wko8TO9JaB5BMF5M1T+fKcg=; b=uCIXqKdqyRCCeO/04GM9WtAD4d
	yR9zVL2ubavBdV7D2NRb3M0NLjQcNlN9zMm0ROuwPe3tim00TmIm1krMTQGHT1mf+XRE5q5FcBr3G
	JcdQ+GrQFY/9KXlBPGAU362F1UfeYsXkAIzlLRYtPY/LdynvcgxPcUzG6LNiY4WK2SN+a4ctnG/QZ
	gHDYcyWR9wHOnqsr3Ox0RJHn+DnKHhaG1EzbyaJBY2ERITUo8PG7oQyoF5UQ9FcHWzMsD+7wFl9YF
	GguqRnXiO2xIrrstPSYhGGph0O36u/q9vk5RkrRD7EEGZef7sE90PqpvnLsPdWl6MH54svWh9zSLE
	pwnYERJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLH5m-00CyZC-28;
	Thu, 04 Jan 2024 06:20:34 +0000
Date: Wed, 3 Jan 2024 22:20:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <ZZZOMiqT8MoKhba7@infradead.org>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104013356.GP361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 05:33:56PM -0800, Darrick J. Wong wrote:
> Sort of both.  For xfbtrees (or anything mapping a xfs_buftarg atop an
> xfile) we can't use the cheap(er) kmap_local_page and have to use kmap,
> which ... is expensive, isn't it?

A little, but not really enough to explain the numbers you quoted..

> Granted, forbidding highmem like you posted today makes all of this
> /much/ simpler so I think it's probably worth the increased chances of
> ENOMEM on i386.
> 
> That said, why not avoid a trip through shmem_get_folio_gfp aka
> filemap_get_entry if we can?  Even if we can use page_address directly
> now?

Sure, I just suspect the commit message is wrong and it's not about
mapping the page into the kernel address space but something else.

