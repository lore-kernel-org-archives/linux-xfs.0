Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D8A14E2CF
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559197; cv=none; b=huNWw8LTkSk01556XDgh0ZwbK3OIDrmCaD1kuIdv/U0te+6+jGXEZzEGvQeaXc4fVV58CM3aRvlFhK468lS6whk91iEjBksdFFuNDXqOGV1bTsRCkrCLMmShgciHHO8vhLR166HtmsOpS9CeHZLpTKmeLOCClq10zOwMmU5dd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559197; c=relaxed/simple;
	bh=W6VKwgBnQL3zhrk+8BUG3zhp0aQGKgcB/yTj22OIdVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmInJ24OqHVTWvmjoHPViPeVyFOCenBr9Ij/eLpTta0qz2vhFS1SpBebzU9rkkjExDq5JwJtYGMo4znJJWAFfSbTwSt6MZdB5daI2Kl42N2iL6CHlqWOn/QIm+4GVuWNvY8z3HcqKmUE3MKFCPowKeXLz6v7XUwBRb2/7yLARCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE79E68B05; Wed, 27 Mar 2024 18:06:32 +0100 (CET)
Date: Wed, 27 Mar 2024 18:06:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240327170632.GC32019@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-5-hch@lst.de> <20240327150755.GX6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327150755.GX6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 08:07:55AM -0700, Darrick J. Wong wrote:
> How does it happen that xfs_rtfree_blocks gets called more than once in
> the same transaction?  Is that simply the effect of xfs_bunmapi_range
> and xfs_unmap_exten calling __xfs_bunmapi with
> nextents == XFS_ITRUNC_MAX_EXTENTS==2?

Yes.

> What if we simply didn't unmap multiple extents per bunmapi call for
> realtime files?  Would that eliminate the need for
> XFS_TRANS_RTBITMAP_LOCKED?

Probably.  Not that I really want to rock that boat now when we'll
also have the extent free item / defer ops based path soon.

