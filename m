Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E79EAC7
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 20:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757969328; cv=none; b=a+yipqkRmpKBAvIdk9ClItp+GN0aQE12Txnl1iO3Om9fVHFKhQKqN2VgSxUu//EmJFKlwUQOQiEeXN0nrZZS7daqmhMZvysBPxN45YnyEtUNjBih3Tp21GCHYlzy+Y+1DSL5cgKhcz4IJVQdHjXUbQEzN6fGaug2UscxAqoWLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757969328; c=relaxed/simple;
	bh=il3bg2PPRdChbv56g1K28vzt/bg8C0o6h4coZmGHrfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhtZjaxXR8LESfP2vTsf+6b//l6ZAlExQPV3cktLf7XRYxvkZeyQxQlH28/UQUhXJq7amVLj/pFHIh6BiEGwnetghY9s95OXH494JgaJoGdHsdPcsNAXHNsFOu9II6DCw2g9+exOZvFW3HPJjRI+k+zyXwPTHDfNc02nGbKEeHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8334768AA6; Mon, 15 Sep 2025 22:48:35 +0200 (CEST)
Date: Mon, 15 Sep 2025 22:48:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: move the XLOG_REG_ constants out of
 xfs_log_format.h
Message-ID: <20250915204835.GA5650@lst.de>
References: <20250915132413.159877-1-hch@lst.de> <20250915182732.GR8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915182732.GR8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 15, 2025 at 11:27:32AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 15, 2025 at 06:24:13AM -0700, Christoph Hellwig wrote:
> > These are purely in-memory values and not used at all in xfsprogs.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, but why not move struct xfs_log_iovec as well?  It's also not
> part of the ondisk log format.

I have a separate series that includes the move, but I might as well
send that now.

