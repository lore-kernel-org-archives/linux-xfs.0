Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B8186E20
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994365; cv=none; b=fsC2pggeihxrhsgTREJXpmL/hMrFtiSaWmkbqHN8u2ZUmO4K/+oiJUhy+9PVHj3Rw5hW7Ye+I8y/efD89/1yeS8vn0EDjJddg1xKUChEO0NKO58ZIvN58WMFxZ/p/2wD/Bc0y8T3kbmsVtMfs/vqq6QoC/KejEprhYJCzef/+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994365; c=relaxed/simple;
	bh=n85AfbX3zXWZcvawgeT8U3Sqh6r6/4u7xoUg42CJeI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaBeO5emi8iSrogW0FZLjsGOB0wbwfH2Po9s425Vl0Qt+k5Ia8EqiyjUQbYcDilYz1DiBQfl/GrhMtClfvu3qnTUpuGbkVKJ9+rVKBDn1exrT1Og1C2g9kmfXan9U+EY9xRvGEIgcVnSaeoJfhO0O1BS4EbdlGkb+cKWOLwXisA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoWaeGdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoWaeGdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF1C4CED3;
	Mon, 23 Dec 2024 22:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994365;
	bh=n85AfbX3zXWZcvawgeT8U3Sqh6r6/4u7xoUg42CJeI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HoWaeGdrNY9aOubPEg4kwmoWDZTAI1AM8LvuyjhTQjmNnWH1cfF3JvWLFL5up+WZL
	 Atm2VE+k03a/0AuL2GqhP3tm0x9h9kskIIHfpZoHH3DzZM+UoIVqT9wtjhi60ZPfUx
	 cyeRXqyFAnFluZM1nzRuZtJTKE4NtR1aJuh/v59XKD7d7BufK56VwUbbC374n+9BpT
	 ZN6D3P13eo9ynSWVeaBhD/Ltwdkw3dftACgyV7p97TY+93NIC2dRICvmpFj165SHLM
	 xn30zIhocfu+rCfG30/cXPoJIWkDKOv5r5507DqoEF1CPwSmKiG57c5aX8dWpKyqtq
	 FWXsmG1SBWnuA==
Date: Mon, 23 Dec 2024 14:52:44 -0800
Subject: [PATCHSET v6.2 2/5] xfs: refactor btrees to support records in inode
 root
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Amend the btree code to support storing btree rcords in the inode root,
because the current bmbt code does not support this.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
Commits in this patchset:
 * xfs: tidy up xfs_iroot_realloc
 * xfs: refactor the inode fork memory allocation functions
 * xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
 * xfs: make xfs_iroot_realloc a bmap btree function
 * xfs: tidy up xfs_bmap_broot_realloc a bit
 * xfs: hoist the node iroot update code out of xfs_btree_new_iroot
 * xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
 * xfs: support storing records in the inode core root
---
 fs/xfs/libxfs/xfs_bmap.c          |    7 -
 fs/xfs/libxfs/xfs_bmap_btree.c    |  111 ++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h    |    3 
 fs/xfs/libxfs/xfs_btree.c         |  333 ++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_btree.h         |   18 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    9 +
 fs/xfs/libxfs/xfs_inode_fork.c    |  170 ++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h    |    6 +
 8 files changed, 445 insertions(+), 212 deletions(-)

