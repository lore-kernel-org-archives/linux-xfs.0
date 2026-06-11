Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989921773D
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186816; cv=none; b=lnGrsnVjaN2uFphV+IUKNXNuf5vTC33xqUfl3AXs+ec+ubklN4oi3vToIYc5FmjgZvY9/lcmU7WNUKuXcmoXiIp0Ci23g0OCNlH0mwAmzV5RPLA71e0B9868wK9M9VjyQaAP+n3vEB1/YB6LfyT0AIMIhxVWDPZMWQAuTpJr8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186816; c=relaxed/simple;
	bh=FWjk9dMBoTol/A6cEvK8eAJOGu0MujjXpBL6sWG3kYs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZnqOPtWiPSiCTFTi08F0KY/PoY3f0jkB9MHQSkA0qU55+J6sgk/9GDRm7s/wdgzQnCaxc5SdT+mb70oQ8pFt/zvhA5VvAEY5goSd6GPmEfd7GaV/9N2R6+J6vuOsyQtjOB7UbhBzZpOyX+f4EB+2YlC0CbaGmZJRS8iwlpjA57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZx5XAiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZx5XAiV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4769F1F00893;
	Thu, 11 Jun 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186815;
	bh=Z6qQ3HkK94kELI33syCIPG/1yLa0FbEr7sQCRlFOxws=;
	h=Date:Subject:From:To:Cc;
	b=kZx5XAiVrD83rX5YVzft99mfaoJ27JTfumaOtWxFoEOY1g3iMBRlkoml1CfRwiEw7
	 KyQg/T/jAi76sOWfF/ER3BJ4Pyv8U2V/1DUFjVOxNNX6sEMzOKlEueO2B3aY+RMlmc
	 egJZl6lYPUwsfvlaRCp9nFtgHR+iQ7n9AW9WSLys3vx4rJh/HEw4iCCK3BhY70IXP+
	 gXFJmLBg5lz8hI7QLSZlqSsD77W2lA57rRdaWzMClCxSbJsDqFOEKaYqLsVeWaS7Nf
	 Ecn+/yn0Frfn3UffCdaVsiYi7UcwurqTvNWZPw+DG/py0rk4N+8FNHm9aHZ/aZMLYo
	 J8T23y3KCvGfg==
Date: Thu, 11 Jun 2026 07:06:55 -0700
Subject: [GIT PULL 2/2] xfs_scrub: codex-inspired bug fixes for 7.1
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118660875.726932.5792903598501308259.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.1-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit c8a61717cd2aa9b23ae826088d90f5517de8a368:

xfs_healer: coordinate access to weakhandle::mntpoint correctly (2026-06-11 07:02:53 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-codex-fixes_2026-06-11

for you to fetch changes up to 46eb78d0807912d97d7c730904117701a9f5c920:

xfs_scrub: read verification isn't ok if it hit runtime errors (2026-06-11 07:02:55 -0700)

----------------------------------------------------------------
xfs_scrub: codex-inspired bug fixes for 7.1 [2/8]

I then threw Codex at the entirety of the xfs_scrub codebase to see what
kinds of problems it would report.  I picked off the obviously
delusional complaints, and fixed the rest as well.  There are a lot of
fixes here, but most of them are for nitpicky details that C is terrible
at, footgun fixes, and missing corner case handling.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (21):
xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
xfs_scrub_all: fix broken command line string array construction
xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
xfs_scrub_fail: send content headers for xfs_scrub_all failures
xfs_scrub: fix uninitialized variable
xfs_scrub: fix integer overflows
xfs_scrub: don't count internal log space in the data device used count
xfs_scrub: widen scrub and repair dependency mask
xfs_scrub: fix work estimation for rtgroups filesystems
xfs_scrub: don't report media errors in specially-owned areas as file data
xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
xfs_scrub: fix nonsense advice after a scrub finds errors
xfs_scrub: don't allow NAN as fstrim percentage
xfs_scrub: reset bulkstat pointer on retry
xfs_scrub: don't return garbage value from bulkstat_the_rest
xfs_scrub: don't continue with phase1 if autofsck=none
xfs_scrub: don't crash trying to complain about clean health
xfs_scrub: fix inverted return value from ptvar_get
xfs_scrub: don't obscure repair failures in repair_list_schedule
xfs_scrub: bitmap iteration functions must retur
xfs_scrub: read verification isn't ok if it hit runtime errors

scrub/scrub_private.h                  |  2 +-
scrub/xfs_scrub.h                      |  2 +-
scrub/inodes.c                         | 17 +++++++---
scrub/phase1.c                         |  5 ++-
scrub/phase2.c                         |  2 +-
scrub/phase3.c                         |  4 +--
scrub/phase4.c                         | 11 ++++---
scrub/phase5.c                         |  4 +--
scrub/phase6.c                         |  4 +++
scrub/phase7.c                         |  4 ---
scrub/phase8.c                         |  2 +-
scrub/read_verify.c                    |  2 +-
scrub/repair.c                         | 10 +++---
scrub/scrub.c                          | 23 +++++++++----
scrub/xfs_scrub.c                      | 18 ++++++++---
scrub/xfs_scrub_all.py.in              |  2 +-
scrub/xfs_scrub_all_fail.service.in    | 59 ++++------------------------------
scrub/xfs_scrub_fail.in                |  2 ++
scrub/xfs_scrub_media_fail@.service.in | 58 ++-------------------------------
19 files changed, 84 insertions(+), 147 deletions(-)

