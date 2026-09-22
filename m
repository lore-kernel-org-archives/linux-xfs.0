Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548B41D110;
	Tue, 22 Sep 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790099595; cv=none; b=SGQphsDXvOKlzW0UdpPcnC2TQsEyvF400vqvmNoGlrLP91eO8MGDhnPxH/C1ObItwkq6uk2xawZprpFDEZnjsZwoGRM77Ua9WGalFeZLxsP3ew0174ZWqpcUXr+KYBBeqveGbxzUoTskCKgYFmBVxCBUPiCfhKdwaJ5uLoqlZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790099595; c=relaxed/simple;
	bh=N1s1xykM9udH9D1Q7vI6ohgS3hen/bOXe2eF5Lo6LNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doB+kvbxWoDrdI0ADqsAgYORSDzLuCRCqmbJfZlGlSl3QCjkuMrv52TVJmyfh/41oji42RLtzS3SDY62rCZxp/oCZRpy21hYFpLwFL9oarSNcQSdrnHwq02vqXUXAXUeVOBm/fElv/sfAXw8n5vibXyyqEKjXyLTub5Z/PzfxO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cW3kT+Tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cW3kT+Tt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E19D1F000FF;
	Tue, 22 Sep 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790099594;
	bh=AOUvqYrzkVQeE0zJHncPX0TuL47fg1J7H0yhLQP1Guw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cW3kT+TtGAAwLmTLQA6fbGqZiryG5hmYP96PeQjKGRO0/r7h6XlK7LLYgoA6H6o8h
	 bGjencKVEjH2qZzHFKaTjVT7YT9LlQt2jWgE/sAQQctznzhxt7bssGFDfjbGuzM+Pq
	 fL+WA0dMg0qiksoCGgL0yl6g9lB6pnoxuhRkN5TdGWvuiR9VQtKKK8CdRbfZ0S3mfu
	 kJ1CkZjodx27S44Lb+cdDE16VTohUE4UcuAZXjCEK6d0sRJ54Yr9/GpmKyRPhlwmEA
	 zxghUsQNzfsp90nWevEeMRleDwG1SeqbukMxINs8qQ19uVxppjbXWrdScoh/7/SYwI
	 0PmyHBBWkZtkw==
Date: Tue, 22 Sep 2026 10:53:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfarray: don't crash when sorting if array element
 crosses a folio
Message-ID: <20260922175313.GW2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120763.181988.2563798655569721557.stgit@frogsfrogsfrogs>
 <arIQntfRrNKGHyoF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIQntfRrNKGHyoF@infradead.org>

On Mon, Sep 21, 2026 at 10:22:38PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:17:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM points out that if an array element crosses a folio boundary,
> > xfile_get_folio returns a NULL folio pointer.  If this happens,
> > si->folio is also set to NULL, and calling folio_pos/folio_address will
> > just crash the kernel.  Teach this function to handle this condition by
> > falling back to reading the array element into scratchpad memory.
> > 
> > Cc: <stable@vger.kernel.org> # v6.6
> > Fixes: cf36f4f64c2d4e ("xfs: cache pages used for xfarray quicksort convergence")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > ---
> >  fs/xfs/scrub/xfarray.c |   18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> > index 2ce24bfe4c0fab..30a58e9d4378e4 100644
> > --- a/fs/xfs/scrub/xfarray.c
> > +++ b/fs/xfs/scrub/xfarray.c
> > @@ -830,22 +830,24 @@ xfarray_sort_scan(
> >  			return PTR_ERR(folio);
> >  		si->folio = folio;
> >  
> > -		si->first_folio_idx = xfarray_idx(si->array,
> > -				folio_pos(si->folio) + si->array->obj_size - 1);
> > +		if (si->folio) {
> > +			si->first_folio_idx = xfarray_idx(si->array,
> > +					folio_pos(si->folio) + si->array->obj_size - 1);
> 
> Overly long line.
> 
> > +			if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
> 
> Another one.
> 
> > +	if (!si->folio || idx < si->first_folio_idx || idx > si->last_folio_idx) {
> 
> And one more.

On second glance, I think a cleaner way to fix this is to move the logic
that loads the folio, computes the new {first,last}_folio_idx, and
validates them into a new helper:

static int
xfarray_sort_load_folio(
	struct xfarray_sortinfo	*si,
	xfarray_idx_t		idx,
	loff_t			idx_pos)
{
	struct folio		*folio;
	loff_t			next_pos;

	folio = xfile_get_folio(si->array->xfile, idx_pos, si->array->obj_size,
			XFILE_ALLOC);
	if (IS_ERR(folio))
		return PTR_ERR(folio);
	si->folio = folio;

	/* No folio?  Get the caller to read into the scratchpad. */
	if (!si->folio)
		return 0;

	si->first_folio_idx = xfarray_idx(si->array,
			folio_pos(si->folio) + si->array->obj_size - 1);

	next_pos = folio_next_pos(si->folio);
	si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
	if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
		si->last_folio_idx--;

	/*
	 * If this folio still doesn't cover the desired element, it must cross
	 * a folio boundary.  Get the caller to read into the scratchpad.
	 */
	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
		xfarray_sort_scan_done(si);
		return 0;
	}

	trace_xfarray_sort_scan(si, idx);
	return 0;
}

--D
