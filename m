Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56A333E8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307547; cv=none; b=KzJU2B9TOsprzerjbbOdmE++r7JHWQbbxXmoCJRVMK3XfHpfR7FNnn42Eq3hHXK5GnuhxZgQoVeM9itzKUswJTEO+ny4T0fuI9Nta0qyReuU4dvRw1XgU4KhpTQXLy+DbmWsdnEjpqdG5+8/M4qiWc/gunDCHxR7fae0A/6jJwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307547; c=relaxed/simple;
	bh=Nqtl6Yn3gwJ2cPB7TBXC/CB2b7tAzGgiuW+Bmm4vOsY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=tITqW2H/P6pfGe2AVBEG7FBkeCBliPTEHZaZBlVyJSmtG2D0OX+JUvYqQR5KoTYDMoghuN0dfSWih1OqFGahU6UWyTcCL+VWXdBtibjEXjBzZo1mbPzZt5T08DZU+aittaIGDLatSMi28BTNjMEukgwflvp11xBWvM4epWNbyxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFg0n/vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFg0n/vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE7C32786;
	Tue, 30 Jul 2024 02:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307547;
	bh=Nqtl6Yn3gwJ2cPB7TBXC/CB2b7tAzGgiuW+Bmm4vOsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iFg0n/viedbl8HO5vxoAiRXwjf4da26253N+CrOs4NpvBykjZ1/3OSowOnUuErBbP
	 KvCNWL7Bqu4Oczvcahh5URXopbQbLs8Jy7kkMYQfYzILwHBtxnKkPa+q9a3UmR60dp
	 NWy1muB2sE3X7MPOBHTmCJj2mliUVPKEe2QgLyD2GH3sthO6eP7+l4y5Vtn+wQCJG2
	 4AsxiUtuCiXgnmcsWcYvN/Ecv56W9egRRTZbBSLgv23OaRls5KxFAzqvIOoDGeuq2+
	 zuXWYPn/bSRglbPtYv9sSAtYmtNOnTLN2uwHnYDzlxJRKuWIjCs8gQ32sry+qTRKAv
	 KtchWxIJ3GgxQ==
Date: Mon, 29 Jul 2024 19:45:46 -0700
Subject: [GIT PULL 21/23] xfsprogs: detect and correct directory tree problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459923.1455085.16884260843364802823.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 7ea215189a3cac45cb9323439318fcc3410727d4:

xfs_repair: wipe ondisk parent pointers when there are none (2024-07-29 17:01:13 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-directory-tree-6.10_2024-07-29

for you to fetch changes up to 5a30504f0c60e10dc0cecd201c5afc18083fd0ac:

xfs_scrub: defer phase5 file scans if dirloop fails (2024-07-29 17:01:13 -0700)

----------------------------------------------------------------
xfsprogs: detect and correct directory tree problems [v13.8 21/28]

Historically, checking the tree-ness of the directory tree structure has
not been complete.  Cycles of subdirectories break the tree properties,
as do subdirectories with multiple parents.  It's easy enough for DFS to
detect problems as long as one of the participants is reachable from the
root, but this technique cannot find unconnected cycles.

Directory parent pointers change that, because we can discover all of
these problems from a simple walk from a subdirectory towards the root.
For each child we start with, if the walk terminates without reaching
the root, we know the path is disconnected and ought to be attached to
the lost and found.  If we find ourselves, we know this is a cycle and
can delete an incoming edge.  If we find multiple paths to the root, we
know to delete an incoming edge.

Even better, once we've finished walking paths, we've identified the
good ones and know which other path(s) to remove.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
libfrog: add directory tree structure scrubber to scrub library
xfs_spaceman: report directory tree corruption in the health information
xfs_scrub: fix erroring out of check_inode_names
xfs_scrub: detect and repair directory tree corruptions
xfs_scrub: defer phase5 file scans if dirloop fails

libfrog/scrub.c                     |   5 +
man/man2/ioctl_xfs_bulkstat.2       |   3 +
man/man2/ioctl_xfs_fsbulkstat.2     |   3 +
man/man2/ioctl_xfs_scrub_metadata.2 |  14 ++
scrub/phase5.c                      | 271 ++++++++++++++++++++++++++++++++++--
scrub/repair.c                      |  13 ++
scrub/repair.h                      |   2 +
spaceman/health.c                   |   4 +
8 files changed, 301 insertions(+), 14 deletions(-)

