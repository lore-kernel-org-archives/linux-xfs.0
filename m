Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5BFB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYaFSxqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5507DC433C7;
	Sun, 31 Dec 2023 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052442;
	bh=JT3li+TRydANcXK+JxcMctLzhCYmV/60Kxj1SjHHPBI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TYaFSxquxO2kQLmsEKxkdjWBrMjfoYg3+wuAOIB6czbE2KEv/W2RQX3KdtpFp1Nhr
	 41/BuFBq4YyebAJoPE5ogTLPHL+IYXsawSxw6wV13J8JSrgQMEHeLCAltoSxMkl71U
	 PV6j/1diHO7inFR/V6o/tZ1fXpH5/lvIolY1z/LHbJNM3NYcsrISRZu4KBqPkTgeiy
	 Npqr1fxecRwfAI3dCVfrTYB0myI6hYlPEFxKZVrkTVLkzxYK+7WQSUqk7eo0MlGeWF
	 TDazktKyIlPIAby1ZcUrUGjUo8ZIgGyAz6TkzlJWUaXtcbiSIaKGN3ZvAqK2ryDrSd
	 s/Lgvcm9BmrjA==
Date: Sun, 31 Dec 2023 11:54:01 -0800
Subject: [PATCHSET v2.0 09/17] xfsprogs: extent free log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This series cleans up some warts in the extent freeing log intent code.
We start by acknowledging that this mechanism does not have anything to
do with the bmap code by moving it to xfs_alloc.c and giving the
function a more descriptive name.  Then we clean up the tracepoints and
the _finish_one call paths to pass the intent structure around.  This
reduces the overhead when the tracepoints are disabled and will make
things much cleaner when we start adding realtime support in the next
patch.  I also incorporated a bunch of cleanups from Christoph Hellwig.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extfree-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extfree-intent-cleanups
---
 include/xfs_mount.h         |    3 +
 include/xfs_trace.h         |    5 +-
 libxfs/defer_item.c         |   91 +++++++++++++++++--------------------------
 libxfs/defer_item.h         |    6 +++
 libxfs/xfs_ag.c             |    2 -
 libxfs/xfs_alloc.c          |   92 +++++++++++--------------------------------
 libxfs/xfs_alloc.h          |   12 +++---
 libxfs/xfs_bmap.c           |   12 ++++--
 libxfs/xfs_bmap_btree.c     |    2 -
 libxfs/xfs_ialloc.c         |    5 +-
 libxfs/xfs_ialloc_btree.c   |    2 -
 libxfs/xfs_refcount.c       |    6 +--
 libxfs/xfs_refcount_btree.c |    2 -
 repair/bulkload.c           |    3 +
 14 files changed, 96 insertions(+), 147 deletions(-)

