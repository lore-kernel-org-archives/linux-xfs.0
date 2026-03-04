Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99963282F36;
	Wed,  4 Mar 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772630005; cv=none; b=uIyx2nUqTghfR4xXa5JEG2eZqzDo2tkGWASUDBrrXhBZxLWPO2VGRCOF0iEOdULrDEj2Iig83hDxzhsR21wlHYjC064xRk6++vGB2wosoRRKTzMfFQ1HgAgZSt545pYEeO3BTSKn57OrTdK2v4q+7k38Lu/NcfN2VJPR6CQuiZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772630005; c=relaxed/simple;
	bh=Ls0LHZ/5oXEpQTytc/7ck7m+ueyYpYyZI0RkBNmS47I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUclUUMat9bWJFWwpb9LrfoNQYfTWyn95J3m97/JScqjBYAgCBUS6xivzEebmgqjG/z8FD5btFRPagvQXfnHs2S3CQi3s6WcJIMzbD9WFvOYQEmUuh+O8jAdgeMlOGf3apPonC5/S4VzGXM79kBgC/M+ZpiqeKttDkmxodcSI7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tTdOIIQB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tTdOIIQB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nsxL+MVdoZB92+Ib9wHHlAdry0G0XLnTsowYixoSNTc=; b=tTdOIIQBOQeR4eagY8LGkif++p
	pIbFKC5nHq7qKPPbtbQ22ouM+vf5OACAYVoXyi964YPT6YF0/LQHrJtTa02axhY++PTT2OLJfjwII
	6s8BZKA/GnS0WrQMmFZcFaPA9ZPzZpce0VZbzr0A97flFevNJ4Mh4dwLPq2hMREyyrA41xcXiYUQx
	ugfhuX+BGAk9Nb9YX8mqjEcqhLi9tuPFKrZxIPla+Rp5E2ZQKZuNuv/zJFKFhVtFdKcunzDqaRWQj
	aK5/cEm/cH2ajz9H5tatzrW0ciWT1ewqUcp9grYh4TlKOYfI95geK+i7o+PbBJeO9s0aN/QWvJnun
	ZeX9RW+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxm2V-0000000HEVy-1g9m;
	Wed, 04 Mar 2026 13:13:24 +0000
Date: Wed, 4 Mar 2026 05:13:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aagv8y96vGHvbOdX@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <aY6_eqkIrMkOr039@infradead.org>
 <aY9hY7TwgMXJNzkI@bfoster>
 <aaXesgEmu46X7OwD@bfoster>
 <aabyFY0l7GTEHnoQ@infradead.org>
 <aacv39AZ5P9ubOZ5@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacv39AZ5P9ubOZ5@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 02:00:47PM -0500, Brian Foster wrote:
> Oh I see. If I follow the high level flow here, zoned mode always writes
> through COW fork delalloc, and then writeback appears to remove the
> delalloc mapping and then does whatever physical zone allocation magic
> further down in the submission path. So there are no unwritten extents
> nor COW fork preallocation as far as I can tell.

Yes.

> I think that actually means the IOMAP_ZERO logic for the zoned
> iomap_begin handler is slightly wrong as it is. I was originally
> thinking this was just another COW fork prealloc situation, but in
> actuality it looks like zoned mode intentionally creates this COW fork
> blocks over data fork hole scenario on first write to a previously
> unallocated file range.

Yes.

> IOMAP_ZERO returns a hole whenever one exists in the data fork, so that
> means we're not properly reporting a data mapping up until the range is
> allocated in the data fork (i.e. writeback occurs at least once). The
> reason this has worked is presumably because iomap does the flush when
> the range of a reported hole is dirty, so it retries the mapping lookup

Yeah.

> So the fix I posted works just the same.. lifting the flush just
> preserves how things work today. But I think what this means is that we
> should also be able to rework zoned mode IOMAP_ZERO handling to require
> neither the flush nor dirty folio lookup. It should be able to return a
> mapping to zero if blocks exist in either fork (allocating to COW fork
> if necessary), otherwise report a hole.

Yeah.  If there still is a delalloc mapping in the COW fork we could
actually steal that for zeroing.

