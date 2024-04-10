Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63D18412D
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787112; cv=none; b=Y7nhjEvFOYe5bxDJEsJKXdX3aIN/OXOIrjkrIMByTA2R70Nu+uy8uLy/rzVK/9NOAZHr+BbRWb6v+EK9Vxtjlqr0UZKcLJ5aENKBgWI/ItlnE0lxy5SoabUwrzIYKOxUQeESoM7SMC9h9r2luY87MfYo2ASWtjhdYHIvQVWF1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787112; c=relaxed/simple;
	bh=/1VYRH7scrwIp2sgxTZOrqN6ATTyw+UgLs3TSyI1rTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XspqhLKS5la7EpX08PtHFExhNb/2Ub+ngC6BzdKaB8ZB5RNFDfnTc6B8too1N754d5qeQetX8NOLeFGLSZtRtwZnH+yBDGjOQgyHuv26uyJAbL726lvGz0guEdDRA726RqVpv/4vbYVOXE240heVDZ3gC1dSBg9JbH9XEBTPGW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8k5s0fV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8k5s0fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E91C433F1;
	Wed, 10 Apr 2024 22:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712787111;
	bh=/1VYRH7scrwIp2sgxTZOrqN6ATTyw+UgLs3TSyI1rTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8k5s0fV2SCHkY7OYtjtFFdQNYK+ONMWT1qtnJmNRT/tp5gCGlgVRGF8n6AvWFisT
	 T7bkN2PjRJp7WP5ycyBYM6qESzwfQQtH5q6+7jMAKBbiaiW7Yj0rx/IX+2DF9yPeeZ
	 eQMvn+iiukj0Fj7k7ABiYZgt9QhoPEP2Y/w7cC8lxOyDokBMSeWURnuK46SUwqnfdH
	 FOM/RVGitHuRgHxTvfwkp0U9K8Wg7266L2kqBOkc+dx9kuZDBbeJjsaOixCRp8b8Vj
	 eJFgp3GFXQH90zEFWmVT9YXTa/AASlGqMYCo4Wa5mjve9aqrbUaQkTxaLBNsW7DQKl
	 NA2mnhWJWuh+g==
Date: Wed, 10 Apr 2024 15:11:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/32] xfs: enable parent pointers
Message-ID: <20240410221151.GK6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970091.3631889.3723065069358160559.stgit@frogsfrogsfrogs>
 <ZhYsafjrEg4Nb6la@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYsafjrEg4Nb6la@infradead.org>

On Tue, Apr 09, 2024 at 11:06:33PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 06:01:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add parent pointers to the list of supported features.
> 
> Any reason to split this from actually adding the feature bit?

Bisection.  If we don't add the bit to XFS_SB_FEAT_INCOMPAT_ALL, then
the kernel won't mount the filesystem.

Nowadays I think we could define the xfs_has_foo helpers at the start
and only add the superblock feature bit and the code that sets
XFS_FEAT_FOO in the final patch.

BUuut.... this patchset predates the xfs_has_foo helpers and I haven't
fully adjusted to that yet.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
