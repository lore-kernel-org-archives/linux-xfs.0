Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD212391AB;
	Thu,  5 Dec 2024 07:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733383025; cv=none; b=fdXQNOFNSL58YXIaVdmqVeN1b5iDrwBqjNQsdK3PuJNji5Dyspd4UJ4a6jw45zW8hQywjeNLE0KYAB1S0I4V/yZxOWEQGwkarVIj2aX+ao2211rtx0S3O2N7AY2oHHmQrn4MgTR7hyr2dGRsYw3nnv2eoC1sTQubIEa657NFPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733383025; c=relaxed/simple;
	bh=aQyQ2G4X3PCiGYhOFonDeYkfKdNOt7hA6AMmscJV1Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IE9fCl2JTwp5QuwVtSOOfiFago7M+hnELQZROumJ+3mrHS3ysSjvSBnwoCd7tpKD2LKvwMMM0IHmmJo7HVN+m3u+Jb6PJuJKTYCxd+1PIdLxU7+6D/60xFpAS1PTuKInSaMXJlhg3lkYrzloaAM6Gda0xkuBs8G+GIZSPkbNa+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IORnTci4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IORnTci4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FC1C4CED1;
	Thu,  5 Dec 2024 07:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733383025;
	bh=aQyQ2G4X3PCiGYhOFonDeYkfKdNOt7hA6AMmscJV1Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IORnTci4vEquWqpQOmqxBwp891HJmqQSAAZIza4UWhGlJah2DudN1VVu93y97STEf
	 Qd2xmXO95+DHxVIjyozYWTLAGBXVegltQ1tLxKGhUsVCJmbdxGNLyrEfM1q3NjMtXJ
	 HHuRi9Ako/zYZMsLO09zcLzyVe7d9qZoBqTh5VG3gm65z/2RU3+3drtY3AzputkVxN
	 8uIE80huZgl4KZOLx5+WJFy8dRduJmFyqxiQ8SZwZHlb8b2waHSxJrVt2p8xuT6nt6
	 gMlpT9IX8F1EQyHdidHnUR/fW18B+6at4eIQftcRP6zR5T6qhqSBWOJvbnDCQmUb6O
	 +K69XzLB2m84w==
Date: Wed, 4 Dec 2024 23:17:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/6] xfs: fix zero byte checking in the superblock
 scrubber
Message-ID: <20241205071704.GG7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
 <Z1ASehwdTewFiwZE@infradead.org>
 <20241205055451.GB7837@frogsfrogsfrogs>
 <Z1FMx63BD_KAUZna@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FMx63BD_KAUZna@infradead.org>

On Wed, Dec 04, 2024 at 10:48:39PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 04, 2024 at 09:54:51PM -0800, Darrick J. Wong wrote:
> > > This really should be libxfs so tht it can be shared with
> > > secondary_sb_whack in xfsrepair.  The comment at the end of
> > > the xfs_dsb definition should also be changed to point to this
> > > libxfs version.
> > 
> > The xfs_repair version of this is subtlely different -- given a
> > secondary ondisk superblock, it figures out the size of the ondisk
> > superblock given the features set *in that alleged superblock*.  From
> > there it validates the secondary superblock.  The featureset in the
> > alleged superblock doesn't even have to match the primary super, but
> > it'll go zero things all the same before copying the incore super back
> > to disk:
> > 
> > 	if (xfs_sb_version_hasmetadir(sb))
> > 		size = offsetofend(struct xfs_dsb, sb_pad);
> > 	else if (xfs_sb_version_hasmetauuid(sb))
> > 		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
> > 
> > This version in online computes the size of the secondary ondisk
> > superblock object given the features set in the *primary* superblock
> > that we used to mount the filesystem.
> 
> Well, it considers the size for the passed in superblock.  Where the
> passed in one happens to be the primary one and the usage is for the
> second.
> 
> > Also if I did that we'd have to recopy the xfs_sb_version_hasXXXX
> > functions back into libxfs after ripping most of them out.  Or we'd have
> > to encode the logic manually.  But even then, the xfs_repair and
> > xfs_scrub functions are /not quite/ switching on the same thing.
> 
> We don't really need the helpers and could just check the flag vs
> the field directly.
> 
> I'd personally prefer to share this code, but I also don't want to
> hold off the fix for it.  So if you prefer to stick to this
> version maybe just clearly document why these two are different
> with a comment that has the above information?

Ok.  I was thinking this hoist is a reasonable cleanup for 6.14 anyway,
not a bugfix to apply to 6.13.

--D
