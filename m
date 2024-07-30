Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C06DF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307297; cv=none; b=W68OL+v57/VZB8V7RHMN1S2+TdZ+efacLwEjxfVH3PQSaT3HPu9+QOuVD0Os0Fpu6p/ax+0gaY7cLsQ9BPAmu5QwVZT+afmI2fD1dMKWkoyyjfoAl/Bnvr4eFN7D3kHwTfOZwnUiONxO5cYajq8CXHrOg1Pb564v3h/MCfodt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307297; c=relaxed/simple;
	bh=Rkblvs7josCQWWp6gV+kKYbnhVf1jav1CJJIq+cdj0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=lhrn4RuAlwKRKlsZk4WcBfU8znmb46F0XEfSD7xJWtLdJNutRCvbEjG3ZFOBvGvbKwo+ClFRRPwHJfvnO5Ig1RrMhmbOrH2zZkJyJgB8FmxDdUMum6saZtNeuXa1N1aIyUscO8boLiOTTrD7BlrPj/h0Y/CT/Em9LCVdAY8cRso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV0v4dAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV0v4dAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C7AC32786;
	Tue, 30 Jul 2024 02:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307296;
	bh=Rkblvs7josCQWWp6gV+kKYbnhVf1jav1CJJIq+cdj0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aV0v4dAB3Akl5dCSXHC+Fy9j+p5qFbpgjOwn8HWcVYvVtWMy0+/OFpRsPspSoq1xe
	 AcojEOMAypvmXFAdzhue7OKsgIaQOjQl+A+NYUVtgBMgF8vl2osi0r7r8qmwCVy8RE
	 xl0/svgf5x1oFhCVYOsGorvTkqf2CBGL8kdYprjYpJXFTw0PW30yZIWLPfyV2G1bT3
	 RDpL8Zv/G3J5+lAplMqn461Zo5AFldRESTtLE6klLkyd1AQHtvX7RYLbyJ5PLKqyTX
	 Bn/yDuPQkEJclpJ1WZAlDnyhX5l2kE9IohZO0Ev3DobJ4OMDpGLFNLPlbSlMHM1fWT
	 guxEopLCb6rDg==
Date: Mon, 29 Jul 2024 19:41:36 -0700
Subject: [GIT PULL 05/23] xfsprogs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458253.1455085.17011073206641235117.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 7e74984e652fab200bc7319d7c3d90f6ae36be2e:

xfs_{db,repair}: add an explicit owner field to xfs_da_args (2024-07-29 17:01:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/inode-repair-improvements-6.10_2024-07-29

for you to fetch changes up to ebf05a446c09336c08865dc29a6332be6ff8223c:

mkfs/repair: pin inodes that would otherwise overflow link count (2024-07-29 17:01:06 -0700)

----------------------------------------------------------------
xfsprogs: inode-related repair fixes [v30.9 05/28]

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.

This scattered patchset fixes those three problems.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
libxfs: port the bumplink function from the kernel
mkfs/repair: pin inodes that would otherwise overflow link count

include/xfs_inode.h |  2 ++
libxfs/util.c       | 18 ++++++++++++++++++
mkfs/proto.c        |  4 ++--
repair/incore_ino.c | 14 +++++++++-----
repair/phase6.c     | 10 +++++-----
5 files changed, 36 insertions(+), 12 deletions(-)

