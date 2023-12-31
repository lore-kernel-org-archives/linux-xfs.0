Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C26BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFNHS12s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C1C433C8;
	Sun, 31 Dec 2023 20:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053051;
	bh=q99cStT7is21iMNuCN4vJD2s1vom/YiyXEZrtAIMjr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VFNHS12sUnVlaPKk6/JcL4oCqTyL3kX0NYrd5PN1904JyMjvMCp0NJvjBLFzaaJek
	 Y9bKq2dFdM8oUfT+9y5h8pMKlJgiIixvTzuDJBp3t0qI/0nR0iEm4a5kQNR7QNd4zC
	 83cFTodSMJIFD6SKGK7VFBoitQuwNlHPr0pUcODd+vGq/Lu02fSaHmC7IbnxLKxAaA
	 oQQABIEK2YOhFkvLYezu4LH3+bdWg7DaVK60E5cNKWZYdVOkHoeIvYbYHoHf6L+rIB
	 UGQkLr4fuHbiCtbKdLjN2hRv+sa9q6oYn+Ft8Q/v9N79eUsOqL2K/9UzT3ulnxZyBb
	 UOhYpUCho0+Ug==
Date: Sun, 31 Dec 2023 12:04:11 -0800
Subject: [PATCHSET v2.0 3/4] xfs-documentation: realtime reverse-mapping
 support
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037626.1829975.16480777008172979264.stgit@frogsfrogsfrogs>
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

This patch documents the realtime reverse mapping btree.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 .../allocation_groups.asciidoc                     |    8 -
 .../internal_inodes.asciidoc                       |    4 
 .../journaling_log.asciidoc                        |    9 +
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    5 
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  216 ++++++++------------
 5 files changed, 105 insertions(+), 137 deletions(-)

