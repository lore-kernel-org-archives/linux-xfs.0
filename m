Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F241A1946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418192; cv=none; b=DyrS6MnAXifkS7J2C2A1Rzfg59DGnvGqJGA575e8TITzlK1F3DHDsFQmVyeuNeY0rGq8rrBr41WmWIGKEN2jCpu4ZldQjgW76UpSZxDTXfvEtxkOkeFSxsWcuQrkJhd9hJZQHONVUDU5n+FzJwckzWMHY5dB6OgM9ElQ3A4blMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418192; c=relaxed/simple;
	bh=kcm6XbX+MCe2/zh0unBoHq/mfg/h+YGP2PbRpwHlP/c=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=E/YpFg4BWwIRLl8iEHbvvx6A2efffZVB7QJf4ajn2HT4JZnZqBhSQP7M8ttwziRGgBlY3Pj9DvhsSw7Le4d6wurs81TwsbFw8t7ZBk1NIpRZIKhnNIE6TtoALlmTTSE5Pf5OhyzVbhQAwp+ei3bwfQfgMjAx+eQqqo85y2uu7eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9nc500k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9nc500k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEDDC4CEC3;
	Thu, 31 Oct 2024 23:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418191;
	bh=kcm6XbX+MCe2/zh0unBoHq/mfg/h+YGP2PbRpwHlP/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e9nc500k1C6M9emkZc62FpbQ0OXippTK2Z14t6z3DWBtb6jT3Xf3rAd++tzTcTH5Y
	 s/j4RmdH3jnainoWNx0xju/dGkbgHJd2BRpbAINeuCCRdtFzsSBYC8mSgi4FHbycUC
	 PhSRmL1z6Q7t6f1uTBKRvDEovUZhBJzgNP39vJ9ikgLxEZ28Gi2qk+qpUtsklpi0mC
	 WWJFJvV+9S7ucZ5M2AlZmZMrQwwL4WBqYdWFfViAwI++i+mwV2kLje3V8EmlWVvLKQ
	 +fRurLbh84HKOwTynX/0OaloEqtgCXLQLDOj/bTw76kzm3Z3w1518iN7GSzat4ARrl
	 m7YeUmu8rAm2A==
Date: Thu, 31 Oct 2024 16:43:11 -0700
Subject: [GIT PULL 3/7] xfs_db: debug realtime geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764589.994242.3294432927483613816.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 1cf7afbc0c8bcb450ebc3acab7616c9da49087de:

xfs_io: add atomic file update commands to exercise file commit range (2024-10-31 15:45:04 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/debug-realtime-geometry-6.12_2024-10-31

for you to fetch changes up to 5f10590bae67d7698191a1392b6b1d3ce4d11a0c:

xfs_db: convert rtsummary geometry (2024-10-31 15:45:05 -0700)

----------------------------------------------------------------
xfs_db: debug realtime geometry [v5.3 3/7]

Before we start modernizing the realtime device, let's first make a few
improvements to the XFS debugger to make our lives easier.  First up is
making it so that users can point the debugger at the block device
containing the realtime section, and augmenting the io cursor code to be
able to read blocks from the rt device.  Next, we add a new geometry
conversion command (rtconvert) to make it easier to go back and forth
between rt blocks, rt extents, and the corresponding locations within
the rt bitmap and summary files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs_db: support passing the realtime device to the debugger
xfs_db: report the realtime device when associated with each io cursor
xfs_db: make the daddr command target the realtime device
xfs_db: access realtime file blocks
xfs_db: access arbitrary realtime blocks and extents
xfs_db: enable conversion of rt space units
xfs_db: convert rtbitmap geometry
xfs_db: convert rtsummary geometry

db/block.c        | 171 ++++++++++++++++++++-
db/block.h        |  20 +++
db/convert.c      | 438 +++++++++++++++++++++++++++++++++++++++++++++++++++---
db/faddr.c        |   5 +-
db/init.c         |   7 +-
db/io.c           |  39 ++++-
db/io.h           |   3 +
db/xfs_admin.sh   |   4 +-
man/man8/xfs_db.8 | 131 +++++++++++++++-
9 files changed, 778 insertions(+), 40 deletions(-)

