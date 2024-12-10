Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E7879FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808951; cv=none; b=XuiWQldzasj9muigddAhCJ66IGYTx9YcoT1aJW5VQF/umwYpebJkZ7e9UlMGT7AerUIRWVJZ5tE6koIJ5gkDz6aVdTjTSUEzk4uGMiELKcNqOnchYhHaKWl7baTk3uRWetjWBEC1bnjf94HDXODKdE6YgXuq3igDEgY3kiRUKew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808951; c=relaxed/simple;
	bh=g8Sq9DZRezMfnb1a2CXzf0VDXw24g5FmrM/nNxvGnmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soRLZ4mVTYxGTb3FihdJALHgAYlCsoPWTbsg16GFZTpYhMdFcp9WloRr7aQFushPTE0Udzb8rJEioukq5NBvK3iOlN8N7c5bq3PkHzBHzYJBDv+09FVlEeaz6h+hmXJIcrjXOlwBo9OcHRMLvvIuUvy70ptgSrcSaBwo4ey9ywM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=05AAVKW1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="05AAVKW1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YPkZQ/03B1Px4octhp3nUCE1ZHxYBVuyBE65qDMrDp0=; b=05AAVKW1bI7S8RAju04rmYpRX+
	aoSK7ylPJUfNzrn3ViU+svR+pEKXjDtYz8uE7fudXvRPuRyJHOv3dpZfMOFq8+OL2UPRphcRq2k1j
	lzBJPRH2Pi+QDy1l0U1e5fDoe//CBaqKjPeOOYrBT8TIGI9MM+8EZsGOpSlbQxhCrbPE/kNoZQBHM
	CegzZNk86ldYFM5VUDGSKwSmJUniLW94aXe1HWMWfHiYtoUJaM8lRmS3p4ihEB82DiRuX4KddbVLr
	aWIgHSbM7LlzkYeSjaCGLT/khZzUG8Nyu5edUUc84grrydRzgPMgLyLkPcvytnx3pl4z46owJw5h3
	5DKftWuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsuU-0000000AI93-0gSJ;
	Tue, 10 Dec 2024 05:35:50 +0000
Date: Mon, 9 Dec 2024 21:35:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/50] xfs_repair: refactor offsetof+sizeof to offsetofend
Message-ID: <Z1fTNjcIi0EiH5fp@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752174.126362.1527723436037046190.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752174.126362.1527723436037046190.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:08:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace this open-coded logic with the kernel's offsetofend macro before
> we start adding more in the next patch.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

