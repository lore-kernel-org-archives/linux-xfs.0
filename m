Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B3F70055
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161002; cv=none; b=r4SFntKHQ2J/V128fe5SDmgSL489PaXZG0LpG8rnvKddaiIQbFxuCcrY9OZxHBJgTFZrxaN334+dixsxLJC4pC5bv8+DOgLG+W2cvMGgUy4GB9bjRx9DJkCC+y1OVXdc+VnhpXFAGxnAR80mQQbRZMPRdyXatzWR0MlMCg35mcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161002; c=relaxed/simple;
	bh=XWPwiJ76kzMBH7gwi/eARp7RzCM7oXAHdjS3YXQTBF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1JIP43BtMI+AG0tX5Zqn5RYUjrE2LdhmUj4lO7UfJSsLvgNHvTPq8yPDkTAYrA2mWlSZMFRe8lB1lmThZhEsMeQ+zE3KgcQDHi7d5lX2fT657PyuyOA0q4Y/4k+kmG08oHj4+z0CR3NKOuwe4bX+6tbi8h/vvCXah4djzpBWic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0HvNHi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0HvNHi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A9C433C7;
	Wed, 28 Feb 2024 22:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709161001;
	bh=XWPwiJ76kzMBH7gwi/eARp7RzCM7oXAHdjS3YXQTBF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m0HvNHi7gqREn/HaNu3+eK/6oL9hWslVqWlAaVf4uoHel4Ylq9ZNhKX3Vg31ZkkW9
	 jbRh6tZrJqL7in2zOJ8TyABCPKoy0fDM3PdcUVKcOliaS0XmSE1FRIB9MCZE/i8Gwg
	 Ln09uezfzK3s80wiKzXxhRbhnD1TmJiK7BBFWUywWD2assRlAyb1anNYnQk9F/Pn27
	 VdbZ8QRY/pXtCPRihzuIuMh9eHXiel+52VVLSsuB05vqd21PaD5N723vbxk+ywLOig
	 JUhdUD/0MUVtjIEqnb+IRKVBwO2YLFjTflDZW44w5R8lBhq0ooBYqegPtTyPsHrfS4
	 T4G0kjwnDcoZQ==
Date: Wed, 28 Feb 2024 14:56:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/14] xfs: create deferred log items for file mapping
 exchanges
Message-ID: <20240228225640.GT1927156@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011723.938268.9127095506680684172.stgit@frogsfrogsfrogs>
 <Zd9V8VIoA6WpZUDM@infradead.org>
 <20240228195532.GR1927156@frogsfrogsfrogs>
 <Zd-u89-cPQAxsCIG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-u89-cPQAxsCIG@infradead.org>

On Wed, Feb 28, 2024 at 02:08:51PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 11:55:32AM -0800, Darrick J. Wong wrote:
> > static inline bool
> > xmi_can_merge_all(
> > 	const struct xfs_bmbt_irec	*l,
> > 	const struct xfs_bmbt_irec	*m,
> > 	const struct xfs_bmbt_irec	*r)
> > {
> > 	xfs_filblks_t			new_len;
> > 
> > 	new_len = l->br_blockcount + m->br_blockcount + r->br_blockcount;
> > 	return new_len <= XFS_MAX_BMBT_EXTLEN;
> > }
> 
> Dumb question:  can the addition overflow?

No.

Both callsites of xmi_can_merge_all trigger only if both LEFT_CONTIG and
RIGHT_CONTIG have been set.  Both of thse _CONTIG flags are set only if
xmi_can_merge returned true, which it only does for real mappings.  Real
mappings are derived from ondisk bmbt mappings, which means they won't
be larger than 2^21 blocks in length.

Therefore, [lmr]->br_blockcount each can only be up to 2^21, and adding
them all together only requires 23 bits.  The u64 here is overkill, but
it matches xfs_bmbt_irec.br_blockcount.

--D
