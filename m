Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBED199FC9
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504415; cv=none; b=ngg9PqPzERRVfvtNP9chYlR4VcYc+7m8qpc5D8eogbj7pnsHnQpzwI9/XdYwX11rfPBJoTZ0Hk+eMCImDbhp08TXEnYa2+/ltlDWWJRU4Hssb+D2E40RNtwISlwfyZlxiojQx3K2ouoJyVYZge/k4Iq1KWhYNp87tmBDlsEAWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504415; c=relaxed/simple;
	bh=alVlUbxVjRTJNbziMEKiysfIZ5ZIi+2Rv43gsPYGx28=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Qki+rUNKe3Oj0Q+55lnDGk5RlGZ3w3etv+b+GVdLpH3YjCU7t2gyCHLwmcD4mITASuvR+nkA+AdNOjqgj9d5LOHGB8sdvrAO7l1s2l4Tscb5Sx256Lx4h9DD5V4Rwl2DRwPorvD1asep5eA6Ib+epkVLwUmb4M/KfLQRY4GZfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBfW656d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBfW656d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A76C4CEDD;
	Tue, 25 Feb 2025 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504415;
	bh=alVlUbxVjRTJNbziMEKiysfIZ5ZIi+2Rv43gsPYGx28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QBfW656dl1j9QfGvFpog8YduC8Iuef88f50RWylpvxB1kavpyLwFMfEdoT7Q/HzA7
	 QGMMplYYBNBKaOR6iEdD/AyKgvYlovbdr2lTFUV0M19tP2kWCsMNKA9yrdsq9jI14m
	 RmOgQqvelqKWWH7Cm5328CiXGDQvN2W+geK6Izny7IUEO7JtiJtY/67PjI8llwvu6r
	 x7Troneldy3nYdnKzUjNyQXyMrq/myzNMuiS+ko53ZcsQJ8vERl9bzWSoRg07/IYmE
	 QCPR1tonzhLhuXDMOHqrYlwruaSI56rDhabQdIP3eYKpswCpA4//0zBcaEbTQyJn1t
	 de3F7KelpxlrQ==
Date: Tue, 25 Feb 2025 09:26:54 -0800
Subject: [GIT PULL 2/7] xfs_scrub: fixes and cleanups for inode iteration
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050432852.404908.16327229050941399572.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit c1963d498ad2612203d83fd7f2d1fb88a4a63eb2:

libxfs: mark xmbuf_{un,}map_page static (2025-02-25 09:15:56 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-inode-iteration-fixes-6.14_2025-02-25

for you to fetch changes up to 7ae92e1cb0aeeb333ac38393a5b3dbcda1ac769e:

xfs_scrub: try harder to fill the bulkstat array with bulkstat() (2025-02-25 09:15:57 -0800)

----------------------------------------------------------------
xfs_scrub: fixes and cleanups for inode iteration [2/7]

Christoph and I were investigating some performance problems in
xfs_scrub on filesystems that have a lot of rtgroups, and we noticed
several problems and inefficiencies in the existing inode iteration
code.

The first observation is that two of the three callers of
scrub_all_inodes (phases 5 and 6) just want to walk all the user files
in the filesystem.  They don't care about metadir directories, and they
don't care about matching inumbers data to bulkstat data for the purpose
of finding broken files.  The third caller (phase 3) does, so it makes
more sense to create a much simpler iterator for phase 5 and 6 that only
calls bulkstat.

But then I started noticing other problems in the phase 3 inode
iteration code -- if the per-inumbers bulkstat iterator races with other
threads that are creating or deleting files we can walk off the end of
the bulkstat array, we can miss newly allocated files, miss old
allocated inodes if there are newly allocated ones, pointlessly try to
scan deleted files, and redundantly scan files from another inobt
record.

These races rarely happen, but they all need fixing.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (15):
man: document new XFS_BULK_IREQ_METADIR flag to bulkstat
libfrog: wrap handle construction code
xfs_scrub: don't report data loss in unlinked inodes twice
xfs_scrub: call bulkstat directly if we're only scanning user files
xfs_scrub: remove flags argument from scrub_scan_all_inodes
xfs_scrub: selectively re-run bulkstat after re-running inumbers
xfs_scrub: actually iterate all the bulkstat records
xfs_scrub: don't double-scan inodes during phase 3
xfs_scrub: don't (re)set the bulkstat request icount incorrectly
xfs_scrub: don't complain if bulkstat fails
xfs_scrub: return early from bulkstat_for_inumbers if no bulkstat data
xfs_scrub: don't blow away new inodes in bulkstat_single_step
xfs_scrub: hoist the phase3 bulkstat single stepping code
xfs_scrub: ignore freed inodes when single-stepping during phase 3
xfs_scrub: try harder to fill the bulkstat array with bulkstat()

libfrog/bitmask.h             |   6 +
libfrog/handle_priv.h         |  55 +++++
scrub/inodes.h                |  12 +-
io/parent.c                   |   9 +-
libfrog/Makefile              |   1 +
man/man2/ioctl_xfs_bulkstat.2 |   8 +
scrub/common.c                |   9 +-
scrub/inodes.c                | 552 ++++++++++++++++++++++++++++++++++++------
scrub/phase3.c                |   7 +-
scrub/phase5.c                |  14 +-
scrub/phase6.c                |  18 +-
spaceman/health.c             |   9 +-
12 files changed, 585 insertions(+), 115 deletions(-)
create mode 100644 libfrog/handle_priv.h

