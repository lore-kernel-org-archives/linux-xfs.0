Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D61B963
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706278553; cv=none; b=NhN+jo7MAyoEkcR3dge2BZKqCx595FmyLnResaMvbCS9ioht6TAh+u7jnMN72gKwuI1cVn3CnlinlNFebM1nCiItZbV0ibFkBlilPDRbPfoMCCt4DOTr6qRAQzMyUkb9uxZl/uhjp+e7vDD2ZnuhuSpNd9dFxEqlV5OVVod5vB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706278553; c=relaxed/simple;
	bh=ytTWUuOUtHDBuRgXhgm7AWGJvUfZuwrcbAO7OHvMz8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aklJ8ZQZFrDEfK+acnOEirZJlYKrId0sdtugTQUzxH+eEQw/qWJA14ag+C1WyCkOplcuXiP03DV72t7xswGdjvPIqQkwOZAZp4TCVVUr34uALd7vJxQuo9c/1UPnZ/vkaK0uBmIqtKOyO4AhpWV6j1snHUfzaghSv8mvik7LrSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VmbzXhku; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VmbzXhku"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lCHm6glD5bpRm5gIuN7QlDUHqu736MGenBOlzRNfVEs=; b=VmbzXhkuXe+tclPmWymAUt3nUA
	5TWXCaTc3oBVYSjrYwTebFl9dZjAbTyfbjc4lMIHXWFakuw8ID9HqkcaBbwL8ctFULUnDt4lRqB53
	6o/B8shOCnhVWEge7rkyrbGG3YC2005m1VzvsK3PDRUN9NF3HALVtAK4+eXsJitK5+VqvfWGPxJEC
	8mNzNNacKve8uq3LHz6kC2sUlkTR4tFGHFBKCoC0UVqCX06Wg3emssDtAjJICAErJ7dPliOy73ISI
	jHf0pgQJ7D3xHwdYYJsMOq1AuGePZN2crOg30rd3TvtW6XfcgXUzCJYMVRjUEF0JQIJS5xzyiN4Q6
	L4z3DRbw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMzg-0000000DpOU-1tUK;
	Fri, 26 Jan 2024 14:15:44 +0000
Date: Fri, 26 Jan 2024 14:15:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v2
Message-ID: <ZbO-kMfwhg1TAGn5@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:42PM +0100, Christoph Hellwig wrote:
> One thing I don't really like yet is that xfile is still based on
> folios and not pages.  The main stumbling block for that is the
> mess around the hwpoison flag - that one still is per-file and not
> per-folio, and shmem checks it weirdly often and not really in

hwpoison is per page not per file.  That's intrinsic to, well, hardware
poison, it affects an entire page (I'd love to support sub-page poison,
but not enough to spend my time working on memory-poison.c).

In general, I think there's a lack of understanding of hwpoison, and
I include myself in that.  Mostly I blame Intel for this; limiting the
hardware support to the higher end machines means that most of us just
don't care about it.

Why even bother checking for hwpoison in xfiles?  If you have flaky
hardware, well, maybe there's a reason you're having to fsck, and crashing
during a fsck might encourage the user to replace their hardware with
stuff that works.

