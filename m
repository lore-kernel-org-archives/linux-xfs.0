Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06A212C819
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391734; cv=none; b=DwuAGp9qNI5WNAIBtsTztQCRZKF1wFVVLakA/SiRLP9Ok4IvhHD/0vzotvG7OQ5rH06gGf7zUblNTaGYCJJp3aIqPZWZcoHhaBxTwJiWthAjCGxrEg4bR2wQhyaCy6G0+pVWsoOH2jY5MaXa9mOztnYPidHgDmbN7IBgyQK+Evw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391734; c=relaxed/simple;
	bh=z0H/aDdhNp5bYFnFKIBD1JWR/J/zsL0SZcCoxlvbjgA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=GB4lnQi1OsEtSYqG9zy2M5U0WZ4q2J5+I50nfYE8r9J/P1s0/bG2oBE2g+WQjfrV/nxwOAcBwtQz2iiVKC74z1pm+uObvt9w1NYaQF4Rl29P47r90BO4zuERlDArXBiqWv6zWSKq74+h4SjUQiJCDID3lvgZ2kUjJaeSIeEFWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ashLVvP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ashLVvP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD2BC072AA;
	Wed, 17 Apr 2024 22:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391734;
	bh=z0H/aDdhNp5bYFnFKIBD1JWR/J/zsL0SZcCoxlvbjgA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ashLVvP1p3zSsFZ3vLAGkq2fgPqAymqrR70Od9nn/JYCtO+FdG+nVm0uGq+TtHYXV
	 ogT94dJNINc+5ssCKktpf3d9yZNRP3JvA9YZ3i/DWZajlkxbf+Xb+fS+YE6zpo0wVi
	 Z3OMuDB3TP1hKkmVbx9IQO6p3cwP9YZdLb+VetmRfJzyFjTVlZcMVJ/5KryU5qEzdx
	 zItYT3oLKN7sb0Tv865Q9QJCreRb0Cjg0+io4krnrYAj63eYN+c8HYHvoSv6nDArp8
	 nnC6eThehX+xnC7wWFC6PfCxswj4SgxtOIFSMkXz1WNoWm6d8fasVoK7iY5/HmqPPY
	 Xcr/2nAeT/gLg==
Date: Wed, 17 Apr 2024 15:08:53 -0700
Subject: [GIT PULL 06/11] xfsprogs: bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339160291.1911630.16552547686432095856.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 2f2e6b36a22c510964fa920b15726526aa102e2c:

xfs_repair: bulk load records into new btree blocks (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfsprogs-fixes-6.8_2024-04-17

for you to fetch changes up to 16a75c71b4c04373c0c726b8e6ddfd030a81c93e:

xfs_io: add linux madvise advice codes (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
xfsprogs: bug fixes for 6.8 [06/20]

Bug fixes for xfsprogs for 6.8.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs_repair: double-check with shortform attr verifiers
xfs_db: improve number extraction in getbitval
xfs_scrub: fix threadcount estimates for phase 6
xfs_scrub: don't fail while reporting media scan errors
xfs_io: add linux madvise advice codes

db/bit.c             | 37 +++++++++++--------------
io/madvise.c         | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++-
repair/attr_repair.c | 17 ++++++++++++
scrub/phase6.c       | 36 ++++++++++++++++++------
4 files changed, 137 insertions(+), 30 deletions(-)

