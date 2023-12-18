Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E71DA28
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJ7OLiVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD802C433C8;
	Mon, 18 Dec 2023 22:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702939263;
	bh=WtEp3m1R7h3d3yGlaofKZh1xsNtvdFrmNfwXPDmPtlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UJ7OLiVw4Igo/U210CctbUTTmYO54TeMiiiGSpyqVybRvMGQY2+yjPiW0IOWdGl7h
	 MHBZjFXDXHsPOymw4DrTd3jN4U8G3F42tuRMiNkEtPSFS+WDhfdP2IeYMNEoweyD4J
	 s3GFHG84bVi1werEJrxqy3/RlnRbKz7qo0uwpsmEAdaeKeZcJjjfYexi6wQUzvvuE8
	 9o5hlOqc2ov+vgL4yFMEEFTVjDH9gMn6pGvBJaRxC5fM5tbJ9HjLPXYpocCB67G8SR
	 CbddqLNxpLX7MFNQfV1Aa6MjjFAX+OkjKous6dNzz+H7hN2aABdJ6+QrS3V/4oKIQF
	 wfvIOHcucDkqA==
Date: Mon, 18 Dec 2023 14:41:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: remove struct xfs_attr_shortform
Message-ID: <20231218224103.GE361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-8-hch@lst.de>
 <ZX9kLBb6vYGsQMhy@dread.disaster.area>
 <20231218043038.GA15579@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218043038.GA15579@lst.de>

On Mon, Dec 18, 2023 at 05:30:38AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 18, 2023 at 08:12:12AM +1100, Dave Chinner wrote:
> > > +struct xfs_attr_sf_hdr {	/* constant-structure header block */
> > > +	__be16	totsize;	/* total bytes in shortform list */
> > > +	__u8	count;	/* count of active entries */
> > > +	__u8	padding;
> > > +};
> > > +
> > > +struct xfs_attr_sf_entry {
> > > +	__u8	namelen;	/* actual length of name (no NULL) */
> > > +	__u8	valuelen;	/* actual length of value (no NULL) */
> > > +	__u8	flags;		/* flags bits (see xfs_attr_leaf.h) */
> > 
> > May as well correct the comment while you are touching this
> > structure; xfs_attr_leaf.h has not existed for a long time. Perhaps
> > just "/* XFS_ATTR_* flags */" as they are defined a little further
> > down this same file...
> 
> Yeah, I'll update it for the next version.

Also, could you add a comment somewhere that the ondisk format is one
struct xfs_attr_sf_hdr followed by a variable number of struct
xfs_attr_sf_entry objects?  That much was clear with the old structure,
even if the C linters can't make sense of it.

--D
