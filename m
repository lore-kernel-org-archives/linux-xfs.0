Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B8DB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gM3zfx55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DCFC433C7;
	Sun, 31 Dec 2023 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051879;
	bh=Bq2qnRApCX+nh6FlnrmxGpdYv7qz24Gz+MoROQ+GU98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gM3zfx55OrSuUeATy11cghT/oPLLcn5v0Q2UIRh5+YWKAlblJMbda1wfpzP8Uu2E8
	 dvtb1iwMxiEpp0m9OsxorMpNt0vYnEzyfT3M3Ygnkhj0ThIkw+/meDZwlYfnRVo+YG
	 D+j8gxEC/csw4RJC+t9K6ASr9OIusQbdlyekNA3IANXh5fGsGQH4UsiWXQvOWx5A6h
	 ttIrsF6Zz1Hsg2vvmfIbliN+XGXXFElDrQMVNpkXCP3A3Rbqv4wBmFhNIsWNP1SOn3
	 Z6i44tPHML2fmr9+FX8hnTOv8iFZRBBJIbL390S/XSvg1TIfvQyYf7AUYAMGdnjWDA
	 nqgsUDJx3vC7g==
Date: Sun, 31 Dec 2023 11:44:38 -0800
Subject: [PATCHSET v29.0 19/40] xfsprogs: clean up symbolic link code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

This series cleans up a few bits of the symbolic link code as needed for
future projects.  Online repair requires the ability to commit fixed
fork-based filesystem metadata such as directories, xattrs, and symbolic
links atomically, so we need to rearrange the symlink code before we
land the atomic extent swapping.

Accomplish this by moving the remote symlink target block code and
declarations to xfs_symlink_remote.[ch].

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=symlink-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=symlink-cleanups
---
 include/libxfs.h            |    1 
 libxfs/libxfs_api_defs.h    |    1 
 libxfs/xfs_bmap.c           |    1 
 libxfs/xfs_inode_fork.c     |    1 
 libxfs/xfs_shared.h         |   13 ----
 libxfs/xfs_symlink_remote.c |  155 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |   26 +++++++
 mkfs/proto.c                |   72 +++++++++++---------
 8 files changed, 222 insertions(+), 48 deletions(-)
 create mode 100644 libxfs/xfs_symlink_remote.h

