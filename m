Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77014B65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8deY8nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88AC433C7;
	Sun, 31 Dec 2023 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051113;
	bh=Upt0gPH1HJvTwazsBg5BDB2aP4V7ReLPSJl+gxRZBzk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M8deY8nnY1ErL/J9fPvjw2GlxoIohrbD8d8y/31bZvjcnBmI0Ev0BvFnyCknOuD2W
	 ybWqwBji59MAmCdgQbSfdDgH4JR9V9SzfQ//9TqQ+DjuMPMh9iBcrDZ7a/xF/EWlB0
	 XdWZ2JI/PjRHwMRivBP6WRsBjBUuRkmnHg2IHgoDvdFC5ZuY5xxsEqF2yuIiAdm23c
	 D9YOQNl73xgr7o6VMb1kJmdwXRflzugf5xxPzkI8e1IbyII2ZwpDMi3yMRSOZIbpJW
	 rUkpAg15KSO5zuU09gVcHCOS4vFtHsSaapIuNe+vNbYOSs6cUAMx4mVIJzAQCVHw1W
	 qyV1QrmJ3FgJA==
Date: Sun, 31 Dec 2023 11:31:52 -0800
Subject: [PATCHSET v29.0 25/28] xfs: online fsck of iunlink buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837191.1753977.11382534548825167511.stgit@frogsfrogsfrogs>
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

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-iunlink
---
 fs/xfs/scrub/agheader.c        |   40 ++
 fs/xfs/scrub/agheader_repair.c |  879 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/agino_bitmap.h    |   49 ++
 fs/xfs/scrub/trace.h           |  255 ++++++++++++
 fs/xfs/xfs_inode.c             |    2 
 fs/xfs/xfs_inode.h             |    1 
 6 files changed, 1179 insertions(+), 47 deletions(-)
 create mode 100644 fs/xfs/scrub/agino_bitmap.h

