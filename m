Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41CA34D4CD;
	Tue, 21 Oct 2025 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761069433; cv=none; b=F1TMgfNDG/2fvHrx/kAlrixYTHf7V6T1ho/NrLxNHetq8iKBburikMFf1AVGp3aMImeXhbhwskHaPnncm6nzRUAdkq9ThcV/ewFR1PtJn6jrVZgDqfpxQ7GEdpWvkjGm3rRGkyH6clCPfpQ+w6y6Jqyv0jlUmCqLGJ8JKR/tWl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761069433; c=relaxed/simple;
	bh=UXdbudGm8ubWZbE4HUE++VDfZu6p0a8n9sHlVXKa1TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyBGBjB72P4D6560J7DDKp9VtZHIdpz3GWAZFQNCFs00f7pCXY8HgHg52nBumXZ97erhi4hMapVEOjXlVX68adsU5ARRc+tnvypIU2ZMnQa/1JOrzYWn+WSG7uStEatHbTqsWwdT5cpTa2/SAZPHem7+XZUy+AN6KlPxmYpAktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSvXZkz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSvXZkz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725DDC4CEF1;
	Tue, 21 Oct 2025 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761069432;
	bh=UXdbudGm8ubWZbE4HUE++VDfZu6p0a8n9sHlVXKa1TU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZSvXZkz547d8xAc5oIP/bHI9NtE7daOHp21kv1uHDXexuKRGCXZDo2sGJ1wOvAB5t
	 MaxXxrYQPXazSVXr255QAEGzW9ew0+skGjjXErXLCNxcNU2OVa/DpHIJHSVFdUp4U6
	 YRDP8cTA7TtTKwmDJvRvnRZA8ci/Ns6PtF6V0YQHIlTE4uDifQ7ssGmFyEc90HvL/I
	 2Bu1ZawJ1sTmcP4MgIT9pe2qaj8BJPd4BGv/JWtVk7ay0dr5vgUsuhGXTKBfOGAqzg
	 HRuhyKR6H9vZodVXTR/tOFGspeXiFrLgzMIqvnIox4zCuDdg5WMeon4TVGQRoWOA0G
	 lBA3t/wRPsirg==
Date: Tue, 21 Oct 2025 10:57:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 4/3] xfs: fix locking in xchk_nlinks_collect_dir
Message-ID: <20251021175711.GJ3356773@frogsfrogsfrogs>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251016162520.GB3356773@frogsfrogsfrogs>
 <aPHYl6uFyxQjhwP5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPHYl6uFyxQjhwP5@infradead.org>

On Thu, Oct 16, 2025 at 10:48:07PM -0700, Christoph Hellwig wrote:
> > +static uint
> > +xchk_nlinks_ilock_dir(
> > +	struct xfs_inode	*ip)
> > +{
> > +	uint			lock_mode = XFS_ILOCK_SHARED;
> > +
> > +	if (xfs_need_iread_extents(&ip->i_df))
> > +		lock_mode = XFS_ILOCK_EXCL;
> > +
> > +	if (xfs_has_parent(ip->i_mount) && xfs_inode_has_attr_fork(ip) &&
> > +	    xfs_need_iread_extents(&ip->i_af))
> > +		lock_mode = XFS_ILOCK_EXCL;
> 
> Please add a comment explaining the need for the conditions, this is too
> much black magic otherwise.

Done.

--D
