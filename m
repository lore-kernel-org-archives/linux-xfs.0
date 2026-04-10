Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0FE35B63E
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802202; cv=none; b=DRgdBp1gqhkt5Sm7bTpLuOy1cB5Pqq0LRuwkFVgEYrxo93NG4mR3vG0LzOrKrT9V/0ypI6ORl8Zt3oBldM2MSaaKkvZ/hgSaGVzB/pR4Nw4f6iKkrQMQ2FISl4gSVd6Y9hcGcfVEo/W4araPrnxCIuyNuf9F2FtLJS2LRiYQLgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802202; c=relaxed/simple;
	bh=Q5NW+2TatqW+glFsQw/MXLyQ2FJq0gD7Ok7fj73u3qY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=FlhpqqjLGdMqVQMZ4KAR9r7YnQ5DIZNM5vTYr5D3wWBTNjPvSihiWJpDaEoOnRJSOptMRUVPFE2Fenzcg2tBZPp+3Z6cEx36JteB4Q4GxK/Z05wpfsnXnLHvVZsxn7quFCN1UYI4eZRQyksb8+rY44QTs8oq4hZNI/P4esU7udY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxNEpeGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxNEpeGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEB2C19421;
	Fri, 10 Apr 2026 06:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802202;
	bh=Q5NW+2TatqW+glFsQw/MXLyQ2FJq0gD7Ok7fj73u3qY=;
	h=Date:Subject:From:To:Cc:From;
	b=DxNEpeGBQSjC4JQMsELu/NoGn0OmRpPBaJKeCnuoN2bfveclVA7w6/2biDjG8PbEH
	 9xez3n8913Vu3kJgxPJRmkONR5dmKz7xmduq3Zyj8YXLA1sdXVf34E4jbt4/XiyKst
	 KIraRzU6L7FFDewaeu0GO6IcnseH9Qvu5z7X6IfVJNLHj/eKwEVpsUIZanwvcRs87f
	 XNp/q6ERPw4ucJaIDyE6aFtRRHuIm4vbdVYZ56YqpLftP4MEXbjbE2TUfv3rGULtsj
	 hE8+iNm6rMhzHQ6CooKobXQiNwuitzdw6bQqz4bb2SgAyiQm87gRv2zDlFSZT8AHBL
	 wRAVujdHAyfgQ==
Date: Thu, 09 Apr 2026 23:23:22 -0700
Subject: [GIT PULL 2/2] xfs_scrub: refactor to XFS_IOC_VERIFY_MEDIA
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577387561.2091101.3654819947635620622.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit bd61d2b9c8527f1f7bf86df45280ab46592bea7d:

debian: enable xfs_healer on the root filesystem by default (2026-04-09 15:30:18 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-media-verify-ioctl_2026-04-09

for you to fetch changes up to 8ef7291a272e4e29e38dda90afec56a983776187:

xfs_scrub: raise media verification IO limits (2026-04-09 15:30:19 -0700)

----------------------------------------------------------------
xfs_scrub: refactor to XFS_IOC_VERIFY_MEDIA [v11 2/4]

Originally, this was a single patch inside the autonomous self healing
patchset.  However, various issues brought up during review of the v9
codebase made it obvious that more cleanups were necessary prior to
shifting xfs_scrub to use the new media verification ioctl.  Therefore,
the xfs_scrub changes have been broken out into a separate patchset to
contain the refactorings and new functionality.

v11: various minor bug fixes detected by static checkers
v10: decouple the spacemap iterator and the read-verify pool code,
simplify the read-verify apis, use a fixed limit of 8 verify IO
threads per device, improve the log media error reporting

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (6):
scrub: remove the unused io_disk field in struct read_verify
scrub: simplify the read_verify_pool_alloc interface
scrub: use enum xfs_device for read verification
scrub: simplify verifier threads calculation
xfs_scrub: move disk media verification error injection
scrub: don't allocate disk for ioctl-based media verify

Darrick J. Wong (15):
libfrog: allow bitmap_free to handle a null bitmap pointer
mkfs: rename byte unit conversion macros
libfrog: lift *BYTES helpers to convert.h
xfs_scrub: report truncated devices as media errors
xfs_scrub: fix i18n of the decode_special_owner return value
xfs_scrub: move read verification scheduling to phase6.c
xfs_scrub: don't pass the io_end_arg around everywhere
xfs_scrub: rename nr_io_threads
xfs_scrub: use the verify media ioctl during phase 6 if possible
xfs_scrub: perform media scanning of the log region
xfs_scrub: index read-verify pools by xfs_device ids
xfs_scrub: move failmap and other outputs into read_verify_pool
xfs_scrub: clean up device-related error messages
xfs_scrub: drop SCSI_VERIFY code from disk.
xfs_scrub: raise media verification IO limits

libfrog/convert.h         |   7 +
scrub/disk.h              |   2 -
scrub/fscounters.h        |   2 +-
scrub/read_verify.h       |  34 +++-
scrub/spacemap.h          |   5 +
scrub/xfs_scrub.h         |   9 +-
db/bmap_inflate.c         |   2 +-
doc/README-env-vars.txt   |   1 -
libfrog/bitmap.c          |   3 +
libfrog/convert.c         |   7 -
mdrestore/xfs_mdrestore.c |   5 +-
mkfs/xfs_mkfs.c           |  38 ++--
repair/agbtree.c          |   3 +-
repair/bmap_repair.c      |   3 +-
repair/rmap.c             |   3 +-
repair/xfs_repair.c       |   5 +-
scrub/common.c            |  19 +-
scrub/disk.c              | 204 ---------------------
scrub/fscounters.c        |   4 +-
scrub/phase1.c            |  91 +++++++---
scrub/phase5.c            |   6 +-
scrub/phase6.c            | 424 +++++++++++++++++++++----------------------
scrub/phase7.c            |   7 +-
scrub/phase8.c            |   3 +-
scrub/read_verify.c       | 451 +++++++++++++++++++++++++++++++++-------------
scrub/xfs_scrub.c         |   1 -
26 files changed, 701 insertions(+), 638 deletions(-)

