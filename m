Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019E9157485;
	Wed, 15 Jan 2025 06:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922596; cv=none; b=IlMYCPMo7Cq6zOlwQ5eC7IenN3euwiPpKskkwazjpyCPUj4ERYZi9jPbfMK9cxkVO/8CQjuIKxPiEY1Z3HDbS0cOhkh3lhbxTCbCTa0hBwaIz51XHh92BOf9P86KLvCigzPR/aMxV96N0to5Y8jwtRNEvs3L+aAS/8S81gKqhOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922596; c=relaxed/simple;
	bh=nvvxrLV3v4C0ac5BFLzCHa3NeNbc0UopIrhs2Y5ehdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBa/6h40HHC+tO41iusGDR6wsfJSRAp1emsYMUymThO4CgkApiAxOcJ90Aiy4zHoF+U69s9BCg+jWGQQU9k9p/ReH5qY/wMGcqDpdk9kiilYdn173q1JzHGtG9BX4p46dWuFEQbMJq3PMu7EH8E5wv1EyfFtFLDm0WS4aTSArl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNQZoZHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNQZoZHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85371C4CEDF;
	Wed, 15 Jan 2025 06:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736922595;
	bh=nvvxrLV3v4C0ac5BFLzCHa3NeNbc0UopIrhs2Y5ehdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LNQZoZHin6VPGvO/xCrdz3vs4hjP2TLsgzhmtxEbpXdAQI0wiNbYufTiqcda7S6oi
	 1a8UOjH3pUfwBvtpjUIgfnD1ltl7GkJbK8WwCXQGmvGZyUxoj5jIa0ymGYz6tUMybX
	 h4xZ1APpgPKS9GDTk19V3XE5edlT+q2nGLrkhkg36nsVLwiIa3fwWZi+YO2DuKHWe7
	 UyA1nESmXHfEprMdY5s1ux9ILMsRnGvdboG4Lm8X1IarBAlBnmqyiw+SHfgmOTXlDt
	 jY/Vj8BCc/nKj0UmDtKC+Osgwc99uEjQghRaG1tcB0O5g4+A/CQk5q8O+FdmJuIyxJ
	 qg8BdLoZ3gJJw==
Date: Tue, 14 Jan 2025 22:29:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	xfs-stable <xfs-stable@lists.linux.dev>, stable@vger.kernel.org,
	david.flynn@oracle.com
Subject: Re: [PATCH] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250115062955.GC3566461@frogsfrogsfrogs>
References: <20250114224819.GD2103004@frogsfrogsfrogs>
 <20250115060615.GA29387@lst.de>
 <20250115062037.GF3557553@frogsfrogsfrogs>
 <20250115062743.GA29997@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115062743.GA29997@lst.de>

On Wed, Jan 15, 2025 at 07:27:43AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2025 at 10:20:37PM -0800, Darrick J. Wong wrote:
> > Good point, we could cut it off right then and there.  Though this seems
> > a little gross:
> > 
> > 	if (xchk_could_repair(sc))
> > #ifdef CONFIG_XFS_ONLINE_REPAIR
> > 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > #else
> > 		return -EOPNOTSUPP;
> > #endif
> > 	return 0;
> > 
> > but I don't mind.  Some day the stubs will go away, fingers crossed.
> 
> We'll I'd write it as:
> 
> 	if (xchk_could_repair(sc)) {
> 		if (!IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR))
> 			return -EOPNOTSUPP;
> 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> 	}
> 
> but I'm fine with either version:

I like your version /much/ better.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
