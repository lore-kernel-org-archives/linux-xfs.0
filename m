Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390B84D34
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307328; cv=none; b=tu8AEVJ6eQEzizGcJbW3Rrex55RHrFrDQum5lK3FowVkDff5O13JiT626FmQiE3bFnu55VLK16dV/7TCfKQYYZ4drze8OWCVmoPwH6SfbkFvddDbpl+dSzY2PLKvaExe4vmoklyATXelUExEXLdSI87oZE6YEjqYx1174P2V0hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307328; c=relaxed/simple;
	bh=0e35jiKGjujQhA3uP9q1N9FwK3Mb5YXH00SbkBvJlns=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=MQnrX78LVW25F0P+weztaMGfyrQJkclzvCx15BIRJnxxf9oJBnS7Q3/YrMRrbFuo8zUKDfoUifkfPzo6HAnu24MBbfHCie0aH4AtE6yk1un2ckFO7bX0aNtG0LWeke5jBqYTrdnLyGumLUvAF2j2ERNYvKKcLA3yddzb/tejm/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+L+780h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+L+780h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2817DC32786;
	Tue, 30 Jul 2024 02:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307328;
	bh=0e35jiKGjujQhA3uP9q1N9FwK3Mb5YXH00SbkBvJlns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C+L+780hAhtz4ezN74hHlRjF1zd4RwHCSXEOb+hQlusnj/E+w1pJmxL0E+r+Fq0EN
	 yvmYoKyFGD6CtVyfrLogCytBtEaI2xurxgrhqQQomaMcU+QYwF/6T4IldTP++47Nbm
	 uwSvnlTR6N1OsIFhHOn5HAVePsOpnQwR+EWtmTnt9VZUEmMFPmRjmnRMt8GOfzli4v
	 mJA5yxiKyzPV+VYvWqjUQZ1chozwrjBKjX2JhZnFweqaTr/9Xb805kzALsS1pwBTJD
	 8/KwDmyJTiylKlBf9ial2ijHAOCcWoGm+Gd6JUdjrCwWOXzTL5fEw0G/vCncUL8B0k
	 a2DuNbQfYZ4ow==
Date: Mon, 29 Jul 2024 19:42:07 -0700
Subject: [GIT PULL 07/23] xfs_scrub: improve warnings about difficult repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458454.1455085.8671992039573793867.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 4b959abc5f353123775973cd98c94d819cc9de79:

xfs_scrub: actually try to fix summary counters ahead of repairs (2024-07-29 17:01:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-better-repair-warnings-6.10_2024-07-29

for you to fetch changes up to bf15d7766e3dd63eda56f6b2f7976e529cd07575:

xfs_scrub: enable users to bump information messages to warnings (2024-07-29 17:01:07 -0700)

----------------------------------------------------------------
xfs_scrub: improve warnings about difficult repairs [v30.9 07/28]

While I was poking through the QA results for xfs_scrub, I noticed that
it doesn't warn the user when the primary and secondary realtime
metadata are so out of whack that the chances of a successful repair are
not so high.  I decided that it was worth refactoring the scrub code a
bit so that we could warn the user about these types of things, and
ended up refactoring unnecessary helpers out of existence and fixing
other reporting gaps.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs_scrub: fix missing scrub coverage for broken inodes
xfs_scrub: collapse trivial superblock scrub helpers
xfs_scrub: get rid of trivial fs metadata scanner helpers
xfs_scrub: split up the mustfix repairs and difficulty assessment functions
xfs_scrub: add missing repair types to the mustfix and difficulty assessment
xfs_scrub: any inconsistency in metadata should trigger difficulty warnings
xfs_scrub: warn about difficult repairs to rt and quota metadata
xfs_scrub: enable users to bump information messages to warnings

man/man8/xfs_scrub.8 | 19 +++++++++++++++++++
scrub/common.c       |  2 ++
scrub/phase1.c       |  2 +-
scrub/phase2.c       | 53 ++++++++++++++++++++++++++++++++--------------------
scrub/phase3.c       | 21 +++++++++++++++++----
scrub/phase4.c       |  9 +++++----
scrub/phase5.c       | 15 +++++++--------
scrub/repair.c       | 47 +++++++++++++++++++++++++++++++++++-----------
scrub/repair.h       | 10 +++++++---
scrub/scrub.c        | 52 +--------------------------------------------------
scrub/scrub.h        |  7 ++-----
scrub/xfs_scrub.c    | 45 +++++++++++++++++++++++++++++++++++++++++++-
scrub/xfs_scrub.h    |  1 +
13 files changed, 175 insertions(+), 108 deletions(-)

