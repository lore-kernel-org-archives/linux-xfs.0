Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9521BF31
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710907; cv=none; b=Gm2++jSVkzhIVp1Pe8Mxm3ppz586HGzQNHsxw8oo3nGFyYdHd/FoKVwQpJu8TmTglMwjNX2W9Lkqt6Ej1OmxP6UlEtzqXewbErnij1fTpYevpdi1hasqj1s0nAov+SeyYdFU2gkD84nS0x0MVAyiATBXvFDjvsLlY7GtlwcKj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710907; c=relaxed/simple;
	bh=OyqJsFM+eWk9o2+zMtCeQxGKI5vTyRfiTzMcztQskcs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=D1NN0dhaM2mxjQ+NPELb9MFVdcaPiqdliWK0fQ+LqJ6IpD43xxjKtqKWzM24EPJe/MvxBNX3uUBFm169mBUAzUyUViJZaN9U1RMx3St3p3Z3AmYh+MIwzBTSGOJO9/6lHn0oqwp2zS5lj+2MgeCvI+Rg8bsI/57bxFCNvB/FFfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGXqAEB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGXqAEB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E9DC116B1;
	Fri,  3 May 2024 04:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710907;
	bh=OyqJsFM+eWk9o2+zMtCeQxGKI5vTyRfiTzMcztQskcs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OGXqAEB6pgfU+JusPIJCiQlwyobNW28//e7VoXnFXnn+eZH08l2BTpUXwCsRXoy3u
	 NNbmzefTgR8D6Cn332AfRjLzGRbVUzAem/BnO0JXd4tdCjiJg4q1dqGrRBgmYtFgK3
	 q26jg5bNPLq2Ww5OieIzVjBTKFoKT71yFlKuOzTWm6xxYQk9MBFMY+bsLcksJWvy5N
	 nEp+lDp7aOHGdbjpl0Ly0KL9XTUd4e7ha7qV9MKU2KLypbkDuEOS3ICyHx7UG/Iv9z
	 f0++3ItiIjjIftcyK7J14QW3TR0WlRVHISpNax3+Cvv31rofq8VaA+jBAJwGd3jB0n
	 yHSzuytrNC/pA==
Date: Thu, 02 May 2024 21:35:06 -0700
Subject: [GIT PULL] xfs: last round of cleanups for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: aalbersh@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471078492.2662518.17791437990071795258.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <None>
References: <None>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 21255afdd7296f57dd65f815301426bcf911c82d:

xfs: do not allocate the entire delalloc extent in xfs_bmapi_write (2024-04-30 09:45:19 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfs-cleanups-6.10_2024-05-02

for you to fetch changes up to 1a3f1afb2532028c7dc5552b3aa39423c2621062:

xfs: widen flags argument to the xfs_iflags_* helpers (2024-05-02 07:48:37 -0700)

----------------------------------------------------------------
xfs: last round of cleanups for 6.10

Here are the reviewed cleanups at the head of the fsverity series.
Apparently there's other work that could use some of these things, so
let's try to get it in for 6.10.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: use unsigned ints for non-negative quantities in xfs_attr_remote.c
xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
xfs: create a helper to compute the blockcount of a max sized remote value
xfs: minor cleanups of xfs_attr3_rmt_blocks
xfs: widen flags argument to the xfs_iflags_* helpers

fs/xfs/libxfs/xfs_attr.c        |  2 +-
fs/xfs/libxfs/xfs_attr_remote.c | 88 +++++++++++++++++++++++------------------
fs/xfs/libxfs/xfs_attr_remote.h |  8 +++-
fs/xfs/libxfs/xfs_da_format.h   |  4 +-
fs/xfs/scrub/reap.c             |  4 +-
fs/xfs/xfs_icache.c             |  4 +-
fs/xfs/xfs_inode.h              | 14 +++----
7 files changed, 69 insertions(+), 55 deletions(-)

