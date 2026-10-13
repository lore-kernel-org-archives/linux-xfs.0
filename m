Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6811472094;
	Tue, 13 Oct 2026 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871518; cv=none; b=UOs7LbxwsLVv+fapAkKH7Q900UN0t4zKBr07Xgyrnr2zJYivUTQoqqu9EARlZ/PpvhesEAzfXtNtZ9aNnbXsSj5AgIjbmGxbJQRVlq9SJymwCjvXKy0dzTrq/4W+eJiZXYiNYWdMy6TzWn5MURlm3Z94Ihn5YFTp8SUjhFIxFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871518; c=relaxed/simple;
	bh=mu8iyZkibj7M3qr9tm1HlxCrPbM70en2UhyYN43zjFE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=I49cTcsfI8ITjmYIYZtSf7B/u5RyXN4bKe3JN3J2zZJudSizqVEwJW6K4rIi92gwwCZ8Mrsqna4z7DKSsrWY24nq1bTRR7N5OK/E1VtpNmYqD/pWvTuzgOdFekPObJAOrHQuoxElGK56uppmVOrNPyl2ksG7JB4u1UetqXZXisU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FdqNeVAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdqNeVAk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 44A571F00893;
	Tue, 13 Oct 2026 06:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871517;
	bh=3rZrViMHP9r1Yo4TJMx+f0o0abT4zKDvkvP8j6Xf90M=;
	h=Date:Subject:From:To:Cc;
	b=FdqNeVAk/QZIShU7c28WZIiry60Igfmkk268dp8yQ7LwJ/jqOvK60B5DZmyqnXM5+
	 ZuJdkIBSSn6DbE2CXb6nWf/rwrVK1tc3laIeERPrD83t67fDTAg4aAFd7v+51V+26w
	 XYN5u42zpS2A4MOUKSy3kM1R/PZpZrliNtBgC2oDbuFSQyV7EP0CPhw1+4qv+sncsy
	 GQ6Fodt/ywRfp6E8IxzMCZXz7EF62FfPUulxpAvwDpo4RKpqVIP+zEgQhesLT6phLs
	 T0eo8kI8KyKNe9A0LEYcKKIwwMXDN7RdZzI2j0xOG6cnWlXlaPN0lbBWaeEov6hggd
	 SOQWvLsDuoK/A==
Date: Mon, 12 Oct 2026 23:05:16 -0700
Subject: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 22
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twenty-second batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

v2: fix issues pointed out by reviewers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-22
---
Commits in this patchset:
 * xfs: don't overrun incore inode when cleaning attr forks
 * xfs: fix data fork block count check in xrep_inode_blockcounts
 * xfs: avoid oversized space allocations when regenerating metadata
 * xfs: reduce new btree slack factor if free space is negative
 * xfs: don't queue rmap update twice when reaping a fork
 * xfs: only written file data blocks can be shared
 * xfs: check for fragments when full-extent sharing matches
 * xfs: don't clear COWEXTSIZE on directories on reflink filesystems
 * xfs: clear set[ug]id mode bits when zapping attr fork
 * xfs: opportunistically skip btree block checks
 * xfs: always report scrub errors in tracepoints
 * xfs: don't scan across metadata/regular directory trees for dirents
---
 fs/xfs/scrub/btree.c        |   16 +++++++++++++++-
 fs/xfs/scrub/common.c       |    7 +++++--
 fs/xfs/scrub/dabtree.c      |    6 +++++-
 fs/xfs/scrub/dir_repair.c   |    4 +++-
 fs/xfs/scrub/inode_repair.c |   13 +++++++++++--
 fs/xfs/scrub/newbt.c        |    6 +++---
 fs/xfs/scrub/reap.c         |    4 ++--
 fs/xfs/scrub/refcount.c     |   17 ++++++++++++++++-
 fs/xfs/scrub/rtrefcount.c   |   17 ++++++++++++++++-
 9 files changed, 76 insertions(+), 14 deletions(-)

Unreviewed in this series:

[PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 22
  [PATCH 04/12] xfs: reduce new btree slack factor if free space is
  [PATCH 06/12] xfs: only written file data blocks can be shared
  [PATCH 10/12] xfs: opportunistically skip btree block checks
