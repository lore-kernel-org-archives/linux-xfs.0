Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4905A22329
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706964; cv=none; b=cSGVtdQDb9IYKE75q01rYBkvq5xDmtfz/7NQNBFolYi/VMb+z9Z1KYZ/p3YYRaoWFJNHj1HCfQxw369XSj2zw6RXu4DtLNp7TcYYIBLRi3th9kaaHj/S2laUXOnCn/igktOWjSkqBCaFyXxFs1UVuzPQqVZqnVi2j+yI9KYy+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706964; c=relaxed/simple;
	bh=e6PEUB3r2K9mLPWHFjjCcu6E1nDQQL9/aagKilX6Kmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgV1h7xVGi+42i31/miQDOOCkzV8VXH75htCjJ5NvAmiF31kjCHLw8oZO8xelaQ0Lp1D9sX96BxxkW87gvYV/o2csE3PBknjo7OCdUbvTTNJDgQCrG2UkE2lRs89W2vHMqAdMgwPL//BdppJraQrpQJ7FHOPmXQP9abLRUSdSpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D506968BEB; Fri, 23 Feb 2024 17:49:16 +0100 (CET)
Date: Fri, 23 Feb 2024 17:49:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240223164916.GA3849@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-3-hch@lst.de> <20240223163448.GN616564@frogsfrogsfrogs> <20240223163737.GA3410@lst.de> <20240223164655.GO616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223164655.GO616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 08:46:55AM -0800, Darrick J. Wong wrote:
> > The only "sane" way out would be to always use a deferred item, which we
> > should be doing for anything using new RT features, but we can't really
> > do that for legacy file systems without forcing a log incompat flag.
> > So while I don't particularly like the transaction flag it seems like
> > the least evil solution.
> 
> I had thought about doing that for rtgroups=1 filesystems. :)

I actually have a patch doing that in my "not quite finished" queue.
Given that your patch queue already enables it for rmap and reflink
it's pretty trivial.
