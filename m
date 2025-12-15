Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE071FFC59
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765776941; cv=none; b=dgzC3gR2IR3A0AgFHaWF4ov/pFkLY1/PDlGlzOEibPR2wScLSYo8DRZ1cepNShrY3dv2qxN5KL5fraoaPzEAX6SXWkBNItS9GUZA1luiqG5DCrmNQpIwwe8KqweQW4/PuZ9sJnF1bXnFJ9vafCPjYy5gcVi/mMhkz4+qJm87pa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765776941; c=relaxed/simple;
	bh=mItaF6xZLcS87pevURn7MoPN1zwqvJFlX8BB8WjJc7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9YKfWKP6yMnmYd7n1qpRu6hBKogcZXvPVyE/Z8h4deuzAl0B4mepG5a8xD8VCzM73cR3zQVkl16dOL5YPUUPp9G0CqW4iiCA7tUeuO7nfSFUn9q22tOxQiCb8YpPY/rzf3IPwx7NjKEfWx2m6vRhxKn/vwjDc6WdHeWTsMyEA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zRRXfSjl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zRRXfSjl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5Td7Jl1xTwD+XMR1o5SAmlEzXFMZ4dARhl0DfjVZzq4=; b=zRRXfSjlGZgyYjhBkW4zHmJdpA
	eyGljBJ6I7h/Qac+UftjIOpaJEjvYtM9X34/ykNLf1v7/d7Ep7cIYODeZFgQyb2tSd8vb3j0cwkdM
	kEEfCu+/m5sI667Hw76H9jiwDc8O12cJtGe8qjOQPGL3/F9w0ResTuOjWM0lN548Ie5N7/Kfvau6u
	7nF5wV9myMr9up8xVVGdMQeiUGAIPwy2bFGVX2rYvEtj73ZiYqcd5D7+79d37xwXcMZ/c2AnOObdv
	LAhC5Ddpu5pX3QBB2x4G9OllSg9qtE6keRi553y5WgnW5j9RYCCl6oweQsY3rLV9Lobo0BzzIpmch
	hYfzNXXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV1FB-000000037Qy-1jSE;
	Mon, 15 Dec 2025 05:35:37 +0000
Date: Sun, 14 Dec 2025 21:35:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev,
	djwong@kernel.org
Subject: Re: [PATCH v1] xfs: test reproducible builds
Message-ID: <aT-eKSYrB_MFQeZY@infradead.org>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
 <aTun4Qs_X1NpNoij@infradead.org>
 <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
 <aTvOQqfpiJDCw7e5@infradead.org>
 <sgb56cw7mzdeebmugn5czivs7ei3g23bfosir6bb66pytuidyo@4irrwmmz4rel>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sgb56cw7mzdeebmugn5czivs7ei3g23bfosir6bb66pytuidyo@4irrwmmz4rel>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 12, 2025 at 05:56:02PM +0100, Luca Di Maio wrote:
> > I mean stick to md5sum for now.  We should eventually migrate
> > all md5sum user over when introducing a new dependency anyway.
> > Combine that with proper helpers.  If that's something you want
> > to do it would be great work, but it should not be requirement
> > for this.
> > 
> 
> Sorry read this too late and v2 I've moved to sha256sum
> Hopefully it's ok?

Let's ask Zorro as the maintainer.  My main issue would be adding a
new dependency, but it seems both md5sum and sha256sum are part of
coreutil and have been for a while, so we should be ok.

