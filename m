Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793683502;
	b=1shywyPK7nP+Oh3rP4CCPORmvNOOYxwPxFq82AdS3psQhegV/pMbTUYbuwHV4f6FkoaC
	 LHuBOy6vKg3Dl0to3FeWrJEiQ13V6VH6pBa04lpvCz3cRyDi9MyA9EPoZT54RR9eFdXyV
	 xfK3LwlaEe5EGKJJyyTmyvw2YZE8/ceI6/XGcfsqGB3y0zoc3hCbYmKJX/n/FwrQOJCgm
	 Q95naX0qHQatPFZRNiORKTuDk8+7HBFbQSU2cRcZTkjazuQSNglBiM7QfOp59HWGArMDT
	 Me6f8U+K7CwLEky+JN6b3hvbaK6GCUPsnl1/Jk/YMvDgLcLEBgE0HP9N9COdU8cFcVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793683502;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=4RjCt2HcFSTcGsbIlTTEtnHofJhlvmBhXGpSDkKK+VI=;
	b=me0OuqmNeXLb4DBntJOK4NHzuNxcmdRNZik9VMyxJycy5zF/upA7+Yb992S5SUqTUU3t
	 V2cq8nx+2deFAPIRxGzuH8+nzENFJylT81g/ZxzYL3BkwNhFlM+ciZTxlfrjIT8HDthtj
	 IkLubAQsNGlS0TUaUf3Mc4DyCLnWVvNGBN0P83rfAQvftnPTds7FzuDWqsCU72/nruMni
	 KVML6FOVeL2XMQcyr63huvLTeQUoU9j1r/y6gaq/ybHa05RvtHLVL94aJ5GmWazf/w9gy
	 4aVIQ2bl9rQwFmtAcWj6Wc1y21U8on/odvC1eoNyMECUCDK21xxJw9+jIucA+wfWbbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yAuyI4ev;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F4E606A324
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 05:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37F4E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yAuyI4ev
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4RjCt2HcFSTcGsbIlTTEtnHofJhlvmBhXGpSDkKK+VI=; b=yAuyI4evXFMILvcM8++RC9TgT4
	XZGDoBP5VHWCCXnF4ijodHDJwWhzblTZuiE2wx8KsVD/to/5slaGfWiL9+kc0QM/VB8saVlVp4lB7
	4OkUfkA5L6wnEoUwYhm4G4r6ju+8N6SxvTbllmynI0zVXz6DNXvoGhqPcC6logExC6BBCuQka567n
	MvFe9aaXRFUhoxk/w8tEajUFtQZ+dH1mUTqXzmMC7epA+lF0YcCa0h8gEm//JKs8QqJ5co1swWOjK
	lVvo1W0Lym3gysyU1x45Wi2j/SA714cACf6sgRZjx7Yf6YOCWnM6BxcUfgB1MNVlEXHeEMJKy+AUd
	Bm+lmh6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO712-000000018Fs-1I3t;
	Tue, 03 Nov 2026 05:25:00 +0000
Date: Mon, 2 Nov 2026 21:25:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lauri Gates <lauri.gates@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <aulwLCnibXfaMzR_@infradead.org>
References: <20261102193533.93690-1-lauri.gates@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102193533.93690-1-lauri.gates@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Lauri,

On Mon, Nov 02, 2026 at 09:32:45PM +0200, Lauri Gates wrote:
> Hi,
> 
> FIEMAP on files with XFS_DIFLAG2_REFLINK set does not scale across
> threads. For every written extent, xfs_read_iomap_begin() calls
> xfs_reflink_trim_around_shared() (IOMAP_REPORT), which goes to
> xfs_reflink_find_shared() and reads the AGF of the extent's AG with
> xfs_alloc_read_agf(pag, NULL, 0, &agbp). Concurrent callers queue on
> that buffer's b_sema. A parallel du-style scan of a reflinked tree
> stops scaling at roughly the AG count, and threads working in the same
> AG run slower than one thread alone.

FIEMAP is purely a debug interface for file system developers.  So
running it in parallel for lots of files is highly unexpected and
suggests a misuse of the interface.

> My question, in more detail at the end: does reporting the shared flag
> for FIEMAP need the AGF buffer locked?

It needs to protect against agf_refcount_level changing, so yes.
In theory it would be fine with a shared lock on the AGF buffer if
we had a shared/exclusive lock on the buffers (which is something
I've wondered about a few times before), or some other high-level
synchronization against adding more reflinks.

> I ran into this adding a shared-block mode to dust, a du clone, which
> FIEMAPs every file and counts FIEMAP_EXTENT_SHARED extents once.
> Inodes without the reflink flag return early and are unaffected.

Ok, so this is the use case.  The more efficient way to do this
would be to subtract the multiple mapped extents based on the
refcount btree, i.e.

	for each AG (and RTG with rtreflink):
		for each entry in the (rt)refcountbt:
			subtract rc_blockcount * (rc_refcount - 1);

We'd need a new ioctl for that, but it should be pretty easy.
The major downside is that this only works for whole-device du,
but then also any other version would have a really hard time figuring
out what to do with reflinks the span the reported/not reported
boundary.

> I am not suggesting dropping the flag. Commit 5f9268ca53ac ("xfs:
> don't bother looking at the refcount tree for reads") kept
> IOMAP_REPORT on the refcount lookup deliberately, and Dave described
> the shared flag as a field diagnostic for reflinked files:
> https://lore.kernel.org/all/20210124214346.GC4626@dread.disaster.area/

IOMAP_REPORT/FIEMAP reporting the shared flag is probably exactly what
your tool relies on...

