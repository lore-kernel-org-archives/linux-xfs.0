Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4493F1BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989781; cv=none; b=hp2vpKnvpo18wCkV/ReQrvqPMxCCBVY0reysYtbSMSWTU2/I55R/acxppI/ggNF+N4yO8l31cSgujA7K6dGtStsL48NIqEXtvqjIeY9UN1itRxSqVNqodN173EQYJSuI+TCh3091sLyvtfYzSuKe0QOzsdGkMaev/iax34iDn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989781; c=relaxed/simple;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSJzSAKO5H0LaVrpmCfPU5RW93dQ9iNhSFXmiwJTWIZUjsegK8/CsfVQxJbcLzVLiWJpCmTNxmYMgvtCq8tUVKhXaBHZ4+j5b2zfCYI+M1npkYvK2iv7u5eWMLIyy7o6Gy8mZCyUw1CVEyBHa0vCSw/zCp3zkneV5LGOaZrGpus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irJyKEip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irJyKEip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D521C4CED3;
	Mon, 23 Dec 2024 21:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989781;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=irJyKEipcQ4NUzDOtxz/6VU+a8guDSHdNy8Nx2PoHo23yYEBUVnrETnFU7ou6G+6z
	 FtMd6kQ8CSGaiW6hn064mi7RFjoy0kL+VxU7yXUBeShmkkVmP3P/D/MXLD8UDKESO1
	 y0JDE2q6KtUXHnBYPpqxYQeDr+CJ24F1/gzVIQiJ41mWSeHbk6yxO9pN1rQ3T3d8Do
	 B+qIeo93w2w2lborzrB0p4Qcn6RT2MOvr0v929y1WFphNgXTjeIsnnA47mhAPleMHy
	 zHQCCZNPn3ntdFGvcv7EOGrJXdzkjA9/9/caKjJZuynVTSi8hQgVH1E8Ezenj+jInk
	 0XeUXNCFwoS/w==
Date: Mon, 23 Dec 2024 13:36:20 -0800
Subject: [PATCHSET v6.2 8/8] xfsprogs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498945439.2299549.17098839803824591839.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
Commits in this patchset:
 * xfs_quota: report warning limits for realtime space quotas
 * mkfs: enable rt quota options
---
 include/xqm.h   |    5 ++++-
 mkfs/xfs_mkfs.c |    6 ------
 quota/state.c   |    1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

