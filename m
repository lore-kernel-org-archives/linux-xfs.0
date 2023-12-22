Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C4A610A
	for <linux-xfs@vger.kernel.org>; Fri, 22 Dec 2023 02:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZPecICt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7E9C433C7;
	Fri, 22 Dec 2023 02:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703212286;
	bh=bKmLWfxxpTXe0DQ891Trt4Ip6/PGZ3hYPMcfurzj/Vs=;
	h=Date:Subject:From:To:Cc:From;
	b=MZPecICtengqwLgQhryZbMsGER3eV51oODUxKfaDvXo9dt4uyGJMoRz2aX1tVntE5
	 gfooi1GFgq/hxl6Rv3wPL/hXjzcbwTZbdftdgKHpYs+uJ4d9zOZcPUKcZjQfKNtGa2
	 Y583IRXsAkgI4wPadFEvagxktcZQz4S0y/9/OdVRPa0e48dpuVq+e095el05yI67Gt
	 NpXxNX9qe7trxIzyr2fu3hHkT4wyua+vCnpcJCFuNzRhxj20eFbDPYaj1bht/l3IGP
	 tGMGXOSgZh6L9hI1XWExIaSzueC+MbF9x2zUN6i/eHJZ0HuhyOyBGqNY6FksSZ1KMY
	 0H0OdFZLXXYHA==
Date: Thu, 21 Dec 2023 18:31:25 -0800
Subject: [GIT PULL 2/4] xfs_metadump: various bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170321220697.2974519.17368869415458763875.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1665923a8302088744a69403ff60a1709f5d24ed:

xfs_db: report the device associated with each io cursor (2023-12-21 18:29:14 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/metadump-fixes-6.6_2023-12-21

for you to fetch changes up to 2cbc52f5c9a9588e1e9c8e54c0435c121424fe5a:

xfs_mdrestore: refactor progress printing and sb fixup code (2023-12-21 18:29:14 -0800)

----------------------------------------------------------------
xfs_metadump: various bug fixes [2/8]

This series fixes numerous errors I found in the new metadump v2 format
handling code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_metadump.8: update for external log device options
xfs_mdrestore: fix uninitialized variables in mdrestore main
xfs_mdrestore: emit newlines for fatal errors
xfs_mdrestore: EXTERNALLOG is a compat value, not incompat
xfs_mdrestore: fix missed progress reporting
xfs_mdrestore: refactor progress printing and sb fixup code

man/man8/xfs_mdrestore.8  |   6 ++-
man/man8/xfs_metadump.8   |   7 ++-
mdrestore/xfs_mdrestore.c | 122 +++++++++++++++++++++++++++-------------------
3 files changed, 81 insertions(+), 54 deletions(-)

