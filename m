Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525317D2
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831114; cv=none; b=j7cDVevS6chYRZnMWdoCW3OzMdJLxU/gB0LldTZ4qkts98T+y21oOovEnmj72JBb7KhNU9YQrmoa4ZXnQ/45BERQs2HnfyPItaW7RBnTlkYiYZVNYWTk2iCKjS2hs/1OkG8/g2GEeR++PJURWMs8HN3PY3OeeqcVZuF43VkhYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831114; c=relaxed/simple;
	bh=nQURVZblbmyEFHvry8gU9ayR1s1k8ki2m0VAwaMRC+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqpnIh/MWNzVDlFNCDlTXrsXf/NuD00ySlOF22wmn3F0Zv3ZOdH2qOWPxwGYqyUHWnwHsnKEDJpwytntUnbzQTiewteKMF4fc57DLR0yLudicNUOeLoodCP27e8HE0BLLl8iNLNtE9VoZvYpIiobKHNhPGdk/C6fqveUaUPp0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgMviZ5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgMviZ5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A91C4CED3;
	Wed,  2 Oct 2024 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831113;
	bh=nQURVZblbmyEFHvry8gU9ayR1s1k8ki2m0VAwaMRC+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QgMviZ5D2OTKOLM4cnOpee6O4DCh9uSO3GAjOa979h9Z/8mJjajNG9UeEqaxa/1lu
	 a+ptPum8M2qOydW0Ax/mIoPt3DdDTVU4g7dePPdHpynRgGtKgogE3R+cLREYxRyw0Z
	 Yt6yvBAh37hdjYQF9nERWomnZcUqBMazKfUPFyx5l2mXpEySa3eGGgQgp3tFNs41+x
	 1nYp9lRu6aIdWcLiDWDa6cxZd8+RH7PEjQlXJxt+kULVdsx0QgjSxajEmaIqbJxnlU
	 TjVD0WC+DE8Mql9QqsX1stKsjpxuU06Jqlh+UnPzWFmDlWXviW8rUSHRGsosxzSO3H
	 wG1ML9crePgyw==
Date: Tue, 01 Oct 2024 18:05:12 -0700
Subject: [PATCHSET v2.5 4/6] xfsprogs: port tools to new 6.11 APIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
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

Port userspace programs to new libxfs APIs made available in Linux 6.11.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-port-6.11
---
Commits in this patchset:
 * xfs_db: port the unlink command to use libxfs_droplink
 * xfs_db/mkfs/xfs_repair: port to use XFS_ICREATE_UNLINKABLE
 * xfs_db/mdrestore/repair: don't use the incore struct xfs_sb for offsets into struct xfs_dsb
 * xfs_db: port the iunlink command to use the libxfs iunlink function
---
 db/iunlink.c              |  112 +--------------------------------------------
 db/namei.c                |   23 ++-------
 db/sb.c                   |    4 +-
 libxfs/libxfs_api_defs.h  |    1 
 mdrestore/xfs_mdrestore.c |    6 +-
 mkfs/proto.c              |    5 +-
 repair/agheader.c         |   12 ++---
 repair/phase6.c           |    3 -
 8 files changed, 22 insertions(+), 144 deletions(-)

