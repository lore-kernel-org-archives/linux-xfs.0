Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803F1DE8B4
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901998; cv=none; b=ae7MlYLc/hlg92DMtLrjmal16tKkh+nC9G1oIgTJAaOzAscOaGS8jPn/gRIsm8RF8RInoYcdiwhzYpy80rNH62T0OrSPcPnky1NyxN1fCXXsz/B2w7hDRFVpzXxkkdJ12gbFxGMosiqO170ZuxYXKKb+HotFj3Xv5bbUwrvwEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901998; c=relaxed/simple;
	bh=vKxrZ2qUbGadboVchaevk+2D1CIeZmJR3NBdJruWe+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pn9ge0qh3fW3P5u7zc2d9PTIpFyM7SECT+gSB3JsuFHlVu2Mc09GFR+BCzVSzTQKU2gCi4cLR/bEo6rhx4RJ8tqfqDohHApjEZm9fZmNFlTMW79pK3WQjX9O4lhLoIAsKOpxJQbNLWvURmamjKEokhXcxH2cLMzTr90+ebSWjLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 979E368C4E; Fri,  7 Feb 2025 05:19:53 +0100 (CET)
Date: Fri, 7 Feb 2025 05:19:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: support XFS_BMAPI_REMAP in
 xfs_bmap_del_extent_delay
Message-ID: <20250207041953.GD5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-13-hch@lst.de> <20250206205449.GN21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206205449.GN21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 12:54:49PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:28AM +0100, Christoph Hellwig wrote:
> > The zone allocator wants to be able to remove a delalloc mapping in the
> > COW fork while keeping the block reservation.  To support that pass the
> > blags argument down to xfs_bmap_del_extent_delay and support the
> 
>   bmapi flags?

sure.

