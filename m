Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B217735
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwEwAB9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B642C433C8;
	Sun,  3 Dec 2023 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630040;
	bh=aQJMKu60FIpW3hTzqXufTGjg2AgDPQEGjwEfZLl9zzE=;
	h=Date:Subject:From:To:Cc:From;
	b=UwEwAB9JgmjmAKSpk1AXlTuP04ThWxine/GQtNBzQOvGX1Y12XXNVo5YKk8lMMU8N
	 aAIcuALVohfEIdT0bwB9tssOUsUMTfQcTVuQJUEppybBAxkCL20IHai5jqN1XNH0Dj
	 dqMwsdbd+0FFPV2ay+pEkcw4IReWwAaVsKcLe0x+4ppLFrU89Z+sERzStmNqrj2no/
	 cSTOfO7/K8vE1H4qN03e4HUtS0Zgp1PI06JAs8pfSWA37NwQt9Qu8YCMGWCv2C+L9X
	 npMKpzvPpAse/6AYcteFDNA/fFj3ZB6STervh0691KI+VYAm00QCg37RLBZnchcikd
	 XBdFgaYtAmX+A==
Date: Sun, 03 Dec 2023 11:00:39 -0800
Subject: [PATCHSET 0/9] xfs: continue removing defer item boilerplate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
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

Now that we've restructured log intent item recovery to reconstruct the
incore deferred work state, apply further cleanups to that code to
remove boilerplate that is duplicated across all the _item.c files.
Having done that, collapse a bunch of trivial helpers to reduce the
overall call chain.  That enables us to refactor the relog code so that
the ->relog_item implementations only have to know how to format the
implementation-specific data encoded in an intent item and don't
themselves have to handle the log item juggling.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reconstruct-defer-cleanups-6.7
---
 fs/xfs/libxfs/xfs_defer.c  |   55 ++++++++++
 fs/xfs/libxfs/xfs_defer.h  |    3 +
 fs/xfs/xfs_attr_item.c     |  137 +++++++------------------
 fs/xfs/xfs_bmap_item.c     |  115 ++++++---------------
 fs/xfs/xfs_extfree_item.c  |  242 ++++++++++++++++----------------------------
 fs/xfs/xfs_refcount_item.c |  113 ++++++---------------
 fs/xfs/xfs_rmap_item.c     |  113 ++++++---------------
 fs/xfs/xfs_trans.h         |   10 --
 8 files changed, 284 insertions(+), 504 deletions(-)

