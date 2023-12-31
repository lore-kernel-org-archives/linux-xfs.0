Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B9CC8D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhmBRvM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13060C433C7;
	Sun, 31 Dec 2023 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052583;
	bh=L9hZH4biKrT6aLJlL6q54N176SdiZwjCsCFtRtlwWrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fhmBRvM4QMJjstR2FkRTKgJgqO1hNwOqzcOKsgVyTS6qepC3iAtyfx43GQZbCPOrM
	 djwbkyYrsvrO+TXj0wmxhuj6a03Xxo5k83mnTdBfqIwVdqB7/szMEq/RFr3OC5ohQO
	 9pdVWZcibmVAzRxRlnKlY56S+UPqEs0iQ0bC5ywAoVP97cEi3fDYzCqRtHrvAXiBj0
	 FaQlRm/0wznD7b31a4SpmiojG3KezaQmps6qPe+psGYgkNmdt5Rjpxqjjxx/OSvT2F
	 qkONYp5pDrmzCKcDZhdK0p5W+Qw0oAAFD5jbUK6tSZBkXpQKK/czMPyZj+lFEwM4Hi
	 UtJDkTb1Mn+WQ==
Date: Sun, 31 Dec 2023 11:56:22 -0800
Subject: [PATCHSET RFC 1/3] xfsprogs: noalloc allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

This series creates a new NOALLOC flag for allocation groups that causes
the block and inode allocators to look elsewhere when trying to
allocate resources.  This is either the first part of a patchset to
implement online shrinking (set noalloc on the last AGs, run fsr to move
the files and directories) or freeze-free rmapbt rebuilding (set
noalloc to prevent creation of new mappings, then hook deletion of old
mappings).  This is still totally a research project.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=noalloc-ags

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=noalloc-ags
---
 include/xfs_trace.h  |    2 +
 include/xfs_trans.h  |    4 ++
 io/aginfo.c          |   45 ++++++++++++++++++--
 libxfs/xfs_ag.c      |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h      |    8 ++++
 libxfs/xfs_ag_resv.c |   28 +++++++++++-
 libxfs/xfs_defer.c   |   14 ++++++
 libxfs/xfs_fs.h      |    5 ++
 libxfs/xfs_ialloc.c  |    3 +
 man/man8/xfs_io.8    |    6 ++-
 10 files changed, 220 insertions(+), 9 deletions(-)

