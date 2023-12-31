Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3F9B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuUhveo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C533C433C8;
	Sun, 31 Dec 2023 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051191;
	bh=Fc2Pzb/SfWo2qdbXFc7FtEfLBY0XtbGJWGpKoOaYp5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PuUhveo1/vbUJKyRfS4CK7E9F+0hEGXaH5UycrZbSiVlnjIoI+T+yA40sKMkvRf29
	 kRuLuXFIpv+3+spLY1oRJm7J2pcWLQNbhcCh2laiSLbaHPHpNGCnLparwpXNts5p3a
	 CTeassBQGp3jChmv+2A0q8h0/2W9OyfSU8QyTwoUlwY8QSpEuOd09+w8t7X4bLkL3I
	 QLqmRmPjqb1i3PciH3GhvLEOU9nWdaFkoxhIOtxkSxyp1nG6EX6a1N1vL7yA+8a0h+
	 LdVIaTtUt9olnk93IRnyyAA4X5ncB3T4/+lcVDl+FAEVqb4wY5GPj0kPRmtuXfyLxg
	 Co9G/2RRYSr7Q==
Date: Sun, 31 Dec 2023 11:33:11 -0800
Subject: [PATCHSET v13.0 2/7] xfs: retain ILOCK during directory updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Catherine Hoang <catherine.hoang@oracle.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=retain-ilock-during-dir-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=retain-ilock-during-dir-ops
---
 fs/xfs/libxfs/xfs_defer.c  |    6 ++-
 fs/xfs/libxfs/xfs_defer.h  |    8 +++-
 fs/xfs/scrub/rmap_repair.c |   16 -------
 fs/xfs/scrub/tempfile.c    |    2 +
 fs/xfs/xfs_dquot.c         |   41 ++++++++++++++++++
 fs/xfs/xfs_dquot.h         |    1 
 fs/xfs/xfs_inode.c         |   98 ++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h         |    2 +
 fs/xfs/xfs_qm.c            |    4 +-
 fs/xfs/xfs_qm.h            |    2 -
 fs/xfs/xfs_symlink.c       |    6 ++-
 fs/xfs/xfs_trans.c         |    9 +++-
 fs/xfs/xfs_trans_dquot.c   |   15 ++++---
 13 files changed, 156 insertions(+), 54 deletions(-)

