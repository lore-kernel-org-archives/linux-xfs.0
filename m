Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32CF13C666
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806366; cv=none; b=R0sbS7yFBcNhOZwkNHn19SOQILIVtyj65aFBMlHy+1iP/fj+ZBb2BcduEa1T2Co9w5lSZgCfNwSJLD5p+y9OPvzzQN9shf+jVT5YCxQHmM+zPvk5iYc6zXn60wbD3JWFP6FXdC4ycOwYP3wM25KsuDilNZcGzXy13UXZG1093kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806366; c=relaxed/simple;
	bh=F3eIkfj8oWePTEOaLP86OI8IWLRMWHjFz4FtLiWCUzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FXlOJnFD2Zi4PkHrjmZ82QUXvYqqUhkm51cTM/dSnsYfYGI0cfqvgAVbJJdMWwAE2fzj43CHWRnjmSVt8Gvt/2Otk8JN/60/pyNHEYKX3CJMzandJqSlcz+87g+Ch3KsbypCu4SaEHhGXCW+PgFrvRNnATMphfRzYQb+yeNh0ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AwZeTwNL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AwZeTwNL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h3lQBFSe1s+0CjH9Q3QO4IK4q305rJXCKzWEkaElkQo=; b=AwZeTwNLt8ck2k+Wvn0WvGrbQj
	4mGIZ23TNC2S/QqPwYVneu1SaFOk7F9rq8laTvJo2slRvYL7GXi0Jm24YZ6x8XWcjHGXYkzBQPszs
	gNkRSZNdACV3MntPcto/gyxBYiNUsUgEkgRWDBERzgY6bMhjW1ne67oKYx/aqvEqNQXp/J4yJeTmM
	UMcubb7o0ZBHxwnXXSseOGK1w0tAkrrIbC2kHRNUKsx2wbmIRWBc/s3HILFlKhA2f4DRcH1J/aUYb
	t0WVZ9nfKligJ7aJ+P7pzrzbloick7ertqQ8sFtsbUqPoegHhMrj0z6UoWMgQap9G8UfnUqATx5K5
	cn7dSggQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rulB6-0000000AAVT-1quj;
	Thu, 11 Apr 2024 03:32:44 +0000
Date: Wed, 10 Apr 2024 20:32:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, catherine.hoang@oracle.com,
	hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: add xattr setname and removename functions
 for internal users
Message-ID: <ZhdZ3IjRjdvqtppH@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
 <ZhYvG1_eNLVKu3Ag@infradead.org>
 <20240410221844.GL6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410221844.GL6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 03:18:44PM -0700, Darrick J. Wong wrote:
> > Is there a good reason to have a separate remove helper and not
> > overload a NULL value like we do for the normal xattr interface?
> 
> xfs_repair uses xfs_parent_unset -> xfs_attr_removename to erase any
> XFS_ATTR_PARENT attribute that doesn't validate, so it needs to be able
> to pass in a non-NULL value.  Perhaps I'll add a comment about that,
> since this isn't the first time this has come up.
> 
> Come to think of it you can't removename a remote parent value, so I
> guess in that bad case xfs_repair will have to drop the entire attr
> structure <frown>.

Maybe we'll need to fix that.  How about you leave the xattr_flags in
place for now, and then I or you if you really want) replace it with
a new enum argument:

enum xfs_attr_change {
	XFS_ATTR_CREATE,
	XFS_ATTR_REPLACE,
	XFS_ATTR_CREATE_OR_REPLACE,
	XFS_ATTR_REMOVE,
};

and we pass that to xfs_attr_set and what is current xfs_attr_setname
(which btw is a name that feels really odd).  That way repair can
also use the libxfs attr helpers with a value match for parent pointers?

