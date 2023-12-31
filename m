Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7063BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsFWoPNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5990EC433C8;
	Sun, 31 Dec 2023 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053067;
	bh=MbAbzrkfIsktsFjyZQQR84cKd+8NZCRbSN+3Mddnhe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UsFWoPNkZkUlRiCmk6ZZjJmSop/HVSqWIckEVI34TtxCoPmrgkzT5804RnQ4EhieG
	 gpvkTfl4hrT9sfN+WVBRHhy5A0MoFJBoK13rn/ugQBkJ9xHy6kYNai8WnJ5XXdD3ZD
	 kzt0K+VgGkFubzIjoOzVQ1VFaT7WosDLPWiqDgiybWny++tBuPIYQHxdzJjJPqa0EW
	 ePz9y+Mv0VDQPDz0tmskZloQ9qtXEKZE6bTJnxyudxvIsbmCJ/qn7Jfz8MGkr4NBnp
	 /w6K9HZtObNqXujlvpTZ5/+thO2M6jV05GLpSI1qMxcGa/YSMLERUYdTijlVAQF/J0
	 LJ1zntHxV7Jjw==
Date: Sun, 31 Dec 2023 12:04:26 -0800
Subject: [PATCHSET v2.0 4/4] xfs-documentation: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037956.1831712.9546527653473091013.stgit@frogsfrogsfrogs>
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

This patch documents the realtime reference count btree.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 .../internal_inodes.asciidoc                       |    5 -
 .../journaling_log.asciidoc                        |    9 +
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    5 -
 .../XFS_Filesystem_Structure/rtrefcountbt.asciidoc |  173 ++++++++++++++++++++
 5 files changed, 190 insertions(+), 3 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc

