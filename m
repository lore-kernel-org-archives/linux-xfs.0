Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050DB1D530
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 04:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714538261; cv=none; b=g7LBGchzZUHXXGs1vQjlGYxDechm5Py1FE3NO/zSdZvEEb1RX3Bgo42A7VdE6+77d299qTh02teHARY1QfEL7EP4EHVEx9gcr0srNFK0JlA+DpaDzmRooSSiMwy/7BZRBczEhx31EyTscHFCpGMFKwAJHsq79so5XdEey4yeRqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714538261; c=relaxed/simple;
	bh=vpo3aWXCyCkezFbch30VJdWkM97wImJjf9diaZhwvJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpcnEjn/lgWwKkmtT9t7tIZlxoDyWjbaAU6faV/WK8bLPfvcXZ0aDf9289NqFZpAAzuHcgE8684mDc9j+otb+4L5GTsjmd2t9kHtEmMcqh0wPKSXKPMm1RKk0eUDsfVobHqvnUNRmHo33bgStusHdpzTyLttUZ599br5XtQqQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C331067373; Wed,  1 May 2024 06:37:34 +0200 (CEST)
Date: Wed, 1 May 2024 06:37:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: allow non-empty forks in
 xfs_bmap_local_to_extents_empty
Message-ID: <20240501043734.GB31252@lst.de>
References: <20240430124926.1775355-1-hch@lst.de> <20240430124926.1775355-2-hch@lst.de> <20240430155131.GO360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430155131.GO360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 30, 2024 at 08:51:31AM -0700, Darrick J. Wong wrote:
> > Change xfs_bmap_local_to_extents_empty to return the old fork data and
> > clear if_bytes to zero instead and let the callers free the memory for
> 
> But I don't see any changes in the callsites to do that freeing, is this
> a memory leak?

Even before this patch, xfs_bmap_local_to_extents_empty never frees any
memory, it just asserts the the local fork size has been changed to 0,
which implies that the caller already freed the memory.  With this
patch the caller can free the memory after calling
xfs_bmap_local_to_extents_empty instead of before it, which the callers
(all but one anyway) will make use of in the following patches.

I thought the commit log made that clear, but if you think it needs to
improved feel free to suggest edits.
