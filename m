Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AED24D8DA3;
	Tue, 14 Jul 2026 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046734; cv=none; b=mqReW+ZRN6pjB0EMMpByb6OSgsAQXzZ5IyaRa9rrcVR6N0eedZ9Qh8WUmYC0SH3RZH2z5QrKgVVkZMdR4dr9/ks/Z84wNnLCVy9Mn3ht1VosuwVQpZ3D+EWqSPCoJ4uNGN4NyTRWXdmfrcHkBMi53u+T0yFUX1iuWDdEKAEtugI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046734; c=relaxed/simple;
	bh=/qdy+5QbEHyAWy5P6v5EBiwBg9jgXoZKFf5FBfXA7dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpOe7hRYaqSgmGLFpPx8e8HCdZ06mVFcgDLmhZQuUIGFasEGQjJpnKk3Os+b5tP7Ls42Xba7BF7I6grDg2PNDtTbRjML3pj8ZlR11Bc02IyvA2ExcGHlgFl19961K14K11AVnaHShr8rRFz2JypY+A/l9R6Slg6O4PjjhG5eNDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQSYsJV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQSYsJV8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3B5721F000E9;
	Tue, 14 Jul 2026 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784046732;
	bh=F7mTaMeT7V3sTPyRTfiPuUfCnFAOVKAkYmA13vQjBjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hQSYsJV8I8UPK2GsxEC62oQGkecQreDq/fJbpNPFr+xh31Wtrt6KUzrYr/Kie1WR4
	 M97As5rO2uNjiLw3h9PChw7MP1EeLL/ZTOI2RQeCFExjojtqdDjtnLWs0WQue1FWPQ
	 5W/Lew5GLXoFGpnv+Iha1tWq+Jfe2HkoEUfoYA3s5jlX5xfL7sYO7+VL/KAISR2s1z
	 Z2qQQKqLk73gv/5AtTg/FqJFQSf6ORshXqRKQt9+ZxYzxcS2Mrfc4/v8su3r6P+lor
	 +6RAdOX1SpLEhINmuK4I0layIZYOt/hQwW9kkuM79157ZExhGvNdpRjdAA3L1dRZc6
	 iN/NTM3hGPosg==
Date: Tue, 14 Jul 2026 09:32:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: handle non-inode owners for rtrmap record
 checking
Message-ID: <20260714163211.GC7398@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
 <178400716881.268162.6869252550857617012.stgit@frogsfrogsfrogs>
 <20260714061409.GD1072@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714061409.GD1072@lst.de>

On Tue, Jul 14, 2026 at 08:14:09AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 11:06:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that two helper functions in the rtrmapbt scrub code don't
> > actually handle non-inode owners correctly -- CoW staging extents and
> > rgsuperblock extents are not shareable, but they are mergeable.  Fix
> > these two helpers.
> 
> The changes looks reasonable:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But why do we consider RT superblocks mergable?

We don't, really, but most of the cross-referencing code in the two
repair tools don't look at the adjacent records just in case someone
split a record wrongly.  Except for the bmap btree, the kernel never
splits mergeable records which is why it's an error in the rmap btree.

--D
