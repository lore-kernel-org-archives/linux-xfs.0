Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E4F1A9F97
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781097; cv=none; b=s6DkT5l28AjB+ve+DCmIfG6TyXa5+YOkmARhCtCOM1A+K1NkPbiJ0OYuM9jH4S/mhDyH7LK4HfwkkFbKLm/l5UDOmt1AKVRjo2DeLQRVl8D9r+y5OJO3CZsKfmC9mvH7HWqZG56bUGAI+cTJFJAp5VhC+mBv9rAPBHISgNhpVqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781097; c=relaxed/simple;
	bh=gk9/azI708G+2iSmG/sX12H1v0pV2rb5JdAsj6imxdk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=dv999TdTMyctVRUVztNC4JWy44Htwk+TAS6zcKEtAbW3VE9cESKx3tSbitInOiOMOB9Gd42EB2m8Aft6pbgrL83daRpiviJ6wq3lz1r//9LsqhoBwsmp7pT9XUKV7nwXDxFz4i2T+gGX6PUvtLNlhex8cculH/jIUs/P3oW8LFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIZI3j35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIZI3j35"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 467A11F000E9;
	Tue, 30 Jun 2026 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781096;
	bh=Jj4njENxnejAfbQZK5wkTyYnd2ewMty1q8WNbca8ZDw=;
	h=Date:Subject:From:To:Cc;
	b=MIZI3j35+AiSRnD6+I5O9rqBiKPNhlV2RF9BzsgsYl4una5tcI7Gao9mZBuLLJ8+k
	 p6oMAlgJwo+XbdfBo05+jPbcP3eRGH0l01RmO8b6dwPAfrEnoOv9dArm1cpuxgkeHK
	 v7jmPRwOFvdkaw+5cnRpHF9H2iQtfmAp25HMi7pAvYYXgVJHcYPkwr9he42NZgzG7f
	 Uan+DpCHHthrYlDAb9syQsGjxP0pwkZ9EQOIVXFSU1W3tDfTKbrkdQDjQbA1HMWf/a
	 M3aXIHdFvKXkA1phhDAXxBWCpfMI3hoUhn0HZVGRis/8XU+KKeFHkov0j6nqfZsVsL
	 DSyyAhDlnZGCQ==
Date: Mon, 29 Jun 2026 17:58:15 -0700
Subject: [GIT PULL] xfs_scrub: codex-inspired bug fixes, part 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178278107232.851483.5695754796170186624.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 708b369bdf8f4f9b2824b9daa54a11df253b7b5b:

mkfs: remove duplicate include of convert.h (2026-06-26 11:54:22 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-codex-fixes3_2026-06-29

for you to fetch changes up to f75bb3f2d598b621c89da0894e5bd0a5e0d2c8f0:

xfs_scrub: always finish cleanup, even if reporting healthy state fails (2026-06-29 17:57:06 -0700)

----------------------------------------------------------------
xfs_scrub: codex-inspired bug fixes, part 3 [1/7]

Here's a third batch of xfs_scrub fixes resulting from Codex reviews.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_scrub: stop user file scan if caller already aborted
xfs_scrub: don't flatten error numbers in read_verify_schedule_now
xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
xfs_scrub: fix phase 8 debug reporting
xfs_scrub: always finish cleanup, even if reporting healthy state fails

scrub/repair.h      | 14 ++++++++++++++
scrub/inodes.c      |  6 ++++--
scrub/phase1.c      | 11 ++++++-----
scrub/phase5.c      |  8 ++++++--
scrub/phase8.c      |  5 ++---
scrub/read_verify.c |  2 +-
scrub/repair.c      | 16 +++++++++++-----
7 files changed, 44 insertions(+), 18 deletions(-)

