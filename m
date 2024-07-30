Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA30DF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307454; cv=none; b=g7MNWlFETDNYSbsI1b++/9RRCoYhMmIpIw5KYvIgH8NLZA/+F5/b3f2YHEUPDq7dKKYOJEPhwR4LP8aUJOr6jqZDp0qlwKrD7fRnZT0xEEcBeAkXhpyuhkms5BzS+w4yx97Fov7o5hzAuVaoumfpxNEj3QqG0iYHThl1UqZ/i+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307454; c=relaxed/simple;
	bh=UtY+4tHFYrcYM+IjSPyYTA8KbB85Z5iUdRv/yk2fQgU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=jYPX/je47WSPnn90UytK3Vdc1be+9QfnPIr1vI7MclPuvO/dT+ulUoUZbVhsFzn8GplLJiERBj0x5J7hdvpun6fdu82NAewNUaTGkotkU31Tk5DCocLb7+KuPSaf9aPBVLb1nn/ltz52UvAaiE1sKmjlj7D60xvsbBNUqIDizJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9skAh1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9skAh1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57050C32786;
	Tue, 30 Jul 2024 02:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307453;
	bh=UtY+4tHFYrcYM+IjSPyYTA8KbB85Z5iUdRv/yk2fQgU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N9skAh1d4+0S6SbBnLhkxyyLWkYhtTxxZm+WmQq2FmADg3Qf8RxbF8GJKwxyQOA5G
	 ocdEzJsSuPgSdPbUaddTziq85x9oeSdtd9Tpyocae0FVmMWmpbL2agq6Bt9E8fRQCq
	 3xZ7+HvnDKdVzg7oFZSnKOXoWjWPL1sTalQsd5dD4nU9QInfeYbFuTORxrBkNZfKAX
	 x4L7VN4Y73Sib3pPdYndlYJiWujpd6+q1yMbYA478engER1aiVugyXueVfXkiwPcNh
	 zNv+yaBGXErd9tuADP+5W8rYJQwGqkWh/ZEnmN0WLRQ+5x+uDq6+LecPGu5Vz16ACm
	 AFhOOnNvrlK6w==
Date: Mon, 29 Jul 2024 19:44:12 -0700
Subject: [GIT PULL 15/23] xfs_scrub_all: automatic media scan service
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459290.1455085.13159985441266119133.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 50411335572120153cc84d54213cd5ca9dd11b14:

xfs_scrub_all: tighten up the security on the background systemd service (2024-07-29 17:01:10 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-media-scan-service-6.10_2024-07-29

for you to fetch changes up to e040916f649f71fb6a695dfcc6f6c9f576c5c4db:

xfs_scrub_all: failure reporting for the xfs_scrub_all job (2024-07-29 17:01:10 -0700)

----------------------------------------------------------------
xfs_scrub_all: automatic media scan service [v30.9 15/28]

Now that we've completed the online fsck functionality, there are a few
things that could be improved in the automatic service.  Specifically,
we would like to perform a more intensive metadata + media scan once per
month, to give the user confidence that the filesystem isn't losing data
silently.  To accomplish this, enhance xfs_scrub_all to be able to
trigger media scans.  Next, add a duplicate set of system services that
start the media scans automatically.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs_scrub_all: only use the xfs_scrub@ systemd services in service mode
xfs_scrub_all: remove journalctl background process
xfs_scrub_all: support metadata+media scans of all filesystems
xfs_scrub_all: enable periodic file data scrubs automatically
xfs_scrub_all: trigger automatic media scans once per month
xfs_scrub_all: failure reporting for the xfs_scrub_all job

debian/rules                                     |   3 +-
include/builddefs.in                             |   3 +
man/man8/Makefile                                |   7 +-
man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} |  20 +++-
scrub/Makefile                                   |  21 +++-
scrub/xfs_scrub@.service.in                      |   2 +-
scrub/xfs_scrub_all.cron.in                      |   2 +-
scrub/xfs_scrub_all.in                           | 126 ++++++++++++++++++-----
scrub/xfs_scrub_all.service.in                   |   9 +-
scrub/xfs_scrub_all_fail.service.in              |  71 +++++++++++++
scrub/xfs_scrub_fail.in                          |  46 +++++++--
scrub/xfs_scrub_fail@.service.in                 |   2 +-
scrub/xfs_scrub_media@.service.in                | 100 ++++++++++++++++++
scrub/xfs_scrub_media_fail@.service.in           |  76 ++++++++++++++
14 files changed, 443 insertions(+), 45 deletions(-)
rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
create mode 100644 scrub/xfs_scrub_all_fail.service.in
create mode 100644 scrub/xfs_scrub_media@.service.in
create mode 100644 scrub/xfs_scrub_media_fail@.service.in

