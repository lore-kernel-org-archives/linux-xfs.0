Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0579208CA
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 21:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734469514; cv=none; b=RRJ8l1Mo4PnrtClGeWKNFE73HPN4Io0eWIFSwBb6xKFi9vyoLOiaZdIWXKv8PAQ5tQBHPUCAZxO5VkJiHHK6CHyYJ8GvSWDKfvWFW8WOh/LWtn4ZIVW2qSoL6XMRC6aXblVNyqXgokc6b2hq8Wnni0qpw0v2hd9Y2rpy+h2vjQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734469514; c=relaxed/simple;
	bh=BIQqTNSIHTfBZti7si4F5vgH8dxOENreKPH3UATF1LY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cL8DonUwzPPp49VIzCLPvRL+7g9Ef5Z4SohMKrpRKuBVSAT+7rqSQ6y/++okIIjxfIx3kY5pMKSZEgKU4AD4UUTfKOHPMarjquVaIlylgVv9j99QkqsQoi348RBDib0eQPpDdyo72KLCRAcdiNF7YgrKz4yKOaoXCxRh+W9hmLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQrDCl5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQrDCl5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D5C4CED3;
	Tue, 17 Dec 2024 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734469514;
	bh=BIQqTNSIHTfBZti7si4F5vgH8dxOENreKPH3UATF1LY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQrDCl5I6k3HVqNfy1EBvPx7eBNLILX6XE1S4dWTY8s37Oqa/hIUM99vHTWKcBo4r
	 PGTsOID60qpfrAQ5e/I4JPuWLry+8RCjOviFz+Eb2CCE6gxWj9oprsTHrDY8soOWPG
	 rKB7JRlmW0fdS6Re/SKfMlL1ecbcAEAKNCY9C3JTHHITiBkRD+AaPl+Uee/ESZw72k
	 IQqOLp49c4BkmtzxDLFSNxW6/xacVGbL9lILxBXZ95PMZAln9D+duthD3VBPxsouZg
	 IR8cJPgaz77cjjPa7UljftVQaxMgfQa3LGg4E+aNQOsB3A+xxktkqbDdiVNQ+RPRd3
	 Xiv0Ui+cokR1w==
Date: Tue, 17 Dec 2024 13:05:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v6.0 5/5] xfs: reflink with large realtime extents
Message-ID: <20241217210513.GX6174@frogsfrogsfrogs>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
 <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
 <Z1vwwOMR9sF3MrWY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1vwwOMR9sF3MrWY@infradead.org>

On Fri, Dec 13, 2024 at 12:30:56AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 04:57:58PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Now that we've landed support for reflink on the realtime device for
> > cases where the rt extent size is the same as the fs block size, enhance
> > the reflink code further to support cases where the rt extent size is a
> > power-of-two multiple of the fs block size.  This enables us to do data
> > block sharing (for example) for much larger allocation units by dirtying
> > pagecache around shared extents and expanding writeback to write back
> > shared extents fully.
> 
> FYI, I'd really like to avoid us pushing the large allocation sizes
> further than we have to.  Or in other words, unless we have a really
> important use case for this I'd prefer not to merge this code.

It's basically there in case (a) someone really wants cow amplification
on the realtime device or (b) something to base forcealign cow off of.
AFAICT it works, but seems a bit gross.

--D
