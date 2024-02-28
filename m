Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674815E5A1
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142100; cv=none; b=qrvrSZjNyTE7VpuvEUjTu07fZzypy05CBe+0IZ01ijMSxcNv/3Kbel87HJJE3UT6rospvNqhcV5/W7a0TIYGTnX1nG/8U9h6aUNvskxR+HfGI8HRxWxP6mrD3ZHH6ifMR4LyKxt3o7H8wYIOahW7FW4tARMX2ySpUXnpDwuKGKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142100; c=relaxed/simple;
	bh=WfzzaES4RMkI/b2YMlyVef9pw/Am6ZDhl8tgucgVQ+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXjvc2p9rIyJrp7mPYEvIhZMmdNSlUGCSDgQ3rh9C4OssqS8sBGm2iTVIcOMzJrM+yH2wP7sKSZrooiP7/mfID9Xowr+AX3D5uKqMbOrvCKElxEm9xDEk5NHRJv9J0IsMkRtpdYFXB7qWlbGzHgMlXsphEp+cxunh6RjcUv+8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQp84z6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQp84z6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F2AC43390;
	Wed, 28 Feb 2024 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709142100;
	bh=WfzzaES4RMkI/b2YMlyVef9pw/Am6ZDhl8tgucgVQ+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YQp84z6uP76KTltxugHMv8LF84HI2K3E7MFBcMTAubEl0DON4BF6Lv0ham57h3J5y
	 PuuyK4WYtVATWi/zY/xAaqVpOCx3nxvkbulYPVy1e4BH+TS+FsUw9Qs7dDjfG+qL5t
	 8tSbI0oclYvVwl2dgE/wjBSh040eCp7eadF4ZOJKLFLjXA+wi1Fy79xcyjFYDPaZmq
	 Bvn+Hxl8WJla321IiQHmhLD9Ws91GLImAECrw7c/liVYHp4yk6fpRh1ghreYa7982q
	 kYQ2mlxQx/vXIFzHT2zjxfe6WhJJf9kNPyyaO+G2gjWUR8vUCqUuWKpg4p8cEgd34Y
	 +dp2IwE9rKOkg==
Date: Wed, 28 Feb 2024 09:41:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/9] xfs: validate attr leaf buffer owners
Message-ID: <20240228174139.GJ1927156@frogsfrogsfrogs>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013143.938940.11677015146987204748.stgit@frogsfrogsfrogs>
 <Zd9X6EqqX3hi56I4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9X6EqqX3hi56I4@infradead.org>

On Wed, Feb 28, 2024 at 07:57:28AM -0800, Christoph Hellwig wrote:
> >  	trace_xfs_attr_node_list(context);
> > @@ -330,6 +339,15 @@ xfs_attr_node_list(
> >  			case XFS_ATTR_LEAF_MAGIC:
> >  			case XFS_ATTR3_LEAF_MAGIC:
> >  				leaf = bp->b_addr;
> > +				fa = xfs_attr3_leaf_header_check(bp,
> > +						dp->i_ino);
> > +				if (fa) {
> > +					__xfs_buf_mark_corrupt(bp, fa);
> > +					xfs_trans_brelse(context->tp, bp);
> > +					xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
> 
> Nit: overly long line here.
> 
> Note: this function would really benefit from factoring out the
> body inside the "if (bp)" into a helper to make it more readable..

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
