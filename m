Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F42206AA
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753296314; cv=none; b=cdfCtXiX1aPJilA0LHqkXrTJqzrR+Ac8ITo7vlqGV8zdwjOwTeYlHuhwBLnmOIK33ckzXsNEx5WirPRaqwdqgitjBLPP+Kdf6HHs+Y1b0muHIwQC/eyNL1+5HLJ7Zg2Yu4gPOLPZX4c/Rco6xGNiX/HBMFU7ITzE5WvHYWSyUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753296314; c=relaxed/simple;
	bh=F0ELj4rkfci7xBufup0Gz7x0dlU8bdjvlt5OVcusnjM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZSMZwCeWWEAJ9ba2H2JvT7E5voC7ix/uUcDNWR4AR1o8lp/+BPQG+WhTkCphwMcMKq2sHAYUwsUpQlCfKh4cHUQpdspdxl3kEgvZtnzuMjmoa6jaDKtvG6m9eLnKpOfJDDpKIG1Ax9r41LVNlylfO9ggyFAfjrFrCiZ8N0DuxkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVhsLoXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVhsLoXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1FDC4CEE7
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753296313;
	bh=F0ELj4rkfci7xBufup0Gz7x0dlU8bdjvlt5OVcusnjM=;
	h=Date:From:To:Subject:From;
	b=DVhsLoXr8EJEzATFXXo6HU4Rp4VGRDUnKFmixBRm2LMx05Cd5nWk93UjIJjAW1kF3
	 pxdZ8bQynbmxV2DhU7yLbI9bagmKyiUx3ki6IjRanGhvGar2Lv4zXLE4wMm1v3MNwx
	 Cof50IHdxILKpkZBMUD6WCmyms3cVLt8+BU8x65V4vi4/ZCoWxzjtk49RoVdSRUIWj
	 aZTG2TwFyYX2b8TuZyGf+WsefoE1CsrrZKbLOFFD//0K5nTlmVqrxJ0IwD5+KAP6Xv
	 al5JOLu8AF1ELHoG43S15Quc2CdIaMpCwccLYT/y8W0B/vPNJiy+d67GTmtmtSKt9c
	 7K2sT3fPeAbVQ==
Date: Wed, 23 Jul 2025 20:45:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to b0494366bd5b
Message-ID: <sgj4qlobnwfgwpekusjfsbot4qeir7cm7qhy7phbshq55naknj@f42gwvwy2njt>
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

b0494366bd5b Merge branch 'xfs-6.17-merge' into for-next

6 new commits:

Carlos Maiolino (1):
      [b0494366bd5b] Merge branch 'xfs-6.17-merge' into for-next

Christoph Hellwig (5):
      [e1de38f55c54] xfs: don't pass the old lv to xfs_cil_prepare_item
      [7b1e478faffc] xfs: cleanup the ordered item logic in xlog_cil_insert_format_items
      [99a59aa44d8f] xfs: use better names for size members in xfs_log_vec
      [48aee97aed87] xfs: don't use a xfs_log_iovec for attr_item names and values
      [9d3b538b1c31] xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Code Diffstat:

 fs/xfs/libxfs/xfs_log_recover.h |   4 +-
 fs/xfs/xfs_attr_item.c          | 143 ++++++++++++++++++++--------------------
 fs/xfs/xfs_attr_item.h          |   8 +--
 fs/xfs/xfs_bmap_item.c          |  18 ++---
 fs/xfs/xfs_buf_item.c           |   8 +--
 fs/xfs/xfs_buf_item.h           |   2 +-
 fs/xfs/xfs_buf_item_recover.c   |  38 +++++------
 fs/xfs/xfs_dquot_item_recover.c |  20 +++---
 fs/xfs/xfs_exchmaps_item.c      |   8 +--
 fs/xfs/xfs_extfree_item.c       |  59 +++++++++--------
 fs/xfs/xfs_icreate_item.c       |   2 +-
 fs/xfs/xfs_inode_item.c         |   6 +-
 fs/xfs/xfs_inode_item.h         |   4 +-
 fs/xfs/xfs_inode_item_recover.c |  26 ++++----
 fs/xfs/xfs_log.c                |  10 +--
 fs/xfs/xfs_log.h                |  16 ++---
 fs/xfs/xfs_log_cil.c            |  71 +++++++++-----------
 fs/xfs/xfs_log_recover.c        |  16 ++---
 fs/xfs/xfs_refcount_item.c      |  34 +++++-----
 fs/xfs/xfs_rmap_item.c          |  34 +++++-----
 fs/xfs/xfs_trans.h              |   1 -
 21 files changed, 259 insertions(+), 269 deletions(-)
