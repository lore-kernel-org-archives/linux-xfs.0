Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3B1C36
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606921; cv=none; b=s6sD54d28C4YDnMhI72NbWtNhsx7mZgaLxgUK3zXLVI4S9bYD1+MMTCrJrybhOjvaSErMODQUyM4vkSJGXc/G69BwGgGGsxGhDM0IVukR1cg7fN1kl2Y+eafYgjj4sAsM9Npaob+nJEBvxZdL6Iz/di0AGkDzvJoTV65xF+ZFb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606921; c=relaxed/simple;
	bh=dyMcNBcxJPiQDAiz1uNXkJg3DL4aFmlFMCDl/VRxX6A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKs45a+n90lbxY/l53M39NjxikIFs4uID9qBIUm4C21A4BPR0G+RdmDknELSPEFHCYXxjvWBCdC0p/o34BaCcl5AY/ey6JLQWJuBBOPoBg2OtSZhL/nZToQ6w3OZvT3Xsb3+TK2eMzNUjZHN3ixD+/VRY1mI8ruUPSUFahW+2nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTvdom8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTvdom8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC67C4CEC5;
	Fri, 11 Oct 2024 00:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606920;
	bh=dyMcNBcxJPiQDAiz1uNXkJg3DL4aFmlFMCDl/VRxX6A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cTvdom8l9FP43U7+tYVu1OwzR94shkpUqaVQ/IF2qubKvEdTSIMNTJ9kShQFYQf0k
	 eFK10RK9xDCy48538oPpynRkaQQkHeA6I+Hlheq33NyPOc4i7Y7N/J+q2ZwJpC+T29
	 Hx5WcNzw2jciEAS34eZUEEgcQjwf50ZiB3ofbvv8cWa1J0pwR1fKO6P5XHMajpq5XX
	 TgWPaEJBoARcjUVLAC3Cs+4Z6dCLyo99Wa6m50LKGx7G/+Bj6hghPrbNja87jh2Kki
	 2TKYQhV/idqf+0i94cM09ZeceSqUqxIrYFjU/h4/CH+8fCDC018Hy4vzHfR8ag7ms7
	 c2LV3rO/1V/Hg==
Date: Thu, 10 Oct 2024 17:35:20 -0700
Subject: [PATCHSET v5.0 8/9] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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
 * xfs: fix chown with rt quota
 * xfs: advertise realtime quota support in the xqm stat files
 * xfs: report realtime block quota limits on realtime directories
 * xfs: create quota preallocation watermarks for realtime quota
 * xfs: reserve quota for realtime files correctly
 * xfs: enable realtime quota again
---
 fs/xfs/xfs_dquot.c       |   41 +++++++++++++++----------
 fs/xfs/xfs_dquot.h       |   18 +++++++++--
 fs/xfs/xfs_iomap.c       |   37 ++++++++++++++++++-----
 fs/xfs/xfs_qm.c          |   75 +++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_qm_bhv.c      |   18 +++++++----
 fs/xfs/xfs_quota.h       |   12 ++++---
 fs/xfs/xfs_rtalloc.c     |    4 ++
 fs/xfs/xfs_stats.c       |   12 ++++++-
 fs/xfs/xfs_super.c       |   11 +++----
 fs/xfs/xfs_trans.c       |   31 ++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   11 +++++++
 11 files changed, 194 insertions(+), 76 deletions(-)

