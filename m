Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D9A4A33
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 00:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqorMBzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82455C433C8;
	Wed,  3 Jan 2024 00:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704240155;
	bh=4dDkFmadYcUbgwoSFTUBibrAw3T9fW7kE07J7Zc06HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fqorMBzwoawm6uuatWUaQRG+FsmejqWXwX4opqKmU9eWqX3JfQWsAU1S6wujHu9lF
	 +K1qu9HQWFkysmhzKZVyhHCeoTIhGf5BaO92OFSkU2IcG3Bev1df46OvCNor23f5ET
	 coq2Cws907LIX9I+uIKfSf6HfVUwuUyrZum2aNtOFxMnk7fU2Ks9rt9AMt1xGkm8v0
	 KfaH+GmxKmGvLzOUcXu3AShGHbqIEx1tyyW60nBaHORXFdYve9Zj32rZVTweuKGWyf
	 FFVKZi/5vxxQUaJoO3oHgPcr7uWdg8lQnRKjWwTVyJe9ZN8QH9AOS8hYmwnHBs5/qd
	 PG9rpBIXtewNQ==
Date: Tue, 2 Jan 2024 16:02:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: create a predicate to determine if two
 xfs_names are the same
Message-ID: <20240103000235.GX361584@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827004.1747851.5152428546473219997.stgit@frogsfrogsfrogs>
 <ZZPvwcT5x1AZAnzI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPvwcT5x1AZAnzI@infradead.org>

On Tue, Jan 02, 2024 at 03:13:05AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:06:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a simple predicate to determine if two xfs_names are the same
> > objects or have the exact same name.  The comparison is always case
> > sensitive.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_dir2.h |    9 +++++++++
> >  fs/xfs/scrub/dir.c       |    4 ++--
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > index 7d7cd8d808e4d..ac3c264402dda 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.h
> > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > @@ -24,6 +24,15 @@ struct xfs_dir3_icleaf_hdr;
> >  extern const struct xfs_name	xfs_name_dotdot;
> >  extern const struct xfs_name	xfs_name_dot;
> >  
> > +static inline bool
> > +xfs_dir2_samename(
> > +	const struct xfs_name	*n1,
> > +	const struct xfs_name	*n2)
> > +{
> > +	return n1 == n2 || (n1->len == n2->len &&
> > +			    !memcmp(n1->name, n2->name, n1->len));
> 
> Nit, but to me the formatting looks weird, why not:
> 
> 	return n1 == n2 ||
> 		(n1->len == n2->len && !memcmp(n1->name, n2->name, n1->len));
> 
> Or even more verbose:
> 
> 	if (n1 == n2)
> 		return true;
> 	if (n1->len != n2->len)
> 		return false;
> 	return !memcmp(n1->name, n2->name, n1->len);

Yeah, I'll do that instead of the multiline thing.

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
