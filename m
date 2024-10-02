Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30DF84A36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 22:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909431; cv=none; b=sv5YerroByiX25kbwD1UzgKO9fgZqBSyVf4hDrZzRFXlR/p1Vo5ddMl3uJOw8uG0YP/dzca4mlkA7D/o7Mm5qB1RQE21BYA7tMfKxwaK3urP9KUWJwb2/5w5SeH9px/MIOomVbezlb9N3SoTgcAfbPsc3YKdMeeDvYQq81vbpSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909431; c=relaxed/simple;
	bh=FReVnAWC9Z7tozSpE7EVef8PFZBTjT/NeIjXIRrUhs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCMk4snz4Ri+NSGs0vnDXHNJCi18TsumEO4mrK921RoZyOLgNNW3xKNoLZvL38V4ZHgMI7RZbnSGAFo9UtlusaUubBut3ZxWoPye8Tjkwm832pBRtxjr87sNTqnjGby2TlxZ8zndEMsEkJiEBLlRWlRgs6gySuCK+TfAritt+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2R8SIik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2R8SIik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFEAC4CEC2;
	Wed,  2 Oct 2024 22:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909430;
	bh=FReVnAWC9Z7tozSpE7EVef8PFZBTjT/NeIjXIRrUhs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a2R8SIikMBtoMfoH/TDXJtstsrHUOOUwFJMW84acV7rx0HxY+kdRMOLv2pwhH/vw2
	 m4HK9PL4RCD9zH3xJ3oDgK1LS6TReD6tU/dN3+e0dRtqigonEpKo7sICQas3Y9Ka3R
	 RPpHFo/2jviG4Ud06ZVrMOVOCEWLPquzEOADBtmj6rzNEN+QnHwVJcYfrr9huRYB12
	 e50xBc2brbi5y5g5PD3r8e13xpVUyl+rSD8mCmYs3y12GhPxY/zm+yCWX7gQX2Jqu5
	 BEFuGlZsxqLfZYyw8UEqnPNyJIVtO2SRdW8uJ137AybDlD5s+hYZ6A3rBF+VspVUg7
	 8frZG52Wrpzgw==
Date: Wed, 2 Oct 2024 15:50:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db/mkfs/xfs_repair: port to use
 XFS_ICREATE_UNLINKABLE
Message-ID: <20241002225029.GH21853@frogsfrogsfrogs>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103061.4038482.13766864255481933120.stgit@frogsfrogsfrogs>
 <ZvzfytE-q1WwJULo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvzfytE-q1WwJULo@infradead.org>

On Tue, Oct 01, 2024 at 10:53:14PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 01, 2024 at 06:25:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Source kernel commit: b11b11e3b7a72606cfef527255a9467537bcaaa5
> 
> How is this a source kernel commit when it purely touched non-libxfs
> code?

scripts gone wild :(

Turns out that editing these free-form commit messages with computer
programs is a bit fraught.

> The code changes themselves look good, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
