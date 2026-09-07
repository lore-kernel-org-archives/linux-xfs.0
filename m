Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F8372071;
	Mon,  7 Sep 2026 05:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760279; cv=none; b=LJ4uegTuNwyb1xCYc0syfol0g4Y2vqNUJ8vBMY/7UScIGNQQXdtvoQe+h8HykS0oz4T+mIbb71KO3ILIJOQu+TntydJCjQWB+G/wuwYyMQLep4pCqUNlj5yPMn2VAT2H8vDSwFnDlYymeBm7etov5FQIgcpPTPVga7w22Dm6BlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760279; c=relaxed/simple;
	bh=Ci5NtyhwS3oxdXOyb4+5nH7uQ1fWYVQ+PGdgWh8KXT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzL2x3GDYXKVvohfKZz6fWMf9KuEqU8vog6pY8PMWkMBQTM9mUy2MHbZ+aNle2mZAdbC6TByYZnfS8usdQ7WN/jy7lPXXRSQ1nV707RXQ2A+kvGH97Uj4DiRv8HyTFp//7M6V7T780rXg19iRoOtlTKVscAnosZyDVmtDxuioGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 28F6F68D05; Mon,  7 Sep 2026 07:51:14 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:51:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs: move PI generation into xfs_submit_zoned_bio
Message-ID: <20260907055113.GD31481@lst.de>
References: <20260831064010.2574896-1-hch@lst.de> <20260831064010.2574896-10-hch@lst.de> <64756fpdb36bljyx6zmlcgdhv6ksly6zfhua6ierzga2jd6bl7@wyz5ar4cbba6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64756fpdb36bljyx6zmlcgdhv6ksly6zfhua6ierzga2jd6bl7@wyz5ar4cbba6>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 11:52:21PM +0530, Anuj Gupta wrote:
> >  xfs_open_zone_free_rcu(
> > @@ -890,6 +891,8 @@ xfs_submit_zoned_bio(
> >  		xfs_mark_rtg_boundary(ioend);
> >  	}
> >  
> > +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> > +		fs_bio_integrity_generate(&ioend->io_bio);
> >  	submit_bio(&ioend->io_bio);
> 
> It seems to me that IOMAP_IOEND_INTEGRITY might never be set here. The
> zoned write iomaps in xfs_zoned_map_blocks() and
> xfs_zoned_direct_write_iomap_begin() do not set IOMAP_F_INTEGRITY based
> on bdev_has_integrity_csum(). Should both paths set it? I didn't have a
> zoned device to confirm this so this is just from a bit of code reading
> only.
> 
> This looks like a pre-existing bug from 6bbb4d96f797 ("xfs: support T10
> protection information") which can be fixed with something like this?

Yeah.  I'm pretty sure I had a fix for this in the queue, but it looks
like that got lost when rebasing on top of xfs_iomap_set_anon_write,
which itself came from a Sashiko review for a trivial bug when
setting this flag.

> [PATCH] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices
> 
> Neither xfs_zoned_map_blocks() nor xfs_zoned_direct_write_iomap_begin()
> sets IOMAP_F_INTEGRITY based on bdev_has_integrity_csum(), so PI
> generation is silently skipped for zoned writes on integrity-enabled
> devices. Add the check in both paths.

This seems to be against a tree that doens't have
xfs_iomap_set_anon_write yet.  I've rebased it on top of that and
added it to my queue (keeping your attribution).

