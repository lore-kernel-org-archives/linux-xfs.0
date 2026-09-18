Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99195172F8;
	Fri, 18 Sep 2026 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789739467; cv=none; b=ZSvgflKXe7rAAzEt0K/CL/I50IDz6Kc4kKU9NpKKeyBa+0fP6RiiWFo1jIFM8X8irqITAARfPY1KtXZoyYyjd8R8Opyoqowe8Ao9M9l9gfLQHES0gLEFdBPajVqVzrTg98OSauhuMlfWQP7bFb4Htx6nuMMy6xcIweE37CjeyAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789739467; c=relaxed/simple;
	bh=r9lrDimKsxCAd/GFlHyTvt7k61I3JdZNuCwiKYQlbtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRdVrNFAH/0vPk18cvWoNITiMPhkoDanxEXja80WhnABa2VwgfvSsXVF68+mzCLbrbEjvPZe1AfwpUlwo7fxQN5pZ/PdjTBt6VerUU61ZrhNj6Ev4I+SSjErNS6udgQb3Qmgz045TQPDOsl6xM6eJxJ1+sOWsPljERB/tgB82Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wgAYKhB5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wgAYKhB5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r9lrDimKsxCAd/GFlHyTvt7k61I3JdZNuCwiKYQlbtU=; b=wgAYKhB5ML7O4pJFyhNfm2564B
	RJvekncDoZhCFdlhu9bHYfhzQ05bhCwI0X/7Sv0lWneEtZwzw7pxObEeMSZir1OqUa0Q1N6EcB0el
	mbaT/8MOY9MKR518p88SO2HBywTxlmn+QwxCJvOMmIFD9+QWVJ3+zygdys/jo3+NkN5NCJBjw45Iz
	mJ7Xw/HBYsYk2sgeuwhphM831/HYcMnZFtZShO8ZPArgPYMQPcV0HTTMnkQMJyjrIEHo5+P10+osT
	p6MNyO3AMcByQnV6tyoU1GIdTUf7MvfuZAiBv15ODngHeBWeXy7FWy7vAasksBvqSnpdW/28fvHxS
	tWe9/O2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7YzX-0000000EdKf-3TlK;
	Fri, 18 Sep 2026 13:51:03 +0000
Date: Fri, 18 Sep 2026 06:51:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Lalit Shankar Chowdhury <lalitshankarch@gmail.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Message-ID: <aq1BxxxUe3iCyPYV@infradead.org>
References: <20260917200835.31027-1-lalitshankarch@gmail.com>
 <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
 <aq0dnoWhkq9JZkiu@infradead.org>
 <aq0i-bfEEMpwJ_Dk@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0i-bfEEMpwJ_Dk@nidhogg.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 18, 2026 at 01:44:12PM +0200, Carlos Maiolino wrote:
> You meant something like this? Leaving xfs_alloc_bucket_bitmap() looks
> a bit better for me, to avoid overly long indentation.
> I don't think there are free_bitmap_bucket though, buckets are straight
> kvfree()'ed.

No, I mean changing bitmap_*alloc* and bitmap_Free in lib/bitmap.c.

