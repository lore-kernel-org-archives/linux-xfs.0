Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A67291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066844; cv=none; b=rjXjtiFU/14orGehYUZX3yWgX1u4b/4DMS0TL0JeOU5oEv3ugDK44eEFLVDIp4AQlxlp+2j0m28fzHkD0VwBa+/pU3zebbEq5f9I6HGaYFVaVQzM8lFknat/O35l2dxTk1cK8SBv5h03QfFt0ef914EuPqms6s3RfAHHpggno2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066844; c=relaxed/simple;
	bh=jxr4U8QtoPxvuR4mNPXD+VJzqJDhLTK9Xecnh2AzCy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCi/gUmDOnKPyTgFLUPKDnl7pDkB5mUwAJPhkF4rP62TOsGxwUjhnPdDxmYYPLGpSUS+cdMZc0Zs9bbHy8lf2g+0fvO3BHAFX9zBrZbexoKuFnkcYnw8fLSelqwHaQPkWfgrc1hwStZ1jj095tNzw/kuQ7kVnDnVY7oc7GgkMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F49368BEB; Fri, 13 Dec 2024 06:14:00 +0100 (CET)
Date: Fri, 13 Dec 2024 06:14:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: refine the unaligned check for always COW
 inodes in xfs_file_dio_write
Message-ID: <20241213051400.GH5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-13-hch@lst.de> <20241212214442.GY6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212214442.GY6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:44:42PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:37AM +0100, Christoph Hellwig wrote:
> > For always COW inodes we also must check the alignment of each individual
> > iovec segment, as they could end up with different I/Os due to the way
> > bio_iov_iter_get_pages works, and we'd then overwrite an already written
> > block.
> 
> I'm not sure why an alwayscow inode now needs to require fsblock-aligned
> segments, seeing as it's been running mostly fine for years.

Because the storage you test always_cow on doesn't actually force
always_cow on you :)  I.e. these segmented iovecs can end up overwriting
a block.  That's ok if you're on a conventional device, but it will
error out on a sequential write required zoned.

