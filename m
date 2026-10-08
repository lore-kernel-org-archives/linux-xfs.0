Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2926336F916;
	Thu,  8 Oct 2026 05:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438902; cv=none; b=IUWZRiz55UEtdVRm1MqDK2jQUPLqcIz9UgEn5lyWXzzcx/i19IjZyoPiC8ij38SGxsmMMku+Gx8N1xoutAVHUuyv6fW/o9UGjulQBeJXVIb8gfHYXrAE4Xa2Ihgt5cy319QQYnJj/a3VJqk9JRmZw0/HpuU8pNkQyWz9clgbIxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438902; c=relaxed/simple;
	bh=oUJlgfJhqnotq/4lKvnrH5YzoPzTlAMTjY0fubNboT8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=AfRzSOwzKhHqiePjENzbkx5ZP31buh66frc90GxC1Tr8SDjlsHnvvY8KLM2jk3BR0qMxpTJNFn7u2hQX6CxFRUiAhY0Zx/fN6DUB/ilqsrHxYtVaSYciZXqlxsBcdYXT2yhTOooRVJR5HVqNvQOCnEF8ZokZq776rUKHs2zXhUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbasw7fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbasw7fm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 97C9D1F000FF;
	Thu,  8 Oct 2026 05:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438900;
	bh=5aKq+fQ5EJ9Mz8enJFGIV5w/5ma7gN3o8XmJQiIMfjI=;
	h=Date:Subject:From:To:Cc;
	b=bbasw7fm483LTMg0zyj6SMe8GG31MacQIO8MUA0vlDfMtOcFeXaK9JBHHAKAfgPfx
	 fDqVUv3WBsOHDT9ToPsUk8EGdstoqvDNUghwJJ29MLJxPHbW9gRiVDIYdTaWfmzqd3
	 iE6n8vzfL99qlgPnOJHIFQ5fZwEnR/d5aTvgHLvBzE1oLWDvQv07vSil7pOXoXUdIH
	 ry75q/HrOjvsIU9KW81FVRsrZD595EaBZZxEkR67i9DIScRQ0loyeUNBCfN4iSHxOt
	 dDY2wVHsL56ZvMKqyZpGNBAbjavqTnY5XtJ9pNVCmwcTp4edAXrY+oWCDF1jdrxKLf
	 tMckxUv5ans+w==
Date: Wed, 07 Oct 2026 22:55:00 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 21
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twenty-first batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-21
---
Commits in this patchset:
 * xfs: check for termination during rmap btree walk
 * xfs: don't subtract excess usage twice when computing agf_btreeblks
 * xfs: abort directory tree repair whenever dl->aborted is set
 * xfs: reattach dquots after changing inode ids
 * xfs: never reset the default quota timer
 * xfs: fix correction of unwritten extents in quota file data fork
 * xfs: always report inode repair setup failures
 * xfs: range-check bc_levels array access in scrub tracepoints
 * xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
 * xfs: check for buffer overruns when examining local/remote xattr entries
 * xfs: clarify various parts of the bitmap API
 * xfs: complain loudly when dirtree checker finds broken links
---
 fs/xfs/scrub/repair.h         |    2 +-
 fs/xfs/scrub/trace.h          |   10 +++++-----
 fs/xfs/scrub/alloc_repair.c   |   11 +++++------
 fs/xfs/scrub/attr.c           |   18 ++++++++++++++++++
 fs/xfs/scrub/attr_repair.c    |   16 ++++++++++++++--
 fs/xfs/scrub/bitmap.c         |   20 ++++++++++++++++++++
 fs/xfs/scrub/dirtree.c        |    3 ++-
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 fs/xfs/scrub/inode.c          |    2 +-
 fs/xfs/scrub/inode_repair.c   |   36 +++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/parent_repair.c  |    4 ++++
 fs/xfs/scrub/quota_repair.c   |   21 ++++++++++++++++++++-
 fs/xfs/scrub/trace.c          |   10 ++++++++++
 13 files changed, 142 insertions(+), 20 deletions(-)

