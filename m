Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017681E48B
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265330; cv=none; b=EoD23jAmwFFvfT3kTVeJaTh/SbqpeK2U74LCWAcKwsT7lrdFF297XPjUp+Cfmm8kqksFqSl8KGRxkeKm16Eu7uTKZm4H63oDd+/GmXcIYcWjK5X6s+IUpbQZxx5kxlbBZbJHzQUsXArOfHXEaQOpWUZaCNWhAHYDKy3Cc4+DS70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265330; c=relaxed/simple;
	bh=XHXCwrD1Igk0Kpgq+ojWV1QQcR0qNQgvIf/k6w65P8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GV+R1cjL/64g088NaxRGYfnBGP4BGy55BoicpSi24G5tA9eaWLe5+SMhtUo6HTosplUrULz2bDG+oqsOQ/zahKbsQ/fHS2aM7PJwv257cZE5um+l4O6LoIa3oAjMsZn59bdnBNX10+FZFwIxN4jBz0Bu/nJelaLnbnB3j0SUsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUomK7mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUomK7mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E730C116B1;
	Thu,  9 May 2024 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715265329;
	bh=XHXCwrD1Igk0Kpgq+ojWV1QQcR0qNQgvIf/k6w65P8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lUomK7mjHCaDTHUV1KK8TpbPcBcw3bzlLmgAoY74AHhgHkmjbUZ6m6zFPdqvKtD4x
	 uVtsYbu3ydgBedhX6+qhrrCyUElpyGRoGLD6Q6YkrzJAabZTLLSTfJ/UwrHEvVSkxp
	 OBYfyf0+Jrvz0XS7zV//Er6Qwyeaz+NQopQKNrES66ljbhwC5FBK2duigRj9Ug3lwM
	 45hjlimFm+mFVi83eRWeInXo+kR2bt9iNnET4+dXNzgZ5LIufva2pyUpg6nOofXWYI
	 VtQ7XqdMgSKBp1nmA+RVFd7ZNMT7qc3f99dKxk8WniKI6N3nsIV2wOFLgjb2lMDiVW
	 DEIGPIdG8pXlw==
Date: Thu, 9 May 2024 07:35:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: fallocate RT flush unmap range fixes
Message-ID: <20240509143529.GG360919@frogsfrogsfrogs>
References: <20240509104057.1197846-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509104057.1197846-1-john.g.garry@oracle.com>

On Thu, May 09, 2024 at 10:40:55AM +0000, John Garry wrote:
> As mentioned by Dave Chinner at [0], xfs_flush_unmap_range() and
> xfs_prepare_shift() should consider RT extents in the flush unmap range,
> and need to be fixed.
> 
> I don't want to add such changes to that series, so I am sending
> separately.
> 
> About the change in xfs_prepare_shift(), that function is only called
> from xfs_insert_file_space() and xfs_collapse_file_space(). Those
> functions only permit RT extent-aligned calls in xfs_is_falloc_aligned(),
> so in practice I don't think that this change would affect
> xfs_prepare_shift(). And xfs_prepare_shift() calls
> xfs_flush_unmap_range(), which is being fixed up anyway.
> 
> [0] https://lore.kernel.org/linux-xfs/ZjGSiOt21g5JCOhf@dread.disaster.area/

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Changes since RFC:
> - Use roundup() and rounddown() (Darrick)
> - Change xfs_prepare_shift() comment (Darrick)
> - Add Christoph's RB tags - I think ok, even though code has changed
>   since RFC
> 
> John Garry (2):
>   xfs: Fix xfs_flush_unmap_range() range for RT
>   xfs: Fix xfs_prepare_shift() range for RT
> 
>  fs/xfs/xfs_bmap_util.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> -- 
> 2.31.1
> 
> 
