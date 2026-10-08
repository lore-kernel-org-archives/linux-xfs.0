Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B613C7E1D;
	Thu,  8 Oct 2026 12:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461019; cv=none; b=imcrtDcTHF9sIDWGa+JBCXvoTtDwbc/4Ybdy+BOtZvGdxAK/4W8ZdJvpFQV1oHAD5kyHCTplHZxjCWK7JHqcD4ukVX4Vw5ctTxtCG49wyKdGcq3szjvh7HfkEVGx90Lmr75jNCUTGQ0ADA5Xae3KGG9yZru/lTVWWTpaywa6vNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461019; c=relaxed/simple;
	bh=ZRL7swpMYev/IGrqGPY2Z1m9/+85TsTz+wvBvbYtBl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeugABV/Ti44z1nCAPsY8Jp0n9H2JlSP7R4ik8y3/wUzoT3CiYzjM1MDzi0NIACAY+0rC7hLh806K7GhXV9Da0tlEdz7LW4x0wDQpr7BprP9cFAPz/X3esB8WrUhm+VVYXkbWftQIja5zX320wu7KpgmrXfa1BBeNtJqQtMttU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NKLMNARF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NKLMNARF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YRtUHC5jYjLBDeC8WmszAZYV6DOm3Vb5LZ+Nnnx0n3w=; b=NKLMNARFxQJgUcjmU5Er3OSuzV
	ql/P0YL8ZKFnuBY4TRGDENBKrk9JorZhG0T1rVq4lYuq5qSf01c674S8cFniLureZVJUjQ7FPigO7
	YJaBwDmVuD6yB7013y4u+LutmWHT4Kbiol6TxBguGDEGqwWVGgPcaXpUwermmCxHgeQN4tOaXKjlX
	Ow1mGhLP8Ll8AjQfP2gX3IXUiSOwRM5zyNeBnUkS8z4AQV7Qc1sxPh5hJ2Vxs45GmRw3itSWjkET4
	WOyOngiqdBAz+KTp91SyPgGYsTbEq9JmZkQ4++5V3EKBa/I2OG4xzxndcHNAKi0mCVF0uorFEJIjd
	yIGFjq6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmqY-00000004Jd8-0spU;
	Thu, 08 Oct 2026 12:03:38 +0000
Date: Thu, 8 Oct 2026 05:03:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: check for buffer overruns when examining
 local/remote xattr entries
Message-ID: <aseGmj8np-ovaiuh@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521472.2728617.17391389777619283843.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521472.2728617.17391389777619283843.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:57:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the xattr scrub and repair code can walk off the end
> of the buffer if the xattr entry record starts so close to the end of
> the buffer that there's not even space for the entry structure itself.
> Strengthen the bounds checking here.
> 
> Cc: <stable@vger.kernel.org> # v4.15
> Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/attr.c        |   12 ++++++++++++
>  fs/xfs/scrub/attr_repair.c |   16 ++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 842d65834afbc9..4ce7299060fbba 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -335,6 +335,12 @@ xchk_xattr_entry(
>  	/* Check the name information. */
>  	if (ent->flags & XFS_ATTR_LOCAL) {
>  		lentry = xfs_attr3_leaf_name_local(leaf, idx);
> +		name_end = (char *)lentry +
> +				offsetof(struct xfs_attr_leaf_name_local, nameval[0]);

Overly long line.

> +		if (name_end > buf_end) {
> +			xchk_da_set_corrupt(ds, level);
> +			return;
> +		}
>  		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
>  				be16_to_cpu(lentry->valuelen));
>  		name_end = (char *)lentry + namesize;
> @@ -342,6 +348,12 @@ xchk_xattr_entry(
>  			xchk_da_set_corrupt(ds, level);
>  	} else {
>  		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
> +		name_end = (char *)rentry +
> +				offsetof(struct xfs_attr_leaf_name_remote, name[0]);

Same here.

Can you split the local vs remote code into separate helpers as
that would really help with readability here?

Also for this long type names just using typeof might be nicer than
spelling out the type.
