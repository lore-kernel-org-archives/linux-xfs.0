Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523CF33C4
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwoQZu5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BC3C433C8;
	Thu,  7 Dec 2023 02:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917669;
	bh=rIVK8M4O/jGvGhzeDZctyRT+QtD8rT7elbtBcZPpIPM=;
	h=Date:Subject:From:To:Cc:From;
	b=uwoQZu5LUK9TaRfQStZjCTH/N3h8vxJCncABSFCWsmFZ+WefpdQv1JZQtIaBaoVMc
	 mNuMY+zxLWNjtCmEaZhKJyEnBibXM1wLonSWj/YE6zhfZppjdyMNylYlHBjCEw6Bjl
	 JCH/uTVme31jUFT89KUv6HSBfX8Lo9C4VCMI7qjhDM0RRUqLU5+3uvgoLmsVRPPDMX
	 6joK+yvG+UYULtBAagm3kooXv8GpC6psmihPhwExRoCK2N+nx3MpCV47vBCU9rooLX
	 545bphF9+js1ubPzHGkYD8QOxgXR2ZAk8AezLPJ/I/ZNOcYARDmsJ0cdcZHWXubbPB
	 jpo4Hn2Z0kt8w==
Date: Wed, 06 Dec 2023 18:54:29 -0800
Subject: [GIT PULL 4/6] xfs: elide defer work ->create_done if no intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191742263.1195961.10414463079678715112.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit e14293803f4e84eb23a417b462b56251033b5a66:

xfs: don't allow overly small or large realtime volumes (2023-12-06 18:45:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/defer-elide-create-done-6.8_2023-12-06

for you to fetch changes up to 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3:

xfs: elide ->create_done calls for unlogged deferred work (2023-12-06 18:45:17 -0800)

----------------------------------------------------------------
xfs: elide defer work ->create_done if no intent [v2]

Christoph pointed out that the defer ops machinery doesn't need to call
->create_done if the deferred work item didn't generate a log intent
item in the first place.  Let's clean that up and save an indirect call
in the non-logged xattr update call path.

v2: pick up rvb tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: document what LARP means
xfs: elide ->create_done calls for unlogged deferred work

fs/xfs/libxfs/xfs_defer.c | 4 ++++
fs/xfs/xfs_attr_item.c    | 3 ---
fs/xfs/xfs_sysfs.c        | 9 +++++++++
3 files changed, 13 insertions(+), 3 deletions(-)

