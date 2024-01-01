Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D809C38E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p0TTIqR6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XwXIVTaQHU9IVrNjjbFTwkTR7jIpe506NGsplbrLhD4=; b=p0TTIqR6mk/kRPE+/Dlao3VRYW
	bni1nnjl5WPC0YqQsxcY9jmtlgxgmE8sNdHQNH3UdKvY7bi5gjGQSgYOWvJ7LMuw8BBN1+2qWqfR8
	Cj1gOpJLXpgtGgG2H1+Hcrv2Wl4W8weKYrCy/2nmNYg6THv3Zo38UhF+hhNESBRLC/ZXakiclKSuF
	FmG5brpQkj6nSrQq3HDNVVISZRIhvpHvhb8Ju7Sp4Ri64QBrY4gelrVLOf1T+jJuuAvRJ4MeioP0d
	AMejQVxP1sZ5lJtb8DQOK7CKTLJXK0QmcvWIlC9cQasjOiza0zUExowZtj/UuxmQE6h9oB4mPOYfe
	KbDct8YA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rK612-008AYo-HE; Mon, 01 Jan 2024 00:18:48 +0000
Date: Mon, 1 Jan 2024 00:18:48 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
Message-ID: <ZZIE6P0aoVgAtONY@casper.infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>

On Sun, Dec 31, 2023 at 12:15:54PM -0800, Darrick J. Wong wrote:
> +/* Ensure that there is storage backing the given range. */
> +int
> +xfile_prealloc(
> +	struct xfile		*xf,
> +	loff_t			pos,
> +	u64			count)
> +{
> +	struct inode		*inode = file_inode(xf->file);
> +	struct address_space	*mapping = inode->i_mapping;
> +	const struct address_space_operations *aops = mapping->a_ops;
> +	struct page		*page = NULL;
> +	unsigned int		pflags;
> +	int			error = 0;
> +
> +	if (count > MAX_RW_COUNT)
> +		return -E2BIG;
> +	if (inode->i_sb->s_maxbytes - pos < count)
> +		return -EFBIG;
> +
> +	trace_xfile_prealloc(xf, pos, count);
> +
> +	pflags = memalloc_nofs_save();
> +	while (count > 0) {
> +		void		*fsdata = NULL;
> +		unsigned int	len;
> +		int		ret;
> +
> +		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> +
> +		/*
> +		 * We call write_begin directly here to avoid all the freezer
> +		 * protection lock-taking that happens in the normal path.
> +		 * shmem doesn't support fs freeze, but lockdep doesn't know
> +		 * that and will trip over that.
> +		 */
> +		error = aops->write_begin(NULL, mapping, pos, len, &page,
> +				&fsdata);
> +		if (error)
> +			break;
> +
> +		/*
> +		 * xfile pages must never be mapped into userspace, so we skip
> +		 * the dcache flush.  If the page is not uptodate, zero it to
> +		 * ensure we never go lacking for space here.
> +		 */
> +		if (!PageUptodate(page)) {
> +			void	*kaddr = kmap_local_page(page);
> +
> +			memset(kaddr, 0, PAGE_SIZE);
> +			SetPageUptodate(page);
> +			kunmap_local(kaddr);
> +		}

Does the xfiles implementation prevent THPs from being created?
If not, this could lead to an entire THP being marked uptodate even
though we've only zeroed one page of it.

