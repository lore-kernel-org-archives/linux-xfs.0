Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66AF381B0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706594779; cv=none; b=KTYjaRXm14uEnDAkxdwsuZsAMYv9yRmS8RASj8uq8FbzOZRpx92wGDa5Zk3viLuRTPfYLOfk9ZfRtxjR52KH5cLMXGrS0Le3VedjPDq/Bja252p8PH2eLvcImgQWud22KUncvNJKuYFptfmOodsBgrtTdSnCZgTg+Vz8HgCHRi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706594779; c=relaxed/simple;
	bh=fCWDrW/MO8sUcRYt7HbSjJpDpLkQSi/jGhn8thT5JyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLMUioIiZo9oEITk6Ecmb27bMjQagbWRUnEwBXPcDQ8/JAB9q2W2FZw98whgsgdDMEYhoRM4zeYQXBUzW5tOdumudHnnnRS8wnOqf20bxiIyTLwVxbQZiNM3PFAnuAJvFSsq+6mRHLlOZ51IHp6LeQ0X834sEpKUH0E0eDXEl5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X4oIRdRD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X4oIRdRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qj1qPrRLMrXb0cY3qIPZY4/0/j8flMAaDYZnRDTA0X0=; b=X4oIRdRDrH2UEAEUdVqX88/Zlx
	HfX/Q40ZuC7tk7XoFU4poXxjyBTzte2eV4rmXW0yUpHJ9iwAu627sJaawHh8LtDQF7SVneeEw233W
	LugxW60dsCkswuG3a8WmNFd3JrVT2DRMXJcOGv/THaLnqjlCDa2fVq7W+3BQlhxOcF310+lLbD8dp
	vFqUQHZWIS8i5/duREham1m5CHGJuWP0CSBudxwf9KKZ9kdzTKvaBCKz1+5oq+nluoWjlCyUztHQI
	sGK8YTH3OZmONDSWG844gRL3uw/7eELbU5JmS/rr4zy1Vkc9Nyq+OHp68WjQ6zZ0z9AZP4Ap5ObKK
	kaaShyLA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUhG8-0000000917b-3nav;
	Tue, 30 Jan 2024 06:06:12 +0000
Date: Tue, 30 Jan 2024 06:06:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/20] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <ZbiR1Jj0gwxAPVSA@casper.infradead.org>
References: <20240129143502.189370-1-hch@lst.de>
 <20240129143502.189370-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129143502.189370-8-hch@lst.de>

On Mon, Jan 29, 2024 at 03:34:49PM +0100, Christoph Hellwig wrote:
> Add a blurb that simply dirtying the folio will persist data for in-kernel
> shmem files.  This is what most of the callers already do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I noticed today that drivers/gpu/drm/i915/gem/i915_gem_shmem.c is
going to a lot of effort to call write_begin and write_end.  I'll
take that out as part of the shmem conversion to buffered_write_ops.
