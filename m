Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3461741A575
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100465; cv=none; b=bDJFrtzU+fsy9zDXlm1/ZnggsxW9eD9FUz0odVfoT5o+kx2FtISfh8jXUIb5hH/nV9bGsTHUpJCsNPx1X/97mtA5DD63CGf9s1xcKK89QIwFXpA4wfhj2ja+1Ulw2pZfC9QlDyyYjZNpH5U+ofOouE9mMCM1Lay2KMREE5C4ArE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100465; c=relaxed/simple;
	bh=Lf9Lj0ihCS7kcy1o6fJLX2IywbHCEMdg7wbI9QPcpsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJmDs4wlUCyg30p52tr8l7DY/p2JUd3MF7nLAQuflT+wzgIb5Fu60YlGtD06P5mwf3CjsQUfzc3HBlxPd7uqW4zUe/TZoa2pNrY/2MJXOtLztBw4XT75drljdaNJO7yAZdmFkl3DeTGCTMeB+Zy1wXESJQNsODYVUuOfwkJ+fgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khDzKDvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khDzKDvi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3DCFB1F000FF;
	Tue, 22 Sep 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100463;
	bh=ojoF2Ifd7pfpN0oa4sMtxLlShZcUi0Hye51kRHb7R9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=khDzKDviH1Y8Oh6NQjEkpKvB02NkUSwD2nO2bNUhpVmedEOWW8QZIT6xKyq77HGoT
	 oJo6+m5qSTN8MWXYMQYuCA7gqjJg5BO46gcHub733cwOchnvYhu3Ml3SevTR0FTcgb
	 Ksf6QU9R0ahCwzO/ZHjt20l+1CJQG20SnDYxdUrAC7vkiyLybRgIHt1SkO9Xut/m//
	 dgBeh7AeXWxaYfMPOXhFXF4129Zw9sRgdac2kdsJP0wuzl3fRkeKYkhCc5AxmSbApO
	 F9Ifeq2YhGPqX+EonakbEIHbTOAtcRv+YS92MIUS5bo8vrTNVyusvUaMUXPG1PysMT
	 4lX470QZwllZQ==
Date: Tue, 22 Sep 2026 11:07:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: don't allow sorting sparse arrays
Message-ID: <20260922180742.GY2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120807.181988.9510302652927544095.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120807.181988.9510302652927544095.stgit@frogsfrogsfrogs>

On Sun, Sep 20, 2026 at 11:18:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've reduced the functionality of xfarray_unset, let's add a
> new safeguard: no sorting of xfarrays with sparse holes in them.  It's
> not clear what that even means, and nobody actually does this, so we're
> really just eliminating subtle logic bombs.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/xfarray.h |    3 +++
>  fs/xfs/scrub/xfarray.c |   11 +++++++++++
>  2 files changed, 14 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
> index d55225c7885b25..05ff65b09fcf41 100644
> --- a/fs/xfs/scrub/xfarray.h
> +++ b/fs/xfs/scrub/xfarray.h
> @@ -32,6 +32,9 @@ struct xfarray {
>  
>  	/* log2 of array element size, if possible. */
>  	int		obj_size_log;
> +
> +	/* Might there be sparse holes in this array? */
> +	bool		possibly_sparse;
>  };
>  
>  int xfarray_create(const char *descr, unsigned long long required_capacity,
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index ee3f0bf87433f1..78274ad53097e1 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -193,6 +193,8 @@ xfarray_store(
>  	if (ret)
>  		return ret;
>  
> +	if (idx > array->nr)
> +		array->possibly_sparse = true;
>  	array->nr = max(array->nr, idx + 1);
>  	return 0;
>  }
> @@ -844,6 +846,14 @@ xfarray_sort(
>  		return 0;
>  	if (array->nr >= QSORT_MAX_RECS)
>  		return -E2BIG;
> +	if (array->possibly_sparse) {
> +		/*
> +		 * What does it mean to sort an array with holes in it?
> +		 * Currently none of the users need this ability.
> +		 */
> +		ASSERT(array->possibly_sparse);

Shashiko says:

"Will this assertion always evaluate to true?
Since it is located inside the if (array->possibly_sparse) block, it acts
as a no-op instead of catching sparse array sorting in debug builds. Should
this be ASSERT(!array->possibly_sparse) before the condition, or ASSERT(0)
inside it?"

Yes.  The logic is backwards.  Will fix.

> +		return -EINVAL;
> +	}
>  
>  	error = xfarray_sortinfo_alloc(array, cmp_fn, flags, &si);
>  	if (error)
> @@ -997,4 +1007,5 @@ xfarray_truncate(
>  {
>  	xfile_discard(array->xfile, 0, MAX_LFS_FILESIZE);
>  	array->nr = 0;
> +	array->possibly_sparse = false;
>  }

"Since the new possibly_sparse flag is cleared here when the array is
truncated to 0 elements, does xfarray_trim() need a similar update?
Looking at fs/xfs/scrub/xfarray.c:xfarray_trim(), it can also reduce
the array to 0 elements:
int
xfarray_trim(
	struct xfarray		*array,
	unsigned long long	nr)
{
	if (nr > array->nr)
		return -ENODATA;
	array->nr -= nr;
	xfile_discard(array->xfile, xfarray_pos(array, array->nr),
			MAX_LFS_FILESIZE);
	return 0;
}
If an array is sparse, completely trimmed to 0 elements via
xfarray_trim(array, array->nr), and then populated densely, it appears
the possibly_sparse flag would remain true. Could this cause future
calls to xfarray_sort() on the dense array to fail with a spurious
-EINVAL?"

Yes, the trim function needs it too.  Nobody does that, but I agree not
to leave a logic bomb.

--D
