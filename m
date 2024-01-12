Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC7110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUkkHg2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0AAC433F1;
	Fri, 12 Jan 2024 02:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025832;
	bh=PbAKLH014UZGiEnFyscLB8KQwLpxdxPjuMtN3rPh0xU=;
	h=Date:Subject:From:To:Cc:From;
	b=kUkkHg2oakYrnlHsW/ACps+okq5X1oSf6A2XJyphXPYJXZcEShaVNAEy9WOkQvjwG
	 mgtu0o7l3Tj0iK+dgAkwmN3Uoe9n3WsavPb3wiZ03NPSaqxieVRWO5PSJCSLNpmHpG
	 XL9l7Iygb/uQ2r5Sw0IhWHDms8joW9BoKcrtqFCx/4/55O7pnNYyQExhKbt3cHNIoT
	 9z/Gb7lY+9EZSjD2s+XzmlfCzYmmcqnSHrwDVXCa0Nhzt93gyC8wj7Rx67M0vq+NUj
	 g5OOIRR833JT2TllJZDe2a/Q780euaBwMkjx9CGkZz8htESwG1xqmXP/lfqWYuDedE
	 dbOw2AtQPg0Hw==
Date: Thu, 11 Jan 2024 18:17:12 -0800
Subject: [GIT PULL 4/6] xfs_scrub: fixes for systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, neal@gompa.dev
Message-ID: <170502573456.996574.9256149259911075241.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 96ac83c88e01ff7f59563ff76a96e555477c8637:

xfs_scrub: don't report media errors for space with unknowable owner (2024-01-11 18:08:46 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-service-fixes-6.6_2024-01-11

for you to fetch changes up to 3d37d8bf535fd6a8ab241a86433b449152746e6a:

xfs_scrub_all.cron: move to package data directory (2024-01-11 18:08:47 -0800)

----------------------------------------------------------------
xfs_scrub: fixes for systemd services [v28.3 4/6]

This series fixes deficiencies in the systemd services that were created
to manage background scans.  First, improve the debian packaging so that
services get installed at package install time.  Next, fix copyright and
spdx header omissions.

Finally, fix bugs in the mailer scripts so that scrub failures are
reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
restarts causing it to think that a scrub has finished before the
service actually finishes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
debian: install scrub services with dh_installsystemd
xfs_scrub_all: escape service names consistently
xfs_scrub: fix pathname escaping across all service definitions
xfs_scrub_fail: fix sendmail detection
xfs_scrub_fail: return the failure status of the mailer program
xfs_scrub_fail: add content type header to failure emails
xfs_scrub_fail: advise recipients not to reply
xfs_scrub_fail: move executable script to /usr/libexec
xfs_scrub_all.cron: move to package data directory

debian/rules                                |  1 +
include/builddefs.in                        |  2 +-
scrub/Makefile                              | 26 ++++++++++-----
scrub/xfs_scrub@.service.in                 |  6 ++--
scrub/xfs_scrub_all.in                      | 49 ++++++++++++-----------------
scrub/{xfs_scrub_fail => xfs_scrub_fail.in} | 12 +++++--
scrub/xfs_scrub_fail@.service.in            |  4 +--
7 files changed, 55 insertions(+), 45 deletions(-)
rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (63%)

