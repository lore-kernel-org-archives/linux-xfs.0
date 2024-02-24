Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76C4A05
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738169; cv=none; b=IgX4roafJIDFdQRglVHEVu7f4W6De4HWO5h+ut8jza8j7uGHXPCjQpQfhx4c2EHrdlvsjC8MyZAOaQZWfdirB1ch0UHSK+am44IQ87nlcs/6mClCXB7SlmnQUpdzP4011NbfLony/5J1YY1RXjfjxDnKxn+IRKYLAFACiQ40wLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738169; c=relaxed/simple;
	bh=4TyjXnNymTmFnOEaPPoZKWYl0BDCh3Vz0zvBeg9e9cM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=jXUbnM1mphf0NRK0iySI8qF+pPr3xjtlpjlGAmYfUBBxo8rSa1i84ZZtHhioKRdiLY+f8bX06CPdzSfecFnQFVIr4SMra6rcp2nVKx86rhcQM3b4ez0cJguujuoOup4nwjw6emBa0R4RDn8LAiPJhnox5Et53MdHZPdLtuJmJv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uT5zDmOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uT5zDmOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF45C433C7;
	Sat, 24 Feb 2024 01:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738169;
	bh=4TyjXnNymTmFnOEaPPoZKWYl0BDCh3Vz0zvBeg9e9cM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uT5zDmOs2mjL8oqBPlEkKHK3TQgFvEK3yMGusErvLU1yEgzPbC3N23/+WlFCOm3I4
	 BlHItfA5buz83c4UbYwFhmmS7nzOrj72ZEKYxL4Fu7AMDKUNvstO9lFwPI2crlTz6W
	 3hFooCj6igowjv5KMQ2Xecbp/ZKS2JB+dEAROC+09VH6mW4dZKSAfWlzJKm6r4YqtO
	 TVGbVbhPcSNRi/Ol1kUjQ6PND9/6q5FuDLGM7OIpzkmQvIab0zBDHeJns9vW/gW651
	 zjmtu2xXxL9cRFV1lSV17QLN+pu+Plqd2+l5vZ8q6WyxvAIfkA0thdHeHBXU/q2TDY
	 M/QEY5FXTXHsw==
Date: Fri, 23 Feb 2024 17:29:28 -0800
Subject: [GIT PULL 2/18] xfs: online repair of quota counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873800654.1891722.9189225009504434462.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 5385f1a60d4e5b73e8ecd2757865352b68f54fb9:

xfs: repair file modes by scanning for a dirent pointing to us (2024-02-22 12:30:51 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-quotacheck-6.9_2024-02-23

for you to fetch changes up to 96ed2ae4a9b06b417e1c20c086c77755a43284bf:

xfs: repair dquots based on live quotacheck results (2024-02-22 12:30:57 -0800)

----------------------------------------------------------------
xfs: online repair of quota counters [v29.3 02/18]

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs: report the health of quota counts
xfs: create a xchk_trans_alloc_empty helper for scrub
xfs: create a helper to count per-device inode block usage
xfs: create a sparse load xfarray function
xfs: implement live quotacheck inode scan
xfs: track quota updates during live quotacheck
xfs: repair cannot update the summary counters when logging quota flags
xfs: repair dquots based on live quotacheck results

fs/xfs/Makefile                  |   2 +
fs/xfs/libxfs/xfs_fs.h           |   4 +-
fs/xfs/libxfs/xfs_health.h       |   4 +-
fs/xfs/scrub/common.c            |  49 ++-
fs/xfs/scrub/common.h            |  11 +
fs/xfs/scrub/fscounters.c        |   2 +-
fs/xfs/scrub/health.c            |   1 +
fs/xfs/scrub/quotacheck.c        | 867 +++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/quotacheck.h        |  76 ++++
fs/xfs/scrub/quotacheck_repair.c | 261 ++++++++++++
fs/xfs/scrub/repair.c            |  46 ++-
fs/xfs/scrub/repair.h            |   5 +
fs/xfs/scrub/scrub.c             |   9 +
fs/xfs/scrub/scrub.h             |  10 +-
fs/xfs/scrub/stats.c             |   1 +
fs/xfs/scrub/trace.h             |  30 +-
fs/xfs/scrub/xfarray.h           |  19 +
fs/xfs/xfs_health.c              |   1 +
fs/xfs/xfs_inode.c               |  16 +
fs/xfs/xfs_inode.h               |   2 +
fs/xfs/xfs_qm.c                  |  23 +-
fs/xfs/xfs_qm.h                  |  16 +
fs/xfs/xfs_qm_bhv.c              |   1 +
fs/xfs/xfs_quota.h               |  46 +++
fs/xfs/xfs_trans_dquot.c         | 169 +++++++-
25 files changed, 1645 insertions(+), 26 deletions(-)
create mode 100644 fs/xfs/scrub/quotacheck.c
create mode 100644 fs/xfs/scrub/quotacheck.h
create mode 100644 fs/xfs/scrub/quotacheck_repair.c

