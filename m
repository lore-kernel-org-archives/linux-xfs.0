Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B2189BBB
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735687956; cv=none; b=bUf5Nx9wwlfYyw8hvEyNaww2DfmwsDKexL4lgb/OjiarX+zCmU/DQv5bo59SnbsG/kzvDtEvc6LRG3On9gvnjChpvhwhkXnl14am+sHn//k/HYM8/OxMTY2IBhIgo2z8dayLwvCUFWuD4VmkqxVZnJ3q5c/SZOsf1wN+/qjwN6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735687956; c=relaxed/simple;
	bh=CoAuLMvJ5m7cCV4l+GOoBMjNE+OOK227x+p3XSnrS0A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L0xGX09VhUVyA6vnKCt1bsID5C2SDHllEbaef7JWw7CFiiiPKioF0Xl9H2+383h12t70DWP1lffc94Zb0s9X++HpIaXttjlu/gQQ22qjKr9Hzw75TQPWhBaFcBPITdEbZ1mZw1DJIXaErErYRGS4T0bmdsOZ6Abi4R7ORBjrvbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhYepVt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhYepVt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0068C4CED2;
	Tue, 31 Dec 2024 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735687955;
	bh=CoAuLMvJ5m7cCV4l+GOoBMjNE+OOK227x+p3XSnrS0A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DhYepVt3s1mqVzDwRnz0HD7Lm73kx/elm9Z1bCwxLASKbaaPzRYezXSZwHqGeTfNv
	 GXQtDhv4/X4TXmVhn7Yb7DMz7zeG8j2/25RPPM9idW67vmiNnA1kS05NHItN2Iqr9C
	 5NPfF3RjiDdjsaUB1SWG1czmmXYIBv92FLfh/2wURa+xDJE78qRqa21Dvc2DXOslat
	 wzkEEocqmr0wOFEsFmQeYRPuGdBIme1P5RF5OXRqO3bueEd82AKE9EKnYDdeH2D1NM
	 slNuaUMDbjABcU64ulKZxkVtkDErhZidMILT8gjzEpB8yhHxSKIPCmQgFgwBPm5EUd
	 nrRJv6mL2AYdg==
Date: Tue, 31 Dec 2024 15:32:35 -0800
Subject: [PATCHSET RFC 2/5] xfs: noalloc allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series creates a new NOALLOC flag for allocation groups that causes
the block and inode allocators to look elsewhere when trying to
allocate resources.  This is either the first part of a patchset to
implement online shrinking (set noalloc on the last AGs, run fsr to move
the files and directories) or freeze-free rmapbt rebuilding (set
noalloc to prevent creation of new mappings, then hook deletion of old
mappings).  This is still totally a research project.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=noalloc-ags

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=noalloc-ags
---
Commits in this patchset:
 * xfs: track deferred ops statistics
 * xfs: whine to dmesg when we encounter errors
 * xfs: create a noalloc mode for allocation groups
 * xfs: enable userspace to hide an AG from allocation
 * xfs: apply noalloc mode to inode allocations too
---
 fs/xfs/Kconfig              |   13 +++++
 fs/xfs/libxfs/xfs_ag.c      |  114 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h      |    8 +++
 fs/xfs/libxfs/xfs_ag_resv.c |   27 +++++++++-
 fs/xfs/libxfs/xfs_defer.c   |   18 ++++++-
 fs/xfs/libxfs/xfs_fs.h      |    5 ++
 fs/xfs/libxfs/xfs_ialloc.c  |    3 +
 fs/xfs/scrub/btree.c        |   89 +++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.c       |  107 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |    1 
 fs/xfs/scrub/dabtree.c      |   24 +++++++++
 fs/xfs/scrub/fscounters.c   |    3 +
 fs/xfs/scrub/inode.c        |    4 ++
 fs/xfs/scrub/scrub.c        |   40 +++++++++++++++
 fs/xfs/scrub/trace.c        |   22 ++++++++
 fs/xfs/scrub/trace.h        |    2 +
 fs/xfs/xfs_fsops.c          |   10 +++-
 fs/xfs/xfs_globals.c        |    5 ++
 fs/xfs/xfs_ioctl.c          |    4 +-
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_sysctl.h         |    1 
 fs/xfs/xfs_sysfs.c          |   32 ++++++++++++
 fs/xfs/xfs_trace.h          |   65 +++++++++++++++++++++++++
 fs/xfs/xfs_trans.c          |    3 +
 fs/xfs/xfs_trans.h          |    7 +++
 25 files changed, 599 insertions(+), 9 deletions(-)

