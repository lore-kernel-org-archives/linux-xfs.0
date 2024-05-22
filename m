Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C97A4C7B
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346048; cv=none; b=rFZLRScgLLY9o35rrttEXSOLSdPvFoNZwsJaZj2HY3do2+Xumc7rNN2PCLO20ozx/Bx7L1LLMsBwL/1aqCymz6/A1Mm6tMJ61RXXzdDSXs+/mqwO5jOUwhGGaU8200a5FAw5ifpRsMB2lIr6KMjrOaXDGUYhjQaDv7J05n1vRWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346048; c=relaxed/simple;
	bh=zUIt1rsa8A5ZR7PlPbbM5U/SY/NGQyqSLbI6jU34pUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFyzV7ewDyjVQV6x2ZFfLMsgPjNrSb2LZSx6GMGp8Pw4LbV69r208jFftt4MV8ddtBbv5FHWATwZgOnWg3O7zI4JdBtCGRvlZsmGE0okgXos2C0yR2jCdzwzzPbCavLk39e90xH8w1qp+e/01quohcSKAJUOSVlfOho40Cjq1Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQSRiMvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQSRiMvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B4BC2BD11;
	Wed, 22 May 2024 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346048;
	bh=zUIt1rsa8A5ZR7PlPbbM5U/SY/NGQyqSLbI6jU34pUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GQSRiMvG/l7S1gh2nZR0C0IcqMWLsRk2ANjmqpXROePo/9qqIS/K8vv4qN0gQwlMA
	 ecq4lEIfzy5MZXfgVW0GQD7dvEv1tiZ/hDSa83oeDmiRYnVxjbLJM0KAypk0Bz4eOE
	 skgk8HmcPpE5o6uhDpPk6ceFWZC/Ql2attqf9YOzYUQrn18EHB1GiNpxnDgiPBZksD
	 CiMPojSMXof+NnN+MNy2mWDHqoiLTIVTMuwY4vkhPyVGTQo+ym0xSF/cK+GG2JcizS
	 6lB/G1aWC32KkddAZHUUI6rKoF+t8Hct5G632hi/+9UtcfbCsmX68lfccnLKuDXlBu
	 qm9PIXCMofPKA==
Date: Tue, 21 May 2024 19:47:27 -0700
Subject: [PATCHSET v30.4 08/10] xfs_repair: use in-memory rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

