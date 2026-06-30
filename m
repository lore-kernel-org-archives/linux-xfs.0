Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF33940D598
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782797937; cv=none; b=H7n1Zn4jPnHEQbT85jdvNY/gDCXXRuCqOrcMlfBmIoIDXk79+s2+7/47gN0t2/d+K/oeHUH4Amn95Xvs33md9D2m9ZW52xXR1zAZctHj8XV4Fa1zHr9rKd+z7lbJAnQA0D4V8T3GCIBrp7pRn0JH6TZYH4UXC63LqBldzdY820s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782797937; c=relaxed/simple;
	bh=AiXJSnDs0v4aWV1dQ9iX/BRTqLVBOv+cn+oYfwZphVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHbQpEnOu9fcEdFrJwpyzT2LZVAjSCnFvF6K+wxHNODBteaG9qs7Tkk9APNRKj9YsHBb2tMcCWghH89L50tecbyMac+KT/CGBoE4riJ4BF4LOq9jGCn6eq3RMGn20TgBhRilncnA33IWrrSkoGeeUtucYvMTRYddWNA9hiJsSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E717268C4E; Tue, 30 Jun 2026 07:38:52 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:38:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/6] mkfs: fix hardlink detection in directory import
 code
Message-ID: <20260630053852.GD21007@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129879.858323.12870914276080297674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129879.858323.12870914276080297674.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:03:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a serious problem in the hardlink detection code in the new mkfs
> protofile functionality that copies a directory tree into the new
> filesystem.  It's been long established that hardlinks can only be
> detected by comparing st_ino *and* st_dev, but the new code doesn't do
> that.

Yes.

> Fix the detector, and stop passing struct stat objects by
> value(!) since they are quite large.

Without looking at the code I suspect the compiler silently passes
them by references as long as the functions are static, but it's
still good to fix this up.

>  static void
>  writetimestamps(
>  	struct xfs_inode	*ip,
> -	struct stat		*statbuf)
> +	const struct stat	*statbuf)

It also seems to constify a few things :)

> -	hardlink_tracker.entries[hardlink_tracker.count].src_ino = src_ino;
> +	hardlink_tracker.entries[hardlink_tracker.count].src_dev = filestat->st_dev;
> +	hardlink_tracker.entries[hardlink_tracker.count].src_ino = filestat->st_ino;
>  	hardlink_tracker.entries[hardlink_tracker.count].dst_ino = dst_ino;

A bunch of overly long lines.  This would probably benefit from
a local variable for the tracker entry.

Otherwise looks good, although I would have split it into a few patches.
