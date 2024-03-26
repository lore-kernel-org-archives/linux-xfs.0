Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479DA128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421935; cv=none; b=A2TEMw5sMx/5McG7AYkrPZrnQoi2wtM40JdaDXg/nAG0Yn4MjrhTlMj2abIKFBk0HYMbsBOQdAop1q78ee3N2RqhB0ZDLqRfCzO/1esraN8s+pYacE7YjaoVnoR9RCxmTOLzFmRHBteJEvQ9wM2Ic9r4dwy2zYtTWo1/5s8CShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421935; c=relaxed/simple;
	bh=WGTz7p17NXykxPyCOCILtF8Ni4c2J6P6Q1vOvETK70Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QP371+DI/mAZmT10yYvFKx3W4bOjoxcEVdDEyBihpp5xUhUMq0Ufs+C6/ZwKSoVnm0SV38ctPs0Sq40V1vdCJmlO2C4519UR2ql2jxaPFLJp4br/7NViQwL7Rp67563KLpC24R5NJXD/8c4+q4u59qctyyCxbMnai54/GDas5Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W289Cp9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W289Cp9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB12C433C7;
	Tue, 26 Mar 2024 02:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421935;
	bh=WGTz7p17NXykxPyCOCILtF8Ni4c2J6P6Q1vOvETK70Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W289Cp9odhRJkg7rREbU1e0qTmopUOS82iKCTW/kvxp2Vs1MPiDyFH0FvST2Q35sy
	 o8mtNlbCJe+ybXZpVUY8bcRbshTbOC4G54vXos5VD++OZwqRRw7K436m/z9jLQ9NSY
	 T5lD+PntSFW+4Ow06lrSJe4vVcEan2UlQILI/xoPfUZnkNGWQ/1W+sGw+/KqX+mLgi
	 yhhT7stU5aGTw9cEwKY4uvpOKt8KPBKJfhylD4OM4VtgM+54AYmUiW3YEsH5mgFmKN
	 90XUlEWacav+FHECDIaYadx2GPe1SHp6rEhsaKIAHTBYz4R3PM4y52NbAA1AYhwdSr
	 /0A+f9SQ2xTww==
Date: Mon, 25 Mar 2024 19:58:54 -0700
Subject: [PATCHSET v29.4 16/18] xfs_repair: use in-memory rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

Now that we've ported support for in-memory btrees to userspace, port
xfs_repair to use them instead of the clunky slab interface that we
currently use.  This has the effect of moving memory consumption for
tracking reverse mappings into a memfd file, which means that we could
(theoretically) reduce the memory requirements by pointing it at an
on-disk file or something.  It also enables us to remove the sorting
step and to avoid having to coalesce adjacent contiguous bmap records
into a single rmap record.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-use-in-memory-btrees
---
Commits in this patchset:
 * xfs_repair: convert regular rmap repair to use in-memory btrees
 * xfs_repair: verify on-disk rmap btrees with in-memory btree data
 * xfs_repair: compute refcount data from in-memory rmap btrees
 * xfs_repair: reduce rmap bag memory usage when creating refcounts
 * xfs_repair: remove the old rmap collection slabs
---
 include/libxfs.h         |    3 
 libfrog/linux.c          |   33 ++
 libfrog/platform.h       |    3 
 libxfs/buf_mem.h         |    5 
 libxfs/libxfs_api_defs.h |   13 +
 repair/agbtree.c         |   18 +
 repair/agbtree.h         |    1 
 repair/dinode.c          |    9 -
 repair/phase4.c          |   25 --
 repair/phase5.c          |    2 
 repair/rmap.c            |  762 ++++++++++++++++++++++++++++++----------------
 repair/rmap.h            |   25 +-
 repair/scan.c            |    7 
 repair/slab.c            |   49 ++-
 repair/slab.h            |    2 
 repair/xfs_repair.c      |    6 
 16 files changed, 622 insertions(+), 341 deletions(-)

