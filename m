Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C4036C
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dnoy0ZBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ACBC433C8;
	Thu,  7 Dec 2023 02:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916698;
	bh=qqGSqikkHdUgf9lCVagBZ+5rwt7qQ/zTxEi5ksTWd5Y=;
	h=Date:Subject:From:To:Cc:From;
	b=Dnoy0ZBRu508QCoJRJaI8csBcWY+DTrz5nd4aPn2wu+SScDciH/C6lFcnh9fgg0yE
	 rohkR7gPzWeg/bUSKK8ZAZIhlA6z444jaKfZYl9ZxClyV3IcHnd0H49fxx659rDQAb
	 pwDaR3pUj02p32Wwf2MVixUKcEujk3NkqRsnEw1zIbd0NVGj/6W0RJlT6UDYb8atnk
	 Ufq4VqSoCOzgspaMrByVSH/npD6kvdwRJFmi+lJ3q36m0yV9tx1s9WF/HM5xTp1RQv
	 tyzRJuDyNy+FRgv3BMtZVzfsz1UuyXGeqhqDz9hSkR38J04lA6JVGSwjJKQU5HBjm0
	 y7OBhU5Lqrrjg==
Date: Wed, 06 Dec 2023 18:38:17 -0800
Subject: [PATCHSET v28.1 0/6] xfs: prepare repair for bulk loading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/libxfs/xfs_btree.c         |    2 +
 fs/xfs/libxfs/xfs_btree.h         |    3 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   72 ++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_btree_staging.h |   25 ++++++++++---
 fs/xfs/scrub/newbt.c              |   12 +++++-
 fs/xfs/xfs_buf.c                  |   52 +++++++++++++++++++++++++--
 fs/xfs/xfs_buf.h                  |    1 +
 fs/xfs/xfs_globals.c              |   12 ++++++
 fs/xfs/xfs_sysctl.h               |    2 +
 fs/xfs/xfs_sysfs.c                |   54 ++++++++++++++++++++++++++++
 10 files changed, 200 insertions(+), 35 deletions(-)

