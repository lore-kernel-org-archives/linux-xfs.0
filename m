Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553120A5EC
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633549; cv=none; b=hEophODNa2uVzzwiLF3VXYECi1e1jmavkFg0ojAfIPeS9dfJep5hGyHnnWPKfLnAPpffoCSjaorKEinjKMZwgyQvUz83L+xIYIaitTCVamuY/WI+kVkmt1n5/ZxvjJvy7c5MrH6WRnLiqEI/WqBjk2IYsZhU+TDFG2UkDxjnYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633549; c=relaxed/simple;
	bh=XoxAgkoZo7cq+0y//UgpNTUoLxBIRe13hWdfqygg3bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3o+ZHJgWqOv7CADHr9KmzrNFljxdTDw8c/yWAZrqw9h4cUTxUfcjHkAtEvuaTGxGpdhuvt3PJH0T0e+R4NPwLJsFoCTO7RBU0qjmCc2OWyPmIRxtfaO5v3fy0CCuyWmsJRalKwAoJB7sw5beUp+eEUQvB6+YyLhlP/8lx85Txg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ABC11227AB3; Fri, 11 Oct 2024 09:59:04 +0200 (CEST)
Date: Fri, 11 Oct 2024 09:59:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011075903.GD2749@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-7-hch@lst.de> <20241010190147.GU21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010190147.GU21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 12:01:47PM -0700, Darrick J. Wong wrote:
> What if instead this took the form of a new defer_ops type?  The
> xfs_prepare_sb_update function would allocate a tracking object where
> we'd pin the sb buffer and record which fields get changed, as well as
> the new values.  xfs_commit_sb_update then xfs_defer_add()s it to the
> transaction and commits it.  (The ->create_intent function would return
> NULL so that no log item is created.)
> 
> The ->finish_item function would then bhold the sb buffer, update the
> ondisk super like how xfs_commit_sb_update does in this patch, set
> XFS_SB_TRANS_SYNC, and return -EAGAIN.  The defer ops would commit and
> flush that transaction and call ->finish_item again, at which point it
> would recompute the incore/cached geometry as necessary, bwrite the sb
> buffer, and release it.
> 
> The downside is that it's more complexity, but the upside is that the
> geometry changes are contained in one place instead of being scattered
> around, and the incore changes only happen if the synchronous
> transaction actually gets written to disk.  IOWs, the end result is the
> same as what you propose here, but structured differently.  

That sounds overkill at first, but if we want to move all sb updates
to that model more strutured infrastructure might be very useful.

