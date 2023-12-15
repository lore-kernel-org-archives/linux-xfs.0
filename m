Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9F48CE6
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiCzeCiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A257C433C7;
	Fri, 15 Dec 2023 21:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677391;
	bh=PV/0qorKdvjhKxU7oF0yoVosQQkWt9ydTne6BEY1GmM=;
	h=Date:Subject:From:To:Cc:From;
	b=BiCzeCiLaQdXDfYJwDZvvFP9LBr6DNQsorhfqOLlKG/U9tmPoeBQbDLmmzMQUpgOy
	 A3/J9WgsGuO3+ASGtl5kUJahIcSW6jhIF7QxknIhVWN9gvrHXXx5z2DVDgitgu6q3q
	 Vkmr/9Qqwmbv51TKgDfQswINhGbRYattVSyoX8fdXzd6uMPXPfdR0vL6xwuZ8n4FD/
	 OFEE+j4YxZUo/STKZOFZ1NRL//R1NFt9B9m4QN2xMA9Vv+TFVfpNsZHiIYkFInksbh
	 n1I608SNKvRMJByl5bZbKtZlCIRJSN3huvSIxR9br9EHbA+tgVPn7l2iSH6NcqUfe+
	 MPOVTI4YKX/AA==
Date: Fri, 15 Dec 2023 13:56:30 -0800
Subject: [GIT PULL 6/6] xfs: online repair of quota and rt metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170267713764.2577253.13285937294329651179.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ffd37b22bd2b7cca7749c85a0a08268158903e55:

xfs: online repair of realtime bitmaps (2023-12-15 10:03:43 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-quota-6.8_2023-12-15

for you to fetch changes up to a5b91555403e3a09ae00bed85fc78b60801dda24:

xfs: repair quotas (2023-12-15 10:03:45 -0800)

----------------------------------------------------------------
xfs: online repair of quota and rt metadata files [v28.3]

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: check the ondisk space mapping behind a dquot
xfs: check dquot resource timers
xfs: improve dquot iteration for scrub
xfs: repair quotas

fs/xfs/Makefile             |   9 +-
fs/xfs/libxfs/xfs_format.h  |   3 +
fs/xfs/scrub/dqiterate.c    | 211 ++++++++++++++++
fs/xfs/scrub/quota.c        | 107 ++++++++-
fs/xfs/scrub/quota.h        |  36 +++
fs/xfs/scrub/quota_repair.c | 575 ++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/repair.h       |   7 +
fs/xfs/scrub/scrub.c        |   6 +-
fs/xfs/scrub/trace.c        |   3 +
fs/xfs/scrub/trace.h        |  78 ++++++
fs/xfs/xfs_dquot.c          |  37 +--
fs/xfs/xfs_dquot.h          |   8 +-
12 files changed, 1026 insertions(+), 54 deletions(-)
create mode 100644 fs/xfs/scrub/dqiterate.c
create mode 100644 fs/xfs/scrub/quota.h
create mode 100644 fs/xfs/scrub/quota_repair.c

