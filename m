Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26AE137748
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444562; cv=none; b=lRvkM2ThbR+A5xDCgo7beAjA52XalgVWZQrnNW2d7jlVCX8MPxKk3hy/moE4XIg0WBD7nqdus8Xc7FDD2MAY3+/mH8rO+0ZKUwIdZ1kqdznx/c2sxqpmCSEtOe9DOLCWdfLHgqGDZ521puVRcR5Qj899w4JRS2HXJr6vgPD6J5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444562; c=relaxed/simple;
	bh=a/iWyS/nJJQzM49Rh6ycIFPJOuTOmIMz/FXLn+m1rSE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=kVCNWdJv4Abt9cpb2DF1GvVl8Hqu9S+7zNY8XB3iKXlZ2vMmmPyNum4z2jQMgg0+hR+MVCyBPkRQ0ZsivYRYbgDOGxwAmbnD4aylhIt3GiEVopsDDyzvA/xJ9Wb2Ur3FULH7sXJoTQKOlQm2hgUj+owX6zOlsG0Z8++glskTYdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHHfYXH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHHfYXH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFDC2BD10;
	Mon,  3 Jun 2024 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444562;
	bh=a/iWyS/nJJQzM49Rh6ycIFPJOuTOmIMz/FXLn+m1rSE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LHHfYXH/PzWe33Tog1+N+VkES1E9y/+9mdHrutUod/UxyE3lL290SNC1cb/dSYQ2w
	 6BzHxzh7WrUnkzhRcPNkHFxJhLrxsYNHwz3xV1TeOJc1GNiJMG4nH5PLt2YkwQANNu
	 pBKzUasokh8MkPgspmF0q5bL3JVK0wlh+giCWqdvl+IuQbLy2CoYPqlasFNqAQJmhg
	 14Xu1J2MMUugWiYRsjxBlbRAVjSWLjkgr5iFYos3fFlVl2PQcMr2K4499agh84O+XU
	 IQtmGLV4+ymmbVGj0ko5DvxTIwV1Cr/xXPX/U0Oe/n3qap3P0ZREsI7lx8xY8e67pG
	 lJxVcFaxW//5g==
Date: Mon, 03 Jun 2024 12:56:01 -0700
Subject: [GIT PULL 06/10] xfs_scrub: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443869.1510943.14122134344374358844.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 60cf6755a65f544665bca5b887fa4926a3253658:

xfs_spaceman: report health of inode link counts (2024-06-03 11:37:42 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fixes-6.9_2024-06-03

for you to fetch changes up to 2025aa7a29e60c89047711922c1340a8b3c9d99e:

xfs_scrub: upload clean bills of health (2024-06-03 11:37:42 -0700)

----------------------------------------------------------------
xfs_scrub: updates for 6.9 [v30.5 06/35]

Now that the kernel has the code for userspace to upload a clean bill of
health (which clears out all the secondary markers of ill health that
hint at forgotten sicknesses), let's make xfs_scrub do that if the
filesystem is actually clean.

Second, restructure the xfs_scrub program so that it scrubs file link
counts and quotacheck in parallel.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs_scrub: implement live quotacheck inode scan
xfs_scrub: check file link counts
xfs_scrub: update health status if we get a clean bill of health
xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes
xfs_scrub: upload clean bills of health

libfrog/scrub.c                     |  15 ++++
man/man2/ioctl_xfs_scrub_metadata.2 |  10 +++
scrub/phase1.c                      |  38 +++++++++
scrub/phase4.c                      |  17 ++++
scrub/phase5.c                      | 150 ++++++++++++++++++++++++++++++++----
scrub/repair.c                      |  18 +++++
scrub/repair.h                      |   1 +
scrub/scrub.c                       |  43 +++++++----
scrub/scrub.h                       |   3 +
9 files changed, 265 insertions(+), 30 deletions(-)

