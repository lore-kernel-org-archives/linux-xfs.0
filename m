Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853DE4334BC;
	Fri,  9 Oct 2026 06:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526501; cv=none; b=kSlOXtznCMKP0+oWrsYS1sq5NtxWW9PwTMlLDqKg6673iT9SBG8mibWmBGRHdlwmRrM5FlDgWD3x84kNvET0zkf5uzypKa8XiF6ZoPXoVMfWxTsnp125gIwjehiN+ioehyLquaE5FnwY9BalIqkTVaU+IKdjp0kkl2sA6/rU19M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526501; c=relaxed/simple;
	bh=NHqkr47ZkZFB+ISVSLnwJZsTAUMqVXXlawndXDTFamI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=XRCpECIGkkyDCTEdm/U1CpXbgfUGfT6m+B9baheRjIbrF3pzK1CUt8G6zuWei+LDTBDEEzkCLydx0ZpBgdYo3BZvl99gLeVTOTmwvDKF1V7HRJsOFkQQ0jKrcm1r3HRXogM02/75ltb+74krrdCKxRAepMtY6LrbiOZbEkqu/EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1I2gCZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1I2gCZG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1001E1F000FF;
	Fri,  9 Oct 2026 06:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526500;
	bh=CJBbIT90J7czdFuCWTD/YOZU5dDcQZ2W1ylAmd4ZyPE=;
	h=Date:Subject:From:To:Cc;
	b=i1I2gCZGxdjUS7rhf6Ib5bLDZScWSeZBLE0xYsus9MXyHZK6qpEKmq3Za7R/aHSOC
	 X6k8/Ga23CSxP9hR3qWyDFOFrchzoKjOxIsHBNTuicvC0XQyEMp1I0us/pXjK5wJfM
	 /SEzvCOnwF5qVqPlQHvFmHZWdwF7Q450tB74hDAhzYqqAGxN9BjN0Z+xaQWkB3Yo2F
	 DpParrg+S8TJyTqD8tJr0hRjG6IGeCezD7kkwqihR91Q54euXcmrxs6oncgbmo7fX9
	 hIJysNCNofAEYj1/W3URgAdRI9SDMYt2wNzRLC6WF3oC20gjU9e+qMZ4DyoaippXA5
	 sRXpTByazeX8g==
Date: Thu, 08 Oct 2026 23:14:59 -0700
Subject: [PATCHSET v2] xfs: LLM-inspired bug fixes, part 21
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
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

v2: fix various problems noted by reviewers and other lollms and
    refactor some attr scrub functions

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
 * xfs: break out xattr entry checks into separate functions
 * xfs: check for buffer overruns when examining local/remote xattr entries
 * xfs: clarify various parts of the bitmap API
 * xfs: complain loudly when dirtree checker finds broken links
---
 fs/xfs/scrub/newbt.h          |    1 
 fs/xfs/scrub/repair.h         |    2 -
 fs/xfs/scrub/trace.h          |   10 ++-
 fs/xfs/scrub/alloc_repair.c   |   11 ++-
 fs/xfs/scrub/attr.c           |  108 ++++++++++++++++++++++++++-------
 fs/xfs/scrub/attr_repair.c    |   14 ++++
 fs/xfs/scrub/bitmap.c         |   20 ++++++
 fs/xfs/scrub/dirtree.c        |    4 +
 fs/xfs/scrub/dirtree_repair.c |    9 +++
 fs/xfs/scrub/inode.c          |    2 -
 fs/xfs/scrub/inode_repair.c   |  136 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/newbt.c          |   13 ----
 fs/xfs/scrub/parent_repair.c  |    4 +
 fs/xfs/scrub/quota_repair.c   |   28 ++++++++
 fs/xfs/scrub/trace.c          |   13 ++++
 15 files changed, 313 insertions(+), 62 deletions(-)

Unreviewed patches:

[PATCHSET v2] xfs: LLM-inspired bug fixes, part 21
  [PATCH 02/13] xfs: don't subtract excess usage twice when computing
  [PATCH 04/13] xfs: reattach dquots after changing inode ids
  [PATCH 06/13] xfs: fix correction of unwritten extents in quota file
  [PATCH 10/13] xfs: break out xattr entry checks into separate
  [PATCH 11/13] xfs: check for buffer overruns when examining
