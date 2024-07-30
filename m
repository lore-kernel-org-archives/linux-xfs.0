Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0133E8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307563; cv=none; b=Q562RXcFHHtKellWmnl4YTKICUq+Z+tB2VVMYIF7QJjZ9ghkuRf50bcn8UHRbPKcgHbgFZ5I6BxbTifXfvYO45cBGdOg9FvQ2200K0AwUlvg2gIZdATWPfBWQY1QARgjLFOb7mK55F/dl3TBmazzapALDQyz+hPLxwM6ciwjYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307563; c=relaxed/simple;
	bh=sD6dHW4VNzzjbc0PXf0owfd79RzlFIttm1TvVsikQtw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Zk0l7SbWqA0klh0kEU8vsUfb1LtRtJVBW7hWjNJ0zkyAuu4NWMoh6F8K3XfUJ1MQBB4QfT4WTIQ0wZyWRdAdu4QTVyRzQ1oZzBkx2H9Vf4Tp+afDbDRL3iYRWwr8AbOC0Qhxr2OdO8dKg4s8BSRRZ3+8yYENe8u0lUSd/X8NaV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3GCxLxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3GCxLxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE51C32786;
	Tue, 30 Jul 2024 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307562;
	bh=sD6dHW4VNzzjbc0PXf0owfd79RzlFIttm1TvVsikQtw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y3GCxLxZPtMKMC5lgg+lxvNwCa9OfuBRdnw70Y67gpzOrombudG08MU5iRzvRYTs9
	 clUvlBvSiCrQ0rMj7L6hfYmGAHjt8YCleK6UEKdx5BPz558ajQ5WIBOi9Xnb9liDdT
	 1OxTDwAf/IGeq7ZQHPpYPw3bmlAKzMeeRHM4vukjCiB2hHJnGyNR+53Naa9NBIsMqa
	 VTc5iC1U7Pl15speLebwaepdW+ljGQfy6v4VxaMRNh0jPOoCFvUVIFAS2IPjaE/1Xx
	 SQlIC9o+32OAq63Ta/7zmB9bN1iypAHLKSrApoQrC5LkiQji6hmcvEnZjTYSs2bMAu
	 9t1UgHXO+oDFA==
Date: Mon, 29 Jul 2024 19:46:02 -0700
Subject: [GIT PULL 22/23] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230460022.1455085.11627065701892282147.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 5a30504f0c60e10dc0cecd201c5afc18083fd0ac:

xfs_scrub: defer phase5 file scans if dirloop fails (2024-07-29 17:01:13 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/vectorized-scrub-6.10_2024-07-29

for you to fetch changes up to df914edeeb1e1919831192951d657cfc73b46418:

xfs_scrub: try spot repairs of metadata items to make scrub progress (2024-07-29 17:01:13 -0700)

----------------------------------------------------------------
xfs_scrub: vectorize kernel calls [v30.9 22/28]

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
man: document vectored scrub mode
libfrog: support vectored scrub
xfs_io: support vectored scrub
xfs_scrub: split the scrub epilogue code into a separate function
xfs_scrub: split the repair epilogue code into a separate function
xfs_scrub: convert scrub and repair epilogues to use xfs_scrub_vec
xfs_scrub: vectorize scrub calls
xfs_scrub: vectorize repair calls
xfs_scrub: use scrub barriers to reduce kernel calls
xfs_scrub: try spot repairs of metadata items to make scrub progress

io/scrub.c                           | 368 +++++++++++++++++++++++++++++++----
libfrog/fsgeom.h                     |   6 +
libfrog/scrub.c                      | 137 +++++++++++++
libfrog/scrub.h                      |  35 ++++
man/man2/ioctl_xfs_scrubv_metadata.2 | 171 ++++++++++++++++
man/man8/xfs_io.8                    |  51 +++++
scrub/phase1.c                       |   2 +
scrub/phase2.c                       |  93 +++++++--
scrub/phase3.c                       |  84 ++++++--
scrub/repair.c                       | 355 ++++++++++++++++++++-------------
scrub/scrub.c                        | 360 +++++++++++++++++++++++++---------
scrub/scrub.h                        |  19 ++
scrub/scrub_private.h                |  55 ++++--
scrub/xfs_scrub.c                    |   1 +
14 files changed, 1431 insertions(+), 306 deletions(-)
create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2

