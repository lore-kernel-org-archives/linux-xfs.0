Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDB110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6HFNaoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B9DC433F1;
	Fri, 12 Jan 2024 02:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025848;
	bh=6CFrbsWShN8Db4AHp8PRBRUBbsizlO+gbbcXi+URNmk=;
	h=Date:Subject:From:To:Cc:From;
	b=C6HFNaoHXEPB+cRzKBhym51irlcwpvlj+bjECdGCbNLQq+IlBWp+SITAm4k1V70mc
	 M3eV2LrZS15eXSTT8o23vgp2ZyRGkBOsRO6rFS9ZSYPyEWvayOIC9p/WQWZdrx7k5d
	 I265/iygyQfDv/EpdyEOEHpfAOXVw39wRSTa/+Dv840TyF3k4VYigb8g3VasbNZ/zf
	 cd7Q6hucQwfoioYI6VZP6gCzkycKCA2/pyq2AEMpi220rfGW4wc0rQf4Tg3ZDlGUdy
	 JWXOiTEt0lrkivXyvPfwW8teHNvtaB1+8KxnEIFugv47ERlwv63lbGgdt7emEeeMHU
	 dA+OUYzz7bbNQ==
Date: Thu, 11 Jan 2024 18:17:28 -0800
Subject: [GIT PULL 5/6] xfs_scrub_all: fixes for systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170502573560.996574.2504743062956504522.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 3d37d8bf535fd6a8ab241a86433b449152746e6a:

xfs_scrub_all.cron: move to package data directory (2024-01-11 18:08:47 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scruball-service-fixes-6.6_2024-01-11

for you to fetch changes up to 1c95c17c8857223d05e8c4516af42c6d41ae579a:

xfs_scrub_all: fix termination signal handling (2024-01-11 18:08:47 -0800)

----------------------------------------------------------------
xfs_scrub_all: fixes for systemd services [v28.3 5/6]

This patchset ties up some problems in the xfs_scrub_all program and
service, which are essential for finding mounted filesystems to scrub
and creating the background service instances that do the scrub.

First, we need to fix various errors in pathname escaping, because
systemd does /not/ like slashes in service names.  Then, teach
xfs_scrub_all to deal with systemd restarts causing it to think that a
scrub has finished before the service actually finishes.  Finally,
implement a signal handler so that SIGINT (console ^C) and SIGTERM
(systemd stopping the service) shut down the xfs_scrub@ services
correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs_scrub_all: fix argument passing when invoking xfs_scrub manually
xfs_scrub_all: survive systemd restarts when waiting for services
xfs_scrub_all: simplify cleanup of run_killable
xfs_scrub_all: fix termination signal handling

scrub/xfs_scrub_all.in | 157 +++++++++++++++++++++++++++++++++++++++----------
1 file changed, 125 insertions(+), 32 deletions(-)

