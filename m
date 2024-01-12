Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281A110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAmoL1cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB3EC433F1;
	Fri, 12 Jan 2024 02:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025864;
	bh=YRN48qKE+8l7l3mJXYxwqugCHfvaB+idNRnAM5eoGYs=;
	h=Date:Subject:From:To:Cc:From;
	b=dAmoL1cCbW70n0exv/AK+y0Bk6Bn/kOYfaIuFxOAAvMVKPqae4k6k79whwvZn+Z4C
	 NIxQOShF6k7JFEuVlKV+nk+oi31n1k7sNPMcNxaAsCAqraSd+zjEogk+d9tNtUgz1v
	 JMMcJ24syAiAtIch7t2QMR23OGCY7FvTWAXWR4X4BxAxQmxHmufZhmnwMKnjgmVd9u
	 lBSqSuPmdWW3FaBmhX0Mmwq58lGjaG6F1BLZ/NC9AoIDVWP7u1tkTUeqPqs8uSoASL
	 mboDZCVH966eWBlngxUf1MaCdx2m6jAYd8jvqGvRTmVmmdeOyhQ9xURJnFL+5Hq2V9
	 Ikecq6VMAsbDg==
Date: Thu, 11 Jan 2024 18:17:43 -0800
Subject: [GIT PULL 6/6] xfs_scrub: tighten security of systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: glitsj16@riseup.net, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170502573653.996574.9591002351083368679.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1c95c17c8857223d05e8c4516af42c6d41ae579a:

xfs_scrub_all: fix termination signal handling (2024-01-11 18:08:47 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-service-security-6.6_2024-01-11

for you to fetch changes up to 13995601c86574e2f65d93055ac7a624fbde4443:

xfs_scrub_all: tighten up the security on the background systemd service (2024-01-11 18:08:47 -0800)

----------------------------------------------------------------
xfs_scrub: tighten security of systemd services [v28.3 6/6]

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_scrub: allow auxiliary pathnames for sandboxing
xfs_scrub.service: reduce CPU usage to 60% when possible
xfs_scrub: use dynamic users when running as a systemd service
xfs_scrub: tighten up the security on the background systemd service
xfs_scrub_fail: tighten up the security on the background systemd service
xfs_scrub_all: tighten up the security on the background systemd service

man/man8/xfs_scrub.8             |  9 +++-
scrub/Makefile                   |  7 ++-
scrub/phase1.c                   |  4 +-
scrub/system-xfs_scrub.slice     | 30 +++++++++++++
scrub/vfs.c                      |  2 +-
scrub/xfs_scrub.c                | 11 +++--
scrub/xfs_scrub.h                |  5 ++-
scrub/xfs_scrub@.service.in      | 97 +++++++++++++++++++++++++++++++++++-----
scrub/xfs_scrub_all.service.in   | 66 +++++++++++++++++++++++++++
scrub/xfs_scrub_fail@.service.in | 59 ++++++++++++++++++++++++
10 files changed, 270 insertions(+), 20 deletions(-)
create mode 100644 scrub/system-xfs_scrub.slice

