Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FB947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929760; cv=none; b=eYxY2zNNUO6yMvc8VQcI+uRn4hdtMez+yGgEk54mJKD+2pIQupZ5lkI8dpAw1AbWwhG3tJnAcseBwUFspnsd/nVKW1V7Kf/+cmWrIsSghJUJJjCHu4hE5d5N92E356t4dXuq7DHw+t9/LMBIX8pMRD8wmIZoPJtM/Tb+yoMHxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929760; c=relaxed/simple;
	bh=DL4cmgT6BJqL6crLOow1UsRJoKVDBrMayO8kOGuJQDU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=N0Ib2MR/m5uZqKAlrmFxYsOlXcqaZXALGgQpXFsip/7xk7eaAUboLyyE7yPvN19jBNhnXJpuu1JlKNZQdv4UqjcyN+LeIIC6tiKJp58otRj6sqUsWNtIuvfx99jtk6uu7z/7ScBL9rn6z2yoDOvEoLul4yCJnDqoiCXp8y8E9yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJgXnCWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJgXnCWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11062C116B1;
	Wed, 24 Apr 2024 03:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929760;
	bh=DL4cmgT6BJqL6crLOow1UsRJoKVDBrMayO8kOGuJQDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MJgXnCWtnuQmamCwQvxaAEmUIV5EF5xh+plTafW5QTxIOGyWcWWuhfqcUn3KRcpMy
	 GP0CiStC8OWQD0bjnZ9Q3kge8h+VJXIC1kypduyxmq7T3GwkSkIRDe/utErazhE3yj
	 GvpNrQqEut4ttgDEgJBGId4j61FMT+GgtmHo4cIQXFRamsATRvrGLOqz6P5pxO5ueB
	 5qYFArbURlLvFcm7pDri+twvnVusM+faiqvunCGTq7yFM/mxnbdvL6XVw5+Nnc6ZSu
	 Ga8RowgUUrTYGuw9VsjcyZF5UpoEX3NYbDiFgD6tzX2RScNqGSr/lfNVlrRitdIqEY
	 kQfxbo+cGcG7w==
Date: Tue, 23 Apr 2024 20:35:59 -0700
Subject: [GIT PULL 9/9] xfs: minor fixes to online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392953650.1941278.18020942589466688173.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4ad350ac58627bfe81f71f43f6738e36b4eb75c6:

xfs: only iget the file once when doing vectored scrub-by-handle (2024-04-23 16:55:18 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-fixes-6.10_2024-04-23

for you to fetch changes up to 5e1c7d0b29f7e05b01e448d2579a469cf3a0d350:

xfs: invalidate dentries for a file before moving it to the orphanage (2024-04-23 16:55:19 -0700)

----------------------------------------------------------------
xfs: minor fixes to online repair [v13.4 9/9]

Here are some miscellaneous bug fixes for the online repair code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: drop the scrub file's iolock when transaction allocation fails
xfs: fix iunlock calls in xrep_adoption_trans_alloc
xfs: exchange-range for repairs is no longer dynamic
xfs: invalidate dentries for a file before moving it to the orphanage

fs/xfs/scrub/attr_repair.c      |  3 +++
fs/xfs/scrub/dir_repair.c       |  3 +++
fs/xfs/scrub/nlinks_repair.c    |  4 +++-
fs/xfs/scrub/orphanage.c        | 49 ++++++++++++++++++-----------------------
fs/xfs/scrub/parent_repair.c    | 10 ++++++---
fs/xfs/scrub/rtsummary_repair.c | 10 ++++-----
fs/xfs/scrub/scrub.c            |  8 +++----
fs/xfs/scrub/scrub.h            |  7 ------
fs/xfs/scrub/symlink_repair.c   |  3 +++
fs/xfs/scrub/tempexch.h         |  1 -
fs/xfs/scrub/tempfile.c         | 24 ++------------------
fs/xfs/scrub/trace.h            |  3 ---
12 files changed, 49 insertions(+), 76 deletions(-)

