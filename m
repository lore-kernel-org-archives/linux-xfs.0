Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243AD49B1EE;
	Mon, 12 Oct 2026 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818432; cv=none; b=oLHSim9fFFvbhDmzQWjCgloTjk1AGdDe7U6UKju5JXFNsdyv+wqW4AdL9eSIjEXcEGZ4cvhlnvJTJF2x3+h8XrDc8/r6a+ZcvHbxLL+a49xP8K5RNdviWYVw8pY8z4QZFvxiWOGrjv2z8gj0p5KOAciOjr4CvLN7SrS73pZ+8Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818432; c=relaxed/simple;
	bh=22jyFaRb90b8SM0cnS2yaWCgj42eYYxW8DCf26JCmJg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=A3V/nN7b8YImg18xgFaujEPQPoPknmtw7IkzozILGNFwcsEsTjbljdBJq9DcXxyrBM7eVfoGfKHNbVV5/8I1rmv/64oQJMFesubI0iiRDJfxiEMIt/wWIC+EjET+13iXtX8QVFDoGrXFa50Fmb48Hf0wcCDu0h4QAE5c1KBAbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+Le8gQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+Le8gQp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A99E1F0089F;
	Mon, 12 Oct 2026 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818430;
	bh=gkBX3Wnp0zyewpBmKnAdRLqX7KdJL7tSxUyLToiuQoU=;
	h=Date:Subject:From:To:Cc;
	b=a+Le8gQpTaKrzMG5ruthJcdPS0OK7T7L2BsZdK0fnVHhx2zoaqdAKsqsQNNviowPA
	 vINwbuip42MriMk2cYPpGyuoFcbcfSTqHOCh6dkzbCNXFsaDxphVB3eV3MNjlweNL7
	 CqtKVZH5VJpGEXsgkPwAg/J13rgG2pTxfeKye6khkSxTX8EWeMotsLUTwPwgSsykmL
	 FPPpTrvvm3xm3b8yD4jMjgz+/AsZMTme1UtZLxqr8D2K6aGDDxe7+tg1x9x1ds/AYn
	 LExtkkOv3uMAjGGjnK0QJ6ffdQtyMfR+4Lb0ijdhqpu2KsxHkOMmn6iwHPv/YggURy
	 AwiJF4VD72LRw==
Date: Mon, 12 Oct 2026 08:20:30 -0700
Subject: [PATCHSET v3] xfs: LLM-inspired bug fixes, part 21
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
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

v2: fix various problems noted by reviewers and other lollms
    refactor xattr entry checks into separate helpers
v3: fix bugs that the buildbots and other lollm found

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
 fs/xfs/scrub/attr.c           |  108 +++++++++++++++++++++++++++------
 fs/xfs/scrub/attr_repair.c    |   16 ++++-
 fs/xfs/scrub/bitmap.c         |   20 ++++++
 fs/xfs/scrub/dirtree.c        |    4 +
 fs/xfs/scrub/dirtree_repair.c |    9 +++
 fs/xfs/scrub/inode.c          |    2 -
 fs/xfs/scrub/inode_repair.c   |  133 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c          |   13 ----
 fs/xfs/scrub/parent_repair.c  |    4 +
 fs/xfs/scrub/quota_repair.c   |   28 ++++++++-
 fs/xfs/scrub/trace.c          |   13 ++++
 15 files changed, 318 insertions(+), 56 deletions(-)

Unreviewed patches in this series:

[PATCHSET v3] xfs: LLM-inspired bug fixes, part 21
  [PATCH 04/13] xfs: reattach dquots after changing inode ids
