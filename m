Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5FC47FB0C
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100638; cv=none; b=u+QSslriOL3h1XTRUPQCboLXNLfSOKZW1os5I8KLWItFFZQ/GLdy9qMmLeB9RouptWMoFgdB2SymOIBtqMi+qo4T0ASSTVlZuAeqvwqxvoaZ94krNukGpD+cvOckFtXAuVS/Z3d864FhRgtj4Q2UGXdbv5Dt01vMV12a6KQx2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100638; c=relaxed/simple;
	bh=i81vWbsbpqx0TMvft5vViWdGB+zkvWoYyOcslYtzwI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovBltcdolDpWKZ/zOm8MM/uwcehycKpWV48aAd/6Olb+51XCNuJiAYXMmVHtDEOM6YA/STPBPQui/kU72c+eOoCz3aAVSznfRvxAj9i6VbKRat5nrHZAcf3uPWF73/1CelXIPcxJrk0ZvciI4a+wejKUd0QA+gGWRU/dr4Hgi90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgBGx7Xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgBGx7Xh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0E7671F000FF;
	Tue, 22 Sep 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100637;
	bh=e0nbZ+LVwbkb4RYmChRiukonCk/iGqz64wro8WCqLZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bgBGx7Xhkg+/M0D3TKlWHcGH5PIyqrVgMcUJSAk2qc7GRFCJjF6um4IfXixHRstY9
	 woBVcJ+xHj/ANKopcEvuuWKzT7DDzHx7Ft0BBxeI5BEfItxl1rnNhxDzECZcfJ79/+
	 Q/XNf7QDypCyYceIYnjcdljseuIl9oZK+45q94WvSUQUzlQ102MVfm9AJz9rCaXPf2
	 nxzasX5RrpTvDCfCiMZHM8OJW7FJQ4mgRHvewpCXkcITfBQYGPxE7XarW+RHhWadxF
	 4cmdNe1aqmjOeGQ9U+pkEMrFwQzCptyDdizYjfS6AdlDIXstuP0bCa6Ibjs2nQbei6
	 qjgpAvv9BRV1Q==
Date: Tue, 22 Sep 2026 11:10:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfarray: warn against sorting arrays with
 identical elements
Message-ID: <20260922181036.GZ2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120850.181988.12177498355342705156.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120850.181988.12177498355342705156.stgit@frogsfrogsfrogs>

On Sun, Sep 20, 2026 at 11:18:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains about a potential underflow here if xfarray_qsort_push
> is called with lo==0.  However, this isn't possible in most cases
> because filesystem metadata records cannot be identical.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/xfarray.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 78274ad53097e1..ab15a73b7d3b10 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -693,6 +693,18 @@ xfarray_qsort_push(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/*
> +	 * Avoid the integer underflow below in (lo - 1).  This shouldn't
> +	 * be possible because the pivot is the median of nine distinct
> +	 * filesystem metadata records, so at least four records will be less
> +	 * than the pivot, which means the pivot will not be in the low end of
> +	 * the range by the time we get here.
> +	 */
> +	if (lo == 0) {
> +		ASSERT(lo != 0);
> +		return -EFSCORRUPTED;
> +	}

Shashiko has a big long comment:

"Can this assertion be triggered if a corrupted filesystem actually contains
identical elements, causing a denial of service?
Looking at the partition loop in xfarray_sort(), it uses a >= 0 check:
fs/xfs/scrub/xfarray.c:xfarray_sort() {
    ...
			while (xfarray_sort_cmp(si, p, pivot) >= 0 && lo < hi) {
				hi--;
    ...
}
If the array contains duplicate elements, the comparison returns 0, and hi is
decremented down to lo. Then xfarray_qsort_push() is called with the
unmodified lo.
If lo is 0, won't this trigger the new assertion and crash the kernel?
Furthermore, if lo > 0, does this cause linear stack growth and another crash?
Because hi was decremented down to lo, the left partition size calculation
underflows:
fs/xfs/scrub/xfarray.c:xfarray_qsort_push() {
    ...
	si_hi[si->stack_depth++] = lo - 1;
	/*
	 * Always start with the smaller of the two partitions to keep the
	 * amount of recursion in check.
	 */
	if (si_hi[si->stack_depth]     - si_lo[si->stack_depth] >
	    si_hi[si->stack_depth - 1] - si_lo[si->stack_depth - 1]) {
    ...
}
The left partition size calculated via (lo - 1) - lo underflows to a very
large unsigned value, bypassing the size optimization.
Will the algorithm then process the N-1 right partition first, pushing empty
left partitions to the stack until it hits max_stack_depth and fails via
the stack overflow assertion?
fs/xfs/scrub/xfarray.c:xfarray_qsort_push() {
	/* Check for stack overflows */
	if (si->stack_depth >= si->max_stack_depth - 1) {
		ASSERT(si->stack_depth < si->max_stack_depth - 1);
		return -EFSCORRUPTED;
	}
}"

To which I say that xfs isn't supposed to store duplicate elements in a
metadata structure, so repair code should never create duplicate
elements in a staging array.  We're not going to exhaustively verify
that for every repair since most repair code is structured so that it
can't create duplicate elements, but we can at least bail out when we
detect the obvious signs of this.

--D

> +
>  	si->max_stack_used = max_t(uint8_t, si->max_stack_used,
>  					    si->stack_depth + 2);
>  
> 
> 
