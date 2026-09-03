Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2AD3A6F06;
	Thu,  3 Sep 2026 06:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415448; cv=none; b=hM9+Cn6ii7j/StrbxlKraeO9+kS/mJDxFXsrd1IAowglrnxqAWEhRluCSqTaGXji73oAAp5acS17O+bzfzV7BuDyQZfstj0j2EW8FXPtiiB/yoqm9a9i6iRPPEGz7sI9LTwSUd7MTym30MJZpYVLNcEBqvR8VYyUSsD2AsT+++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415448; c=relaxed/simple;
	bh=Lp6VlRhE5om8ZZp9FQI0kQ7D61oR/aJzO1WkBOw8weM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkZG7uj5iGlcDeO1zAsY7sJWWWv6GlIQ4IfKvP238XpKCdaivM9VwoB3f+/NIBperaB0MUmz1+g7GZ8f72jZgSWlnUhFd5W5onXnZ4DGoc8OqaquQ8o1YCMXdLa1+gYHkybNpmaSUsSfZi0hxR+zN3W/AVCCrA7/0NqAM1uMN5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 219C968C4E; Thu,  3 Sep 2026 08:04:01 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:04:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: cross-reference the rtgroup superblock
 extent, not block
Message-ID: <20260903060400.GA17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969850.484660.6737366204336091136.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969850.484660.6737366204336091136.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 10:51:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that when libxfs creates a realtime superblock, it will
> create an rtrmapbt record covering the entire rtextent in which the
> superblock lives.  However, the cross-referencing checks only look for
> the first block, which means that we can miss a corrupt rtrmap record.
> That will get picked up by the rtrmap scrubber, but we should make the
> rgsuper scrubber more robust anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

