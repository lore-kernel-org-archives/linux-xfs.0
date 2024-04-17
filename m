Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362D718C19
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388625; cv=none; b=K94RcPNtRsfKksUokJ+XYzA+XZmsT74qjgqvASpvI75K+K0Id7JrEMbtipRvWkFPBOGBmyxdZkJhs42Cq85oMGS89V2NPsEN7HNoL1Msr64WN2C5VizwsySSPzJ0odbSiB0STXsWIJT8VkzBgcXDKzKG0XD06BD86Q95/+JtdwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388625; c=relaxed/simple;
	bh=ePevMEXnDvzjVeOIQwaBno35xdu5MIlXeNfeq4FP8Fc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8ARMRSAaHPuau8AiZsyuRz0wQw969yUmh1mdNPeIe5xFz6/DYGbn2czHAPMC66IkCjdRLOPniiOJuVQyBWkGAMIGeqEg9Pw7uGb1w+RHfM7t1QYgZENES4YBIQMH4Mz42dtEouc6lOq74CYCMJ+D6IVkrmcaPZl/t0X4Mjeeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtSVh23H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtSVh23H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7052C072AA;
	Wed, 17 Apr 2024 21:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388624;
	bh=ePevMEXnDvzjVeOIQwaBno35xdu5MIlXeNfeq4FP8Fc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gtSVh23HWRzSmfl/Fw8COycDZzf1fzN/VcohNyV31Y0goKxSbv0sHTWJDZaqJxEtB
	 D3jekTBlF86L+I9LNWTCZkWQ3gTec+zAmDzfwg9wMF3iPZF4QqFEXL1KDYvYgvtdsN
	 Hw1bktfWimBnlUdYMT/M8iIONNojGc6w3Gl4wKu/N2PrKjALMsoRR7+hanf+aVlkzx
	 5QsHCoiNMVwD9zebWaskgouSWMrnjSDHZ8zA1HSmkRbQYyJ3wofFL0nCIH9KUrXu8y
	 UmJu9Bgxl9x23QI2r+T1zVo7APq8EP30rpOVf7avEnUnvrFhgHf8urSLEPMXYN3Kh1
	 WAQe7cHToscoA==
Date: Wed, 17 Apr 2024 14:17:04 -0700
Subject: [PATCHSET V3 07/11] xfsprogs: fix log sector size detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Pankaj Raghav <p.raghav@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

From Christoph Hellwig,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v2:
 - rebased to the lastest for-next branch

Changes since v1:
 - fix a spelling mistake
 - add a few more cleanups

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fix-log-sector-size-6.8
---
Commits in this patchset:
 * libxfs: remove the unused fs_topology_t typedef
 * libxfs: refactor the fs_topology structure
 * libxfs: remove the S_ISREG check from blkid_get_topology
 * libxfs: also query log device topology in get_topology
 * mkfs: use a sensible log sector size default
---
 libxfs/topology.c |  109 ++++++++++++++++++++++++++---------------------------
 libxfs/topology.h |   19 ++++++---
 mkfs/xfs_mkfs.c   |   71 ++++++++++++++++-------------------
 repair/sb.c       |    2 -
 4 files changed, 100 insertions(+), 101 deletions(-)

