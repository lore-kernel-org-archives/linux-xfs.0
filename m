Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838B52943F
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543579; cv=none; b=Dphifn96GPOk+dj/Aa2p9Do+mqMOebVC2O3T0i+bI1B66/KHxeVML7pwpKZ0mjF01S2m2+eQxnycCjChjp4CA745NFzewhWYp+77/OS656pbOUs+1IzXsIMimoUYeZ18UPLIyRjPPEdQQIS9DyE33v/cNQ3cURPjWoF7Bo14aB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543579; c=relaxed/simple;
	bh=9IldSwpY7aOWfTwQA/J94xDyExds5ntBeR9z8vjVeJI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=kAAToFGCmSgJXTZgSB9jUwchA/vFvQYFJEIEFEIkLxAnlm1084hdydCOh0ZIqmVT5kPTftUYVb722gBqxILuAwnTf6rDmu+Cbk+kCb/Oz+tFCyfNQ+ZfnvcSzzvfMxqqcO0uXnKfFc6bU3raRlnKOTVd76zub3pLvjLZLKHeuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6bsS2Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6bsS2Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C71FC4CEC3;
	Thu, 14 Nov 2024 00:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543579;
	bh=9IldSwpY7aOWfTwQA/J94xDyExds5ntBeR9z8vjVeJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J6bsS2Jk1bzvmhkr5/WiXu9j+fpcRnCj6iB43LKgnK/gCxCu1GmRmiLEw/o6M/oBa
	 qyreSaFdY4TK0P91By862BP08bZlBExHHEZXPtVcqDnRD5DvFnFcvxFH+W6NorF7hX
	 xgsslaJVGI7MSvjIdIqLnjYLwbFd0HVh5BedQy7//asFim/KbGi/I5vcysD90k/pxJ
	 NUlVJux3pft4Qgr6UCPJJaxZq0Xw2tVq1SVAYmzg88PdpTJHzlWy1LVnqFxRHqOjcN
	 zmqkaEnA6rimW8ViqVzmCvV4wh+PKNM3joY/rGZ12tgKIZtMVAVSwYbkNNNrhNYbii
	 /4X+rUUw8a4Xw==
Date: Wed, 13 Nov 2024 16:19:38 -0800
Subject: [GIT PULL 08/10] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342584.1140548.16670512765123388017.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 7b9f1c2e842b1f493c4fd7e2c878c9fd785ec033:

xfs: persist quota flags with metadir (2024-11-13 16:05:38 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-quotas-6.13_2024-11-13

for you to fetch changes up to 72eae9ba15798bdea27ebd975323a32c3319827a:

xfs: enable realtime quota again (2024-11-13 16:05:39 -0800)

----------------------------------------------------------------
xfs: enable quota for realtime volumes [v5.6 08/10]

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

