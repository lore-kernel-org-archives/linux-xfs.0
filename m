Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37D3644C9;
	Mon, 28 Sep 2026 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577460; cv=none; b=JafcGuK6oX1StNlWg+m+0zhSlu9QbCu7jXLnyjT6Ex10Cotxi1KnXhvsLNPUEShOTrNDo3p88ATYE5xY7hv95FNiVdtrsyGS3fw/4Y9DBLB2z6REeKwqBlvbSCT+bNqmGmdkSggHfcT/0G4iWLCkDS3R3ri2kmUI55fdu3wzxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577460; c=relaxed/simple;
	bh=KEma73ORU6ep/YE00L+z70M9iZFOIbRGWlLE8A9Ssro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx7QW+lIRlHHPk75ut6cHDgubbThKjyGi/wtOhzQvlKMCvTgNLiyq5Y39PCpzqjBQb+0m8MbGo5FmEpr+jZhwDAY/zbJLXM90VTQp3qnZPtIvq7Z3/nKpuM184WSbfp7QqhI3mZ+Gf92PEhfH4iZhah4aUj/xg4gZKavZeessCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OIGyXcib; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OIGyXcib"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c0gZA7FOHEHPd1dBItejNaSRuc9uwbkdH6ifw9EO+xo=; b=OIGyXcibwCAGTz4i1gUwBP4bWX
	q4/TUNlPKGTxWI7+uY+5X8NjUaDucCfl+3w8daL9Viz11v29Unsp/FzHijNqfLfMKDbhKT2LfKic7
	yLlwGAYH2ruoqi0PBqQpWBjO9zGVA2LcBhKBTspjRy88axDDC8LB9wZgsT7I1HQa8uNJivoB7ityb
	YdEcN47YVTG1z/LM1EBV9wdY8mr48GBZxF4QwEEdpWZnSai17b+FTHcjBevCXHatyQWCSEXEG7esR
	YkUvm6d1T4ne6ykEGjtrmczAoiFUf+pPE6hZ0rAuUOAyljxFk/0wJjOvnlS6YzErrloCXDLXPFlAM
	ES0wH3kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4zZ-0000000HSol-37QL;
	Mon, 28 Sep 2026 06:37:37 +0000
Date: Sun, 27 Sep 2026 23:37:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: improve dirent bounds checking in scrub and
 repair
Message-ID: <aroLMeT0OiY37AnN@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612639.479634.13348969749056583205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612639.479634.13348969749056583205.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:16:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that we don't do enough bounds checking of the directory
> entries in directory blocks when we're looking for errors or trying to
> salvage entries.  Let's improve that with more detailed checks.
> 
> Cc: <stable@vger.kernel.org> # v4.16
> Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/dir.c        |   56 +++++++++++++++++++++++++++++++++++++++++----
>  fs/xfs/scrub/dir_repair.c |   30 +++++++++++++++++++++++-
>  2 files changed, 79 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index a63eebf39fd496..dd21570378b281 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -340,6 +340,7 @@ xchk_dir_rec(
>  	xfs_dahash_t			hash;
>  	struct xfs_dir3_icleaf_hdr	hdr;
>  	unsigned int			tag;
> +	bool				foundit = false;
>  	int				error;
>  
>  	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
> @@ -390,22 +391,60 @@ xchk_dir_rec(
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
>  		goto out_relse;
>  	}
> -	for (;;) {
> +	while (iter_off < end) {

Nit: maybe move the iter_off initialization just above this for
clarify?

>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
> +		unsigned int			advance;
>  
> -		if (iter_off >= end) {
> +		/* must have freetag */
> +		if (iter_off + offsetof(struct xfs_dir2_data_unused, length) >= end) {

Overly long line.

In general it feels like the inner body would benefit from being
split into a helper for readability given how big it becomes.  That
would also ease deduplicating the xchk_fblock_set_corrupt calls.

