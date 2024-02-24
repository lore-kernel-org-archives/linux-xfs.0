Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FDB4A05
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738216; cv=none; b=NwRgFZadIysip4Af4e8LwA4H510sjMKNJrzl/SLPHKayunvnhjzk3POz/neRGMoRacFpny6g6x5E5XZXmW/Ro+RJNs2TaLBL0EAwhK81Qjm0nhJJlVx0sW691vvdVLlhB9D8qePbnxrz0QPLiFwjvEeq9JqARHFX7Pwk6f4gQVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738216; c=relaxed/simple;
	bh=suktxaHdtmDAE3cxTGbaMcpl3bCKByt5FBAl7HfoSvM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DMMieb2CBsk+fqBTjT28ycnbSkOBkyyr5kLiXzZvY1qBBeZZat2wDIDgwu2vVowK1HVcVggoCqapSFr1g4CBnoy3vhVJ627kMgCb0a6XoA0jaBFQz3BJF2xifVrh65dV3TnhBr+FtyyujcbQL4c096fJxlDeyVCC7KCxvzA7PSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmTN25OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmTN25OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EF5C433C7;
	Sat, 24 Feb 2024 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738216;
	bh=suktxaHdtmDAE3cxTGbaMcpl3bCKByt5FBAl7HfoSvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LmTN25OXfa1YvtThQuhKi9akqpjcUGuP8P8eDmCFUMlwNzglNDIk+CzzuwtM6TyvN
	 LD7RYvx/+iK3OYBmjCGCyEN37fXG0e16zvvoTN1CpNlb1WtQGnlxT+0FoDquMkX618
	 gxdA6GjQ8fkQfGWMUGln8ncsqn7UQEEZF7NGauTKZKz0V6bdSwZoOZZy3LVKAoijUH
	 IEXW+769OZAPrExMImg0zGeCHTIETLhGikicCQo2uAp3Uicyr1TwFeSbnTrgOlrbVC
	 06CL87Ddmwi+MYh94duc/L8wBcAuO+1uzrgOujqDyD1Wx83Wp/cZu/FTsMMU6Yh9ib
	 E5UYBtxLobmGQ==
Date: Fri, 23 Feb 2024 17:30:15 -0800
Subject: [GIT PULL 5/18] xfs: indirect health reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873802029.1891722.8679783946344381114.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 989d5ec3175be7c0012d7744c667ae6a266fab06:

xfs: report XFS_IS_CORRUPT errors to the health system (2024-02-22 12:32:55 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/indirect-health-reporting-6.9_2024-02-23

for you to fetch changes up to a1f3e0cca41036c3c66abb6a2ed8fedc214e9a4c:

xfs: update health status if we get a clean bill of health (2024-02-22 12:33:04 -0800)

----------------------------------------------------------------
xfs: indirect health reporting [v29.3 05/18]

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: add secondary and indirect classes to the health tracking system
xfs: remember sick inodes that get inactivated
xfs: update health status if we get a clean bill of health

fs/xfs/libxfs/xfs_fs.h        |  4 ++-
fs/xfs/libxfs/xfs_health.h    | 47 +++++++++++++++++++++++++
fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
fs/xfs/scrub/health.c         | 80 +++++++++++++++++++++++++++++++++++++++++--
fs/xfs/scrub/health.h         |  1 +
fs/xfs/scrub/repair.c         |  1 +
fs/xfs/scrub/scrub.c          |  6 ++++
fs/xfs/scrub/trace.h          |  4 ++-
fs/xfs/xfs_health.c           | 33 +++++++++++-------
fs/xfs/xfs_inode.c            | 35 +++++++++++++++++++
fs/xfs/xfs_trace.h            |  1 +
11 files changed, 196 insertions(+), 18 deletions(-)

