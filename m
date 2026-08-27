Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948163C2D;
	Thu, 27 Aug 2026 05:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808666; cv=none; b=BwO66btWXyC5CYSHvJW7g0X72Qooy7wumhT1y29h/RzoiAfJtHm+8FUrb8X6EKk35i4NX5Io3LbR6kSviIhKz/9pfcw1jZInzTSxvRgdI54nbTFAf1kTT5jzvMnPt06Jertm8X5pgVhgqVjvSuVtsIxID4+Nrqh9o3OxZQ8Ehos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808666; c=relaxed/simple;
	bh=ZEVb71eFKtFIPk0kd3pjGoVX99LPcbU9b/AkvxHKdEE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ntSrey8LU+Tw3n2GA9ajL7dM22BrLPU3/R9YL6dg2qFDOd47PfxOh4pTRQHlAr/TsmFnjSGbqtTre20Jtl+xlYBljrwzb37rFeH8q2Y/e9PGWs12MMaOCFM6vEkGEf/5/SSM2l+eIhC6iva59iJC0toLEw12WGRrNzbdlr9avcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7uFafBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7uFafBF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F98F1F000E9;
	Thu, 27 Aug 2026 05:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808665;
	bh=W7wMaj52HEdN8ifOg3J5IlgvVdJQbnIEJXsd5dWOoTs=;
	h=Date:Subject:From:To:Cc;
	b=K7uFafBFNScnnrSwAWIgC9nwVx2Sn9onIdYukXoKHszasPtMxjIPLNYKmKYK1NFEV
	 vLJk9qLEGXhExvm2itHr+jVzvTcRrCa7nEdk2+WiblDqayq9ziOV7fHFQYBEyzRZwA
	 HuH4EXHTA188+evtX62WWqRLPJf85bPcK2ezCzog2lIZTwwiIlAWlsr0oXnZgotsPa
	 hnS2B3oGjlG2gwA9PDJN59vysXcWJvSOUz+I6o7rD7d852kxz5+sgXFrnjOqdgLA+B
	 v5e/5aE7Coe1QFwHIU+Kbd9xRyB+WowO9HEH+GtUpdP603cDYCTk1TzDO7NoXM7E9P
	 dXT1pbMpFtlJA==
Date: Wed, 26 Aug 2026 22:31:04 -0700
Subject: [PATCHSET v2 2/2] xfs: LLM-inspired bug fixes, part 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's an eighth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add rvbs, tweak commit messages, do more cleanup of healthmon lists

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-8
---
Commits in this patchset:
 * xfs: always set xfs_healthmon::first_event when inserting at front of list
 * xfs: port healthmon event list to list_head
 * xfs: check healthmon outbuffer space correctly
 * xfs: merge healthmon insert/push helpers
 * xfs: bump lost_prev_errors if we lose even the healthmon lost event
 * xfs: report nonexistent parents as a filesystem corruption
 * xfs: destroy seen inode bitmap when we fail to add a dirpath
---
 fs/xfs/scrub/trace.h          |   33 ++++++++++
 fs/xfs/xfs_healthmon.h        |    5 +-
 fs/xfs/xfs_trace.h            |    4 +
 fs/xfs/scrub/dirtree.c        |   31 +++++++++-
 fs/xfs/scrub/dirtree_repair.c |    1 
 fs/xfs/xfs_healthmon.c        |  131 ++++++++++++++++++++++++-----------------
 6 files changed, 144 insertions(+), 61 deletions(-)

Unreviewed patches in this series:

[PATCHSET v2 2/2] xfs: LLM-inspired bug fixes, part 8
  [PATCH 1/7] xfs: always set xfs_healthmon::first_event when inserting
  [PATCH 2/7] xfs: port healthmon event list to list_head
  [PATCH 3/7] xfs: check healthmon outbuffer space correctly
  [PATCH 4/7] xfs: merge healthmon insert/push helpers
