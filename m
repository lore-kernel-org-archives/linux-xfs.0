Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700F31DC994
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984000; cv=none; b=L+04WRCyFo5T2F7IofF/AHw4Tfmx6gnfUEgcZBz1JhjgBX80FWrY4mI0NBaPB0Khn2F7KGbKHA4veMLGJXN4PGR2DGaZqRGwoQSwRdjligEZd7q6E3dDds0efjgkUvyqc0BYRHVDDjCvoyevjBTvFyNJFsFP0Dir0pBB+ePShQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984000; c=relaxed/simple;
	bh=yNxeHBnwISp7e/pI7dZfPkDIsAoHjmA2TfH/VnY7Syg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YiiDQSRU+0CJHPgB2NXP6dpl18N1wDDLEFmvIf05IB+yhZVekd1FnDGKG5fJgEaublB/FsgtOwYR/MCWCW7Igv3PLXgqYy1XrV8Tz3oTEIvOm+uPNJg7Kshbev2Ar3kvw73icez+O19OYezlnlbJkL8INDWA8bkvKAyOwxfnllU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBYPJwzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBYPJwzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D11AC4CEF0
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754983997;
	bh=yNxeHBnwISp7e/pI7dZfPkDIsAoHjmA2TfH/VnY7Syg=;
	h=Date:From:To:Subject:From;
	b=IBYPJwzpX9bEs4Ed0WW9ORM8IzcYWQD9+qg1stFbkROMkfixBhVkJZrE2VI+coY0n
	 PsTtMgWlt7TmKqRH7r+vGgWsKqi9K2K2oF1Nnz5KZBMcrzhOK26Cir/aS32DTzrD7d
	 AmrNwx+ZYuqAHBYAbyvRIUM5B2LCf/3MTDje6xSz/aaAXBrAkRGSBV98nOqGEGzLGM
	 TTgGVH8EMCeQ97aRqdQr8iNxanqlsPhRO94i6xYmnH6NhgeVieFpG8Nhep1g7viyW1
	 WmBfN4qJle94y6fBfsf03MBPDlz8f5Ndrk/w1eE78LPhhqi3TrHe62lwQBuLeSPJJJ
	 in++sOv3NcoMw==
Date: Tue, 12 Aug 2025 09:33:13 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f76823e3b284
Message-ID: <nsgsn5yrkfushdddgwnkl4v4ymwzon7tk2ngkatxysfsbpbpn7@r43ytlvgybfd>
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

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f76823e3b284 xfs: split xfs_zone_record_blocks

8 new commits:

Andrey Albershteyn (1):
      [5d94b19f0664] xfs: fix scrub trace with null pointer in quotacheck

Christoph Hellwig (4):
      [647b3d59c768] xfs: fix frozen file system assert in xfs_trans_alloc
      [d2845519b072] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags
      [82efde9cf2e4] xfs: remove XFS_IBULK_SAME_AG
      [f76823e3b284] xfs: split xfs_zone_record_blocks

John Garry (2):
      [68456d05eb57] xfs: disallow atomic writes on DAX
      [8dc5e9b03713] xfs: reject max_atomic_write mount option for no reflink

Code Diffstat:

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
 11 files changed, 75 insertions(+), 33 deletions(-)
