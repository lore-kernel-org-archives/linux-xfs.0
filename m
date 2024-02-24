Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30805625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738388; cv=none; b=rNMWCa9RTuVId4GGIIuLz1EHHxbnGV8plSqUvEpqwyt3r35zU9LBnKEGbwBAk2QLOp6dHnjjEkjqxrhfmFnLjbEV1znELI81AN/4TzXLlc+fNedlETHZuRgGJd/U6jhFf6DXZG5xu9rGS8q9pK16+ZlUia/itK05wQ2YHuqrEvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738388; c=relaxed/simple;
	bh=VoaECzDnjEtcXqZNRB8bVxY77eJGipW/ebinzO2ZluE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=g3UB9n4WwVKByOaDuN1R19vykvOB8C2bAahTppTuRnBduPiA73DVbpLpp+tdwmRLbASf+B4vWrq1RkJc8AOTQcjLvjhnkjbY3cUEycCsC/yL/6JT84cZ+542OMZ1JGWKjkjnm4AHMJmxWEJ4BbCrxiX5rQliq83d9bsz2KPx/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTMM2T/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTMM2T/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2B8C433F1;
	Sat, 24 Feb 2024 01:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738388;
	bh=VoaECzDnjEtcXqZNRB8bVxY77eJGipW/ebinzO2ZluE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rTMM2T/D/L0KTFZCnp+hR3A5Y5X1TPU1OuGtlPsWG40hG1Q2OSdIjnkUHZhjSm7Xm
	 KEZfY0kdYg0LUlzDI0eylATlzUK6+tI5VblKpGPrEbD0sMs87xsKhK5rRYHBw072w7
	 VN+xQoQmLF5SW2GfHwGawBOGEnlV+qidDxpsLaGhDgvfKY/hwiR5x74ZhQi2nTyNTC
	 k2bWRvrR2n57twuB4b2lqE5vwprMAeegM+dwoo7+kphWJW0PGpyUfskDRCeD254qEe
	 5Npk3F1IxMfIVBJT4xil9m+44vkkpy1103wlmnYmudfy/yI+v175lqKKEB9FfdZ3VH
	 2soJNycns9H3A==
Date: Fri, 23 Feb 2024 17:33:07 -0800
Subject: [GIT PULL 16/18] xfs: widen BUI formats to support realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873806923.1891722.6359185979646674968.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit c75f1a2c154979287ee12c336e2b8c3122832bf7:

xfs: add a xattr_entry helper (2024-02-22 12:44:22 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-bmap-intents-6.9_2024-02-23

for you to fetch changes up to 1b5453baed3a43dd4726eda0e8a5618c56a4f3f7:

xfs: support recovering bmap intent items targetting realtime extents (2024-02-22 12:44:24 -0800)

----------------------------------------------------------------
xfs: widen BUI formats to support realtime [v29.3 16/18]

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
xfs: add a realtime flag to the bmap update log redo items
xfs: support recovering bmap intent items targetting realtime extents

fs/xfs/libxfs/xfs_bmap.c       |  4 ++--
fs/xfs/libxfs/xfs_log_format.h |  4 +++-
fs/xfs/xfs_bmap_item.c         | 17 +++++++++++++++++
fs/xfs/xfs_trace.h             | 23 ++++++++++++++++++-----
4 files changed, 40 insertions(+), 8 deletions(-)

