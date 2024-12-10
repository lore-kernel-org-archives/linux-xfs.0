Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A687822ACFF
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811447; cv=none; b=po+W7kVTlX+WVuvMo+V4qGHqmU69iHFbjvXMP9DbJjCCAi7KHNXNWHU4t3fnaC8K1LHVsNIji8UH4jsnoPa9OpTS9d69A2dsnhWf2+n+f/PZoC1i5oGgP6Bu0FI/nCk00h5wrR8iKFGVOW+BvrrSgSd0Lmyl9kgbu3/ShlgML7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811447; c=relaxed/simple;
	bh=Dgy0nbXzfTS4swDah9fWiPYmZO7ThC0wOgNA+F2nVxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqNpQ1PsHNw9EsE/jBpSNLgGZwOIlec0tHIPjODgVYySVrTAosiI2IIcX45W4J/sdruRO7V+sRF7JZCjGh95yrcfTaiLqvRnDiP0Cxmu5cyKcflpw5B5d///aO/wqxZjPtKrs4Zmoodx7HadguaTWi0zOCwSQEsFaLFSvQIqk5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iaq9vD30; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iaq9vD30"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m49ut5pwVAwwzyZbZVlLCUmZSxokjYGMELeqjdy2/Uc=; b=iaq9vD307r6G6E4oiQ0YzebYHn
	d94n9E5LPxXudaIuH98x1OZpGKF+WFmk3Xiv3xoN6q3IV5az773krxYBIP7d+7gX3hp7yZSVzSXDL
	DTltB3t8lAavhc/5EPm9mr0JVhjdeT7VGRGtovDmV79Ljb31T3Z5SeN/2aSMeDlHhPf8rrHa2CkQN
	gnqa9XIm4DYzQlYxgcxaG7yLP4BuddNbvglmuwuo5HHGrrgcSBm7EDJQYQQN46Ez8Z7wh+nUbjl5P
	YTrVvxPQMRXCEkeXYzhAJXsdCxCQMI6unz7OzoWnBnWI+HQjaK+IzZsfl3LnFoM1OMImtBHI8WnNH
	i8+M7zNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtYj-0000000AONY-1J7f;
	Tue, 10 Dec 2024 06:17:25 +0000
Date: Mon, 9 Dec 2024 22:17:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs_repair: support quota inodes in the metadata
 directory
Message-ID: <Z1fc9W4pd8lUIWEe@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753310.129683.8156547641009207395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753310.129683.8156547641009207395.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:19:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Handle quota inodes on metadir filesystems.

Maybe write a slightly longer commit log to explain what this means?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
