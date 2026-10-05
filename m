Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19074825A1;
	Mon,  5 Oct 2026 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205265; cv=none; b=uSoi26FYNxZ/PCThdkkDMEoYQ0fRikYKPzGEjS1sexFI2nV2ZUFMoyP60bdp4N3PMbN1s2bWFmlLmKkxJYB5014TJTmzqVMsMK0hN/DNRaSJieiGdfRPJFwh+FzfI++5MjRCYYROpaDA2eEA9+8ZwNd4arzWsc4nScGNiiTctD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205265; c=relaxed/simple;
	bh=a9i4OaXYqElH/+EvN3j20R1KtHQ317LrRoh5jufZb4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCtd+k7ggLWyFB7nfINxkKJ0TP1AutqHII1EpwIWJHq5vAa05YzcbOyrocmG7JIzgI34cJ7wXyInGTetZXa2wf8mdbfU13Q9+gdzYBzjoPh6EGgy/8WbUxczIFpbFe3kjplUdZTPbkdepe9/dCbCki9J08k16WpiYgcGdBU/iPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3DEEA68BFE; Mon,  5 Oct 2026 15:01:00 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:00:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: add support for writing with data checksums
Message-ID: <20261005130059.GB26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-16-hch@lst.de> <20260929010103.GW2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929010103.GW2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:01:03PM -0700, Darrick J. Wong wrote:
> > +	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
> > +		return blk_status_to_errno(bio->bi_status);
> > +	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
> > +		fs_bio_integrity_alloc(bio);
> > +	saved_iter = bio->bi_iter;
> > +	error = submit_bio_wait(bio);
> > +	if (bio_integrity(bio)) {
> > +		if (!error)
> > +			error = fs_bio_integrity_verify(bio, &saved_iter);
> > +		fs_bio_integrity_free(bio);
> > +	}
> > +	if (xfs_is_rtcsum_inode(ip))
> > +		error = xfs_rtcsum_verify_ioend(ioend, error);
> > +	return error;
> > +}
> 
> Hm, synchronous reads to pull in whatever unaligned parts of the
> pagecache aren't yet uptodate?

Yes.  Very similar to the generic version in
iomap_bio_read_folio_range_sync, but using an ioend and with all the
extra csum magic.

> It would be helpful to document this ordering dependency here explicitly
> for the benefit of code spelunkers in a few years.

I've added it with a minor edit.

