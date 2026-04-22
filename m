Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3F021CC5A;
	Wed, 22 Apr 2026 06:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838062; cv=none; b=Milqlp+s/Lo1ZnsjE5v5kd8CYiAUhElbddZMnRLT/E3OnkgDHfb5EyjBK3flVLOgPuSzyQUlL6vcKZ9C9hoTN/6PDvsCR2rTQ7URbPZ+5hT663Y2zqgMP3YAGKZjyLApvU+vXMYpPbLdMFlMSNOE6dZmW7Y/dVjJAZq38zPPvHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838062; c=relaxed/simple;
	bh=eZAAR7hEYpuwaQzLXAYTbwmDH0yw7Rm1IzUXCwIBshw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKkqwoV7eQZsU+N1tpun/SQI0AgM8z+T93JvnL/Cu9DbTr6/qL00c0cWSZjsAWRRMBbhI1MQ0BlfMDhKPYKuDsXrc3GShvWCdlT6j8za2rx7hGuHJxJeOz2m6h9vM13v5N1GZfiOikdr8DHn1V5RmEwOdSFxsLbYC3BRT+xK7Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mhQQAfKH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mhQQAfKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iMW8Vx62O/6nF3nfk6vYcn+eHtMGo9C8VQwZfMzOmSE=; b=mhQQAfKH8wq6MdiElxLqzE+Grp
	5N8rUZoz/v5Ad4W+KwXlBCbOqnKpP3GMR3VmbXI1gRczQIYGeIrziKkQ5qd6LFYa5urpf4o1Z/i1i
	w5XCkns9AfiRIlEhTa40BVc80ghInlGlWpYSAvlQxa8+zRUjwQfCfwBagKynbTNYsU/RYbqjS4Mpo
	1hZSCl6G5FP/2UR3x1zkIAbsvxuZ+TNnmJHNNmgdtgtXNPHbcsKCOTpZmRWgt4M4W0RE8zndZQZVr
	9CGbdfSYhgIOg/TIX1KhQugVpPFEWjsOFMQL48VTDosr/0QOb/Eu0AGuAnZUs7B0UQjqJLpYxyip/
	ZZsxOZ9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFQkD-00000009e5R-3tOZ;
	Wed, 22 Apr 2026 06:07:29 +0000
Date: Tue, 21 Apr 2026 23:07:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	linux-kernel@vger.kernel.org, ritesh.list@gmail.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aehloU-hKZ3VDhbX@infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
 <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
 <aeZzP6iQel-tkZOu@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeZzP6iQel-tkZOu@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 20, 2026 at 07:41:03PM +0100, Matthew Wilcox wrote:
> > 5d8edfb900d5 came with no performance testing results.  Does anyone
> > have any evidence that it improved anything?  By how much?
> 
> Christoph reported it doubled write performance with NFS once NFS was
> converted to use it.

For the right workloads the same is true for local file systems.

