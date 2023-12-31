Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEE0BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXlpc11M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCA3C433C7;
	Sun, 31 Dec 2023 20:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053036;
	bh=/4EJhcvyKuTlFpFKwjFan02wfSd6FzBZL2BoUEJNeOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UXlpc11M9DhsO/NMZxRgx2gPmEXQh07+0cOKHQJgaJMC74HFSsxj+0srOHtatX16O
	 dSIak/5e2anb7jhtqCI2hDOjDKKGS6AubwWH23hyE5Y6fbYrriF5V1SM6kcTv8H2F1
	 Q/VTEL/0zDi2b3D+vPE37CUGxBv1/K2wdUZmYpPRcw9T79P0y1viXpJol2tPu6vbjI
	 pMq9rc8TOhlf+sSTV+svU75yEpN64RxSR57GJmKExq1fsvr/yFm13w2Nx9eRnu7Yu4
	 3Dn9mW/Qi+MvWQjOznCSCBJTpivc88Kg4i4eaM1R6Ynb/1Up/1J7KhOUhGWbYYWo4i
	 lORkzC/cdu4wA==
Date: Sun, 31 Dec 2023 12:03:55 -0800
Subject: [PATCHSET v2.0 2/4] xfs-documentation: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037287.1829872.4170922148688875113.stgit@frogsfrogsfrogs>
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

Document changes to the ondisk format for realtime groups.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
 .../allocation_groups.asciidoc                     |   39 ++-
 .../internal_inodes.asciidoc                       |   36 ---
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  232 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 
 5 files changed, 256 insertions(+), 54 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/realtime.asciidoc

