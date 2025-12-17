Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45C3346A0E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 09:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765965073; cv=none; b=I+ZTXYZWwpNSI7oSDhYG73yngfFdVi1r8ccvc2ybrFmGhFUExeylvPleK9Vjqv7mNBgXKmn/SoxpcRzaPUPOOn3wJnM4CFMl+0ealaEqHRp45uHm+fBAlV7B0M6hpUj5j6SxCh93XNjWV2C2j4QHqvwvpH1+hzuNTHH0coBmRRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765965073; c=relaxed/simple;
	bh=KrFTDy9r0W6KxFMAeWGNaHfFbo9S4PqJ/K1n0gKJvBY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n9cSI1iaQ5t0RHKPejmkEv4Gcs8v1jvFKnu4T7XvyOcAEFLqAQALbPv5Qteb6quQ56n1tiaNMjeiqMrFTygY/qwPeUc5l90HUkJ6W4rcoQ9+Z0gm65nxrGdb2P2gH1zGw0MVADc2DpFA6/awP9/+nCqDShRJQr4bunl1vNXQzjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvYiUpkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvYiUpkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54D1C4CEF5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 09:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765965073;
	bh=KrFTDy9r0W6KxFMAeWGNaHfFbo9S4PqJ/K1n0gKJvBY=;
	h=Date:From:To:Subject:From;
	b=WvYiUpkrae0HUFgFkGOSRlFaTbOsSmDLfu2cE0kAaHpaPZwLdZyMmc5EdznayjfuS
	 /yBY8PcrrAo4eGLOWTX1UjRqVK7Dtz2Q65Oc1FGWFa/Uvttm0MrkBWsgkVRxzjQevr
	 5nQ9FJZhpuS/BKmiQj716lDuvR2m/1v6b4DxY10w2AS4zY7cMduzFC2ytfpPnMGfUE
	 /CgkrQUYUUh5/z99+fFztgV7sdBKjhMouI4q52/yEAvwq8pNMoC9JABbv2Esni7r8D
	 VqtW/z/SvoWGD0lu0W+Wa6Jk9307QOS7Cxz3T/bytE9FclGUoSyjvtMOhj1nqozmQU
	 q3XVSDTwJ6vFw==
Date: Wed, 17 Dec 2025 10:51:09 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f401306d72f2
Message-ID: <bn373xetzspynudrs7vxikq7fcrf5vljraazztkzrz7hgvhdbg@lragoe5jucwf>
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

f401306d72f2 xfs: factor out a xlog_write_space_advance helper

17 new commits:

Chaitanya Kulkarni (1):
      [2145f447b79a] xfs: ignore discard return value

Christoph Hellwig (13):
      [8dc15b7a6e59] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file system
      [982d2616a290] xfs: validate that zoned RT devices are zone aligned
      [dc68c0f60169] xfs: fix the zoned RT growfs check for zone alignment
      [4846ee1098ee] xfs: add a xlog_write_one_vec helper
      [3215ad1d5183] xfs: set lv_bytes in xlog_write_one_vec
      [36a032902569] xfs: improve the ->iop_format interface
      [0782c1c41deb] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [1a3a3b917d22] xfs: move struct xfs_log_vec to xfs_log_priv.h
      [72f573863f96] xfs: regularize iclog space accounting in xlog_write_partial
      [2d394d9a73c9] xfs: improve the calling convention for the xlog_write helpers
      [998d1ac52da7] xfs: add a xlog_write_space_left helper
      [f1e948b51c93] xfs: improve the iclog space assert in xlog_write_iovec
      [f401306d72f2] xfs: factor out a xlog_write_space_advance helper

Darrick J. Wong (2):
      [5990fd756943] xfs: fix a UAF problem in xattr repair
      [f06725052098] xfs: fix stupid compiler warning

Haoxiang Li (1):
      [fc40459de825] xfs: fix a memory leak in xfs_buf_item_init()

Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h |   7 -
 fs/xfs/libxfs/xfs_sb.c         |  15 +++
 fs/xfs/scrub/attr_repair.c     |   2 +-
 fs/xfs/xfs_attr_item.c         |  29 ++--
 fs/xfs/xfs_bmap_item.c         |  10 +-
 fs/xfs/xfs_buf_item.c          |  20 ++-
 fs/xfs/xfs_discard.c           |  27 +---
 fs/xfs/xfs_discard.h           |   2 +-
 fs/xfs/xfs_dquot_item.c        |   9 +-
 fs/xfs/xfs_exchmaps_item.c     |  11 +-
 fs/xfs/xfs_extfree_item.c      |  10 +-
 fs/xfs/xfs_file.c              |  58 ++++++--
 fs/xfs/xfs_icreate_item.c      |   6 +-
 fs/xfs/xfs_inode_item.c        |  49 ++++---
 fs/xfs/xfs_log.c               | 292 ++++++++++++++++-------------------------
 fs/xfs/xfs_log.h               |  65 ++-------
 fs/xfs/xfs_log_cil.c           | 111 ++++++++++++++--
 fs/xfs/xfs_log_priv.h          |  20 +++
 fs/xfs/xfs_refcount_item.c     |  10 +-
 fs/xfs/xfs_rmap_item.c         |  10 +-
 fs/xfs/xfs_rtalloc.c           |  14 +-
 fs/xfs/xfs_trans.h             |   4 +-
 22 files changed, 393 insertions(+), 388 deletions(-)
