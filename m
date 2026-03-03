Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1913C6A52
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772556742; cv=none; b=oB42BRwyq+dM814DKLIfb3ZTKn9srAiuYMior8ab3DAevsrjyz39djDWKHj6nsfumr0ZL9pu6sxG204IKUlp4bN5xKmdH6D4MSCuMZg+AaSW949EsLRAId+eWrbjLgwb0my1rWu7z0V9pycPcL80S9TvcUZFJ8KVO26QVxP6ZO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772556742; c=relaxed/simple;
	bh=bDUG9uLgpVFsusRvyz3UeI4Y9nfMA62BArLgXuOkcvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMc1dMJfHusEG0L8TYxAxBfmXv24yt/NEHc0DZyveUEj8kuCc+xW4jyZ+d32DymGajowYqbwCjEi5Y3zO2ty9lmCJql8cKbkD/yww+3DHMgX7yQ8b1l9HzdrJTdMcuoVNORPE0h0eKwHtf5ZSVv6/NzKyeaRkNTIIm9ogUneJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTxMsnJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTxMsnJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41B8C2BCB1;
	Tue,  3 Mar 2026 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772556741;
	bh=bDUG9uLgpVFsusRvyz3UeI4Y9nfMA62BArLgXuOkcvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QTxMsnJrmJlhPC7eQGBLGUgPfp+aVIjr2V9fjjxYxVocVMzi0p4IkDtdJhHw37SjT
	 aY1UeOnu6kaoUaa5TmKy2d985CP1hmnvgiIt980KXUfcicL0/oCJeRZLsRzZ8DloVi
	 pUiHriSshcEhlDlEZorugJr0Xpz7ZOFHP8MLfFI7D+tLKhuLxlgQHmzjm+KxAGErNC
	 ikwuvtbxE9r7TxBmy7Dqa7DqYTx7IsuJx5zqAI06oeQgyHyKKFLQgrGWOfZa0dewkJ
	 NmGTnpfK36DGDsqtyFuT8lt0cWnDT1ojwf/PMQpr7jXp8ImPoi6bNIZBaqC4PU6CIv
	 Cs4ULzcBAq4qw==
Date: Tue, 3 Mar 2026 08:52:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <20260303165221.GK57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
 <aacDDXudwf9ygIkQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacDDXudwf9ygIkQ@infradead.org>

On Tue, Mar 03, 2026 at 07:49:33AM -0800, Christoph Hellwig wrote:
> > +/* Start healer services for existing XFS mounts. */
> > +static int
> > +start_existing_mounts(
> > +	int			mnt_ns_fd)
> > +{
> > +	struct mnt_id_req	req = {
> > +		.size		= sizeof(struct mnt_id_req),
> > +#ifdef HAVE_LISTMOUNT_NS_FD
> > +		.mnt_ns_fd	= mnt_ns_fd,
> > +#else
> > +		.spare		= mnt_ns_fd,
> > +#endif
> > +		.mnt_id		= LSMT_ROOT,
> > +	};
> > +	uint64_t		mnt_ids[32];
> > +	int			i;
> 
> 
> > +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {
> 
> Should this use a wrapper so we can switch to the type safe libc
> version once it becomes available?

What kind of wrapper?

static inline void
set_mnt_id_req_ns_fd(struct mnt_id_req *r, int mnt_ns_fd)
{
#ifdef HAVE_LISTMOUNT_NS_FD
	r->mnt_ns_fd = mnt_ns_fd;
#else
	r->spare = mnt_ns_fd;
#endif
}

or did you have something else in mind?  The manual page for listmount
says that glibc provides no wrapper[1].

--D

[1] https://www.man7.org/linux//man-pages/man2/listmount.2.html
