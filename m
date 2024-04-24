Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0657713340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929729; cv=none; b=NkZJA4o8ZjSuWIxdL7vfoV7WhWIDwLMeQD0zjCHjmZ4XuRlRFNYH5hHyjh/476dDAaRTt8DPFh/Au961PIm2atvhNHAR9Np3wEWW8uNxUQ2IWl4hVKOXNt34N+QkUtRsvvsaB5zBeN9DG8uxviSNMa/vqWp851OIPgzAeR3M/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929729; c=relaxed/simple;
	bh=CvEnNRnytyKFebqY1qbfnPzXC7ujgFIM1zvfdhMZ8RU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DO8aPxtLRB2nc+vAQmNMTdFWxBI2LY9AAgV2C4+ZWbueg1gD2zNA3H6AkX1ygNtgLrtzlwA47UxiqODnOujXtkxehL4AGehrQXluhJmtKFQKPhXB6GiJl7jWn3zcCR+Nvo9jPsR/ngWmbRt2JB+wBnZ4PCEodXPfFoSTr3kwgF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLjzhS6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLjzhS6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55BBC2BD11;
	Wed, 24 Apr 2024 03:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929728;
	bh=CvEnNRnytyKFebqY1qbfnPzXC7ujgFIM1zvfdhMZ8RU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nLjzhS6uifYSzltkLYWUWcxvH4pVtFB7GRW6Bv671iy6tnv4zepkcsx2BBWuZMBVf
	 7qOfq4Od1/TsAVFOv1gE+x1KZ2MpDy0gFRsYP4uvIbk0YHS+a6usjQJ1druGvg0MvZ
	 eRgsb64cbe98H7LKrCUuwV3jqlwaV2uaQPb9w5ru/eG15So4v588HhGgFGvK3DPRYh
	 807+HEMg6fPwaB+V7aomuVLDeMLcnTow8NlMT5/s66A7mol3gffpL5cjZdCTJ/OFa4
	 28arJXguD5xGevvSjeu5TjV1OE//bces1BC3kKWHbiiBhTZX/RDsrGfd7c/KzL81XW
	 p/yZnUVx8PbWg==
Date: Tue, 23 Apr 2024 20:35:28 -0700
Subject: [GIT PULL 7/9] xfs: vectorize scrub kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392952737.1941278.15338406430048213468.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 3f31406aef493b3f19020909d29974e28253f91c:

xfs: fix corruptions in the directory tree (2024-04-23 16:55:17 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/vectorized-scrub-6.10_2024-04-23

for you to fetch changes up to c77b37584c2d1054452853e47e42c7350b8fe687:

xfs: introduce vectored scrub mode (2024-04-23 16:55:18 -0700)

----------------------------------------------------------------
xfs: vectorize scrub kernel calls [v13.4 7/9]

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This mitigates the impact of system call
overhead on xfs_scrub runtime.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: reduce the rate of cond_resched calls inside scrub
xfs: move xfs_ioc_scrub_metadata to scrub.c
xfs: introduce vectored scrub mode

fs/xfs/libxfs/xfs_fs.h   |  33 +++++++++
fs/xfs/scrub/common.h    |  25 -------
fs/xfs/scrub/scrub.c     | 177 ++++++++++++++++++++++++++++++++++++++++++++++-
fs/xfs/scrub/scrub.h     |  64 +++++++++++++++++
fs/xfs/scrub/trace.h     |  79 ++++++++++++++++++++-
fs/xfs/scrub/xfarray.c   |  10 +--
fs/xfs/scrub/xfarray.h   |   3 +
fs/xfs/scrub/xfile.c     |   2 +-
fs/xfs/scrub/xfs_scrub.h |   6 +-
fs/xfs/xfs_ioctl.c       |  26 +------
10 files changed, 366 insertions(+), 59 deletions(-)

