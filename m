Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DDB8F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388672; cv=none; b=OfgF+yPnNith9YjMNxcTaNpLccBsJvBfXXGm8JwLQHvGNGcfGcHiYeNuoHwFtL1of8ACUdGtlhxftIoAy4ckmhrfeYr6XLCE8Ii6U+Oh8Qa3ex+7NtGtk4WuE/sxsUa6jEsaCVf5G+Uvqwd2c+cx2ECRrbFOjEhpIgZ/8giLRus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388672; c=relaxed/simple;
	bh=P+ON+C8dlAOfWpAs8y84soqkmk6J3cezPc+QKxkn2ms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q59NSB1BKJUWF+vyn0hEK40rZhTgIQeRAA/2nknM7d1yhmPKZ42EBvNYE8evJB0XEOY+nob3ChRIOulu1YLR+gAHXsWKgZAXX7XmZecKJxYMSdivVaTozZCG7HdLQS7iP39+zYKNcGEaOvhZ8G+wR5tWUhvdeD4snM/MTUiWrw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlbGnMvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlbGnMvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C480FC072AA;
	Wed, 17 Apr 2024 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388671;
	bh=P+ON+C8dlAOfWpAs8y84soqkmk6J3cezPc+QKxkn2ms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MlbGnMvUvsjYK0hwGDQ82Lzn1+UVIZ4bY71kfUNLmoqxnx+/HLYUyY8Jlp7LAcI36
	 y+R7CAaHBjuLzIPYyVm6yYd2Y8EdxGHHI8qbYubyfqQHUbgpEM1wjfmgUXlRptCjOu
	 64FAXgKxkgx/Z0No+lSTYq/Lm3WV80a4ZE4c41XwmUN+cXrXWzObVCtL34u5j9KMa/
	 KSg/TomAcnX/U7JKzsrErPpXzYXKv5UKvLNzEs3wWgThxhqPhLKj5mL4O9y9Q+VD22
	 tWkGIuMqhp9+vloCBPiPvKi95fxo8OBVpggNRo1Ce8+AUGkGZg/Q7fvSxHVhEZ7uWk
	 LJlwDZRS2XNDw==
Date: Wed, 17 Apr 2024 14:17:51 -0700
Subject: [PATCHSET v30.3 10/11] xfs_repair: rebuild inode fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845416.1856515.8750904442149650753.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rebuild-forks-6.8
---
Commits in this patchset:
 * xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
 * xfs_repair: sync bulkload data structures with kernel newbt code
 * xfs_repair: rebuild block mappings from rmapbt data
---
 include/xfs_trans.h      |    2 
 libfrog/util.h           |    5 
 libxfs/libxfs_api_defs.h |   16 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |   24 +
 repair/bmap_repair.c     |  748 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  260 +++++++++++++++-
 repair/bulkload.h        |   34 ++
 repair/dino_chunks.c     |    5 
 repair/dinode.c          |  142 ++++++---
 repair/dinode.h          |    7 
 repair/phase5.c          |    2 
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 16 files changed, 1231 insertions(+), 80 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

