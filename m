Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545C751037
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708406087; cv=none; b=WknkTumki/5fjSssKsw/SMaceiDF3Qlx5wtpZ4bMKIA3WzGJsgYHMwCdJd/7kd+oLGVq0zLnhDw2DJqninPfkgTocSX53nTB3F67ZxU3XJbjppKaiXiVgEcT6An/S7dM+zgvqMjEGA4Rzm/Huz6OJn4OxdRe/am943VWKwWJbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708406087; c=relaxed/simple;
	bh=UaGFnuelR/MPBnNiKR4opmp2nNBtQY+rC6ZqlIigQhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8ncvqX012Sqr7uhxfRhwMfE5W9vkrzC5CMCgSnpq6buAkvPthIR3ZT9RJxRB2DaT0koFcQb6NHeGUQZJbwB0MNkA2AuaJxhSKTXP1fMQjuSA2yQVUrxSjHWf+i2nTpi0FZwvsrQTS2a/wcCOdV5ZdL4TY0m+Hg1jkLPdxxsaok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 069A568AFE; Tue, 20 Feb 2024 06:14:42 +0100 (CET)
Date: Tue, 20 Feb 2024 06:14:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240220051441.GC5988@lst.de>
References: <20240219063450.3032254-1-hch@lst.de> <20240219063450.3032254-7-hch@lst.de> <ZdPke6g0cp1jcMn4@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdPke6g0cp1jcMn4@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 10:30:03AM +1100, Dave Chinner wrote:
> On Mon, Feb 19, 2024 at 07:34:47AM +0100, Christoph Hellwig wrote:
> > To prepare for re-enabling delalloc on RT devices, track the data blocks
> > (which use the RT device when the inode sits on it) and the indirect
> > blocks (which don't) separately to xfs_mod_delalloc, and add a new
> > percpu counter to also track the RT delalloc blocks.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> .....
> 
> > @@ -4938,7 +4938,7 @@ xfs_bmap_del_extent_delay(
> >  		fdblocks += del->br_blockcount;
> >  
> >  	xfs_add_fdblocks(mp, fdblocks);
> > -	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
> > +	xfs_mod_delalloc(ip, -(long)del->br_blockcount, -da_diff);
> >  	return error;
> 
> That change of cast type looks wrong.

Yes, this should be a int64_t.
