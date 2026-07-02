Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF603064A9;
	Thu,  2 Jul 2026 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002913; cv=none; b=NiE4GLSnHjAoaP1u6hvGXY8vujVbvt3idhrsDb69M1OYbuuhTrcobHHD1daXR2wUbs+eCFl8flNAwwc1Voawn8QkO2cRB64xQwttLL6ltrg6sQnmuKT0hvRY7LNOmysVG9O/6LfpUkn0M6HXYRZhde+qELQWZiEOZGzg2JEi1qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002913; c=relaxed/simple;
	bh=1kt65DLagGhNp/iUjH0uj7X1gzNt+47tLoAEEWQZCS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQz3E+xcCqQicklHtU+4tVd5vbf6nAVCaz15u6+P1ZG276fnlnnMDNKZGjMpmPA85GBmcUOp3GdXFjuUsDVKD9gPy3MedVM/Rx93Q/eR2yNhH805kq7CSREHgdmz+HMyeIVPorLS9kEKRdV7jd+p7+Kn7uGLxmVs75+RcrUZaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rX6Rw1lk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rX6Rw1lk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pA0CM8Fc6UjjQDncsUNFaetCTuExU5mBuGyBr7HKc+A=; b=rX6Rw1lk8+aoWYNntLbjZAQUJp
	Ev2/yNrDaWdg3+phQNEgEIWrO82gV9GYQaGD+MPS+LVzHCwFKM40SW/h3+yVkcbEuy1pQiAWB4a7a
	8xKfQ9UMB/KF8pyAOFCKQrVWuTl3tTreFklAu6A/rgcgOICXVE3YpPGuVGQ0BB2ra9cr7Bx0KvScE
	257INZ9oH0Wkuv+CvWsnhzHmbzW6w9u2JQ/p3LDBEXPCES7j1T0hbZcTBKBH/dFFESWcURpxZI+bM
	FGYjZFpqwWU5Uzwna1Eu47jGuMGZWLMsOp2v2Ig4EsOFRV4/OkAnkUuAisqD7ScV7lWC5pJ05HrO2
	eQCoxo7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfIVM-00000004dkW-2BD0;
	Thu, 02 Jul 2026 14:35:04 +0000
Date: Thu, 2 Jul 2026 07:35:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Fengnan Chang <changfengnan@bytedance.com>, brauner@kernel.org,
	djwong@kernel.org, ojaswin@linux.ibm.com, dgc@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	lidiangang@bytedance.com, pankaj.raghav@linux.dev,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
Message-ID: <akZ3GErzJSTtOn-H@infradead.org>
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com>
 <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 12:35:24PM -0700, Joanne Koong wrote:
> I think it ends up being pretty simple to get it integrated since
> ->iomap_next already contains the logic to only begin the mapping at
> the start and only finish the mapping when the iter has been fully
> consumed, eg

I wonder if this adds overhead that the simple path removed.

As a first step we could look into inlining iomap_iter_advance as it
is pretty trivial, and iomap_iter once the legacy path is gone.

If it still shows overhead for that (I think we'll want Fengnan in the
loop to benchmark that), we could look into a 'need end' flag in the
iter and allow to skip the call to iomap_iter_advance and iomap_iter
if it set.  Although I'd be happier if we could avoid that..

Talking about iomap_next - I also wonder iwe should move everything
that isn't the call to ->iter_next into iomap_process, which would
remove any calling overhead for ->iter_next itself.
