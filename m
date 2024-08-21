Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0548B2595
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 04:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724215599; cv=none; b=LzWlPzEmKHfxyhzuNnngBQhW//Lx5zwOZaMOgQ8YQOMC7TPeAGMXha8euCxJJl8vcykrWrjE0wNIrl+uoPiWB/yNe5/GaBbYXmWyJrl/SYocZwp7oRbJ4xEMcXQnjyRBQjv/zRTU6jmfuVYGosvo3ocgHN3SSZ2sWO5xPhIwM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724215599; c=relaxed/simple;
	bh=C3gLjIS14FACfhHcMzbvr2VBva+tUFDBVjbXXcsFPc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwBJQyYuL1hNfheEGYbK1ZvNNWEE2XCLngqVN/ZOPtLz3zxqv1q3h/dWfvTA/VriadOLLjIgxRkZdg0eSklG0/Pah4J2sL81BH9E9ZCwrmn0nTY7YYapecAfXmfhQyjEsDX4VFbdWEYhRbC2r/RD9CQkM5DnmTqEUAHf4Qxz1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFDA768AFE; Wed, 21 Aug 2024 06:46:31 +0200 (CEST)
Date: Wed, 21 Aug 2024 06:46:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <20240821044631.GA27814@lst.de>
References: <20240820163000.525121-1-hch@lst.de> <20240821044427.GU865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821044427.GU865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 20, 2024 at 09:44:27PM -0700, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> How hard is it to hit this race?a  I guess all you have to do is statx
> in a loop while doing a bunch of cow writeback?

Yes.  That's essential what generic/615 is doing.  Now without always_cow
you'd need to do this on freshly reflinked inodes, which makes the
reproducer a bit harder to create.

> >  	ip->i_nblocks += len;
> > +	ip->i_delayed_blks -= len;
> 
> This proabably ought to have a comment to reference xfs_bmap_defer_add.

Ok.

> >  	bi->bi_owner = *ipp;
> >  	xfs_bmap_update_get_group(mp, bi);
> >  
> > +	/* see __xfs_bmap_add for details */
> 
> xfs_bmap_defer_add?

Yes.

