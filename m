Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3967E157A5A;
	Mon, 12 Oct 2026 05:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784550; cv=none; b=ntS6oueQBtD9S5qvvUSSZbBOabCuuokZy7FHXuqfgScSCrCaQskfFg+iKvPe5l6XxxJeoRlK0y3BdNU+4rYBKalduVDY9Vi/+k4MGP+b+7IXYWTGJOp5M0FWxw0kX4juAL0RyOWJX5D3kJ7z3iTVd840LYdX6K02do85veqqAx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784550; c=relaxed/simple;
	bh=fdMBDCQ8SrHaiSw77TXVEzNCh0/a6eLra/7vnue2soo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=B1yROTsxTwcnLvrDBYOkjS0a9DZWWG8wqE24ZX892DeUDROl9bj3BfGDhH6nqetKp3bb1OgeCGa8j2UhUccytpufqfV4JcPdWlLPVtn62ZTW9NF8ZQx+YK174qCR3hjvMZIvZfip1yxmJIOanQLzgi6wgKPB8xRn+AAQ69KBfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsPvghss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsPvghss"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BCAAE1F0089B;
	Mon, 12 Oct 2026 05:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784548;
	bh=+Hg4JoGQk+Ia1hGT6NKAX7AaGF5FvcwXIaDeMUXs3Ng=;
	h=Date:Subject:From:To:Cc;
	b=RsPvghssAu3xyaFOSgWdqCGkeqThcLUOAE0JNitwKCellaBI+CpzhKn604Nsp59x9
	 7gYvusTuy00FTh9DJq2I/KcBJQE4zZlPTP82FYwdVlM6hum7HtZL1a4yl5tSo98f6V
	 V7MpOtRsANp3LQCc/b1xP4oOXIfQt4nxWOxyc1Bc50dSpGf3xaOrG+TfccRr0+OcJb
	 0rml/g/sJ9ZgTJczkZP6LMzKLwhlEiPkxECwQIUeUyoDW23e+huvKjADWkdwg2aa/V
	 E7pBcOQOQYQL/gF2x8lAMmP8EvYzEa2B5Z5q1ECe59mxyKtXjq8dzYrw+UYM0cIiIo
	 IVUeOxEeXk8Bg==
Date: Sun, 11 Oct 2026 22:55:48 -0700
Subject: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 22
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/btree.c        |    9 ++++++++-
 fs/xfs/scrub/common.c       |    7 +++++--
 fs/xfs/scrub/dabtree.c      |    6 +++++-
 fs/xfs/scrub/dir_repair.c   |    4 +++-
 fs/xfs/scrub/inode_repair.c |   13 +++++++++++--
 fs/xfs/scrub/newbt.c        |    8 +++++---
 fs/xfs/scrub/reap.c         |    4 ++--
 fs/xfs/scrub/refcount.c     |   17 ++++++++++++++++-
 fs/xfs/scrub/rtrefcount.c   |   17 ++++++++++++++++-
 9 files changed, 71 insertions(+), 14 deletions(-)

