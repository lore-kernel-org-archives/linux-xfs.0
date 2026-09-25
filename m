Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE6329E5A;
	Fri, 25 Sep 2026 04:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309442; cv=none; b=dps7US1c2zUA22MWn+yST4Wxor8GHJMDLFcOeMUsMk8Ct4uJzSVoU27eTMDBr27b13k0WLjL8C3NMnAV19DaMYpXxfpPjINxOiFEAlUT2eJMwSmEq9/S1h6lERVEPYpzv/zTh/DsGe2WlA9n7jcrsvN85t5hw6FKJuWV4ZdZmmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309442; c=relaxed/simple;
	bh=6z3fYrCbA2KrlhApm6UF1Me7S6e6SdtPgbec+J6wWy4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=kMpcyqekAAsdW6iQcI9Ur0mnNbugpZwIwk3TWzBjSZt0K8BPTWYKVN2RFfML6iOM0E+zktmCi7gRxwqqOBF5ANt+VHEH6sjOVxR8cVS4IN5C3nY+h2JRT4j/OBkUs7n6wXZQ4sVQg41QFlqkQSbC0/qwhA9501qGLCOqarEkNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+UC0Kt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+UC0Kt+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A91AE1F000FF;
	Fri, 25 Sep 2026 04:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309440;
	bh=i7ajgrkzTixm0++jYrqttkrzXH4TLu3BXww/E5KkFVQ=;
	h=Date:Subject:From:To:Cc;
	b=k+UC0Kt+fvSYQTx2ytU5oFlhAnPNnRDkqrr4th7Vyf/FLj8+FVC3t4JKZ5Jyxzxb0
	 HWc0Ht4YShLkIN3b7APV+1gHBktnd4xPXrJo492S8qdbQbUO1turoyNbcmbACFagj+
	 XgoQ3R5ELc2GEXdCWA72yak0u25jcbL3xhvRgsySbJpdqaRfBfBY6tMeywm9GVRlTW
	 8vzblpNtLu8qOxwzldgUrhEpAggDU4VhVPu8Pfo2do9b38zkI4v1KCIOSge5wOI7Cx
	 Mb9lSw0Jp5kAgVKglCal7n/IEpN6LELMmrRkR0T3S+e1xpTRENupTjUMbHrxVCeWsw
	 Hu1XdLICpqS5w==
Date: Thu, 24 Sep 2026 21:10:40 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 18
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a eighteenth batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-18
---
Commits in this patchset:
 * xfs: adjust checks for cross-AG reaping issues
 * xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
 * xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
 * xfs: cross-reference the primary superblock
 * xfs: write the rt super immediately during repair
 * xfs: read rt superblock from disk during scrub
 * xfs: write the primary super immediately during repair
 * xfs: read primary superblock from disk during scrub
 * xfs: break out of zoned reservation loop if signals are pending
 * xfs: jump out of xchk_bmap_check_rmap if fatal signals
 * xfs: mark overfull dabtree node blocks as corrupt
 * xfs: check fork type against dabtree block magic number
---
 fs/xfs/scrub/agheader.c        |   50 ++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/agheader_repair.c |   31 ++++++++++++++++++++++---
 fs/xfs/scrub/bmap.c            |    7 ++++++
 fs/xfs/scrub/dabtree.c         |   16 +++++++++++++
 fs/xfs/scrub/inode_repair.c    |    5 ++++
 fs/xfs/scrub/reap.c            |    2 +-
 fs/xfs/scrub/rgsuper.c         |   33 +++++++++++++++++++++++---
 fs/xfs/scrub/stats.c           |    3 ++
 fs/xfs/xfs_zone_space_resv.c   |    5 ++++
 9 files changed, 132 insertions(+), 20 deletions(-)

