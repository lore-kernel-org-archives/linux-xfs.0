Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MujhbFC2"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E16CA3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 07:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kpRf+h+uPYhRm6aDovMPXqExvkIL7A88Mq3voh/PMrY=; b=MujhbFC2NxOtjF5WpI4UTiSaJC
	LNq09WS+pyRtfA/MZEPLlkDfN/5/6eoNCSsEZH4d5cCEjR13DtXUXIPRzTRFMxyIBv4H6kqmFgy/J
	bgR9U2vsxYhwQcvjfQsTElNVf+YAUsTZ53d8nXDQGgg4/qDyFGOqAs/aYBOGZO7VbKICSE3XB0vMA
	HqWQmkiyXBZnqcf5xxL2MvWEg2eNnRiT2sDV92cCU50u1im2N84h2YNV065BjqFFvIEDJh7vFUih6
	I1ZWTuWfNxFty7VQqP7eP7w6opuqZCvyrC48MDozyS6HF83AfVRZ1plXupfnutKIoaOTxRKwRaXdY
	kCNhNYpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r80Se-005kdB-2M;
	Tue, 28 Nov 2023 15:57:20 +0000
Date: Tue, 28 Nov 2023 07:57:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair inode btrees
Message-ID: <ZWYN4MvhQDhFWqHO@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This generally looks good to me.

A bunch of my superficial comments to the previous patch apply
here as well, but I'm not going to repeat them, but I have a bunch of
new just as nitpicky ones:

> +	uint64_t				realfree;
>  
> +	if (!xfs_inobt_issparse(irec->ir_holemask))
> +		realfree = irec->ir_free;
> +	else
> +		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);

Nit:

I'd write this as:


	uint64_t				realfree = irec->ir_free;

	if (xfs_inobt_issparse(irec->ir_holemask))
		realfree &= xfs_inobt_irec_to_allocmask(irec);
	return hweight64(realfree);

to simplify the logic a bit (and yes, I see the sniplet was just copied
out of an existing function).


> +/* Record extents that belong to inode btrees. */
> +STATIC int
> +xrep_ibt_walk_rmap(
> +	struct xfs_btree_cur		*cur,
> +	const struct xfs_rmap_irec	*rec,
> +	void				*priv)
> +{
> +	struct xrep_ibt			*ri = priv;
> +	struct xfs_mount		*mp = cur->bc_mp;
> +	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
> +	xfs_agblock_t			cluster_base;
> +	int				error = 0;
> +
> +	if (xchk_should_terminate(ri->sc, &error))
> +		return error;
> +
> +	if (rec->rm_owner == XFS_RMAP_OWN_INOBT)
> +		return xrep_ibt_record_old_btree_blocks(ri, rec);
> +
> +	/* Skip extents which are not owned by this inode and fork. */
> +	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
> +		return 0;

The "Skip extents.." comment is clearly wrong and looks like it got
here by accident.  And may ocaml-trained ind screams for a switch
statement and another helper for the rest of the functin body here:

	switch (rec->rm_owner) {
	case XFS_RMAP_OWN_INOBT:
		return xrep_ibt_record_old_btree_blocks(ri, rec);
	case XFS_RMAP_OWN_INODES:
		return xrep_ibt_record_inode_blocks(mp, ri, rec);
	default:
		return 0;
	
> +	/* If we have a record ready to go, add it to the array. */
> +	if (ri->rie.ir_startino == NULLAGINO)
> +		return 0;
> +
> +	return xrep_ibt_stash(ri);
> +}

Superficial, but having the logic inverted from the comment makes
my brain a little dizzy.  Anything again:

	if (ri->rie.ir_startino != NULLAGINO)
		error = xrep_ibt_stash(ri);

	return error;

?

> +/* Make sure the records do not overlap in inumber address space. */
> +STATIC int
> +xrep_ibt_check_startino(

Would xrep_ibt_check_overlap be a better name here?

