Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C552BA30;
	Sun, 31 Dec 2023 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6h3CuUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD8EC433C8;
	Sun, 31 Dec 2023 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052817;
	bh=HQEqa9Sc8iFTDdBi7u4M6wQmJnt48BOZ8mHqso+gtWQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R6h3CuUYm1GLWqy657U+Q2au5y8/0bg3qGPnPH9qyHH+bmrROLZ3gk482l+ufYong
	 ajJZjfoYk7ta00D7PgttHbdhVHXgiuyHqhdD740+aidegZoYRTJ8WCOdJL43nxC3zl
	 jKIWGLGzt7bGKekMzo1gYQT7QSxGLTqKMzY6KS6SB1VrD9/PKMLGrINMuPOSZJB59I
	 puOWerjsQwBIh18nXH49INF4r7KT9e/IrAW8ZZQDcZXGEEGB6/6g6+/mgQ7He1aRAC
	 KMM2SlaD17b3OxgrQh5aqHNyL0j9z7BXcK6frR3AYzr+ocP1YswBw3pEITelFPJnE9
	 gxZs3lE5udcaQ==
Date: Sun, 31 Dec 2023 12:00:16 -0800
Subject: [PATCHSET v2.0 2/9] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
 common/ext4             |   17 +++++
 common/fuzzy            |   38 ++++++++++--
 common/populate         |   78 +++++++++++++-----------
 common/xfs              |  150 ++++++++++++++++++++++++++++++++++++++++++++---
 src/punch-alternating.c |   28 ++++++++-
 tests/xfs/114           |    4 +
 tests/xfs/122           |    2 -
 tests/xfs/122.out       |    8 +++
 tests/xfs/146           |    2 -
 tests/xfs/185           |    2 -
 tests/xfs/187           |    3 +
 tests/xfs/206           |    3 +
 tests/xfs/271           |    3 +
 tests/xfs/341           |    4 +
 tests/xfs/449           |    6 ++
 tests/xfs/556           |   16 +++--
 tests/xfs/581           |    2 -
 tests/xfs/720           |    2 -
 tests/xfs/795           |    2 -
 19 files changed, 298 insertions(+), 72 deletions(-)

