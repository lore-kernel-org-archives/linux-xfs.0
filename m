Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iwFogE89"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EADACC
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zY5C9Hll3vgo2eWFfBLs+NZYSiCpV19fAxQlcRcxrHU=; b=iwFogE89sU5yTkWtQaKKqNZtrI
	PHqwgIvqv55nsF5uLLYUUuameztk4gFjFJL/gk35n+8545DyGj4/96I/4ixmGBsFulvSNJHNt7vsP
	GGG0WbgyWXkls+AsO7Kzpk9YNCEqIG0IxWDchWLc/y586ZlMCwj+d1x1gH8vSJ4mYlQRoNozLijCJ
	v9NQ1Ij/4t9/M6niQfzgb3T8sKPD63aPHsrRFmLA8yV5WjFjC08dyReiFfLJxy7kPu7lLy/3w/4l5
	GP1CeRyf057zPQRXqMV29aK+2qVTrr3fw6WcGxzY3L70gu1kGueOFY7zym14ti1OPrJ/3UgQSQDaQ
	Tzaekd+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qmZ-004A74-1b;
	Tue, 28 Nov 2023 05:37:15 +0000
Date: Mon, 27 Nov 2023 21:37:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Message-ID: <ZWV8izIb2XTOc9dJ@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
 <ZV7zCVxzEnufP53Q@infradead.org>
 <20231127181024.GA2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127181024.GA2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 10:10:24AM -0800, Darrick J. Wong wrote:
> > It might be time to move this code into shared files?
> 
> I think Chandan started looking into what it would take to port the log
> code from the kernel into userspace.  Then xfs_trans_commit in userspace
> could actually write transactions to the log and write them back
> atomically; and xfs_repair could finally lose the -L switch.

While that does sound like a really good idea, it's now what I meant
here.  I think if we moved the actual defer ops instances out of the
_item.c files into libxfs, I think we could reuse them for the current
way of operating in userspace quite easily with strategic stubs for
some functionality.

