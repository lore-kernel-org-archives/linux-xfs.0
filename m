Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2321B65C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsTbiXaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D52C433C8;
	Sun, 31 Dec 2023 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051097;
	bh=H6OyoDutHosXlF3YjrzxPq0kaV68XnN9WWfL3+dO91M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fsTbiXaOS5GsqcUlGRvLTQASEwkBT3g/1AXj2TOWKd4D39KMB9iS46kORRlA9azgG
	 w3Od4JMwzZyiaU5z1TxI+kH0IHzpKyH1WXkMz68b+poaqwlo3oJQG9NkJTvJeXg5ei
	 0RCrY9akN/+kei4BHAwrhr9pVmNTYSO3RYZcayefWvfjWJQyT2unDEdxdYEqkon/eI
	 ugj0Sfw2rR8BmvXKqc06DD7slGLkEA0Pb+ObUL1ove5NLHA6DpoHbDLnABl7Io4xoU
	 OpZlTqPlmgT/8whrw2K2/Ehoq6H3/9uvWMybZEiFMi/5viO4Nmiadsin3FX3x+gsfL
	 IoJ/ET04lgtHQ==
Date: Sun, 31 Dec 2023 11:31:37 -0800
Subject: [PATCHSET v29.0 24/28] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836829.1753898.12847456543644205933.stgit@frogsfrogsfrogs>
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

The sole patch in this set adds the ability to repair the target buffer
of a symbolic link, using the same salvage, rebuild, and swap strategy
used everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  488 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 +++
 11 files changed, 596 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

