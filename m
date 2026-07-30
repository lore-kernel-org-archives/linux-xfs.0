Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAF242C4F8;
	Thu, 30 Jul 2026 12:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785412871; cv=none; b=acKf8ce/gZ8OZbBbE2LagPflE1tobZ8ELEvds+HTZRHKbwbKBYaO77ZrsdgRA2iL/GxdFwvrUd6jhtTa3WHjTX0quJ84FnDj2ScHIrY+qfuwLtOksNcUb+M6GG2vS4OTXIeXYIBbMnEMCJFmjzfAB+6u8auTToqaXyj23ouS8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785412871; c=relaxed/simple;
	bh=1yZOI8wIw/VNu8Ygr/+tkAvokVE2AMmq1nQCRFZqLzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXQqMXL8mMKIbhkoY3WFSsSHsiF352bWvI9/NCRyAdmLYo//D5Sk8PHLJje6lfb8HdW9Rl3ngR4ULFqRBxi4kxWUxOO7m4BuFhocsMw3Esn18L6VnlQOGTrYta5F2s6uQ8E3mvRFf+LFt2xHNMe0Gcppc4xZ6TcGtNBiWDKhdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tj4LlkDZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tj4LlkDZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rnppetcb2tfpWkLN16GLZ+CKN9eTsL7d4/gwEpcDIIs=; b=tj4LlkDZCWbgqwwRDdSYSxkZM6
	Rob0lX2Hz7g2wPGOaYEJyGDi8SRM1dR8kYWJ2w0q67EkW19EYPEDhJeP81nduUU42gnX63VGNi1ED
	pEuoYwlbZwVlHdqywVuDiA7uGI3Ks+ylzImoaLHMo1LlZREhxtiTLC/nzM2RtAxVcr7nB5AKD9Q3R
	NgvevoDDAbF+wRSQtVmo1bgBExBH5NvPprxvNB5dUnVDtOPoRm91W9g8/nRwVKPy3rEBzVO8n2gnO
	FqADlfoJ082zUvhtPLJo3Ms7apUuCsB+WXw8ikQKgeNtPIEhKZH5jc3OQC9OOISU3fdnL0YxKzy9s
	Eoasijxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpPRj-0000000APNj-06Lj;
	Thu, 30 Jul 2026 12:01:07 +0000
Date: Thu, 30 Jul 2026 05:01:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <ams9Agj_C0DhBF54@infradead.org>
References: <e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com>
 <amsBEVNnsYJjKGpK@infradead.org>
 <30f0bdfb-c8ee-4459-8137-773020960f7b@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f0bdfb-c8ee-4459-8137-773020960f7b@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 06:06:17PM +0930, Qu Wenruo wrote:
> > iomap generall expects extents to be block aligned, how do you end up
> > with non-aligned reporting here?
> 
> The dio read buffer is 2 pages (matching the 8K alignment), but only the
> first page is faulted in.
> 
> Furthermore btrfs has disabled page fault during dio read, so the 2nd page
> will not be faulted in.
> 
> Thus iov_iter_zero() only got to zero the first page.
> 
> Btrfs always returned a hole that is properly aligned, but as long as bs >
> ps, the page fault can always break in the middle, causing unaligned range.

Urgg, we really need to get rid of this nofault behavior rather sooner
than later.  But I think the iomap should always be fsblock alignment.
While we can support smaller I/O, the mapping should always be block
aligned.

