Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5342773C3
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757969479; cv=none; b=Bj5+3PmrdhvBZ2fN172dkG0mYUHHjjfjYS1b3mnDEVpbAwI6etk9W6/8/8rJ+lp7CFfK7KcbdhkwN5ngncgREtxOtHXXBZfkqCidMLb/B+o3kmnfLT8nutcz9HPhpBbVEWMPUZumZ0VLeK9vnaQwAFZOhtZr2OLZ4e6lZ1FjY6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757969479; c=relaxed/simple;
	bh=SkyIc955KAt9qlamPhYwL0n1OndilZg/1bMA1MA0udw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fISWTmmhXzx328bhmYCY8YasXy+AKSwf7bpqgt4ZA4kRVKA44TUM9+8WPPZ5k9998NCJYuCjX81lUCwGvvd7U3CR39a9/jU+aCcjiqeI7BgvX2jPkO/b1WeW/WRtVWJsq57dOfR4PjmZbYIkzGhDW6qZQmTYqLJTkKXw/P4lcZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 49CA068AA6; Mon, 15 Sep 2025 22:51:13 +0200 (CEST)
Date: Mon, 15 Sep 2025 22:51:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: use the XFS_ERRTAG macro to generate
 injection targets
Message-ID: <20250915205113.GC5650@lst.de>
References: <20250915133336.161352-1-hch@lst.de> <20250915133336.161352-3-hch@lst.de> <20250915191115.GZ8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915191115.GZ8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 15, 2025 at 12:11:15PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 15, 2025 at 06:33:17AM -0700, Christoph Hellwig wrote:
> > Use the new magic macro table provided by libxfs to autogenerate
> > the list of valid error injection targets.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> With this applied we no longer have to manually update inject.c every
> time we do a libxfs port too, right?

Exactly.

