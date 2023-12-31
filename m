Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBCDB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+YwTRo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4655C433C8;
	Sun, 31 Dec 2023 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051129;
	bh=T6gqbO0uYbR2Cit9s+l1dbtFSlep2HqBb8yG3DUtybw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i+YwTRo6Hs9Ploeu7TwluDiXmaw7ZEpwGngm2CGEnFQoJPjsxD3KZ6RrDl6Hq0tV8
	 nKDCs/EgMbdO7X8tDvksJOQZ/lqg7DIQv0Kwwpt2DJ2Sa1Go1ouujID29ETTcmr0ua
	 5C3G/CSCwoaJGe20tAX16RUDeQi8pmMtmDDU45ywQtl+xMqtxUiV+1HsZIvfhJjml0
	 yuWPaVzXdWZjeIGoKk/mornhMBzuTBtahyKO/6E9g7zT0N9KZXcfhZyTlAdZxkwY3f
	 pOWSiFbw3D/EhQ+Ur/zUru/3WGfPG6UNbtSWd9itzAhycbnGqG80QsAc1/U9mIO1/N
	 +Z+eBn4bUyhSg==
Date: Sun, 31 Dec 2023 11:32:08 -0800
Subject: [PATCHSET v29.0 26/28] xfs: cache xfile pages for better performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
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

This patchset improves the performance of xfile-backed btrees by
teaching the buffer cache to directly map pages from the xfile.  It also
speeds up xfarray operations substantially by implementing a small page
cache to avoid repeated kmap/kunmap calls.  Collectively, these can
reduce the runtime of online repair functions by twenty percent or so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfile-page-caching

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfile-page-caching
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    6 +
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 
 fs/xfs/scrub/rcbag_btree.c     |    1 
 fs/xfs/scrub/trace.h           |   44 ++++++
 fs/xfs/scrub/xfbtree.c         |   23 +++
 fs/xfs/scrub/xfile.c           |  307 ++++++++++++++++++++++++++--------------
 fs/xfs/scrub/xfile.h           |   23 +++
 fs/xfs/xfs_buf.c               |  116 ++++++++++++---
 fs/xfs/xfs_buf.h               |   16 ++
 fs/xfs/xfs_buf_xfile.c         |  173 +++++++++++++++++++++++
 fs/xfs/xfs_buf_xfile.h         |   11 +
 11 files changed, 584 insertions(+), 137 deletions(-)

