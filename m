Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC2926AC3;
	Wed,  8 Apr 2026 20:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775678514; cv=none; b=l71eTdfGS0gOEvVfSqUXHFHrNtwJo1q4luK8E+fTE21izempPXaD0/l/S9Cjoen2OjA8bdNG6h+Mfo+cwIAddvQYGaNlS/eG+qauDhzJZ8RwfmT4VmcZrjXoiARxkYSFVed66s4eGBUTUQ3+LX/0wzezxcyO4udIu+QdNztdri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775678514; c=relaxed/simple;
	bh=80lBMjcV+pjw8m7JWX4mo3zR6ywBHZwOCAIGiKgZtn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaF9OL2q+4pUVB5OCN7hVSOVJG7nLYAZHJ4B2/ayYQKPqqUenscuOZFeFkJ9HucMvZwkwyL5f40zy7dJrP3XV9dvoZzkvoHUcUVrds4WwGjBiCrt3crWeiaFLRdIo73Xa4644FJ+hKPwyACfnfyXxdq8g1SVbBICWExtug5bRFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tPdDet7B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tPdDet7B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Z6y5mzwmAQdrf9oPiv/Zpc3+lv0vlBFnEYQxnmFeos=; b=tPdDet7BMdnQrWQfPC5mjFDQLl
	QHfwYh9hZk8gMelhgivq7Hiq1g1lESVcRAZnb/qv8pLIumyKzEzeW9anFdH+uOvX5TY1goULJ5sYJ
	J8KJSqCfJK9PX4jHbjgFmCfmocjCFq68BtBlckgK1kXbfJtV882MEhPF8b4g92/26aqz/O6PDkTUy
	4XRCsaF0xl73kGSTKilKC8fhXbVh7lXSVqllFfK5fT0dXCx354VnS7+wTiY18mr9m7kOLwnLqO1ny
	GRdgw0ss3YA0GicL3j1Kc76Gh7e0A43EcAOcvXF9KRRidW1IwMMtukya8oddIUIN53gBiSdVBY9Qw
	nvzXFI3w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZ5u-00000005sOg-3Nri;
	Wed, 08 Apr 2026 20:01:46 +0000
Date: Wed, 8 Apr 2026 21:01:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <ada0KnRjpYnY_QYh@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
 <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>

On Wed, Apr 08, 2026 at 03:44:37PM -0400, Tal Zussman wrote:
> On 3/25/26 4:21 PM, Matthew Wilcox wrote:
> > On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> >> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> >> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> >> context, where folio_end_dropbehind() can safely invalidate folios.
> >> 
> >> With the bio layer now handling task-context deferral generically, XFS
> >> no longer needs to route DONTCACHE ioends through its completion
> >> workqueue for page cache invalidation. Remove the DONTCACHE check from
> >> xfs_ioend_needs_wq_completion().
> >> 
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >> ---
> >>  fs/iomap/ioend.c  | 2 ++
> >>  fs/xfs/xfs_aops.c | 4 ----
> >>  2 files changed, 2 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> >> index e4d57cb969f1..6b8375d11cc0 100644
> >> --- a/fs/iomap/ioend.c
> >> +++ b/fs/iomap/ioend.c
> >> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
> >>  			       GFP_NOFS, &iomap_ioend_bioset);
> >>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
> >>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> >> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> >> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> >>  	wbc_init_bio(wpc->wbc, bio);
> >>  	wpc->nr_folios = 0;
> >>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> > 
> > Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> > 
> > 	if (folio_test_dropbehind(folio))
> > 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> > 
> > It'd need to move down a few lines in iomap_add_to_ioend() to after
> > bio_add_folio() succeeds.
> > 
> 
> Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
> IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
> no-merge behavior would be uglier than leaving it in.

But why was it added to NOMERGE in the first place?  I don't think it's
harmful to merge writeback I/Os which are COMPLETE_IN_TASK and I/Os
which are not, as long as the final I/O is completed in a task.
