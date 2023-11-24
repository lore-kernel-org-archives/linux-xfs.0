Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0502C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvP5CpPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFBFC433C7;
	Fri, 24 Nov 2023 23:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869536;
	bh=7SDbdUT1+NHb0Aw4FN4i7yz+e5SDarFOk/fpbWYP/ik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rvP5CpPQUQlimQk3ub26F/ZUsDlWoiPKijfX9CxBoGrwMDYm6W6+CC9p32qNZ+KbL
	 9jDZVhn/nc6EB3+8zzTKlTBNAfgQHuInRnoCzBgHGU3HR3DTxeGmTLd2c3aCiDAoDR
	 eihDvzs0Muk7mOGpT2dUdqBCmQed6GVCTUQzkt47XT+TTdI9apTcJpNzHJJf9t7GIQ
	 tLLV0qUX21lzTmc1IPzmq6Ga+AKCihtVN79FQfvL3wYmoD+yORim0Tsq/N0vrQt/x9
	 cWTRg6VGQl0T+Vb/zT/xewvl3MK3kwmrT3CozJkFyINs/cf8F5AK4sDgKiPvewM8Bc
	 BiD7v9s1zhaKw==
Date: Fri, 24 Nov 2023 15:45:35 -0800
Subject: [PATCHSET v28.0 0/5] xfs: online repair of AG btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

Now that we've spent a lot of time reworking common code in online fsck,
we're ready to start rebuilding the AG space btrees.  This series
implements repair functions for the free space, inode, and refcount
btrees.  Rebuilding the reverse mapping btree is much more intense and
is left for a subsequent patchset.  The fstests counterpart of this
patchset implements stress testing of repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-ag-btrees
---
 fs/xfs/Makefile                    |    3 
 fs/xfs/libxfs/xfs_ag.h             |   10 
 fs/xfs/libxfs/xfs_ag_resv.c        |    2 
 fs/xfs/libxfs/xfs_alloc.c          |   18 -
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 -
 fs/xfs/libxfs/xfs_btree.c          |   26 +
 fs/xfs/libxfs/xfs_btree.h          |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |   41 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    3 
 fs/xfs/libxfs/xfs_refcount.c       |   18 -
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 -
 fs/xfs/libxfs/xfs_types.h          |    7 
 fs/xfs/scrub/agheader_repair.c     |   18 -
 fs/xfs/scrub/alloc.c               |   16 +
 fs/xfs/scrub/alloc_repair.c        |  914 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.c              |  404 +++++++++++++---
 fs/xfs/scrub/bitmap.h              |   70 ++-
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/common.h              |   19 +
 fs/xfs/scrub/ialloc_repair.c       |  874 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   48 ++
 fs/xfs/scrub/newbt.h               |    6 
 fs/xfs/scrub/reap.c                |    5 
 fs/xfs/scrub/refcount_repair.c     |  793 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  128 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/scrub.c               |   22 +
 fs/xfs/scrub/scrub.h               |    9 
 fs/xfs/scrub/trace.h               |  112 +++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 34 files changed, 3493 insertions(+), 186 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

