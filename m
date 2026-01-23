Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CBA33C528;
	Fri, 23 Jan 2026 07:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151657; cv=none; b=iHKp1G9mVFWtUUyG16u3YScrxOultZiLxs8JkFZs6HJh8JJF/ADzpLJbZHWvC72O+4B9l90gybGIJSq7kwRLEV3LKXc6PL91EI9KML57xeBtKj1nTkLwOTtYd5rZXFABo8I7wCi0r+IW+gPrgGZ2ZjM7OUjtEpr44mKinRPU26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151657; c=relaxed/simple;
	bh=C9spGjgvukd4cuwh+kz+G5Q1gZ7JEOxQWGfPkvcAkHA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=N9PQUVdBKVUlIQbNF7JmB6oSl06/KDMooHB1f8YgKxmbYz6J7GRTK6Ixi2xoJQhjPmLspp6N00djP2tGYYTy02csr9a9L5WfJgk2o2LY2Th1eq6C+CzIVQleb31Ywl01118MGhofuGzIudAiYb4AokFUt+QlEdVn+TS6dDbl/js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7vW5if7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7vW5if7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E006C19422;
	Fri, 23 Jan 2026 07:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151656;
	bh=C9spGjgvukd4cuwh+kz+G5Q1gZ7JEOxQWGfPkvcAkHA=;
	h=Date:Subject:From:To:Cc:From;
	b=t7vW5if7ws0U5etCU3EM+U2s1qF8JFdYeCUgRfZkYP0eBjW/7NjE33Rxs8V7zqeSD
	 EGgqs4hov75ONPzTJEUV2AKwVyvOpbdjKfLsEsJSfei9DJzNaV8LFqu3QPCmcaH8f7
	 rTnke55EIhXRDnUqEH1TM82nh9kia8zKqRGqpvdaFGtvOSubrVzJCbanF73pqk/HUm
	 jzcIHwmRpsgJSXLFpI5pjFrRa3fcl3GjBxBngamXxX51oZSctM/wMpctRaHdL/zneT
	 H27KNtfxhhX2A55VlH6DPIf4U7U9AWxlz0yV7/qvdNEQdCA9jTB+3c4O3ifqy+RJpV
	 O5nqp4RBnVShQ==
Date: Thu, 22 Jan 2026 23:00:55 -0800
Subject: [PATCHSET 3/3] xfs: syzbot fixes for online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, r772577952@gmail.com,
 linux-xfs@vger.kernel.org, r772577952@gmail.com, hch@lst.de
Message-ID: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix various syzbot complaints about scrub that Jiaming Zhang found.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

Unreviewed patches:
[PATCHSET 3/3] xfs: syzbot fixes for online fsck
  [PATCH 1/5] xfs: get rid of the xchk_xfile_*_descr calls
  [PATCH 2/5] xfs: only call xf{array,blob}_destroy if we have a valid
  [PATCH 5/5] xfs: check for deleted cursors when revalidating two

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-syzbot-fixes
---
Commits in this patchset:
 * xfs: get rid of the xchk_xfile_*_descr calls
 * xfs: only call xf{array,blob}_destroy if we have a valid pointer
 * xfs: check return value of xchk_scrub_create_subord
 * xfs: fix UAF in xchk_btree_check_block_owner
 * xfs: check for deleted cursors when revalidating two btrees
---
 fs/xfs/scrub/common.h            |   25 -------------------------
 fs/xfs/scrub/agheader_repair.c   |   21 ++++++++++-----------
 fs/xfs/scrub/alloc_repair.c      |   20 ++++++++++++++++----
 fs/xfs/scrub/attr_repair.c       |   26 +++++++++-----------------
 fs/xfs/scrub/bmap_repair.c       |    6 +-----
 fs/xfs/scrub/btree.c             |    7 +++++--
 fs/xfs/scrub/common.c            |    3 +++
 fs/xfs/scrub/dir.c               |   13 ++++---------
 fs/xfs/scrub/dir_repair.c        |   19 +++++++++----------
 fs/xfs/scrub/dirtree.c           |   19 +++++++++----------
 fs/xfs/scrub/ialloc_repair.c     |   25 ++++++++++++++++++-------
 fs/xfs/scrub/nlinks.c            |    9 ++++-----
 fs/xfs/scrub/parent.c            |   11 +++--------
 fs/xfs/scrub/parent_repair.c     |   23 ++++++-----------------
 fs/xfs/scrub/quotacheck.c        |   13 +++----------
 fs/xfs/scrub/refcount_repair.c   |   13 ++-----------
 fs/xfs/scrub/repair.c            |    3 +++
 fs/xfs/scrub/rmap_repair.c       |    5 +----
 fs/xfs/scrub/rtbitmap_repair.c   |    6 ++----
 fs/xfs/scrub/rtrefcount_repair.c |   15 +++------------
 fs/xfs/scrub/rtrmap_repair.c     |    5 +----
 fs/xfs/scrub/rtsummary.c         |    7 ++-----
 fs/xfs/scrub/scrub.c             |    2 +-
 23 files changed, 115 insertions(+), 181 deletions(-)

