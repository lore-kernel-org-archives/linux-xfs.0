Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1288612BE89
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713283556; cv=none; b=Me6OK9da0Fzb2+ZQaL9rjlbasi8ms23rnjnIWF1/oF85zaX3+liVYdhRSLQucEGd1w6vkC0CU55R4KcfUJ3r8wZ1hgatMKsaLhuYFaj0ZeaIKImQlMLSiVvdpxxPw0XsP1u3iYJUaqg8xRapLIr333muDmyvhav4GnpintxSLHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713283556; c=relaxed/simple;
	bh=+faEAzHFcseUMdkqB3LzFpqJutX9jQ+GPdXy56VENNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCe0c4wp+7jB6KR501YPfntRL0NNcR6OC90EOK7wPZRHz9Jxnfv2JaLp1jCF5jec0seylhDOmp/2z+LpYTdCW2V3RPPMvL7NUC89UnSYlKyJzRbmphF36aJk/5YYIFPFELZDY8q6+wcSOaFXycNFgv66lzmjW8PFwcwXLIdKCZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lbv+A0mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lbv+A0mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F6FC113CE;
	Tue, 16 Apr 2024 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713283555;
	bh=+faEAzHFcseUMdkqB3LzFpqJutX9jQ+GPdXy56VENNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lbv+A0mkiv//T3p68xKbOE9YRZUyJG3AjtTiHO+7LI3FqHSOlx0BZiWPskBClfBF+
	 oJsZqObkWHi32i4dWhVT8WkV8VGjZ3i0p8JCz2CZ+XfjdXyllXQzv2nXRLcZGgcycs
	 Ld9sI13AMelXGYrdYLe6dfEZajTwsGIY8moYpAagqgA2R1amy6uypy8DYGtw1/88aP
	 Bnr25uXBBKoxl/zN2QEihmR8Wa37Yz5S7q8IlpF9mr4JtlUCIcSJ0dZ3jHH07UWvmG
	 aXnTkKhElM8gaLQ0ZZZMbLTkbMvqWIqv0dJqgM/AeD9wfBrQ7rES1A4Ay+yRXyO8Wb
	 m4Van+l8IkY5Q==
Date: Tue, 16 Apr 2024 09:05:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <20240416160555.GI11948@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4MtaGpyL0qf5Pa@infradead.org>

On Mon, Apr 15, 2024 at 10:29:25PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 06:36:43PM -0700, Darrick J. Wong wrote:
> > +			if (args->attr_filter & XFS_ATTR_PARENT)
> > +				xfs_attr_defer_parent(args,
> > +						XFS_ATTR_DEFER_REMOVE);
> > +			else
> > +				xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
> 
> > +		if (args->attr_filter & XFS_ATTR_PARENT)
> > +			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REPLACE);
> > +		else
> > +			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
> 
> > +		if (args->attr_filter & XFS_ATTR_PARENT)
> > +			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_SET);
> > +		else
> > +			xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
> 
> Given how xfs_attr_defer_add/xfs_attr_defer_parent are basically
> duplicates except for setting op_flags, shouldn't this move into
> xfs_attr_defer_add?

I prefer to keep the pptr version separate so that we can assert that
the args contents for parent pointers is really correct.  Looking at
xfs_attr_defer_parent again, it also ought to be checking that
args->valuelen == sizeof(xfs_getparents_rec);

--D
