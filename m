Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87F638FB9
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752855156; cv=none; b=h7mJ6ONSzipO6dqr+pVRZl8HoYR5afNhtm8EHAWN+BvKxWwUgbthnxlP6c58YvEEc703OdwrvAK3/xBouQML14wgTcAMHJuZLovmXsZ4nj/+OoT6x48gkcGCtrf0Kjwj2wiWhrbUOy4IrmzX2IDnwbVBrc56aCOcrIO/7LXMp5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752855156; c=relaxed/simple;
	bh=gh6kLIobxw2tDR6DZthRLhcz3X3ZkpNlaaJvg+Z8JD0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nl9tYeq9+FXSFf9DNc/N+8ghek79pjNvEq/fntgBmNio/6d4cqxF7D5xk9PLBKmXpl4DoW/a2jgneB5SVca3Y2i4x6H+gmkc8Yc3I2XpT+xmCbvdYn1ZD4HFdm7w6YCTC61YDpNsRR0+hLTSfwya66yEOyEJB5rU18c/avSpz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzWc54Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzWc54Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ED8C4CEEB;
	Fri, 18 Jul 2025 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752855155;
	bh=gh6kLIobxw2tDR6DZthRLhcz3X3ZkpNlaaJvg+Z8JD0=;
	h=Date:From:To:Cc:Subject:From;
	b=QzWc54CoFmq3QuZaBjl56IqpCSZiFrNg//LiskO0XDdrS8OjzrFNeH7dZXVW7wLCC
	 0kHU0rBWYXoj6e5OTkvJHd2lCEmz9J011MnjH976pEZ/x3We52v8AU46Zy7Vip4kx6
	 kP/hicxqrSrX/x+HxAJ2XKIEBz+aDObJfkowCrR0rhrmCDphlursxxUicT5nLFMK1p
	 jHRYH/GZ6E5efOTHN4kCiAJtqSJbzpq5hooji5u5mBhmz3sbUhbhY+z+ZPpk5zuIFF
	 Ljx4NIavTKkHeKYwXieBNusdMEExIsLM2QQoiu1pGokr2gwvR6XXo2PqCeCtU65h/N
	 Sgj8D8mTqVa7Q==
Date: Fri, 18 Jul 2025 18:12:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.16-rc7
Message-ID: <lwjtudstcnsdwkum4szlk3k3lrqxykvijlsqbk3bznggpw7wok@2xxumekrogmy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

This pull-request contain mostly code clean up, refactoring and comments
modification. The most important patch in this series is the last one
that removes an unnecessary data structure allocation of xfs busy
extents which might lead to a memory leak on the zoned allocator code.

This last patch arrived late this week, so I didn't manage to get it
into linux-next yet. All the other patches are there for a while.

An attempt merge against your current TOT (6832a9317eee) has been
successful and the diffstat is included below.

Hopefully I didn't miss anything.

Thanks,
Carlos

The following changes since commit 9e9b46672b1daac814b384286c21fb8332a87392:

  xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask (2025-06-30 14:16:13 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc7

for you to fetch changes up to 5948705adbf1a7afcecfe9a13ff39221ef61e16b:

  xfs: don't allocate the xfs_extent_busy structure for zoned RTGs (2025-07-18 17:42:31 +0200)

----------------------------------------------------------------
xfs: fixes for 6.16-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (7):
      xfs: clean up the initial read logic in xfs_readsb
      xfs: remove the call to sync_blockdev in xfs_configure_buftarg
      xfs: add a xfs_group_type_buftarg helper
      xfs: refactor xfs_calc_atomic_write_unit_max
      xfs: rename the bt_bdev_* buftarg fields
      xfs: remove the bt_bdev_file buftarg field
      xfs: don't allocate the xfs_extent_busy structure for zoned RTGs

Pranav Tyagi (1):
      xfs: replace strncpy with memcpy in xattr listing

Merge made by the 'ort' strategy.
 fs/xfs/libxfs/xfs_group.c   | 14 +++++++-----
 fs/xfs/xfs_buf.c            | 15 +++++--------
 fs/xfs/xfs_buf.h            |  8 +++----
 fs/xfs/xfs_discard.c        | 29 ++++++------------------
 fs/xfs/xfs_extent_busy.h    |  8 +++++++
 fs/xfs/xfs_file.c           |  2 +-
 fs/xfs/xfs_inode.h          |  2 +-
 fs/xfs/xfs_iomap.c          |  2 +-
 fs/xfs/xfs_iops.c           |  2 +-
 fs/xfs/xfs_mount.c          | 97 ++++++++++++++++++++++++++++++++------------------------------------------------
 fs/xfs/xfs_mount.h          | 17 ++++++++++++++
 fs/xfs/xfs_notify_failure.c |  3 +--
 fs/xfs/xfs_trace.h          | 31 ++++++++++++--------------
 fs/xfs/xfs_xattr.c          |  2 +-
 14 files changed, 108 insertions(+), 124 deletions(-)

