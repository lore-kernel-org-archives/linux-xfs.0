Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E52E46C4CD;
	Wed,  2 Sep 2026 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346068; cv=none; b=eDu6FnNnGgqcLl1QOvxRaIsMgPAuiR+FYbAlqjId3Kdr5h1q94a8V0g6T2dYNO5wFK4aktR22JfYMaXeEJY5HPgvzCMUaUhI4ml/yHeA7dBEqt/2if9ATVloSaF2PkF+Ns6qpIDjbvS0OgK5YrTy6TpCwMFSz2VAwuVqxbjwJH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346068; c=relaxed/simple;
	bh=T1eX0M1hUR91onB6YIMO4/r3htVRzHdZDrQE0+m3g/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjGlkGbZ4PwfBsq52v90PRWnj/AQVNkDu+CEhAmuI19h0dzixpcqdWp3RLy2M1KLgak5J4XJAcaZ5LsNLmBfCvpA0NqAUU+Hvn3n5oehWuoYdRp7gEhmOqI5eVvPUkXq5qkVaOUIeccW89r70nsY7B5Zm/yjIKSbQqxEZZB8e8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ECMn3hjr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ECMn3hjr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qt/W3DSxMQKIwG+yUDdW7Q2R2X7cicnF1/L0NrB0XIs=; b=ECMn3hjrfpjO+4jRc0BJUqRldG
	C8pEzEh7EAe2mFlZ6f4a2lleEZ7PEM+QsgJr346Sy8Fy/yhlby7UPNX3JhH1RG+Y5AglE0pJP1FQy
	wEj9lzPR40rM2WqAV0+LcLKb0PSBk/tMtNVuqB72N0v3kDMjMuem2dvLAxeuBxP+RsmhRb2ArqGUw
	5UgHEtIj9vrq/1vzPHMU3avyhWXV/1RKw9VnXlqJPiLcjnE2RnjlGo/miLnynKIaZ8l8J0zIKOg7r
	BY0TlTJCCVDapg6RVFC8yj5UgAK9J4pV2nD4kZYPaoKZv5FgVy8YG3V9NISPx/tukGxMyTiUVd8AV
	zHiq5Pow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1iV8-0000000EOUL-1SWG;
	Wed, 02 Sep 2026 10:47:30 +0000
Date: Wed, 2 Sep 2026 03:47:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: vbabka@kernel.org, hannes@cmpxchg.org, willy@infradead.org,
	abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, rvvandan@amazon.com, brauner@kernel.org,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
	ritesh.list@gmail.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <apf-wsCj_5QvAPcV@infradead.org>
References: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
 <20260827092100.3988386-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827092100.3988386-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 27, 2026 at 09:21:00AM +0000, Salvatore Dipietro wrote:
> 
> On Wed, Jul 22, 2026 at 02:35:00PM +0200, Vlastimil Babka (SUSE) wrote:
> > AFAICS both your v3 and the implemented Johannes' suggestion effectively
> > make all the compact_first logic dead code - at least for the intended THP
> > use case based on costly_order. It will only continue to do something for
> > the non-movable order>0  case. So that's a significant change which will not
> > show up in your results, but might affect other workloads (I'd expect mainly
> > by having fewer THPs).
> 
> Right - the change above modifies THP allocation requests as well. So instead
> of applying it to every costly __GFP_NORETRY allocation, I restrict it to
> callers that do not ask for __GFP_THISNODE. That leaves the local-node THP
> attempt untouched: the same bit pair is already tested further down the function 
> to bail out of the compact_first block (page_alloc.c:4899), and alloc_pages_mpol()
> sets both flags on the local-node-first attempt (mempolicy.c:2476-2478).
> 
> I tested this with my PostgreSQL workload on kernel v7.2-rc7 and results look good:
> 
> Baseline:       70,735 tps
> This version:  144,670 tps  (145,280 / 144,037 / 144,694)  +104.5%

This looks really nice.  Can you turn this into a formal patch?

