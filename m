Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182742AA9;
	Mon, 18 Aug 2025 04:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755492362; cv=none; b=qlenwi5RaVO1ldlSsbefglTx2jsoTgPb/Jf0Wqn0VyOkMozmqAOX4t4QJYRSft6bAopa1CQZXeOhrWGjt3I93tO3rP/WbStShqkVYlZ/pHphhd5wBgxORu6X5PfytMt6GrzI8uyLk4WltUmuGf5+0ECKuiME/i47ZLqlcwffR6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755492362; c=relaxed/simple;
	bh=DYiu9Mqu06AQlZtUQwvMaZWULdA5Fh8Dvk0W2Ch3aXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKR2Ke60q/jRcrsSYXzxzVobY2uzJ+Zlm0Smb13GHsKuC930N8sKQgHH2m/w1J29zGo3qozsxF4mbzw7bHQVF11IU+o7UK/go+odtgRquPc6do0GbOr1YIeLqs89DMYnZr49hQMdWqE+uKy+QzRQAb7AUYOs7OEurjaRB0gGqyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qItQqzXP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qItQqzXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DYiu9Mqu06AQlZtUQwvMaZWULdA5Fh8Dvk0W2Ch3aXc=; b=qItQqzXPRvvNp0T3RehfczY5E3
	Jb+n/7xuCzoEjT+5a91ggBAc4zpZ1uhX5BrwetBnZmPm1bv++yO0ytDYruWkzIs6je+IbXYG6+x+K
	E8d656y6eROOSPadZehGIyKItcHxo20OCiOIenpd1LE5f5B8v9VAolfdISsqbM7OupbE6TUFpVqkO
	gobRtm+h1lvMiZ3aof5nWLGZHNpXNk1gU3xSve3yWcZlAbtCzW/U2rxtRwelx0ss12M+fhjA+xTpB
	Y3tL+VsJZjDtYBvyc/MzSI26UZZzNG9QQGrLGnNuEUjEPhByJEUwvthvMx51wlm7tqR63PNsdoh6b
	6o7tw1Cw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unrku-00000006UkS-2VKK;
	Mon, 18 Aug 2025 04:46:00 +0000
Date: Sun, 17 Aug 2025 21:46:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
Message-ID: <aKKwCKhf4bRy_W4Y@infradead.org>
References: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
 <aKKvjVfm9IPw9UAg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKKvjVfm9IPw9UAg@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Aug 17, 2025 at 09:43:57PM -0700, Christoph Hellwig wrote:
> I tried to follow the link, but got a warning about a potential security
> threat because firefox doesn't trust the SSL certificate.

.. and if ignoring that redirects to a site that has the same issue.
I tried this for a few steps but didn't get anywhere even ignoring the
warnings as unlike what the warning claims you are very unlikely to
steal my credit card data by me rading your blog :)

