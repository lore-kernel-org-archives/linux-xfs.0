Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A65B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQ5JU6+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AC8C433C7;
	Sun, 31 Dec 2023 19:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052426;
	bh=/Cic1DMV6aJ6MW0l4p37GD0/UCBzlalBIAdSMVPPZsU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CQ5JU6+bDkIxAl3KVlyX7YKdlV6cEAOZM/cJCemMhwadYg+4wdxUXdUy7vI3o/aDK
	 EEO/20zEMHW0juHw/55DzC12FfXE5xCRHJtofApVZvz7IpH+3quBDg9E3E9pou+uIi
	 EixsaDeEBhhhQYWoDwqWtfJXouGXb9oEAWe7BAFxHyvCFbCExYu7rUIBlGEU4XM8Dm
	 lzsLr8hlrLJxXwSQu7z3KajuLzO7R+vFmTbyZ6Bas629SqI3L2iroZ50XpzMQtltr5
	 Yv/xWc1NSqbToGNHSfiN2PCGe6dlZ91MRQmH5t4UmkgFQu3WfL9GvtgHfrRP46rOfn
	 5HAP6U2qscF6g==
Date: Sun, 31 Dec 2023 11:53:46 -0800
Subject: [PATCHSET v2.0 08/17] xfsprogs: enable in-core block reservation for
 rt metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013700.1813633.7627597760064686124.stgit@frogsfrogsfrogs>
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

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This effectively allows us to pre-allocate space for the rmap and
refcount btrees in the same manner as we do for the data device
counterparts, which is how we avoid ENOSPC failures when space is low
but we've already committed to a COW operation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
 include/xfs_inode.h   |    5 +
 include/xfs_mount.h   |    1 
 include/xfs_trace.h   |    8 ++
 io/inject.c           |    1 
 libxfs/init.c         |   11 +++
 libxfs/libxfs_priv.h  |   11 +++
 libxfs/xfs_ag.c       |    4 -
 libxfs/xfs_ag_resv.c  |   25 ++----
 libxfs/xfs_ag_resv.h  |    2 -
 libxfs/xfs_errortag.h |    4 +
 libxfs/xfs_imeta.c    |  190 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h    |   11 +++
 libxfs/xfs_types.h    |    7 ++
 13 files changed, 255 insertions(+), 25 deletions(-)

