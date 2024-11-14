Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9491632E7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565680; cv=none; b=XQzNQFUiFykt/C00C53daKUWexuTb35B+wMeBEtaRnzA7X96+m1/8r+PsuaD2dGMLAhz+DSZl6gATDW5JDF/UabtfiP0ic+P1N0fsPS0Q0jTPwvUIX+dGh4UY0pRu5SBBKMTriOUPS8aqM0+zvtuJ8Edg4GE+6E8w9riIKXb0Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565680; c=relaxed/simple;
	bh=nI74nav8Tds8dFPan82YK+zX+EDGVnkl2+eNvxhdFG8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=R0r1Vas2YsHjJwO/g3pGIIxI0RktM4sj8G1inFjspsnAtlY+MrvTXOsCF4qv5p7LAvYkxbKFlv4wVmWtRdP+j18y4N6HyjW9ykRmprP6md39iJ5fYrkxi3ktVUEfYijqD/Oxek5b4wmYYQbjwCgIWCTDZRlqDkbtlgzfsLmsS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXFzUkQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXFzUkQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A8C4CECF;
	Thu, 14 Nov 2024 06:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565680;
	bh=nI74nav8Tds8dFPan82YK+zX+EDGVnkl2+eNvxhdFG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tXFzUkQeJC0QxUsu25sko989xxSksXy/ZnLHNj0GlaTesAMwTdE8Ov4ahBW83/OeA
	 qwb6t3DorhZ0Z2MpsJenJz1+oNtIVhtSfpR4GPXzulYkVN+jG9Ax+z8S5vG3OUesxb
	 4gto5h2DfX3xzEAFOK9NRpczsufi8wiCizhU6bVpF1SlV8R6JgfO3ajw2xb3MBpFSu
	 St++0QmnaICd8JsGS0kGURCnSQxZwBE+H1AaDCHvcDHvUn9/DnC1Pl8j1RPqeOsOCF
	 OKqvYy1Wg6LU4iRlttvrhRdafPjkqxeNeCUHKDvff30yf/pv/yZstr2zzelbBcQqQX
	 GtPwzPXPRkWBw==
Date: Wed, 13 Nov 2024 22:27:59 -0800
Subject: [GIT PULL 08/10] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551772.1445256.15514711426901305678.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit a68492e312d9033055b0012a08f2e23ea7311654:

xfs: persist quota flags with metadir (2024-11-13 22:17:12 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-quotas-6.13_2024-11-13

for you to fetch changes up to 5a1557a29fb395698f8222404507d19c6f893361:

xfs: enable realtime quota again (2024-11-13 22:17:13 -0800)

----------------------------------------------------------------
xfs: enable quota for realtime volumes [v5.7 08/10]

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: fix chown with rt quota
xfs: advertise realtime quota support in the xqm stat files
xfs: report realtime block quota limits on realtime directories
xfs: create quota preallocation watermarks for realtime quota
xfs: reserve quota for realtime files correctly
xfs: enable realtime quota again

fs/xfs/xfs_dquot.c       | 37 ++++++++++++++-----------
fs/xfs/xfs_dquot.h       | 18 +++++++++---
fs/xfs/xfs_iomap.c       | 37 ++++++++++++++++++++-----
fs/xfs/xfs_qm.c          | 72 +++++++++++++++++++++++++++++++-----------------
fs/xfs/xfs_qm_bhv.c      | 18 ++++++++----
fs/xfs/xfs_quota.h       | 12 ++++----
fs/xfs/xfs_rtalloc.c     |  4 ++-
fs/xfs/xfs_stats.c       |  7 +++--
fs/xfs/xfs_super.c       | 11 ++++----
fs/xfs/xfs_trans.c       | 31 +++++++++++++++++++--
fs/xfs/xfs_trans_dquot.c | 11 ++++++++
11 files changed, 182 insertions(+), 76 deletions(-)

