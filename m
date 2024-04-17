Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A1922338
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391781; cv=none; b=Iq/fAicZjgwtrEcapQda98nFP0d2yK3E2Cs+7Y1rBPmrgCrsFVwoQz3Xm2q9JAhsmNwGx1vCmyA3eYVcHWkjuIjv6G9fqwE7QxsX2HbQ3R+K7l7ArE/BnwRowxE/ou5B/uNTM2H9AdXrRcJO2G992n+UXfg8pP+yhZtOcq20awU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391781; c=relaxed/simple;
	bh=TNmnxjwiUAhIf6cJ0CyoBTj7W0bZVxFd1qk2vgniOM8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=sXk6KUayTERuQw0lAn/TcFVdZm8onkbNZhx+9Ke5FIWZ7iXr/IqOguGbDdZBuhgtHoqtLK5gz7aZL39jQ0j5T8CqhYG9bRyOpKbOvNl84wlPEQ72bqi/imXIEdDRul9dWU4Wue+XFisD/aVUlNISSSE30LQ1zd/EG32xSjB7v1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmgoFxG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmgoFxG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B94AC116B1;
	Wed, 17 Apr 2024 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391781;
	bh=TNmnxjwiUAhIf6cJ0CyoBTj7W0bZVxFd1qk2vgniOM8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HmgoFxG/OCCbVN71YFNircsDFcaR63PNahhvurtIKb4AkKrcVtfWvN9IVK62FwXp7
	 n8EcnNwgLM4RUlEjsXzkW4qOSOCmYJUn2dOIgXMj/eXK9ZFuIoWcg5nXu0xpUWdOKs
	 0BK3VxXS0h0+bsMfqXkxjy9bYAkFL600o0KJlbIZAYggo74zbCsGQIeqWDHdEQQl/m
	 jCHuG/E2k3QgqFf7vmZteTPy4qWvaaRX2qLPI/jqXaUrSjso6fNYN+OTurP8cHa1vs
	 BYI2taOKuLmzjP4a2TWW6NRR/Kihe86ieemEoKgU2GNwEZdfGsYy0MAJ99TswYgB1f
	 2/5HIWJw2sDYg==
Date: Wed, 17 Apr 2024 15:09:40 -0700
Subject: [GIT PULL 09/11] xfs_scrub: scan metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339161485.1911630.11207269499180561787.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit c02a18733fc0a0e1b607f75e90962b3adc27c8fa:

mkfs: allow sizing internal logs for concurrency (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-metafile-parallel-6.8_2024-04-17

for you to fetch changes up to bd35f31ce91bcf5ed9370e94a4a5da89638f37f4:

xfs_scrub: scan whole-fs metadata files in parallel (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
xfs_scrub: scan metadata files in parallel [v30.3 09/20]

At this point, we need to clean up the libfrog and xfs_scrub code a
little bit.  First, correct some of the weird naming and organizing
choices I made in libfrog for scrub types and fs summary counter scans.
Second, break out metadata file scans as a separate group, and teach
xfs_scrub that it can ask the kernel to scan them in parallel.  On
filesystems with quota or realtime volumes, this can speed up that part
significantly.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub type
xfs_scrub: scan whole-fs metadata files in parallel

io/scrub.c      |  13 +++---
libfrog/scrub.c |  51 +++++++++++----------
libfrog/scrub.h |  24 ++++------
scrub/phase2.c  | 135 ++++++++++++++++++++++++++++++++++++++++++--------------
scrub/phase4.c  |   2 +-
scrub/phase7.c  |   4 +-
scrub/scrub.c   |  75 +++++++++++++++++--------------
scrub/scrub.h   |   6 ++-
8 files changed, 194 insertions(+), 116 deletions(-)

