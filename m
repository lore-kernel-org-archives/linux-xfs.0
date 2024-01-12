Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C37E110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmXdvfEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A906CC433C7;
	Fri, 12 Jan 2024 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025801;
	bh=H4mJ4di6MR1EBLPnfiCBOYn5wJjWaTUD7yPeJBu/+dQ=;
	h=Date:Subject:From:To:Cc:From;
	b=RmXdvfEJzFjJYVkNljo1yT3WTQyDIq8MCe7ybAUKsowJDHUwh4sEqfR0y5gUQSlMv
	 P8H077YMULG4SExCGOlWaxGYr7TYtbLm85ZP0Sfvnd2CESlccFSvLc+NR2LeQQNU8Q
	 ETwMPj0UYvYNcLcLjmFZ4zYTL8rSChVI+Jj2G/Q9/PcA6N4wKbwteB66/GB5bbdFyb
	 wAXwKyVTZXwBlO6ppBH1k6x9arAubjLCjXMEAZ3xSjzujyp9b06NwXo0HApjRFfNKZ
	 puCoxR06KqiQNF357YlU94tqhXh8gvhvadHPtRLLo3BG7EXbIEjtLphaqd4f0alZxZ
	 tnMG2jj/vxshw==
Date: Thu, 11 Jan 2024 18:16:41 -0800
Subject: [GIT PULL 2/6] xfs_scrub: fix licensing and copyright notices
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170502573264.996574.15670186027839841218.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 55021e7533bc55100f8ae0125aec513885cc5987:

libxfs: fix krealloc to allow freeing data (2024-01-11 18:07:03 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fix-legalese-6.6_2024-01-11

for you to fetch changes up to 52520522199efa984dcf172a3eb8d835b93e324e:

xfs_scrub: update copyright years for scrub/ files (2024-01-11 18:08:46 -0800)

----------------------------------------------------------------
xfs_scrub: fix licensing and copyright notices [v28.3 2/6]

Fix various attribution problems in the xfs_scrub source code, such as
the author's contact information, out of date SPDX tags, and a rough
estimate of when the feature was under heavy development.  The most
egregious parts are the files that are missing license information
completely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs_scrub: fix author and spdx headers on scrub/ files
xfs_scrub: add missing license and copyright information
xfs_scrub: update copyright years for scrub/ files

scrub/Makefile                   | 2 +-
scrub/common.c                   | 6 +++---
scrub/common.h                   | 6 +++---
scrub/counter.c                  | 6 +++---
scrub/counter.h                  | 6 +++---
scrub/descr.c                    | 4 ++--
scrub/descr.h                    | 4 ++--
scrub/disk.c                     | 6 +++---
scrub/disk.h                     | 6 +++---
scrub/filemap.c                  | 6 +++---
scrub/filemap.h                  | 6 +++---
scrub/fscounters.c               | 6 +++---
scrub/fscounters.h               | 6 +++---
scrub/inodes.c                   | 6 +++---
scrub/inodes.h                   | 6 +++---
scrub/phase1.c                   | 6 +++---
scrub/phase2.c                   | 6 +++---
scrub/phase3.c                   | 6 +++---
scrub/phase4.c                   | 6 +++---
scrub/phase5.c                   | 6 +++---
scrub/phase6.c                   | 6 +++---
scrub/phase7.c                   | 6 +++---
scrub/progress.c                 | 6 +++---
scrub/progress.h                 | 6 +++---
scrub/read_verify.c              | 6 +++---
scrub/read_verify.h              | 6 +++---
scrub/repair.c                   | 6 +++---
scrub/repair.h                   | 6 +++---
scrub/scrub.c                    | 6 +++---
scrub/scrub.h                    | 6 +++---
scrub/spacemap.c                 | 6 +++---
scrub/spacemap.h                 | 6 +++---
scrub/unicrash.c                 | 6 +++---
scrub/unicrash.h                 | 6 +++---
scrub/vfs.c                      | 6 +++---
scrub/vfs.h                      | 6 +++---
scrub/xfs_scrub.c                | 6 +++---
scrub/xfs_scrub.h                | 6 +++---
scrub/xfs_scrub@.service.in      | 5 +++++
scrub/xfs_scrub_all.cron.in      | 5 +++++
scrub/xfs_scrub_all.in           | 6 +++---
scrub/xfs_scrub_all.service.in   | 5 +++++
scrub/xfs_scrub_all.timer        | 5 +++++
scrub/xfs_scrub_fail             | 5 +++++
scrub/xfs_scrub_fail@.service.in | 5 +++++
45 files changed, 143 insertions(+), 113 deletions(-)

