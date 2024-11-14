Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8B1BC49
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543563; cv=none; b=oDRrxfK+uVck7Tt8XJ1e18MHHgVzaL1pPZQwsMUAqjjHurv+FPvSXoUXMs4jXM2/DXyBFh73cWovRnwHSuqQxSpJWJdkafqn85cuX20H2gLhLB6TFXbyHw6XQ8y9KgDS41Bmh2NaclzuMMDBm5grBiqEQ0+WWsUiDl+kaAAPI68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543563; c=relaxed/simple;
	bh=k0FtU4gi36I48WfG9SyHPkf8RsreSQVd7NC8jYubAlE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=QpotGLzc2SVWp82OrH/xpWz8V+RUT5a9EnKuSQBCj6ZyHjM6avvMrXgyr+n86/1KY6s9kxgP0vHfmRDHD5sZnL0/RfKzVcX5HP3u20AeeZyr9qF6q7BY8kdQe3I0E/1Fk203QHbSN+3Vqy/QEwlvR5fynumE5z7h3z6SRkXjmUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S30ud34M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S30ud34M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D715C4CEC3;
	Thu, 14 Nov 2024 00:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543563;
	bh=k0FtU4gi36I48WfG9SyHPkf8RsreSQVd7NC8jYubAlE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S30ud34M4Et3vdwPRbB42xQMqwuq2tjj/XlcpwkbE4jo2M6kX+HdEMo0gXP+y6rIT
	 nAPoerEeG3lyUqIPxOOtusX6sXlUDQ0Q15Zxco0at/meGLNxdVvU00J7mW216l00QI
	 8UlhPppO3dYLRhpz+irIJZzhca/yfO3zUGNM+o6CtBo8iP8fdlIj/jAUg/GzIin0Dj
	 yHUsB5qfoAr4/8FWnL2lUH5RAT5g3qCLPbsgxfI9Kt0LRDiNBfn7GBN3YHf2tVedWs
	 oaW6yBxy1s8crDero1fpALAO7xF+j78m9C3Qqv+QwrYfG0EdyGPYXEh2kSADix8eBr
	 8/o6alzcy2IoA==
Date: Wed, 13 Nov 2024 16:19:22 -0800
Subject: [GIT PULL 07/10] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342485.1140548.17449607487412358951.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4e88a1158f8c167b47a0f115b74d4ffbc1c9901d:

xfs: use rtgroup busy extent list for FITRIM (2024-11-13 16:05:38 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-quotas-6.13_2024-11-13

for you to fetch changes up to 7b9f1c2e842b1f493c4fd7e2c878c9fd785ec033:

xfs: persist quota flags with metadir (2024-11-13 16:05:38 -0800)

----------------------------------------------------------------
xfs: persist quota options with metadir [v5.6 07/10]

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: refactor xfs_qm_destroy_quotainos
xfs: use metadir for quota inodes
xfs: scrub quota file metapaths
xfs: persist quota flags with metadir

fs/xfs/libxfs/xfs_dquot_buf.c  | 190 +++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_fs.h         |   6 +-
fs/xfs/libxfs/xfs_quota_defs.h |  43 +++++++
fs/xfs/libxfs/xfs_sb.c         |   1 +
fs/xfs/scrub/metapath.c        |  76 +++++++++++++
fs/xfs/xfs_mount.c             |  15 +++
fs/xfs/xfs_mount.h             |  21 +++-
fs/xfs/xfs_qm.c                | 250 +++++++++++++++++++++++++++++++----------
fs/xfs/xfs_qm_bhv.c            |  18 +++
fs/xfs/xfs_quota.h             |   2 +
fs/xfs/xfs_super.c             |  25 ++++-
11 files changed, 586 insertions(+), 61 deletions(-)

