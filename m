Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47403E5585
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492927; cv=none; b=DLJyx9F0JybfCQz7daUQ2n5zMqT0kJtHqnOFqLmz3rOQu4UmQqBuoa3UWJXbRJsZVvoSpvdyGUgNCC4zxWOf9PaTnpfI1/HEVYP6+hqflC/bVW4L3Nai5qoa5HNYnOgG9euJtcuwTKC7TgTCiAv2zSA4YY7ypXskX0UKOgQMDgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492927; c=relaxed/simple;
	bh=fBWrSS/m+USePhYZg3H3IwIl7kI8HF4swV5HTwcZnmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=giBzCXpBOypraPhR5MimtCQn7NYMO9tn7xwyK6aTHO5udWtrssBEwDJJXLHI/UIFT3ZV/rEGVp4sIAft0tOHSxx6yQx2BC4FKSKUf8w9/lPkAERVt/cWJYuIXmWVqPdfmdpHoyGAEUIoLfOKF+ClO6oVYmdEQ7dvHUyD4LN3YF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4CeYAuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4CeYAuC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4BD051F00A3A;
	Fri, 26 Jun 2026 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782492926;
	bh=lnzavlRtAow+8UCuH+z9k5b8zCezsspp0XfD0s71EXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j4CeYAuCP69kEkcNO9GRk9VG5tmST9RIh85Q0ZULt2IDShPvSJT4U0eGHEXiTsnWx
	 TmgekISakCqVpEQSP9JSuy1t5ms9FHAvvlKA8U8Kkie8PemWpmjDN+q+AIk7OT+mpA
	 sCAzqk0oGKhgVldbejbxYQbUotsM4NvISgjGDMbk4mDA6yFPJ1eYToIFwy9OtKWDYg
	 sTZn/5xHUftj2x7ipDwfuBkJrg8uHXLmJIe950oL//fikoJ5BQ/pCzQeZhvpsz2wwd
	 47SSsdsxb4fsQGaEiufZzN9m1kNEx25aUDccfC7496Op8g+pgeryOEK2euadRoxl6H
	 Q0vBgV4lHPTuw==
Date: Fri, 26 Jun 2026 09:55:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_scrub: fix estimate of work items for phase 4
Message-ID: <20260626165525.GY6078@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
 <178242801396.1981574.2199805727145890150.stgit@frogsfrogsfrogs>
 <20260626050426.GE8786@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260626050426.GE8786@lst.de>

On Fri, Jun 26, 2026 at 07:04:26AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 03:55:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Codex complains that the number of work items computed when estimating
> > the amount of work for phase 4 doesn't include the FSCOUNTERS and
> > QUOTACHECK items.  Add them back in.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  scrub/phase4.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > 
> > diff --git a/scrub/phase4.c b/scrub/phase4.c
> > index 6bd16c23939eb4..744fd92ab195f4 100644
> > --- a/scrub/phase4.c
> > +++ b/scrub/phase4.c
> > @@ -297,6 +297,10 @@ phase4_estimate(
> >  	need_fixing = action_list_length(ctx->fs_repair_list) +
> >  		      action_list_length(ctx->file_repair_list);
> >  
> > +	/* fscounters and quotacheck */
> > +	if (need_fixing)
> > +		need_fixing += 2;
> > +
> 
> This matches the commit message, but there does this come from?
> Why are fscountれrs and quotachck special?

They're run explicitly by phase4_func so that repairs don't fail with
ENOSPC or EDQUOT if the summary counters (or quota usage numbers) are
wrong.  How about I expand on this in the comments?

phase4_func:

	/*
	 * Check the resource usage counters early.  Normally we do this
	 * during phase 7, but some of the cross-referencing requires
	 * fairly accurate summary counters.  Check and try to repair
	 * them now to minimize the chance that repairs of primary
	 * metadata fail due to secondary metadata or ENOSPC on broken
	 * counters.  If repairs fails, we'll come back during phase 7.
	 */
	scrub_item_init_fs(&sri);
	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_FSCOUNTERS);

and:

	/*
	 * Try to fix the quota usage counts so that online repair
	 * doesn't fail with EDQUOT (or worse shut down the fs) due to
	 * bad counts.
	 */
	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK)
		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_QUOTACHECK);

phase4_estimate:

	/*
	 * fscounters and quotacheck are run directly by phase4_func
	 * independent of the repair lists, so put that in the item
	 * count.  See phase4_func for why.
	 */
	if (need_fixing)
		need_fixing += 2;

How does that sound?

--D
