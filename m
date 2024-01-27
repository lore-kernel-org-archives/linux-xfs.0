Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671F1635
	for <linux-xfs@vger.kernel.org>; Sat, 27 Jan 2024 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706317805; cv=none; b=iB0mC6aRzxYbek1lPhgCmHYttYhlUB0ObEx6lOqLWuBpcQul/9Ob+QNCLmGolRvZmBnA5v/iGzUU7Z38gBFuE70w3qDi8jhBfA0PuK4CDP2rqUtV6/0D/IhOfO3cIxGWRid48mA2fkLroukdWYAvzyu+kTl9i+YhfrhqjlIQnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706317805; c=relaxed/simple;
	bh=jRkNZivR9XS9e66FnV/2rJlprMiWcGV2L93LQs1NKOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/ifvlbgr/s5UjsLZ6JJkKDmmWbCLqo9amM64dQg++zqRYJxXniCmifI5f+QLP7eltatFw5YAsFn/NkhsjpdmaAoQPZxDwbI7dAgJmymaonVlBU1LoUWxLwAv7g4dMwlw4Il/Y9qaj1eS99BwAg6hK1zju3gmCC2KrzZRSOve1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EVA6yrb0; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EVA6yrb0"
Date: Fri, 26 Jan 2024 20:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706317799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5Z+zvrj4aAqrEptlwLOzGsTYdIUNZGmOXG9NolY9xU=;
	b=EVA6yrb0r4Oo0JFSNJKemqFJjEa+G0m1jAh5LXa3UtcljI9C3g6Hs6QVSyKwVOBZGWRd+9
	pq819wlAAwOxY9As7LtgqWrllYrtuvUExfjcP7UAcxkd5j4FPxnmzCDmSY469KzbwrZY+2
	TttwVlbrK4807d7qnuLJbNrKpYFfa7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 20/21] xfs: convert xfarray_pagesort to deal with large
 folios
Message-ID: <zy6enk6gzao3fhndowsavzok7mxeasefupjvgp2bn2nb5rthfi@mjon6gpxrjh2>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-21-hch@lst.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 26, 2024 at 02:29:02PM +0100, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Convert xfarray_pagesort to handle large folios by introducing a new
> xfile_get_folio routine that can return a folio of arbitrary size, and
> using heapsort on the full folio.  This also corrects an off-by-one bug
> in the calculation of len in xfarray_pagesort that was papered over by
> xfarray_want_pagesort.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

not the fastest way this could be done - but it was performance tested
and according to Darrick was only 2x slower than the "use a normal sort
routine on a contiguously mapped buffer" version, which really isn't
that bad. So -

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
