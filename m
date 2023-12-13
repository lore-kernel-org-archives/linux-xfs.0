Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18C88183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr6NXrEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C41C433C8;
	Wed, 13 Dec 2023 22:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507895;
	bh=W9DuTv4b+It0ON7tvgeUrIm0K3KaLfWP7labd2LSjwU=;
	h=Date:Subject:From:To:Cc:From;
	b=Sr6NXrEJzhqpt/+cjmB3i4iVsQoingLGsDMe7qwgfyUR8Dk3d/J+66sH+tLLeut5m
	 cOW4KUSREngtP3ioIGBXOYczO0y5Z2p2r9n+sFSzUET+wBj9amWF8F/9C2UDYl23Dy
	 2iJggdX0IxDttLBBmUJW8iwrWHRjlv7O9jzd5pQ7+6UOc2g843SlMXZWYAt627Ue4M
	 HEAbGZWV4EW/Bbg3ni0Up0PYpEuS9w8Wz4ZT8lmhqECgiRpGPFpFMWw4KUfy3z4PwY
	 /7IG1EP1mq1Tlumn0Won6pCyh9yygNXObtBHDSwLOcMS+gPPdXsfmrI6Ni6KyXEX98
	 CsMk9QdFVhUlA==
Date: Wed, 13 Dec 2023 14:51:34 -0800
Subject: [PATCHSET v28.2 0/6] xfs: prepare repair for bulk loading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
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

Before we start merging the online repair functions, let's improve the
bulk loading code a bit.  First, we need to fix a misinteraction between
the AIL and the btree bulkloader wherein the delwri at the end of the
bulk load fails to queue a buffer for writeback if it happens to be on
the AIL list.

Second, we introduce a defer ops barrier object so that the process of
reaping blocks after a repair cannot queue more than two extents per EFI
log item.  This increases our exposure to leaking blocks if the system
goes down during a reap, but also should prevent transaction overflows,
which result in the system going down.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading-6.8
---
 fs/xfs/libxfs/xfs_btree.c         |    2 -
 fs/xfs/libxfs/xfs_btree.h         |    3 +
 fs/xfs/libxfs/xfs_btree_staging.c |   78 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_btree_staging.h |   25 +++++++++---
 fs/xfs/scrub/newbt.c              |   12 ++++--
 fs/xfs/xfs_buf.c                  |   44 +++++++++++++++++++--
 fs/xfs/xfs_buf.h                  |    1 
 fs/xfs/xfs_globals.c              |   12 ++++++
 fs/xfs/xfs_sysctl.h               |    2 +
 fs/xfs/xfs_sysfs.c                |   54 ++++++++++++++++++++++++++
 10 files changed, 198 insertions(+), 35 deletions(-)

