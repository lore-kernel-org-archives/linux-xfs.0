Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C88DF46
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1C0c82wZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P991dVxJRv9FOZQj31gskjhQjwbWxZx/OUTLshGBCNs=; b=1C0c82wZ2JHYOmvAh6VtD14z2Q
	uW5aSVnrE1RNJP7y8+ACPXIn9pjLbN26M219FkRv693fHxpoKLqqFZEYIpvV1rz2XD8QF76aM9YZ4
	cg+yt6PXZSorKm+FZlXL5v8RJjDKmoMgVKu9acyiMmheMM70vz2DM7C2O3ZQ87sjTABjQ1ZUs34w3
	z2FDPnClMhsrDUJcAzStUm3wIPNEO8ZpJSbjS1lIotnthBSaeRt8+3bKrKzhxFn6BkQCletBXrzMG
	bDuLPSEl46p0DII5pL/AVxyIwcUXwVDn6EBCP/PmrlkurV79vc32dEEeuDbrspk15OoGe2PzRgX33
	rw6n6FSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKchl-007gSu-1g;
	Tue, 02 Jan 2024 11:13:05 +0000
Date: Tue, 2 Jan 2024 03:13:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: create a predicate to determine if two
 xfs_names are the same
Message-ID: <ZZPvwcT5x1AZAnzI@infradead.org>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827004.1747851.5152428546473219997.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827004.1747851.5152428546473219997.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:06:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a simple predicate to determine if two xfs_names are the same
> objects or have the exact same name.  The comparison is always case
> sensitive.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_dir2.h |    9 +++++++++
>  fs/xfs/scrub/dir.c       |    4 ++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 7d7cd8d808e4d..ac3c264402dda 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -24,6 +24,15 @@ struct xfs_dir3_icleaf_hdr;
>  extern const struct xfs_name	xfs_name_dotdot;
>  extern const struct xfs_name	xfs_name_dot;
>  
> +static inline bool
> +xfs_dir2_samename(
> +	const struct xfs_name	*n1,
> +	const struct xfs_name	*n2)
> +{
> +	return n1 == n2 || (n1->len == n2->len &&
> +			    !memcmp(n1->name, n2->name, n1->len));

Nit, but to me the formatting looks weird, why not:

	return n1 == n2 ||
		(n1->len == n2->len && !memcmp(n1->name, n2->name, n1->len));

Or even more verbose:

	if (n1 == n2)
		return true;
	if (n1->len != n2->len)
		return false;
	return !memcmp(n1->name, n2->name, n1->len);

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
