Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA73720ED
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444546; cv=none; b=NeXnP4Tpg4SxVMv8XTr6CtQwo4bNRTxQ9N4UFsLB1zR4XqIlYzJg2Viyc1bYoOK59cS0I20xdGmWAPqGmuTwu2UDZMG5dhmPdUdCHXaMJvODvikaY/kbWkpE5jCkX00bGks+qp6zuf2XNaPraoVhldMJq7J+X0G1WNKp0uYGEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444546; c=relaxed/simple;
	bh=29X3iqKfDvbu1QxAtOGbzKeisr4xVtRCTvTZPt0Y2uc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=RxS0TEQS/SwqXsAA3ea5hHC6fHIofcFROEcTY0o+eONBuO2LR/BSr90YkT7i+9TQ6J6fC8sIFc6nJVIBG3N1FqHE1RhYiDk2jCJct3hxyvTZqKxw0FPOlru1ARooMBmrs7nG4H6+VOzflf4mF4BUq9XopWZhniD7yJzuGvbgaRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erAHQf28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erAHQf28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7967C2BD10;
	Mon,  3 Jun 2024 19:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444546;
	bh=29X3iqKfDvbu1QxAtOGbzKeisr4xVtRCTvTZPt0Y2uc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=erAHQf28GpMYgIz7TcsvwTJlFvN65r87Ru/h/gRG8OBWHMgxYoCCpDIwo+FwPU8Hu
	 lrdbegBeyy2oS6xX8CDf6vylx7eoY3aLiQoytVtyxobbmSrSbydVWlX+NYrkdKgTei
	 VXumtefIgHN73goMHie7Sp8+smN+bbi81lqrawrewXgbnyEB3iA9zuHNuyeTOghfcX
	 rmb5wq2d1loxkDv4Q4IlS9EjZ+S3trr0g8ThsgzuzE1ZQXzg/KLaFOBxp9jOp0/iO4
	 1NKa9ecR31+F/uYbP110Ur+j06BF4FRJoUtSLW0azBTf05oRqRwHDtC2NX0RpJ8Den
	 LwcnYF2UuyT/Q==
Date: Mon, 03 Jun 2024 12:55:46 -0700
Subject: [GIT PULL 05/10] xfs_spaceman: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443759.1510943.9513422266058623916.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit a552c62f50207db2346732f8171de992f61ef894:

libxfs: add a realtime flag to the bmap update log redo items (2024-06-03 11:37:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/spaceman-updates-6.9_2024-06-03

for you to fetch changes up to 60cf6755a65f544665bca5b887fa4926a3253658:

xfs_spaceman: report health of inode link counts (2024-06-03 11:37:42 -0700)

----------------------------------------------------------------
xfs_spaceman: updates for 6.9 [v30.5 05/35]

Update xfs_spaceman to handle the new health reporting code that was
merged in 6.9.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_spaceman: report the health of quota counts
xfs_spaceman: report health of inode link counts

man/man2/ioctl_xfs_fsgeometry.2 | 3 +++
spaceman/health.c               | 8 ++++++++
2 files changed, 11 insertions(+)

