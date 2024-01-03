Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0044B110D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2rRJVwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728B9C433C8;
	Wed,  3 Jan 2024 02:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704247490;
	bh=lUhEAP++kW1tZ/+ps07VSSdAkJoZ3sIPyTQpOafV0Tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2rRJVwntCC0ZU2MngmFPmxoo4b0B5ZfH26fpU2aGFLILEdSbF5R4NdU9wrAgAqIA
	 BasX5lee2gddt4vOaCQNnc/AwoA0/Cj0RdhSJdVvBhi73QUR1hGKGH98NyjpiJWPe3
	 Zt0j+eozxx1dAsI7GG7dABm5C8kB2i/+4f4/tw2X8imrRiG1GEqDvNLrWdPJeJDOgV
	 L2/YtmOgJBPV4KlQuRt/oB06L939d13LYbbgDuB0A9Cx3XPKhJmlZNsKCD2Fb9aXAT
	 NiuG7WvyXV/tGmUuP6SF0eFFxWMcoTo7DRFSyEt/OPb1qjXFhl3ejMyBgbNnMpnFLp
	 V4QDTDLVtw7og==
Date: Tue, 2 Jan 2024 18:04:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
Message-ID: <20240103020449.GJ361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
 <ZZIE6P0aoVgAtONY@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZIE6P0aoVgAtONY@casper.infradead.org>

On Mon, Jan 01, 2024 at 12:18:48AM +0000, Matthew Wilcox wrote:
> On Sun, Dec 31, 2023 at 12:15:54PM -0800, Darrick J. Wong wrote:
> > +/* Ensure that there is storage backing the given range. */
> > +int
> > +xfile_prealloc(
> > +	struct xfile		*xf,
> > +	loff_t			pos,
> > +	u64			count)
> > +{
> > +	struct inode		*inode = file_inode(xf->file);
> > +	struct address_space	*mapping = inode->i_mapping;
> > +	const struct address_space_operations *aops = mapping->a_ops;
> > +	struct page		*page = NULL;
> > +	unsigned int		pflags;
> > +	int			error = 0;
> > +
> > +	if (count > MAX_RW_COUNT)
> > +		return -E2BIG;
> > +	if (inode->i_sb->s_maxbytes - pos < count)
> > +		return -EFBIG;
> > +
> > +	trace_xfile_prealloc(xf, pos, count);
> > +
> > +	pflags = memalloc_nofs_save();
> > +	while (count > 0) {
> > +		void		*fsdata = NULL;
> > +		unsigned int	len;
> > +		int		ret;
> > +
> > +		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> > +
> > +		/*
> > +		 * We call write_begin directly here to avoid all the freezer
> > +		 * protection lock-taking that happens in the normal path.
> > +		 * shmem doesn't support fs freeze, but lockdep doesn't know
> > +		 * that and will trip over that.
> > +		 */
> > +		error = aops->write_begin(NULL, mapping, pos, len, &page,
> > +				&fsdata);
> > +		if (error)
> > +			break;
> > +
> > +		/*
> > +		 * xfile pages must never be mapped into userspace, so we skip
> > +		 * the dcache flush.  If the page is not uptodate, zero it to
> > +		 * ensure we never go lacking for space here.
> > +		 */
> > +		if (!PageUptodate(page)) {
> > +			void	*kaddr = kmap_local_page(page);
> > +
> > +			memset(kaddr, 0, PAGE_SIZE);
> > +			SetPageUptodate(page);
> > +			kunmap_local(kaddr);
> > +		}
> 
> Does the xfiles implementation prevent THPs from being created?
> If not, this could lead to an entire THP being marked uptodate even
> though we've only zeroed one page of it.

No.  How does one prevent THPs from being created for a specific tmpfs
file?  It's probably time you and I burned a 1x1 on straightening out
some of xfile.c's folio-idiocy. ;)

--D
