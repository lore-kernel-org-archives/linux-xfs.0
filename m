Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B3E386566;
	Wed,  2 Sep 2026 05:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327715; cv=none; b=Op6AbW2mjUXadKXsjWztLb2yCZk9PquuXQaQc1RaN7GDcA12/aZ/EZOkoOlGVekYJo8esuZUyXgZuM0s8MNbGVLH6KfEv5uTyIbZ2lwyXt4EP51ERST7il3sJ8yUQ8VgBYdCYhKmtNyd8jr0yvGmG+H1Um8xYpsWSi0xlTCH5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327715; c=relaxed/simple;
	bh=hw7HB21kWg1fbEzcouv+mOfEtxTsDjGxrHwfh1q8eZA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=W3CAqBrTEJEWxx8cNgjd6z41pCNDzkEpmTBiKACKsi2LsnnXMjjmugMNzLpJgtPbYocMoLmZPZoSN9igbOfScLBz5GZVi0SFexWrPvFiMdOzTynTRYy67Nj+cUJT00L65kmDZp3ANCMkCUizvDxOAL13IlIyv8S5UlFRZJkJ1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BhDzHMVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BhDzHMVO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9252B1F000E9;
	Wed,  2 Sep 2026 05:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327714;
	bh=vflxhXWuB4dHMR+GtHGtgQEYloNanOy9Ae5DLcPC9VQ=;
	h=Date:Subject:From:To:Cc;
	b=BhDzHMVOd/+11ah2J+FQEAfGTVNDk7v2QuE9GnZyT7chjEeFiKasisBWng298nr0y
	 8RfXwXJRUlu3uMBSux8AF6APYprvpR5pEaZjge5CIXSMPcKqKB52mLefIkO5SOrV4I
	 MVPCLeUq8+1ozvaFnksg7/Xbxla8QN7cQ+1pQ/5ikecEg3OkFccgbbvowKPGt7obMO
	 Dh0IrKwg7unzckIi74oAaVOFuF8zTvcOY1v5tJUhqEfM8gReNfwLm3YVjRTHctKkc4
	 JYzdgChEgOyKVLFo9KYxqyXQ87/+qEMP77xnhMRwa9Wq6IkV15btGi9wphtnSxgrvw
	 9hbN5Ox4UfRog==
Date: Tue, 01 Sep 2026 22:41:54 -0700
Subject: [PATCHSET 5/5] xfs: LLM-inspired bug fixes, part 9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a ninth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-9
---
Commits in this patchset:
 * xfs: signal inode btree xref error if get_rec returns an error
 * xfs: truncate quota file correctly when repairing quota file
 * xfs: compute dquot checksum after resetting dd_lsn in repair
 * xfs: fix backwards skipping logic in xrep_quota_block
 * xfs: fix backwards mergeability logic in refcount scrubber
---
 fs/xfs/scrub/ialloc.c       |    4 ++++
 fs/xfs/scrub/quota_repair.c |    7 +++----
 fs/xfs/scrub/refcount.c     |    2 +-
 fs/xfs/scrub/rtrefcount.c   |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

Unreviewed patches in this series are:

[PATCHSET 5/5] xfs: LLM-inspired bug fixes, part 9
  [PATCH 1/5] xfs: signal inode btree xref error if get_rec returns an
  [PATCH 2/5] xfs: truncate quota file correctly when repairing quota
  [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn in
  [PATCH 4/5] xfs: fix backwards skipping logic in xrep_quota_block
  [PATCH 5/5] xfs: fix backwards mergeability logic in refcount
