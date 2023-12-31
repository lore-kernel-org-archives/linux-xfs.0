Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B08B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMqE7DcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601E6C433C7;
	Sun, 31 Dec 2023 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050956;
	bh=jupXcPO72QQMD7OHoV9/rO2DWM/5yJMWaJ5q40nzJTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FMqE7DcXDmd/eZzbg1go3w0OzbzKEREGi1UMF5gRBPBoZShTShC6w7TEqFm3VwnA9
	 arORI/lluBLsdO1MLfL9XzTWTdZdSC2ULagiofdh6TE7HGL3CAJlw/rCk1OsvLO1XX
	 pjOi3+4Ge9K6SON3C3vZLO17tPY007/53IlU0iJ9EY/fXuTfILpatPMt0nRMWll6BA
	 1ioH/mIxi9Dbq21QMEq4n5DmHjwRCmqpxmZOOu6Wz+dmcFJ0JBlyx9SvGiddjc+zF2
	 mVmDqWCvooXaFDigR7rYDcTLnLI7Qq4x5cctE1eEfuyyDQSEmRZhsj+Q33F6g4O9Bp
	 3JbQvPYjQL6pw==
Date: Sun, 31 Dec 2023 11:29:15 -0800
Subject: [PATCHSET v29.0 15/28] xfs: clean up symbolic link code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c           |    1 
 fs/xfs/libxfs/xfs_inode_fork.c     |    1 
 fs/xfs/libxfs/xfs_shared.h         |   13 ---
 fs/xfs/libxfs/xfs_symlink_remote.c |  155 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_symlink_remote.h |   26 ++++++
 fs/xfs/scrub/inode_repair.c        |    1 
 fs/xfs/scrub/symlink.c             |    3 -
 fs/xfs/xfs_symlink.c               |  145 ++--------------------------------
 fs/xfs/xfs_symlink.h               |    1 
 9 files changed, 192 insertions(+), 154 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h

