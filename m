Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P3q8ckhb"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CCA10F4
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 21:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WdDJMqLXuQaCSeU1lJGikmIMpjYXsfcOU4nxS3tiP+s=; b=P3q8ckhbm3cGIak8w1aRwj6LQg
	tG2yQcgGbJNZfLaMPB1PgugxODy0GWKumayyYEqrrVwLSIHSHV65SU6sbeal2eiQKbH8ibTRVloyI
	5okqOVPRoeNvlMwJf9h15H5wHP2SWLpjpVrHpSdKIuLQdphRFs3cyL/WyP0et+/TAAlp3qZNY31h+
	W0a/HxsCUWtObxMq9rcnRF7csqtfQo9+Ivr36w0bF+xyPbsuPOhsIdcP4CzXWUZTXSnlDlyVEOgfD
	LjdxdIbPb2tx/Ykn5F5MCV31dV/5MQNQRrm99yqfrxNpEYCO4vRAp4kFXTF7PXBuyQcMapkt8SL0k
	0TV60lRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8DZD-0078ba-1H;
	Wed, 29 Nov 2023 05:56:59 +0000
Date: Tue, 28 Nov 2023 21:56:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <ZWbSq7591xG1I+SQ@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWYDASlIqLQvk9Wh@infradead.org>
 <20231128211358.GB4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128211358.GB4167244@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 01:13:58PM -0800, Darrick J. Wong wrote:
> >  - xrep_abt_find_freespace accounts the old allocbt blocks as freespace
> >    per the comment, although as far as I understand  the code in
> >    xrep_abt_walk_rmap the allocbt blocks aren't actually added to the
> >    free_records xfarray, but recorded into the old_allocbt_blocks
> >    bitmap (btw, why are we using different data structures for them?)
> 
> The old free space btree blocks are tracked via old_allocbt_blocks so
> that we can reap the space after committing the new btree roots.

Yes, I got that from the code.  But I'm a bit confused about the
comment treating the old allocbt blocks as free space, while the code
doesn't.  Or I guess the confusion is that we really have two slightly
different notions of "free space":

  1) the space we try to build the trees for
  2) the space used as free space to us for the trees

The old allocbt blocks are part of 1 but not of 2.

> >  - what happens if the AG is so full and fragmented that we do not
> >    have space to create a second set of allocbts without tearing down
> >    the old ones first?
> 
> xrep_abt_reserve_space returns -ENOSPC, so we throw away all the incore
> records and throw the errno out to userspace.  Across all the btree
> rebuilding code, the block reservation step happens as the very last
> thing before we start writing btree blocks, so it's still possible to
> back out cleanly.

But that means we can't repair the allocation btrees for this case.

> > > +	/* We require the rmapbt to rebuild anything. */
> > > +	if (!xfs_has_rmapbt(mp))
> > > +		return -EOPNOTSUPP;
> > 
> > Shoudn't this be checked by the .has callback in struct xchk_meta_ops?
> 
> No.  Checking doesn't require the rmapbt because all we do is walk the
> bnobt/cntbt records and cross-reference them with whatever metadata we
> can find.

Oh, and .has applies to both checking and repairing.  Gt it.

> This wrapper simplifes the interface to xrep_newbt_add_blocks so that
> external callers don't have to know which magic values of xfs_alloc_arg
> are actually used by xrep_newbt_add_blocks and therefore need to be set.
> 
> For all the other repair functions, they have to allocate space from the
> free space btree, so xrep_newbt_add_blocks is passed the full
> _alloc_args as returned by the allocator to xrep_newbt_alloc_ag_blocks.

Ok.  Maybe throw in a comment that it just is a convenience wrapper?
