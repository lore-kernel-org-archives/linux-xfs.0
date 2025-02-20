Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821AE1DFE32
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032248; cv=none; b=LzVJzzdW2bOCqcFIOoPE/p1Cq1HLYJ6FDkyR0R03cKPQP1e0leKw9OEi6kQEPVbori1j+uWVzURdXpMc5ZcKYG+ZMa1HI3t3DuB5xXandoCiMRKc8FHNLqL5PhPM09uSEEQe8Ze0a+Cxgv/Q9fIay5QZ8/KsOy3YkI9BtSmtuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032248; c=relaxed/simple;
	bh=uY0bgsloQNqklc/5Ch8WBjHDv5Qk49pWI+0RUlp+2C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pu3aSbeIHJbxOO49SS7QNXRankq1gWVnzadpfhmyjF6RAK+7dNF3HeAhdu6tjhwIa/dmjOqsIBuCZbiq4ZJIExQa/yHUWR+n3Q5u0mLMKfgsYRvvZRif9+T+sXM9IFcm+CTbVQW9gusZi5F0/S81LU/CD/mP0h+h/+N5E++b4/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6221968CFE; Thu, 20 Feb 2025 07:17:22 +0100 (CET)
Date: Thu, 20 Feb 2025 07:17:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/45] xfs: add the zoned space allocator
Message-ID: <20250220061722.GB28550@lst.de>
References: <20250218081153.3889537-1-hch@lst.de> <20250218081153.3889537-25-hch@lst.de> <20250219215815.GX21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219215815.GX21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 19, 2025 at 01:58:15PM -0800, Darrick J. Wong wrote:

[pretty anoying full quote that takes a lot scrolling to get to the meat
 of the message..]

> > +	if (len > rmapip->i_used_blocks) {
> > +		xfs_err(mp,
> > +"trying to free more blocks (%lld) than used counter (%u).",
> > +			len, rmapip->i_used_blocks);
> > +		ASSERT(len <= rmapip->i_used_blocks);
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return -EFSCORRUPTED;
> 
> Nit: This should probably be marking the rtrmap inode corrupt any time
> we decide to return EFSCORRUPTED, even if all we do is shut down the
> filesystem:
> 
> 		xfs_rtginode_mark_sick(rtg, XFS_RTGI_RMAP);
> 
> The other place we need it is xfs_zoned_buffered_write_iomap_begin.

Yes, that sounds reasonable.

