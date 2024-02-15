Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBED57872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998955; cv=none; b=FEWdGfrEXBRBToH5p+9KXFznCGgcbzwyhf1dTyFmgqU9+bMy3SsN/gfGrDWAaMD6sCmbX33VwOsweUs3+rWLkUk0reBez6DNT18/tDSHsq58hLuhHRzVnmLZTz1Ewph1BEg55S0oMkI26sST0nm+xeHaF6N7TKA6p93qDRd/hP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998955; c=relaxed/simple;
	bh=kfyvuik/LU4QB6n6HGh7GX265bbOY4tyR+IM22hCm0U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kB+xiXf70N5WUJ1v7G5sGYl8y/VmYdK0+ft1vJrLoMcTHG32ARHgpRypcZBIsQhPzcG26mAeejA2+wlUz70NL6wBoDI7Sc/OSmt1M3rTamzNlUMg32/Dxj534ZEZsOPDOqjenYaWdI//XR4K5d8rIjG5Ze1xv9iSYXpj8MPH5MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJXn698k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJXn698k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B3C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998954;
	bh=kfyvuik/LU4QB6n6HGh7GX265bbOY4tyR+IM22hCm0U=;
	h=From:To:Subject:Date:From;
	b=DJXn698kFUb0dkBPsC0N7ychqvxp1scziBPCzJcvKEctGcHoHWNn7THfCDDUTSl4Y
	 +FiYPYktEn8Xx1DVftDHDH4tud7fVyUU1sEDePT1shHBK9Pv+Ycrsn+jwfr+aj/AAW
	 UmXfYF5fk2y6BlwiXBpnJIAiGxA0obCixJl59kJWdRs0MvOqimPowcLRx1+p34wd//
	 Xo77QCg0E184jFyi2VAi8nmjMYg+PTP5C5ABkm8S5/lzUMPOeUTuTRCJmgjkrMcNXY
	 kQUMXwHYOwi/nSdjCcG8pBH1GRrB0/L2LBGZrDeIk8BA1UZygmjhSyTphDcudeHctC
	 2LhSe0NEY1/TQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 00/35] xfsprogs: libxfs-sync for 6.7 
Date: Thu, 15 Feb 2024 13:08:12 +0100
Message-ID: <20240215120907.1542854-1-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hello folks,

this is the libxfs-sync for 6.7. I know we don't use to publish the results on
the list, but this release's sync was a bit more complicated, so, if you can
spare a few minutes, I'd appreciate an extra pair of eyes on top of it.
Also I thinkg it's a good idea to publish the patches here before pushing them
to for-next.

You can also pull the patches directly from my repository:

git@gitolite.kernel.org:pub/scm/linux/kernel/git/cem/xfsprogs-dev.git libxfs-sync-6.7

The sync is under testing now, so far nothing has been found, but it's still
going.


Darrick J. Wong (27):
  xfs: bump max fsgeom struct version
  xfs: hoist freeing of rt data fork extent mappings
  xfs: fix units conversion error in xfs_bmap_del_extent_delay
  xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
  xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
  xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
  xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
  xfs: rename xfs_verify_rtext to xfs_verify_rtbext
  xfs: convert rt extent numbers to xfs_rtxnum_t
  xfs: create a helper to convert rtextents to rtblocks
  xfs: create a helper to compute leftovers of realtime extents
  xfs: create a helper to convert extlen to rtextlen
  xfs: create helpers to convert rt block numbers to rt extent numbers
  xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
  xfs: create rt extent rounding helpers for realtime extent blocks
  xfs: use shifting and masking when converting rt extents, if possible
  xfs: convert the rtbitmap block and bit macros to static inline
    functions
  xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
  xfs: convert open-coded xfs_rtword_t pointer accesses to helper
  xfs: convert rt summary macros to helpers
  xfs: create helpers for rtbitmap block/wordcount computations
  xfs: create a helper to handle logging parts of rt bitmap/summary
    blocks
  xfs: use accessor functions for bitmap words
  xfs: create helpers for rtsummary block/wordcount computations
  xfs: use accessor functions for summary info words
  xfs: simplify xfs_rtbuf_get calling conventions
  xfs: simplify rt bitmap/summary block accessor functions

Dave Chinner (2):
  xfs: consolidate realtime allocation arguments
  xfs: inode recovery does not validate the recovered inode

Jeff Layton (1):
  xfs: convert to new timestamp accessors

Long Li (2):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail

Omar Sandoval (3):
  xfs: cache last bitmap block in realtime allocator
  xfs: invert the realtime summary cache
  xfs: fix internal error from AGFL exhaustion

 db/check.c               |   5 +-
 include/libxfs.h         |   1 +
 include/xfs_inode.h      |  74 +++-
 include/xfs_mount.h      |   2 +
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/libxfs_priv.h     |  79 ++--
 libxfs/util.c            |   2 +-
 libxfs/xfs_alloc.c       |  27 +-
 libxfs/xfs_bmap.c        |  44 +--
 libxfs/xfs_defer.c       |  28 +-
 libxfs/xfs_defer.h       |   2 +-
 libxfs/xfs_format.h      |  34 +-
 libxfs/xfs_inode_buf.c   |  13 +-
 libxfs/xfs_rtbitmap.c    | 809 +++++++++++++++++++++------------------
 libxfs/xfs_rtbitmap.h    | 386 +++++++++++++++++++
 libxfs/xfs_sb.c          |   2 +
 libxfs/xfs_sb.h          |   2 +-
 libxfs/xfs_trans_inode.c |   2 +-
 libxfs/xfs_trans_resv.c  |  10 +-
 libxfs/xfs_types.c       |   4 +-
 libxfs/xfs_types.h       |  10 +-
 mkfs/proto.c             |   2 +-
 repair/rt.c              |   5 +-
 23 files changed, 1043 insertions(+), 501 deletions(-)
 create mode 100644 libxfs/xfs_rtbitmap.h

Carlos
-- 
2.43.0

