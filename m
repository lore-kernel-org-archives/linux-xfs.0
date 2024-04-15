Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DDC156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224136; cv=none; b=XymwSFEUIOwMxJ3z0FH5Ogp9fPacZrZzpPkEnlKVYnDMFXBjEVGHH0fkORy4ojaPuJNrfsSSffSsb54fxUQhTwPJVFNy6DSlqwCLJMjNmFqnXG/2UQcT+iIVopzk5BGyQIV2J+x/0s7J/p9CuuIhGzegzLQCC1yQaDmdoY4dsOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224136; c=relaxed/simple;
	bh=1XzB4ZJc7VbeabvNdOq7MZ9MCcUzDlSsWCiIqKrYaRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyIt4Ftc1JXQrj3O6/NVfEmtljgzZf7N/19+CfbJgLj+fUNneDLc4cD2fYYXtTKYe7of7wmJ+DXqXhGBT5h4imHw3fqi0DSnkboxLwhqJyQLBfwlNNf1DnYF5EBuDJbIS+QTbZgp+8A8umOOfiVUS0zre0USV9zr0KEn3WmMqrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKvRnSbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKvRnSbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0F2C113CC;
	Mon, 15 Apr 2024 23:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224136;
	bh=1XzB4ZJc7VbeabvNdOq7MZ9MCcUzDlSsWCiIqKrYaRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eKvRnSbHjVIz0W38Glmdybh24NfZZA84avWpzArU2mLGB4lj8ipIap4FK9XEu+nDS
	 vRiOT/eWh0X9ysLt+I49S0Y/7rjJJY7KPo9Q7tpRR1A8CbO/HO/KupmrRR95UW8K1T
	 hq27zFos+OY77oq66myB46P0taGOufYt+dj/CGqtzLvGFYY0XTf7Vy8LGHVVYXRv7B
	 WbPsuh/Ob7vpthL/aTNH7WLDdM6rLi+WhKNUFrCBwe3n/VysCoJQLMuWjHGswNt9sG
	 vLGogGSQHPrzBEbGrYK21FAyc+C+ZFMSsqPbByMkT9ATPHO9hMWfkWvotJCGzxO4sP
	 gy9vP1uSXtT2g==
Date: Mon, 15 Apr 2024 16:35:35 -0700
Subject: [PATCHSET v30.3 08/16] xfs: online repair of inode unlinked state
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383505.89063.1663567277512574374.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

This series adds some logic to the inode scrubbers so that they can
detect and deal with consistency errors between the link count and the
per-inode unlinked list state.  The helpers needed to do this are
presented here because they are a prequisite for rebuildng directories,
since we need to get a rebuilt non-empty directory off the unlinked
list.

Note that this patchset does not provide comprehensive reconstruction of
the AGI unlinked list; that is coming in a subsequent patchset.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-unlinked-inode-state-6.10
---
Commits in this patchset:
 * xfs: ensure unlinked list state is consistent with nlink during scrub
 * xfs: update the unlinked list when repairing link counts
---
 fs/xfs/scrub/inode.c         |   19 ++++++++++++++++++
 fs/xfs/scrub/inode_repair.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c           |    5 +----
 fs/xfs/xfs_inode.h           |    2 ++
 5 files changed, 100 insertions(+), 13 deletions(-)

