Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B7810E9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606968; cv=none; b=Cq+KH+shfMOj3EUDHiRNNSGCFs1zRLHXjuEBhW/OP5H/ehJ/b29pKihlwXLbqI4go+PHhvsDi4JgHvkYhqFzgEbpqLTh8g1vWHtsalEj7Lg1flrP+4RmiA4um1ZCJdsXVSTGk5UkObusK/iXHUxvWL58Ao6WlCkLHzIQlwrHYhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606968; c=relaxed/simple;
	bh=SKs7Nd60WBaMmxDmmPFFeA2La52SJg/UvxA7tumK2GE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAOBBwTw8C/2JkyF83c4i6+sBIXRo7TzWj/hNrvAJ4E2IMvQp+O1mAWDhpTMqtQ7Lqrhpo7UozOjZMA3qrJbjMUBlBIXZIrBciM+h7UC1jOGtruIjGAPF+XVZbL7LfnpZ3W8veAUs7AMvuOumZvFZGua9BeXLUkDG90qtQyrwb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5WX2gtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5WX2gtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8428C4CEC5;
	Fri, 11 Oct 2024 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606967;
	bh=SKs7Nd60WBaMmxDmmPFFeA2La52SJg/UvxA7tumK2GE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e5WX2gtBZhzW4ihoFDTYMimA7qy8dltEN63g8DB028iGYjOJv/K5SbNgADOmEF9Fh
	 Zz8JdeYKMDT2bftK6OCtnE6y14rvCSlZw+8x524Jfb0f2c64CjZBuh2t0KF3d1Kw52
	 TOefrnsO5TWJE2IKOvVUPT4+092hwfksEY1wVulPy3uwFnwuALY5t6boC8WlAnh15c
	 I0m1A22mcO469Vx6BuTsPVD7bwgjcC14ae/wj1gCuJA8E1+2uG7rGKOSJbttz9MpUk
	 D78ovgQsCT99nBWC/9RrUi1p8Ic+cGX7jRp+smaL0STH4tKVH1klVF+58FIdM+Xo6P
	 jrfS02zRGUc4A==
Date: Thu, 10 Oct 2024 17:36:07 -0700
Subject: [PATCHSET v5.0 2/5] xfsprogs: preparation for realtime allocation
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654880.4184510.591452825012506934.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Clean up the userspace utilities libraries prior to merging of realtime
allocation groups.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtgroups-prep

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rtgroups-prep
---
Commits in this patchset:
 * libfrog: add memchr_inv
 * xfs_repair: remove calls to xfs_rtb_round{up,down}_rtx
---
 libfrog/util.c  |   14 ++++++++++++++
 libfrog/util.h  |    4 ++++
 repair/dinode.c |    4 ++--
 3 files changed, 20 insertions(+), 2 deletions(-)

