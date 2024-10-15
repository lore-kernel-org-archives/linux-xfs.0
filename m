Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A888915C120
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990450; cv=none; b=FQLKlhO0ngM/qbMSWOrwgor6vhCBRZKUdJygzTz/5WAGQZlQVwIzNfFACDygELRJJg/V/pzVvr9TBymMTOKy/Kyq3lKCY3Tm9Eee90sDpPufHrzkc2rXF2dEGScS6tK0KgAjhA5rjQ+kPGq6DOl3YY7rMjSrnYXGKcOv1guwZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990450; c=relaxed/simple;
	bh=LZ92OCLROAYYhdrn8E3O8SGLVSlfZGPpG7BJkGbJjOM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u/Q9SfdhEPUs6tmD7MGTbb95JuNWinTXiFIyzkXZRBIXl6zRw5cmpVHYr2ndDC8IQdTwG7Qjz9Zy+ghHLZLp5URJx0RrgE46KEuRjGu+2rNvqXQBO5Homu19xROJ5hIO0o1MO8bScpT9gA8ZKl/p8tC5z3qb6NTf/PQAncBmAq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qepmm6kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qepmm6kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8952C4CEC6
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 11:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728990450;
	bh=LZ92OCLROAYYhdrn8E3O8SGLVSlfZGPpG7BJkGbJjOM=;
	h=Date:From:To:Subject:From;
	b=Qepmm6kxdP3/wWeQ7bKZu+VDuhzNq5nGEV940+723H125CEo8lmvvT5bUjztixPNi
	 JESm3+41vHoa5gUe3xHaE/3QEeOnVqbneni2rS1h6iso0yAENg+58sctVgXmdtS2Jp
	 Mbyhh3wmnNblmBeXB8vaJAF2LQ950f2ZBQlvIX9Vf0i4cpXHTNhUnuT5MrRRN7pBby
	 vOBtj0UqQwIyMgLPFSJXEghpG1RcmR7Qpehim+xUuyq6/FocXO6ZKRz3fGSEeRfT5u
	 WmZBiJEzE+8nc62vHEi6LESDWoSFMaUUqstTpbsZX4lsvisXjmAXAYvIMotvtONNyP
	 lghctF1QMvRcw==
Date: Tue, 15 Oct 2024 13:07:26 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f6f91d290c8b
Message-ID: <j3wsebdnxdcyre2lug4gi5c67cdd45ak52ijgbqdopk33gcf7p@izluo6qwo2hu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The for-next branch of the xfs-linux repository at:

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f6f91d290c8b xfs: punch delalloc extents from the COW fork for COW writes

11 new commits:

Christoph Hellwig (10):
      [c0adf8c3a9bf] iomap: factor out a iomap_last_written_block helper
      [caf0ea451d97] iomap: remove iomap_file_buffered_write_punch_delalloc
      [b78495166264] iomap: move locking out of iomap_write_delalloc_release
      [3c399374af28] xfs: factor out a xfs_file_write_zero_eof helper
      [acfbac776496] xfs: take XFS_MMAPLOCK_EXCL xfs_file_write_zero_eof
      [abd7d651ad2c] xfs: IOMAP_ZERO and IOMAP_UNSHARE already hold invalidate_lock
      [8fe3b21efa07] xfs: support the COW fork in xfs_bmap_punch_delalloc_range
      [c29440ff66d6] xfs: share more code in xfs_buffered_write_iomap_begin
      [7d6fe5c586e6] xfs: set IOMAP_F_SHARED for all COW fork allocations
      [f6f91d290c8b] xfs: punch delalloc extents from the COW fork for COW writes

Darrick J. Wong (1):
      [0fb823f1cf34] xfs: fix integer overflow in xrep_bmap

Code Diffstat:

 Documentation/filesystems/iomap/operations.rst |   2 +-
 fs/iomap/buffered-io.c                         | 111 ++++++-------------
 fs/xfs/scrub/bmap_repair.c                     |   2 +-
 fs/xfs/xfs_aops.c                              |   4 +-
 fs/xfs/xfs_bmap_util.c                         |  10 +-
 fs/xfs/xfs_bmap_util.h                         |   2 +-
 fs/xfs/xfs_file.c                              | 146 +++++++++++++++----------
 fs/xfs/xfs_iomap.c                             |  67 ++++++++----
 include/linux/iomap.h                          |  20 +++-
 9 files changed, 199 insertions(+), 165 deletions(-)
