Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416BD471CE6
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250145; cv=none; b=JUGyxtY9qUX3J0qGw3cXiwnFFzmad/pW0qT4dXHR2ooABtMUXF1r4MlXSwytb3qW+uub50M2d+i3aLuIszBqQCOLE4huggAJ4rCrvWuG459JbTGv6HadwjQXqMp/NEThb42fuJbtGxsXlsJjiheN6EhyD+T4YWnquyJBo6O7DZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250145; c=relaxed/simple;
	bh=6NGdd87ZlxYUoaNCKxu6Lu6nAyPUy9tQxCGdf2NRMXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMeAHKa95bzJ/ePLhLZfga8154OdGViJ9iQ66hSDldQoFl+UYnMPZYEb5zXNwdFR+uSrCExQC9iRglsDokI4Oqtzx1JJpq6i01OnUN0R0c/HUMq2n73WNwdO7XzmcIdqSWzSg24GzK4og1lxeoHHvrjRojOTGp3Wy9lsbCtqxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44BE668C4E; Tue,  1 Sep 2026 10:08:51 +0200 (CEST)
Date: Tue, 1 Sep 2026 10:08:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: improve the fsmap man page entry
Message-ID: <20260901080850.GA22531@lst.de>
References: <20260831071152.2580927-1-hch@lst.de> <20260831144604.GE6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831144604.GE6072@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 31, 2026 at 07:46:04AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 31, 2026 at 10:11:52AM +0300, Christoph Hellwig wrote:
> > Improve documentation of the flags and optional arguments, and fix up
> > messed up formatting.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder if it's worth documenting that fsmap -l shows external
> log device mappings?

That would be a bad idea, because it doesn't actually support that
option (in for-next at least).
