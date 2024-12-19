Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A581A0B0C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734635954; cv=none; b=Y0WxL1KnMD4cahyD2BHni8ADbc6G/y3lUBJ+NObcb4D7q/hDuN59pesjMy2ddQsa7JnIkEMS+07avU6aNijCdjHqjiMnfoL3KUeYtDKvS2acN+kHJpv3p0uT++rQ9CRrbqQPVLcrTVOsu/25Mg/TiSKA0TtRbEA1+b4HjRKaJfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734635954; c=relaxed/simple;
	bh=n85AfbX3zXWZcvawgeT8U3Sqh6r6/4u7xoUg42CJeI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D11Gi+FALE5P71lQqcNv0TOBu5zgAaHjALQ1zmXiAe66RwMrMxDSiODzDX0tUiT+byXW6qgsmW22hhdiSS2xxzmuog91Bq0l7b4CzfDudkKvTWoNcnlRe8fpDsexvk4MSqazWvt3lh/NTpaoLUhQUsX19Psql/LmDMENWBaGiFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRLzmMs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRLzmMs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0881C4CECE;
	Thu, 19 Dec 2024 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734635954;
	bh=n85AfbX3zXWZcvawgeT8U3Sqh6r6/4u7xoUg42CJeI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VRLzmMs9kztg8JLcsRUR3nfaiWY0GjRr+UXzRLEsSKD2eCN2CEnks02B/3nYGbCMC
	 CCYdyIXOAXl5U6MyrOzgQJP7oMNks8ipZf2XckOfWcl6OkVousBN9bbHPP0NdiSfD6
	 ao1X5lLlFmI6h3S37qPFQqA3cSL8yNwISyhbg64zT3yrwemOs0uaZA1fkJAb12Bwp/
	 KEh8N5max/XHGrYH2LgjpwbSXZfJw+t0H26AzcCv5mbwpN8CLD/hoHHyhEkc8zdvTv
	 ruSE6UUbECOQzpen99BgOn/VyUS7AVz5jAvFYi/cHMdtoZGReRdIqdHBujo+xFh6Uu
	 EmFJou9IbPJ3w==
Date: Thu, 19 Dec 2024 11:19:13 -0800
Subject: [PATCHSET v6.1 2/5] xfs: refactor btrees to support records in inode
 root
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578631.1571062.6149474539778937307.stgit@frogsfrogsfrogs>
In-Reply-To: <20241219191553.GI6160@frogsfrogsfrogs>
References: <20241219191553.GI6160@frogsfrogsfrogs>
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

