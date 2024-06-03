Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C59FF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440645; cv=none; b=L1bCSq5hiNb8WLLg/vA7HBiOB63+sbpbJ1+gN6xhV1ugzSKL4ne4q306VpUiBsNqFRuJ+6fr9cWUOj+dOnksYq6feJ0eczbGqNGTInGCuRC6rucc1o2WPvEjphGIwSDemPwdhW/Xh16+P/L1Wki9j9Brr8apOMPpmiZguND/zls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440645; c=relaxed/simple;
	bh=zUIt1rsa8A5ZR7PlPbbM5U/SY/NGQyqSLbI6jU34pUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSc+JJzM3EVqMv9Y1t5I+3V/T9LHhRpmfZ1tqWKKq5oG2nan66NCOK+VHio4PegEDo/aM6tCJPRokXGKHIo32u/hlZBy3+M0i8KCZmPWc97C+tnD1jkpOzeVzbG8jaYiicGpZ6PFnV9DKq/JbyDw3RjYjAVu2Id57jgHROiv9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6cH4svW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6cH4svW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F804C2BD10;
	Mon,  3 Jun 2024 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440645;
	bh=zUIt1rsa8A5ZR7PlPbbM5U/SY/NGQyqSLbI6jU34pUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M6cH4svWPx9wx005BgS6Po3r+7BT0sy7quH/p3AdIROfUDOlKgAcn/enL4IrPOqJg
	 Jyexn/+YAIN2iCC+M9UDRd2aRwO6q57fUNm4c80gfmp5vLDegTHHYzmK22t988hc4/
	 S4QPht4bv3SJZ01xcKSnHmNLCVxCQbRXeC7mCWQhvaPfo7sDqbDnPTAIWRhPh8/2Db
	 NhgafkxN3HrgfpTujLfZO1bzFRyfoCQYj45RRRZEytf4Pd39MxfzvTv8huxXtMr104
	 cj7jxkl1jfECEqwyvpvpKU/vXpN/eKn0PHS29pygoQAqNHFYvkqfLAwidJZg7FIbVe
	 mlE5PigIKJP/A==
Date: Mon, 03 Jun 2024 11:50:44 -0700
Subject: [PATCHSET v30.5 08/10] xfs_repair: use in-memory rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-use-in-memory-btrees-6.9
---
Commits in this patchset:
 * libxfs: provide a kernel-compatible kasprintf
 * xfs_repair: convert regular rmap repair to use in-memory btrees
 * xfs_repair: verify on-disk rmap btrees with in-memory btree data
 * xfs_repair: compute refcount data from in-memory rmap btrees
 * xfs_repair: reduce rmap bag memory usage when creating refcounts
 * xfs_repair: remove the old rmap collection slabs
---
 include/kmem.h           |    3 
 include/libxfs.h         |    3 
 libxfs/buf_mem.h         |    5 
 libxfs/kmem.c            |   13 +
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
 16 files changed, 602 insertions(+), 341 deletions(-)

