Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DD17FF
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227369; cv=none; b=p9ihtfODjDy6lIvwVmA2iLyp3at0n0yXoLyJ0sF9yl0vaISL4QwduQngbmylAknPfx/lUykC68CHQByIBqvyfkj/JhmZAS2H7QvI7cTpAomIVajxvgC+0gCa4/GbWsxxzGeYT/sEUxKwRjZPBRqlxbpOEbklsQsqZhW0LSLaezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227369; c=relaxed/simple;
	bh=o43O5SvU0s/3yPRRAHp26W2EpOXtIIIUooFdseENA0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=SPsFpSQ9lzWSUrSKKgkI7Vw0dCS0xI5Ica0AUI4pLEPaS6oVXJEdqfhSQgl6BT8Smo8/Gzck7yBjRaCnqOvUxOkEGm2HL5cB8t0WA9CgFQxi1IBH4mkbi1a/pcIcpAuvx7160FH21BgwrMC9lKg1fb8K0AICbQ5iDE0iyGfigxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG03g6tS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG03g6tS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2587C4AF0D;
	Tue, 16 Apr 2024 00:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227368;
	bh=o43O5SvU0s/3yPRRAHp26W2EpOXtIIIUooFdseENA0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rG03g6tSDo8HFnEaOL1I6xhGdcYJeEEq2CrLhqNFuePSK4JCTywrdX4KEsDZepuij
	 GG9vPrW1c8jO4ZxtI8EBu7rSNjMeIJ52Jdj7hxB256rFL/1oR9u/3zS8rq7KHX3Ylu
	 iG9w+nJgohOV9l6WSgo7m3yQbOAUY8pMJIWwHrXtgFg2QsEEyZsH6b9kpN6EB9SoYb
	 HM8HPRUOvGyA+2LTVR4bh7viwLuC4N3OlDIpHxP6TGcimEhUlVX4G8oW3FW7/YCvWC
	 22ndeK+Qg6kmyB/oVEaqga/1+aE/hPA47dNoWMnALx7bpOKwBFSOAg0V6vv+QX0OIz
	 Fq2bRZVlm0mIg==
Date: Mon, 15 Apr 2024 17:29:28 -0700
Subject: [GIT PULL 08/16] xfs: online repair of inode unlinked state
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322717340.141687.6678010107258349437.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6c631e79e73c7122c890ef943f8ca9aab9e1dec8:

xfs: create an xattr iteration function for scrub (2024-04-15 14:58:54 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-unlinked-inode-state-6.10_2024-04-15

for you to fetch changes up to 669dfe883c8e20231495f80a28ec7cc0b8fdddc4:

xfs: update the unlinked list when repairing link counts (2024-04-15 14:58:55 -0700)

----------------------------------------------------------------
xfs: online repair of inode unlinked state [v30.3 08/16]

This series adds some logic to the inode scrubbers so that they can
detect and deal with consistency errors between the link count and the
per-inode unlinked list state.  The helpers needed to do this are
presented here because they are a prequisite for rebuildng directories,
since we need to get a rebuilt non-empty directory off the unlinked
list.

Note that this patchset does not provide comprehensive reconstruction of
the AGI unlinked list; that is coming in a subsequent patchset.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: ensure unlinked list state is consistent with nlink during scrub
xfs: update the unlinked list when repairing link counts

fs/xfs/scrub/inode.c         | 19 +++++++++++++++++++
fs/xfs/scrub/inode_repair.c  | 45 ++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/nlinks_repair.c | 42 ++++++++++++++++++++++++++++++++---------
fs/xfs/xfs_inode.c           |  5 +----
fs/xfs/xfs_inode.h           |  2 ++
5 files changed, 100 insertions(+), 13 deletions(-)

