Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0C14F112
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 18:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755282527; cv=none; b=Lb7Ur4CsFmkWl6fz2eODPUIr4R9sVA6uR9csjJVo0OPFpXdW3Pujt+4vBE8nGKq9XHmazFrrjkGHYct/8DrUEncsaM0GuZOWdYyBAhNuZ5OHFXXsjMeJclzesr7GNJnmb5XhbfT96aUdSot6hKxdBmJc39OaKE+TGLKPgB/+f98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755282527; c=relaxed/simple;
	bh=e1daa4y7WepJ0mP8561GrJcGE+X/U1OmFAg28LWYfaM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ie+JfNEaZzx0yfAUelJBDVMV62qJBAW50e2Mw4qifrZPnemgHQCxx25va1VjG3ZXvfI/kvOMgQxwG/GK05VFVbn/b6ZsMyxsYFy6E1NDiq7v8MMRKKTNu9qLnH/1p1GYKv5bExIL/TVF0nfdHnPxhdhEFQuR0G1vd4K0tpzQbAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwecRgZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwecRgZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B38C4CEEB;
	Fri, 15 Aug 2025 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755282527;
	bh=e1daa4y7WepJ0mP8561GrJcGE+X/U1OmFAg28LWYfaM=;
	h=Date:From:To:Cc:Subject:From;
	b=OwecRgZeXnQOb8zTlAADtk7LDpQ7shUYsst1FMwQY3vICxWTogR/x1Kt4sgb6PNPe
	 bwEWmVT2p0KZB6hT/AjCxQUgRYCxCXvnGX7yEV5lBMgun6ecxiWRaxcMTOpCF1xfQ+
	 ql6LRm5SLqb7BXyJLkCrqQEz4FnuVQ7rjGBMFMyKtBRNq0ZCWrN3Ta5nl1Mg+GBee7
	 vBXEwguDf6IN98fOfA1iaQS9xhdA48NcNuNG+2TgOgqCSogZUwK23ebBE3Hp8gAU3n
	 pl7PW7e/PwMaYtC0EKiz8KQsXfng0J9E94pBfAqwK0rnT2tiX5S6uW4FEswX60wLY6
	 55IN51Sk2jI6Q==
Date: Fri, 15 Aug 2025 20:28:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.17-rc2
Message-ID: <4uzlmlwbgmv5e7u6ytcigddcqw65omiopv5thji3h4bbt65vrh@v2qu6rexmojc>
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

An attempt merge against your current TOT has been successful.

This includes some code refactoring and fixes. Highlights for this pull
request are:
	- Fix an assert trigger introduced during the merge window
	- Prevent atomic writes to be used with DAX
	- Prevent users to use max_atomic_write mount option without
	  reflink, as atomic writes > 1block are not supported without
	  reflink.
	- Fixes a null-pointer-deref in a tracepoint.

Thanks,
Carlos

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.17-rc2

for you to fetch changes up to f76823e3b284aae30797fded988a807eab2da246:

  xfs: split xfs_zone_record_blocks (2025-08-11 14:04:20 +0200)

----------------------------------------------------------------
xfs: Fixes for 6.17-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
      xfs: fix scrub trace with null pointer in quotacheck

Christoph Hellwig (4):
      xfs: fix frozen file system assert in xfs_trans_alloc
      xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags
      xfs: remove XFS_IBULK_SAME_AG
      xfs: split xfs_zone_record_blocks

John Garry (3):
      fs/dax: Reject IOCB_ATOMIC in dax_iomap_rw()
      xfs: disallow atomic writes on DAX
      xfs: reject max_atomic_write mount option for no reflink

 fs/dax.c                |  3 +++
 fs/xfs/scrub/trace.h    |  2 +-
 fs/xfs/xfs_file.c       |  6 +++---
 fs/xfs/xfs_inode.h      | 11 +++++++++++
 fs/xfs/xfs_ioctl.c      |  2 +-
 fs/xfs/xfs_iops.c       |  5 +++--
 fs/xfs/xfs_itable.c     |  8 ++------
 fs/xfs/xfs_itable.h     | 10 ++++------
 fs/xfs/xfs_mount.c      | 19 +++++++++++++++++++
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_trans.c      |  2 +-
 fs/xfs/xfs_zone_alloc.c | 42 +++++++++++++++++++++++++++++-------------
 12 files changed, 78 insertions(+), 33 deletions(-)

