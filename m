Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B463C49D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708357286; cv=none; b=rmqkMAwB3g81ZzcOPgcDZfGsMHxEZbOs+McMMFK2GhhHtAfwhjlnMAEdyJcyCWazZyqHA4hZTR9IzyfeRPMECUlJ+C+/+UQSJ3XaCHRSEVP4qj88EhOg2dA8sbU0bl8iXD8qBSQsqS6uO7rMTPxNEuz4XRmTrzYbZUW/N9H47l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708357286; c=relaxed/simple;
	bh=IrVgPLuVM03mB92IddQuJRmpO8mm9cmsqX1sFVRe4aA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aDpJRW+PLbBBjm48AkMHscF8c8J6DStn8Q9162mnhsHLqnuaL1TEQgKSnpM0AETKy99165s7roX7v3rR3eVdz3IWjLBz2nonWqp/mDbTCAeWkynhk9uqB2zuxmVWfOShxsz5opfXCmPiL9pyoLW7m5TRUFslBWKfuTRAsjqpij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ry/Ei1xe; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ry/Ei1xe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/xgkcVaenq62+J1K6jDpFE3QRH4NdTn5SNSLa722Jlw=; b=ry/Ei1xedI15u1d3gi4mArpS4D
	k2XR+nzXN9H57PAd0Og4zpb2DbuZyQ88mCz25ZdtctXsxG0kM+qPJ4jQZfpw4WYug9gGUuZSHR4Xt
	LJpu/8h0sdnrDkIHi1v2ybRvYGnncX/SW+qSeJQYwvyd3msZR9H8R+VhnoglIQ4gV6Zc7mdjVNMxd
	n8IW3JU2I3nbX2+NcyAZPpqlJEYkT4JGRc7YZ2irzerrRnfKjN+DGwUTSrZvSHGSxZXH6c8oiVVMk
	a60YSQunixAy7+I+EtJTIIcGlKxchUTLSQb9Fa9pB0JYSyzV09NkLM4P81QNgcJWNdT8SnKHzVJqP
	djeEhZ9A==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rc5lg-0000000DA3y-2Nfo;
	Mon, 19 Feb 2024 15:41:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH v6 0/3] Remove the XFS mrlock
Date: Mon, 19 Feb 2024 15:41:10 +0000
Message-ID: <20240219154115.3136901-1-willy@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS has an mrlock wrapper around the rwsem which adds only the
functionality of knowing whether the rwsem is currently held in read
or write mode.  Both regular rwsems and rt-rwsems know this, they just
don't expose it as an API.  By adding that, we can remove the XFS mrlock
as well as improving the debug assertions for the mmap_lock when lockdep
is disabled.

v6:
 - Pick up acks/review tags from Wayman, Darrick & Dave
 - Fix spacing around | (Darrick)
 - Rebase on 577acb1ef359 (current xfs for-next)
v5:
 - Rebase on 5bad490858c3 (current Linus head) to pick up XFS changes
v4:
 - Switch the BUG_ONs to WARN_ONs (Wayman, Peter)
v3:
 - Rename __rwsem_assert_held() and __rwsem_assert_held_write() to
   rwsem_assert_held*_nolockdep()
 - Use IS_ENABLED(CONFIG_LOCKDEP) to only dump the information once
 - Use ASSERT instead of BUG_ON in xfs
 - Fix typo in subject line of patch 4
 - Drop patch 5 (inode_assert_locked)
 - Rebase on top of xfs-6.7-merge-2 which had a merge conflict
v2: Add rwsem_assert_held() and rwsem_assert_held_write() instead of
augmenting the existing rwsem_is_locked() with rwsem_is_write_locked().
There's also an __rwsem_assert_held() and __rwsem_assert_held_write()
for the benefit of XFS when it's in a context where lockdep doesn't
know what's going on.  It's still an improvement, so I hope those who
are looking for perfection can accept a mere improvement.

Matthew Wilcox (Oracle) (3):
  locking: Add rwsem_assert_held() and rwsem_assert_held_write()
  xfs: Replace xfs_isilocked with xfs_assert_ilocked
  xfs: Remove mrlock wrapper

 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.c        | 21 ++++----
 fs/xfs/libxfs/xfs_defer.c       |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |  2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |  2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |  6 +--
 fs/xfs/mrlock.h                 | 78 ------------------------------
 fs/xfs/scrub/readdir.c          |  4 +-
 fs/xfs/xfs_attr_list.c          |  2 +-
 fs/xfs/xfs_bmap_util.c          | 10 ++--
 fs/xfs/xfs_dir2_readdir.c       |  2 +-
 fs/xfs/xfs_dquot.c              |  4 +-
 fs/xfs/xfs_file.c               |  4 +-
 fs/xfs/xfs_inode.c              | 86 ++++++++++++---------------------
 fs/xfs/xfs_inode.h              |  4 +-
 fs/xfs/xfs_inode_item.c         |  4 +-
 fs/xfs/xfs_iops.c               |  7 ++-
 fs/xfs/xfs_linux.h              |  2 +-
 fs/xfs/xfs_qm.c                 | 10 ++--
 fs/xfs/xfs_reflink.c            |  2 +-
 fs/xfs/xfs_rtalloc.c            |  2 +-
 fs/xfs/xfs_super.c              |  4 +-
 fs/xfs/xfs_symlink.c            |  2 +-
 fs/xfs/xfs_trans.c              |  2 +-
 fs/xfs/xfs_trans_dquot.c        |  2 +-
 include/linux/rwbase_rt.h       |  9 +++-
 include/linux/rwsem.h           | 46 ++++++++++++++++--
 28 files changed, 129 insertions(+), 194 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.43.0

