Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A285A780
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005591; cv=none; b=QEY57U+eU6taRvin2+MNJwN9RKSxLQS4Yf4tzsNflKgOZ6BGrea8UlWm8e0hdcv5xtpbBdn4ugPv/Dk1fQLKee4bFdF3OXjFzaqW1ppdDDULhx/PNlG46J1yE+NYzwcPn9DxAJy0OaeOkW4Xxb8LK8DK1M0aChzRiMYAdvw7iB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005591; c=relaxed/simple;
	bh=ENLErGkmfCcb9V9Pv0dNNp7ka1xm6aHCFYaGgB7ODAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EA7S8a4JEXQip3MkUF+UNOCKgEbZr4djz1Suus/bA/yzkzgvpFJpcMIyeD7Y2MWD9pg3dRHaL3y8JRwgB9HqMP0XYHSpvc0EuWZADdHArafQ+i1tGU/54/x5jTUzIXF0P+grtiLQvLadhnywS48PQo/rMDTgAJ2lWVerEBpUyI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMyfxXKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMyfxXKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09CAC433C7;
	Tue, 23 Jan 2024 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005591;
	bh=ENLErGkmfCcb9V9Pv0dNNp7ka1xm6aHCFYaGgB7ODAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nMyfxXKhGweh91HKkjT05LZzRb4NUosii/KqTcp0o4sgYoBIj4fmxa3M2NrRwoALH
	 Nwgb6k2nNFP6tioO42JXYpnuJEWjWRAmwRzGiGt/NmQtrrtamz32DwFPxJCNwCB5UC
	 0do9XBKRh5ND4Ri+YcZfZn86XNHRF2+erIGKpUNIqTXJIvk9snIloq3IGYB9UWX0vV
	 oaCr4ZT6yYwajM1sdC0024DsJ/Zpk6TXJ6dLnYTR88F2aE85qbBqvJnLCiaAudmZg6
	 DMFCPsrwwGjMsyQouQ6yNr3drb4l7LQg/+uGXy1Gdb7XymrAs1majn/CsH3ZYn9sZI
	 2wa8QPPaHlxeQ==
Date: Tue, 23 Jan 2024 11:26:26 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 1/6] xfsprogs: various bug fixes for 6.6
Message-ID: <3now35mejgcnfnlpinaasrnitkzzpwujynsgnuucimmb7rj3vg@w776vsivr7kf>
References: <vCoJelUtonPrC7yIaGrpuKT11Gy7wq4M8hp-E0X9DG1GTx5fz8de1ONJTnOZbDnRBu5ClhUfGTtoLLFYZjRiqQ==@protonmail.internalid>
 <170502573166.996574.10606759915783984277.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573166.996574.10606759915783984277.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:16:25PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit c2371fdd0ffeecb407969ad3e4e1d55f26e26407:
> 
> xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD (2023-12-21 18:29:14 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfsprogs-fixes-6.6_2024-01-11
> 
> for you to fetch changes up to 55021e7533bc55100f8ae0125aec513885cc5987:
> 
> libxfs: fix krealloc to allow freeing data (2024-01-11 18:07:03 -0800)

Pulled. Thanks!

Carlos

> 
> ----------------------------------------------------------------
> xfsprogs: various bug fixes for 6.6 [1/6]
> 
> This series fixes a couple of bugs that I found in the userspace support
> libraries.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (1):
> libxfs: fix krealloc to allow freeing data
> 
> libxfs/kmem.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
> 
