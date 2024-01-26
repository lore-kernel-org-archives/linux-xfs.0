Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC8C1CFB4
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706283916; cv=none; b=So4HTm6JrcX3/HPjXdthZHYBWAP2vI297T9zt8Urd7AGHi0ISKRTYCjnqzd5fvrWaGaPq5z4+/aDEBGTa/S7NyKUr093crhaCCYEOwTSO/a7umV3s3oAGVR5KLW83BLyKu7YIHxGpNCKXB8ipeJ+SHW6UZP7rwl7fuMWRl1CMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706283916; c=relaxed/simple;
	bh=We/kBSuSFD0aaegfo9j27nWpIkQ8Iyuvg17lJ+tp/eE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyGi+7qxtvkuRnEyQuACrP5ntcCVLT4/O6edStCxEOlU+pm2ZZ1Lsp6nqAK8wOrNsUokEN32PFKimhOwkV0wi5KQUhgqv1oYmZTZNbB0keK/2cqmtI19JByBneeHhSGT4sdNdJ6ysZzkx6o/K7HYDrh5OUbvEog563D1p/21ZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j5rGv95B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5rGv95B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ctT0oVk7vbvrzSkltK6S87WbOniGUNHGID+szVERiBo=; b=j5rGv95BWMbFXUnqE5fNw1m2RQ
	yuJapl+LVIcuoKMquVESVBd/SGJFOOqPo1DorrTFTXjuitU9WNMTMirM+2Zhg2vXqbksTnaFjGgIU
	R84Mqy8f2Aqa4mN5W18kH32/ZzLqUoe1Rmxyu3wQL7+hcHuPt72ur4IHGaL3mkYdTKXqdIejG685K
	g8MsQBs7ZUnSMW4ci5U7DvXiaHBmmJ3k3wSJqQi/z6/4RYCI2JfTI62k8GM+7Y1dtCvsiicehCyhM
	/X8xapM926uHbjkJ1Nx+PqKezzJuFMKv223mmepzZ0v4dkkqzZjpCLJXISVAzCe36fx3IeTkRmxzu
	dIzE0I9w==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTOOF-0000000E3v6-07Cv;
	Fri, 26 Jan 2024 15:45:11 +0000
Date: Fri, 26 Jan 2024 15:45:10 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/21] shmem: export shmem_kernel_file_setup
Message-ID: <ZbPThjwhjG6WITt8@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-7-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:48PM +0100, Christoph Hellwig wrote:
> XFS wants to use this for it's internal in-memory data structures and
> currently duplicates the functionality.  Export shmem_kernel_file_setup
> to allow XFS to switch over to using the proper kernel API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
