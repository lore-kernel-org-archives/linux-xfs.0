Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E2E224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809141; cv=none; b=B99nS2otFY3AqoFK654ie5VBqgsyKv1VBIv631dqLTERCp8gL5M+sWY0eEyTYHV0zBxJchcjbJHThW9orcjWqgTtsbH/I1pyMJKml94nBklzGH2wwff6y9J29un4PmDEpQmoAcimInpZ2FM9+2CjC6d3qEqytQpGCFFiFtEFN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809141; c=relaxed/simple;
	bh=Pdc6OGA946Jxx7Rkh31ux0KLIstfPAkdyY64wI5f5kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nm6dOJSh6onhiqFOzseJuJOpTuXH4dAES+J1hp76Z7MPzVIW8epmrmcpo2gK4Udmc6/D+Sd46SvTkVhHK3w8fdaEajG5gQLrHmzcJboe60kpB0PQCq10QlccF94ilJH/pWxKq6MWQBaC0EZgd7zPCjGVjuG/7PVf7Z7iv7NCCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mke8HHsy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mke8HHsy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bnm3l4Wotu6clEu8W9RqHwueSJ3YgaJS92hSxDVlctk=; b=Mke8HHsyYpc6U1nrLX5U6aNaX+
	uLPRNksjmNVHnDIIGjDIYv4SgE9+Hdm2YOwtH7udkU7EcP9NYhgEB/6FbBVpwZzpsMHGMV4eBIyH7
	iu5rrfljVJ47JKY26iuO1CyTTLsv1jDPU0h/dL7Gvqy3R88VCTJly0P3HCofJwLV6z/E9bnyj8hPF
	jDTiKLFPJjD04MNzd9b9P3XjxAvfDnm5izr7uKKGkgv+ChC5QF96/ePLfB3WujuEIwG5lxxlnoGtP
	BXgGvfhcxuf44uwKV7f6S0FEJYVGvVZ1P5y+YYOAwmD8xOW9kUTXtjFNlccUDZq0MRr9GJlujLcSX
	uSCaX+pA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsxX-0000000AIMN-3VhI;
	Tue, 10 Dec 2024 05:38:59 +0000
Date: Mon, 9 Dec 2024 21:38:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/50] xfs_repair: stop tracking duplicate RT extents
 with rtgroups
Message-ID: <Z1fT81WvNczywKBL@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752311.126362.6980632236757578255.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752311.126362.6980632236757578255.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:11:11PM -0800, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Nothing ever looks them up, so don't bother with tracking them by
> overloading the AG numbers.

This should probably also get folded into the main rtgroup repair patch.

