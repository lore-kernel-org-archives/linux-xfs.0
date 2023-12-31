Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C446AB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaaIN0ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ED3C433C8;
	Sun, 31 Dec 2023 19:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051785;
	bh=k9QCH303Vp3SsPIjujE0jJI4vtr8N9/1b5cknHfKKEE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eaaIN0ngn0S2usA+vAUag/ccKIhwpkBPJFBnNhUSsmihaZ3Dun/iT5/l0RbKNYSmU
	 j3tpWnbKoXzrejHqmtTErQ9OWljEazC2eXDaWB02bAa2AtfBcSPA05ZUxN0J9LqyU8
	 JTcz2tNhGiChAXcMR3yacI8iLUNl3/ivrqg21wRacTCwD4aaul6A52iB18Oikkvrim
	 J7uEI+IMk8PlLTOhE+k5g6bHKEsAUU3zqwDFnQqN7i/awPS/YxvY/MdoP0ha2TYVTK
	 oqnIr00/iNhXihioj+UJsFjj4ryrXP9SHclhems9Qh8vkmPY3NIk/tyOr+du41B71K
	 Q7u4EFISxAWUQ==
Date: Sun, 31 Dec 2023 11:43:05 -0800
Subject: [PATCHSET v29.0 13/40] xfs_repair: use in-memory rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 include/xfs_mount.h      |    2 
 libfrog/linux.c          |   33 ++
 libfrog/platform.h       |    3 
 libxfs/init.c            |    3 
 libxfs/libxfs_api_defs.h |   13 +
 libxfs/xfbtree.c         |    8 
 libxfs/xfbtree.h         |    1 
 libxfs/xfile.c           |  200 +++++++++++-
 libxfs/xfile.h           |    9 -
 repair/agbtree.c         |   18 +
 repair/agbtree.h         |    1 
 repair/dinode.c          |    9 -
 repair/phase4.c          |   25 -
 repair/phase5.c          |    2 
 repair/rmap.c            |  768 ++++++++++++++++++++++++++++++----------------
 repair/rmap.h            |   32 +-
 repair/scan.c            |    7 
 repair/slab.c            |   49 ++-
 repair/slab.h            |    2 
 repair/xfs_repair.c      |    6 
 20 files changed, 839 insertions(+), 352 deletions(-)

