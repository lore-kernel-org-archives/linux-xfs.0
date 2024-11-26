Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF0B67A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 05:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597885; cv=none; b=LN3sM8t7KBJe0rXTRdgTlrN5RGLTSRjAzEM6/msDzvVj8V+P5UnX/M/kpYLtCz4f8om9dkQ4yLiTsPxj7MI0HiRPLcaGVrWVsSblhaKgyVmELNSjUy7tTgp5n1aqkGxJz9e5slf5xDcH58tirav7Y8ZMAZH6GKmQ/q3X9Ri4SQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597885; c=relaxed/simple;
	bh=Hg6uk+jeQJJ1/bmfUnNGzg3elPXW7l7lMK5de6im6HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=preynN8i8n2poD1OueV5VfU8vOvvncxbsvxyK+EPIowfTMIpi4GRhUe9XWk6c8zSHqCL/o/I0xwgUCUMGXZwuVH/ddhDmCSqNXNNHWuyC3GDl+6+3guIkBWlcCmf8Tyh6dNgrpHnt7UPEIVM4BjECKa3fqniXsSr7bvJl7PuKVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2PP2Z7lg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2PP2Z7lg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DfXtGU/cBXyTqhYnYvhCfY/VcoKnJrBQdo2wypFK+gk=; b=2PP2Z7lgQZN0ERuBVgDaTY7xmz
	9iVetTk8anm3Elg4Ij64pv1wm3Ygufmjvhkk5j7V7NLpYMAO6Dbgxtz1GCmyaob18bdSL+Rsd5x4i
	h/0hE5K0hmbYvNAZJHgX6Xm9MWmr9wkLBFcT9hVNr9Z3flTzuixieAtXsrDvMeK/oWrNqUZ0JVVdK
	6KWKV7rxqrYWXxGQVJeXBNbslNi3fRJNxuxXLE3TDY0JGit43aejtdGmc5EI14ybDSFRy4J0wwgmm
	z0/XEwbD+mejvi8jvUcwPwk3odYa9cojqj3Sg0eA7SHqYeKH2bRW+7NqZP7t4E5rxGgIOyhF+Gyx2
	dkvc2x3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnr9-00000009ei7-1pBj;
	Tue, 26 Nov 2024 05:11:23 +0000
Date: Mon, 25 Nov 2024 21:11:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
Message-ID: <Z0VYew8ATCmf-jBA@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
 <Z0VYar-LmcdXptXh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0VYar-LmcdXptXh@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 09:11:06PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 05:28:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
> > __xfs_trans_commit again on the same transaction.  In other words,
> > there's function recursion that has caused minor amounts of confusion in
> > the past.  There's no reason to keep this around, since there's only one
> > place where we actually want the xfs_defer_finish_noroll, and that is in
> > the top level xfs_trans_commit call.
> 
> Hmm, I don't think the current version is a recursion, because the
> is keyed off the regrant argument.  That being said the new version is
> a lot cleaner, but maybe adjust the commit log and drop the fixes tag?

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

