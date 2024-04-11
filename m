Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5157E2A1DC
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712808928; cv=none; b=uoDQ0xt6ac170MdHxTK2K7aOOO2yIVR311W2KyDl2J0Cd5Y/+34KHyYGL3rTeqzobhAw9QlTbzhP0MH8/P2i9TA4rHMg5E++KNPfib/AfAm4IY60J/JvF9KX1GxNMgOvEObzi8f1FJ9n7QMGVKjmW94esf7bsunMalxsNccHTI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712808928; c=relaxed/simple;
	bh=iFRr1ugLPvs6GIPDBMW6waGjLBgNKSQz/fC3gtD8ulM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbB/l/aEhHc6VBMG36thv09HK2gHEE6dMWT1y/TTmcidn6LqmK/vJQJ6rL/V666jk0spmyCH0VHzczDLUOkw6AvbK9qUUtrQ/4yAMbqKnObKKB9ICyXt/eCsdbTyaSAFA9sfqEIw2SndsQgJftMInfrgxg5hotW9BmfRpV6yVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N85zgtIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N85zgtIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6294C433C7;
	Thu, 11 Apr 2024 04:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712808927;
	bh=iFRr1ugLPvs6GIPDBMW6waGjLBgNKSQz/fC3gtD8ulM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N85zgtITDIhpSDcJZ5eCNT5EY70qwKr6osMDHE1Rb1otLNBBUbaf3pZAYYmHxMaTK
	 v6o/QZHODFrt3w1vqIUfwnnJFi3hA+4B9X3bHzTK1dNybdD0wPJ2ZdxRmclnJ+VVvX
	 g/1PbdZ/qZMxHRAmUAtRrNfmXAbshNmtPtFaePwQFFGxaL/iYWiUlhoMfBCCTc/Ava
	 yRRSB2anqURjn5DFSfQMjjCe1tIb5uhW/qQdXnW7LfcKMM56c2ni0WKQxnt/6XaD/p
	 E8JnwAtlxUCKiTk6GxF+UXm3+5jp6W0VRRyWZC/CypkHFeaDwCysykAS/bMA7QOpox
	 kS6JKMzovZFFA==
Date: Wed, 10 Apr 2024 21:15:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: rename xfs_da_args.attr_flags
Message-ID: <20240411041527.GT6390@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968435.3631393.4664304714455437765.stgit@frogsfrogsfrogs>
 <ZhYdQ90rqsMOGaa1@infradead.org>
 <20240410205528.GZ6390@frogsfrogsfrogs>
 <ZhdYdjXDQqNXv40Y@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhdYdjXDQqNXv40Y@infradead.org>

On Wed, Apr 10, 2024 at 08:26:46PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 01:55:28PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 09, 2024 at 10:01:55PM -0700, Christoph Hellwig wrote:
> > > On Tue, Apr 09, 2024 at 05:50:07PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This field only ever contains XATTR_{CREATE,REPLACE}, so let's change
> > > > the name of the field to make the field and its values consistent.
> > > 
> > > So, these flags only get passed to xfs_attr_set through xfs_attr_change
> > > and xfs_attr_setname, which means we should probably just pass them
> > > directly as in my patch (against your whole stack) below.
> > 
> > Want me to reflow this through the tree, or just tack it on the end
> > after (perhaps?) "xfs: fix corruptions in the directory tree" ?
> 
> If it makes your life easier feel free to add it at the end.

It does, and done!

--D
