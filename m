Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4721A1F8911
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455688; cv=none; b=FRUwIN1UmTOWpg+2Ab7DvQ1s4qt2Zdb8aHpDYnDMK0ic0UX8eNJcFndlxYwvQ9TWdjMrIxXOCM7Ia2Nx5BcpnhffcYucSPuqWewu/Pzf/gs/zGWkTmTGEbxQIa9SPVYmW9qUTuN60EBBgvv17g4NLarvEWF1jy+GH5c52rfUz7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455688; c=relaxed/simple;
	bh=yhbJhPB8vfa7p7bvqlKnpBo9Z6Tm6Z3SgJsaRZCP6pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxM9TSjiLtxSyNTk0eGiPeK1ThHnYbOGrgbl/kRjKEYHbQJ9RSBuLiCAgdrL+SqeOx/T/2nEBxA3H1dHmTpNzvctuLvVffDP8qsL4f6ypBHcA8ZYX07KpFRe9vF7zYAuoP9b9obyphyJM59pvAptLT5VdDNxRDPMYFRKQlNFhiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsIjm8n5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsIjm8n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA2FC4CED3;
	Tue, 17 Dec 2024 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734455688;
	bh=yhbJhPB8vfa7p7bvqlKnpBo9Z6Tm6Z3SgJsaRZCP6pc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fsIjm8n5KYUtqPkOaha8GkgMHUUSQFnc/jF7FEeK7Mj9eD87jzwpzdd3jR00OMOKW
	 oQprn6EIRVP+nExbw30TcnxQQbJ9wf6OjtFYx9G+gW1tRXqgnaLJhk9qqkARyQyVBk
	 Ljo1wS4yw/rsiWZBb2FQOFoq4IFbZ3KWnsc6nqDNizrJ1bI9yiV7KQ//6GPPVlp+Y3
	 N2S2qx+adUsTKsCmGS1UW7CVQYG0ov5W7vQ6AlYPrYpkBj9SFxIhRW43krvs3PzHI2
	 qvYPeVlcdWy/PCVKkO8bYjAWKdD/wPsBGLduDGkEkasXjVooL42O33fC9SQS7mBr6s
	 xaxZDCE54J1Gg==
Date: Tue, 17 Dec 2024 09:14:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: support write life time based data placement
Message-ID: <20241217171447.GL6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-42-hch@lst.de>
 <20241213230051.GB6678@frogsfrogsfrogs>
 <20241215061902.GE10855@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241215061902.GE10855@lst.de>

On Sun, Dec 15, 2024 at 07:19:02AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 03:00:51PM -0800, Darrick J. Wong wrote:
> > >  		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE))
> > >  			oz = xfs_steal_open_zone_for_gc(zi);
> > >  		else
> > > -			oz = xfs_open_zone(mp, true);
> > > +			oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
> > 
> > I wonder, is it possible to remember (at least incore) what write hint
> > was associated with an open zone all the way to gc time so that zones
> > with compatible hints can be gc'd into a new zone with the same hint?
> > Or is that overkill?
> 
> We've been thinking about that a lot.  Right now we don't have an
> immediate use case for it, but it sure would be nice to have it without
> needing another incompat bit.   But then we'd need to find some space
> (3 bits to be exact) in the on-disk inode for it that doesn't make
> otherwise useful space unavaіlable for more widely useful things.
> If you have a good idea I'll look into implementing it.

How about reusing the dmapi fields in xfs_dinode, seeing as we forced
them to zero in the base metadir series?  Or do you have another use in
mind for those 6 bytes?

--D
