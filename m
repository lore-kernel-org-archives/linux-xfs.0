Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEC1DE8A6
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063533; cv=none; b=TxmQ0UQ1mY2/qqqKr7hJDnEJrbstDRGJohs1C0oWDxZHnRagvok84EvRIqWTxU+Dfq0nVUnJ4EQ/vvDSV24zju7AAfCyFMmjVek8wJoqRNLEw211YObOJ15TYL6Xv+5no7Xrrhs//r18wYbaDx7DBuB+zNaZe3dMdx/zTW/ws1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063533; c=relaxed/simple;
	bh=6808FLM2Q+pGsemnP1t7W8cu7BZD8DcK8QDBghrC5zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2KsjDft0kxaBGo0LHsUU1YARRwNqBFDUF3cBp6hIscUEJRrFD811WMrzMTWIUoly+mFPp/mwRWeZnEYHmijUMpqmS5mLjgPMTlZuCqzYJcFsw5r2rasp4DU9DdMLE/c6mdQ1Eoi2KFIYzUdX/N/GYGdQwamMKJFjmk1rcS0Klw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27BBA68B05; Mon, 12 May 2025 17:25:26 +0200 (CEST)
Date: Mon, 12 May 2025 17:25:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mdrestore: don't allow restoring onto zoned block
 devices
Message-ID: <20250512152525.GA9425@lst.de>
References: <20250512131737.629337-1-hch@lst.de> <20250512151240.GE2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512151240.GE2701446@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 08:12:40AM -0700, Darrick J. Wong wrote:
> I wonder if there ought to be guards around blkzoned.h, but OTOH that
> seems to have been introduced in 4.9 around 8 years ago so maybe it's
> fine?

I think we're fine.  If not we'll also need to do this for mkfs and
repair anyway.

> /me is willing to go along with that if the maintainer is.  Meanwhile
> the code changes make sense so as long as there isn't some "set the
> write pointer to an arbitrary LBA" command that I missed,

There isn't.  It would have been really useful for testing, though..

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> since we wouldn't be mdrestoring user file data to the zoned section,
> right?

Well, mdrestore can't even restore user data :)

