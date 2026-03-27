Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F2D2FF155;
	Fri, 27 Mar 2026 06:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774591405; cv=none; b=JRRrFkibYNqjy8IN9RCegD1elUDp5K0K58/jYoIAz9/RsLdxvguoW9WcttX1TasWHbhxnMAkA5qxmkihp7zOVV+8fPmGefUAwlfiwnqXeahD4TXYkVkW4+u0rOemRdtplSp0N8Vr6cpXmKQbUoqSUcxCZu3gBNTk5C0BAil1lN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774591405; c=relaxed/simple;
	bh=gLZml7dQQ76kXkfHsxfJsDVWJaTCa3UXJ23/NaSvdwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJQ9pjHClFaq3EzgQhZI9QRC0MTrXctfeKqH60gP3O3C+aYuENzXS+EEa0OhJgfvq4umGSVqKcbInUuhNdDX4lPHGAFLrXFCnx2uDriC0VVh/qT0WR8CVCtJjSk7jBH4Iv840swkqrGvxVhb68Iolsi6G9ayctdP9U6wUfRN9tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nNqIJz5O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nNqIJz5O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iv7k7jt4dplLesyfY+epqBGiPQNj+XYY7x/5mn5IrXQ=; b=nNqIJz5O/4su2NhB0ci8ATVbf9
	+UVEnolYQZjthdz8NSR3EzFfHpYMYcvH+/D8WrVJIa4xUIE8S5JaNXceG5QndLnnVDmKtwdI5hZ8i
	IbfB75jHd/wRHS3PVwSsol68iPinA0TqyNDduPvldYRkkh7qNt2+EzHCCr1KbyuLnKZKe/eJbY+OA
	s99wGstoT+wV+qMJemG1NHwJb5A/JMIlqqofcocgYUWce5eAVQLx8L7n0tRtSiK9ztC0SyOTQBpOa
	trM7SQqt5kuiGw3bRRPct79zkmgbXXfOOlfrgKUq0DM0PoTS1OTTBHHnsrG5FABCIecLdDRVImFh9
	uDRKOi5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Hy-00000006jhq-0TXU;
	Fri, 27 Mar 2026 06:03:22 +0000
Date: Thu, 26 Mar 2026 23:03:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYdqqe6sahnfH7c@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRDyJrkJhnHHMSe@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 25, 2026 at 08:21:28PM +0000, Matthew Wilcox wrote:
> > +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> > +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> >  	wbc_init_bio(wpc->wbc, bio);
> >  	wpc->nr_folios = 0;
> >  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> 
> Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> 
> 	if (folio_test_dropbehind(folio))
> 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> It'd need to move down a few lines in iomap_add_to_ioend() to after
> bio_add_folio() succeeds.

Yes, that sounds sensible.

