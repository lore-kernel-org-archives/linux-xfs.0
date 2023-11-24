Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2BB3DB85
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1lN1F7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BF0C433C7;
	Fri, 24 Nov 2023 23:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869583;
	bh=WfEmjs3L2aIdIvBB9X0GkIcnEB1Kmo+oNh75iEht9eY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j1lN1F7//uUrVmrHOxPlvefWom3a4/OFMycBDTDSly53XDXzXNFz1O3+qErl9sgna
	 6sdxQpNCdcDgftpoThdeW9vk/lnG9jEOlLkKHQ5MyXfoB40Fiq60yL8+Uj5PyjWA9/
	 9HwQNtCeKJs23rFEnyoEyQEWdDosd78iP0ozqORLdyYvinaAnPO8ARyktn18YGszp8
	 XCrf9kuGtXDCwrrIobyfrECTbi9XyW0OOcV2pqp5zI/kSlJrZmAUUg4YphocOoSpvU
	 kJiSJtPza/ZizdQXKgwtc27vkvOx6yTXgMTxSBsG3jzAvLMPlZWEU1RlCrnEYtmbjc
	 qEkHEJjjd25xw==
Date: Fri, 24 Nov 2023 15:46:22 -0800
Subject: [PATCHSET v28.0 0/6] xfs: online repair of rt bitmap file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

Add in the necessary infrastructure to check the inode and data forks of
metadata files, then apply that to the realtime bitmap file.  We won't
be able to reconstruct the contents of the rtbitmap file until rmapbt is
added for realtime volumes, but we can at least get the basics started.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtbitmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtbitmap
---
 fs/xfs/Makefile                |    4 +
 fs/xfs/libxfs/xfs_bmap.c       |   39 ++++++++
 fs/xfs/libxfs/xfs_bmap.h       |    2 
 fs/xfs/scrub/bmap_repair.c     |   17 +++
 fs/xfs/scrub/repair.c          |  151 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    9 ++
 fs/xfs/scrub/rtbitmap.c        |  101 +++++++++++++++++---
 fs/xfs/scrub/rtbitmap.h        |   22 ++++
 fs/xfs/scrub/rtbitmap_repair.c |  202 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary.c       |  132 +++++++++++++++++++++-----
 fs/xfs/scrub/scrub.c           |    4 -
 fs/xfs/xfs_inode.c             |   24 +----
 12 files changed, 637 insertions(+), 70 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.h
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c

