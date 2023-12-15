Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8456778
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRRwH2OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96310C433C7;
	Fri, 15 Dec 2023 21:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677312;
	bh=yQiZLv7CHrS0se9lS/YvEFTHBctWx+Rk6WfYWvbwpic=;
	h=Date:Subject:From:To:Cc:From;
	b=MRRwH2OAzNdMhS94iO3SlCR0SP0hB34y4c7puag85enJNDtuWwqcKq7KKw0NTDQg2
	 ijH/lY1SgoOYccZXg/0FYoWLppJgw9s3Xiwofm4EqKEgWWQEI2SRZn3q/IJT4bAZwF
	 0RjUHSxmHXd5ab8JIRR52QUxj5L6ZxpFIvoUJ0goBvdUHU+Ka4Lp6S/TTP5DDxIhuH
	 RZ4RkrATftkX0FcmxGBRj9p0yOqLNIHGvb3NEzwVGM0uGovOX1PUAKSHaUjCDoy82D
	 QRWKYWk8hjhKaDjDLkVeUn4/gTiHSj7Cs2QHCnd0av2msedtql3ToqcH+ASXnKK7O4
	 brS5zZNfIjlzA==
Date: Fri, 15 Dec 2023 13:55:11 -0800
Subject: [GIT PULL 1/6] xfs: prepare repair for bulk loading
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170267713236.2577253.8439413037561169584.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0573676fdde7ce3829ee6a42a8e5a56355234712:

xfs: initialise di_crc in xfs_log_dinode (2023-12-15 09:33:29 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-prep-for-bulk-loading-6.8_2023-12-15

for you to fetch changes up to e069d549705e49841247acf9b3176744e27d5425:

xfs: constrain dirty buffers while formatting a staged btree (2023-12-15 10:03:29 -0800)

----------------------------------------------------------------
xfs: prepare repair for bulk loading [v28.3]

Before we start merging the online repair functions, let's improve the
bulk loading code a bit.  First, we need to fix a misinteraction between
the AIL and the btree bulkloader wherein the delwri at the end of the
bulk load fails to queue a buffer for writeback if it happens to be on
the AIL list.

Second, we introduce a defer ops barrier object so that the process of
reaping blocks after a repair cannot queue more than two extents per EFI
log item.  This increases our exposure to leaking blocks if the system
goes down during a reap, but also should prevent transaction overflows,
which result in the system going down.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: force all buffers to be written during btree bulk load
xfs: set XBF_DONE on newly formatted btree block that are ready for writing
xfs: read leaf blocks when computing keys for bulkloading into node blocks
xfs: add debug knobs to control btree bulk load slack factors
xfs: move btree bulkload record initialization to ->get_record implementations
xfs: constrain dirty buffers while formatting a staged btree

fs/xfs/libxfs/xfs_btree.c         |  2 +-
fs/xfs/libxfs/xfs_btree.h         |  3 ++
fs/xfs/libxfs/xfs_btree_staging.c | 78 ++++++++++++++++++++++++++++-----------
fs/xfs/libxfs/xfs_btree_staging.h | 25 ++++++++++---
fs/xfs/scrub/newbt.c              | 12 ++++--
fs/xfs/xfs_buf.c                  | 44 ++++++++++++++++++++--
fs/xfs/xfs_buf.h                  |  1 +
fs/xfs/xfs_globals.c              | 12 ++++++
fs/xfs/xfs_sysctl.h               |  2 +
fs/xfs/xfs_sysfs.c                | 54 +++++++++++++++++++++++++++
10 files changed, 198 insertions(+), 35 deletions(-)

