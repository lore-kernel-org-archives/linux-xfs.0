Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF79131737
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289470; cv=none; b=oeC6W10SAHnzRfTdZVGfcm1NEAQNzRdth0lUmoksZmcFs9Nl+YuEe/BU1dLq2zzvu9U38WtR1Nl69pg5bgemZ77Fq2nQNMox1+nshmo3rnlCxsSux2iXwPQexPKQWretpz3EP2MDRlDsh1TKwD5vikrJOcIrtFUt3J4gmtZV0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289470; c=relaxed/simple;
	bh=GqjgGK/g4NLRJ+Z7M87Mqxeo0jnVQ474Z6bUFcR06hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goeGpbBbb2NARPWnw9u7wcWLDuqdYXrtuUeRV6XPjA2nDr9dyPTbidDQVGQ/WYMyf+9tRUTxxFFMnMVQI2SL7hhjtTMpAC4fB/ktlpx5/w/g2GGbbWnfpuvewUyMTEC2K+Ad8Nabck70psjHCZjqly+dfVxmx6eZN11SA1q6aO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATPLAgdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATPLAgdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9DC113CE;
	Tue, 16 Apr 2024 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713289469;
	bh=GqjgGK/g4NLRJ+Z7M87Mqxeo0jnVQ474Z6bUFcR06hM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATPLAgdSV84UqeVcGghM1FSGxzXrUa+1RXJ8Duj1EEWyv5fzzSJuYcwH83yL2MMtv
	 reKg5CdhdmSH3nEKQZSYJXJz7JmAbRmOmyVsZAqhWtSnYCoUdlPFezESBiwbPq8fnY
	 XabcZeQwbfOknsQg8lDFd8kXvxaUKj73Hcv5orLOFXaSNGNdftdTlbAGC4oqOa0i0s
	 G+DQMEOnmJU42TivpBhsNNy20kn8b4lwz83YM0PFsy8kesoMI9Oz2UATndd6Kwurgq
	 2MXTbqVnuzQUtNKxusk3LWiAtdqrl/pkue8Qab/itcOngC/g6DpFBamn6MFWwm49M8
	 MVTUa6AyOUiAA==
Date: Tue, 16 Apr 2024 10:44:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 25/31] xfs: actually check the fsid of a handle
Message-ID: <20240416174428.GT11948@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028194.251715.15160167066761168436.stgit@frogsfrogsfrogs>
 <Zh4KaCzFogVbX_hV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4KaCzFogVbX_hV@infradead.org>

On Mon, Apr 15, 2024 at 10:19:36PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 06:32:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Compare the fsid of a handle to m_fixedfsid so that we don't try to open
> > a handle from the wrong fs and get lucky if the ino/gen happen to match.
> 
> I don't think this is a good idea.  It'll break so far perfectly valid uses
> of the handle API when userspace hancrafted the handles or stored them
> in a more compact format.

Ah, ok.  It'll break userspace, and for the bad-fsid case you'll
probably get an error code unless you get lucky and guess the generation
correctly.  Will drop this patch.

--D
