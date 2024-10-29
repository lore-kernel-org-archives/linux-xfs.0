Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3E198823
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216846; cv=none; b=uVibN/N3tqxYMa/I3EBcIL39Nh6ufvspI1Wgi+hqx+8Zo4eZ8weXFGqVamLpNVXTh/kcNs5NnGMs9ixysQ5+Wu59XzkR75pQwlz2dutjpcynkywUzAfgpTlGq6vO4ehapQNTm61yM1B7nFJeKw+KXpkeZ/L0sgxy4749CoOrazE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216846; c=relaxed/simple;
	bh=9zqzewbgMBhzktj3ZscnTbx02duxjRcSMpYrtwveZXU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUsNh7u+hEfzw987xhFY/3geHDaN0YoC+SbS7Jas6LRlBaR6ojIrmtaYQcAXKaOr+Zj97zmIKn3sNmpabyizQHwYF0uz7X2Aq46iurPNYvZ05/Bl0TH0hRI7ux4+jtXgpuQ+o2AQUofUjRQ4lBrU54ZHMw4eZq7uXg2x93S2lBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8IYvYTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8IYvYTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530DFC4CEE7;
	Tue, 29 Oct 2024 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216845;
	bh=9zqzewbgMBhzktj3ZscnTbx02duxjRcSMpYrtwveZXU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j8IYvYTKkvU+OsoKoFTv8O6S99CmRvbNCmRunwwsrxE3BSHB2e859RVfoy5rSpzxr
	 oWHHM9Xs8BKirJy5W9ftxrxWbFqtYdBva0bOMzAbSlLcpo10rVkAipgCbxqVPVxgND
	 J3b61pgY0+OMavaIjV/KU9WjDyk3982eQZ0llXu6vyzNRZ0trNRhKzs2jbBob9nA1Z
	 RVmZ0wNtJq2DcOKfTwUQ3/fJuiMhv9yt2ANKdX0U7jHIiV8kLbGekKPNN/CpJciLb0
	 JxfRXL9S3SrFcL5fUskoovk/aUV6+tg1LAIOukLMcWmZodtD1S5mwsOHm0talvV3X/
	 GJ+QlZE4PktCg==
Date: Tue, 29 Oct 2024 08:47:24 -0700
Subject: [PATCHSET v5.2 1/2] xfs_db: debug realtime geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
In-Reply-To: <20241029154457.GT2386201@frogsfrogsfrogs>
References: <20241029154457.GT2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Before we start modernizing the realtime device, let's first make a few
improvements to the XFS debugger to make our lives easier.  First up is
making it so that users can point the debugger at the block device
containing the realtime section, and augmenting the io cursor code to be
able to read blocks from the rt device.  Next, we add a new geometry
conversion command (rtconvert) to make it easier to go back and forth
between rt blocks, rt extents, and the corresponding locations within
the rt bitmap and summary files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debug-realtime-geometry-6.12
---
Commits in this patchset:
 * xfs_db: support passing the realtime device to the debugger
 * xfs_db: report the realtime device when associated with each io cursor
 * xfs_db: make the daddr command target the realtime device
 * xfs_db: access realtime file blocks
 * xfs_db: access arbitrary realtime blocks and extents
 * xfs_db: enable conversion of rt space units
 * xfs_db: convert rtbitmap geometry
 * xfs_db: convert rtsummary geometry
---
 db/block.c        |  171 ++++++++++++++++++++-
 db/block.h        |   20 ++
 db/convert.c      |  438 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 db/faddr.c        |    5 -
 db/init.c         |    7 +
 db/io.c           |   39 ++++-
 db/io.h           |    3 
 db/xfs_admin.sh   |    4 
 man/man8/xfs_db.8 |  131 ++++++++++++++++
 9 files changed, 778 insertions(+), 40 deletions(-)

