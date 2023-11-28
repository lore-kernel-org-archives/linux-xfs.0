Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j8ff7vBF"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D87D41
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 07:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AiexOOO4qBrbY2L6PSdPok3qxJEcIuiJ7d+SR7z2PcE=; b=j8ff7vBF7rGPDtXvWOtFCB4MUf
	gqWASSf0PmqZR4XiRmfllcHlERiRX1N6toPyzDrpwoQzVRadlqIXTNkGjeBGh/MD9VCr3xeRbFfQz
	eNROhWm0x6weoVbnVbqEfyf+r4HgdUIxBy5u4yqzGxIOdzSMzrh40V08oqbVi5qLR76Ljc8jRDvYM
	lGOUN+fjm4Xn6bpUmlRwOXoec9LezHrrNEq5TgWFUhCVrukvXa2PT1saE9ZfXk+gq8gzYsgBiE+Ge
	JNbG6Rtk4yW1nPZRNl75LRcg187zP9CaWq/CMkGVO+/J5JCP3ahZFhDU3gBMEFhyQ/Ai12sgV5XbZ
	ms3oF2fA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7zjl-005cvo-1P;
	Tue, 28 Nov 2023 15:10:57 +0000
Date: Tue, 28 Nov 2023 07:10:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <ZWYDASlIqLQvk9Wh@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A highlevel question on how blocks are (re)used here.

 - xrep_abt_find_freespace accounts the old allocbt blocks as freespace
   per the comment, although as far as I understand  the code in
   xrep_abt_walk_rmap the allocbt blocks aren't actually added to the
   free_records xfarray, but recorded into the old_allocbt_blocks
   bitmap (btw, why are we using different data structures for them?)
 - xrep_abt_reserve_space seems to allocate space for the new alloc
   btrees by popping the first entry of ->free_records until it has
   enough space.
 - what happens if the AG is so full and fragmented that we do not
   have space to create a second set of allocbts without tearing down
   the old ones first?

I've also got a whole bunch of nitpicks that mostly don't require an
immediate action and/or about existing code that just grows more users
here:

> +int
> +xrep_allocbt(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xrep_abt		*ra;
> +	struct xfs_mount	*mp = sc->mp;
> +	char			*descr;
> +	int			error;
> +
> +	/* We require the rmapbt to rebuild anything. */
> +	if (!xfs_has_rmapbt(mp))
> +		return -EOPNOTSUPP;

Shoudn't this be checked by the .has callback in struct xchk_meta_ops?

> +	/* Set up enough storage to handle maximally fragmented free space. */
> +	descr = xchk_xfile_ag_descr(sc, "free space records");
> +	error = xfarray_create(descr, mp->m_sb.sb_agblocks / 2,
> +			sizeof(struct xfs_alloc_rec_incore),
> +			&ra->free_records);
> +	kfree(descr);

Commenting on a new user of old code here, but why doesn't
xfarray_create simply take a format string so that we don't need the
separate allocatiom and kasprintf here?

> +	/*
> +	 * We must update sm_type temporarily so that the tree-to-tree cross
> +	 * reference checks will work in the correct direction, and also so
> +	 * that tracing will report correctly if there are more errors.
> +	 */
> +	sc->sm->sm_type = XFS_SCRUB_TYPE_BNOBT;
> +	error = xchk_bnobt(sc);

So xchk_bnobt is a tiny wrapper around xchk_allocbt, which is a small
wrapper around xchk_btree that basіally de-multiplex the argument
pass in by xchk_bnobt again.  This is existing code not newly added,
but the call chain looks a bit odd to me.


> +/*
> + * Add an extent to the new btree reservation pool.  Callers are required to
> + * reap this reservation manually if the repair is cancelled.  @pag must be a
> + * passive reference.
> + */
> +int
> +xrep_newbt_add_extent(
> +	struct xrep_newbt	*xnr,
> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_mount	*mp = xnr->sc->mp;
> +	struct xfs_alloc_arg	args = {
> +		.tp		= NULL, /* no autoreap */
> +		.oinfo		= xnr->oinfo,
> +		.fsbno		= XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno),
> +		.len		= len,
> +		.resv		= xnr->resv,
> +	};
> +
> +	return xrep_newbt_add_blocks(xnr, pag, &args);
> +}

I don't quite understand what this helper adds, and the _blocks vs
_extent naming is a bit confusing.


> +#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
> +	list_for_each_entry_safe((resv), (n), &(xnr)->resv_list, list)

I have to admit that I find the open code list_for_each_entry_safe
easier to follow than such wrappers.


> +/* Initialize all the btree cursors for an AG repair. */
> +void
> +xrep_ag_btcur_init(
> +	struct xfs_scrub	*sc,
> +	struct xchk_ag		*sa)
> +{

As far as I can tell this basically sets up cursors for all the
btrees except the one that we want to repair, and the one that
goes along with for the alloc and ialloc pairs?  Maybe just spell
that out for clarity.

