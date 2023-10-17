Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E825CDB465
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 00:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjJQAhl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 20:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbjJQAhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 20:37:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA07DAB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 17:37:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD8AC433C7;
        Tue, 17 Oct 2023 00:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697503058;
        bh=mVH4iKxzqLK+Sdyd8foGLfi02uoNB0UYovG/VyfU+6U=;
        h=Date:From:To:Cc:Subject:From;
        b=VgnbbnN60+3lZ4S4DYcWzFwi0yCLF1KIulQFWME1bzWgAjBP6TH5GiTisklcqbkf1
         CJfyFLBh+o6dFZRbxheUOoPkArWFdmBKZPTh3OWwa0qwHooUWXAnLmQ4q6e71KG+Fi
         hxCuB6Up/Hz2Ht4TVPXDVpczOr5iiRtG7lkac+JjobCBNS8CY5zCE9t8St/PgqvG4G
         HaCfZxSS/6onVqxtFE2WOhjGK7ncHBn5bxLKuHGVU9pMeMj5PN8bxB8mAsxmiJDyUr
         N4irT6lG8EzHEWhKAzo/nK7PwmoquUCt1x49bc9IqotY9VCrTs8S0eVhU5R+rbrP4n
         H+FKmJSigrTKQ==
Date:   Mon, 16 Oct 2023 17:37:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        osandov@fb.com, osandov@osandov.com
Subject: [RFC] xfs-linux: realtime work branch rtalloc-speedups-6.7 updated
 to 8468dc886e05
Message-ID: <169750284502.2885534.2271041380117759971.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've created a work branch for all of our realtime cleanups and
optimizations in the rtalloc-speedups-6.7 branch of the xfs-linux
repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

I started by rebasing last week's rt cleanups patchsets against 6.6-rc6
TOT instead of djwong-dev, then I added Dave's xfs_rtalloc_args cleanup,
and then added Omar's rt allocator speedups.  This branch HAS NOT BEEN
TESTED YET, but it's a starting point.

The new head of the rtalloc-speedups-6.7 branch is commit:

8468dc886e05 xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

36 new commits:

Darrick J. Wong (28):
[6e271069a8e8] xfs: make xchk_iget safer in the presence of corrupt inode btrees
[a4f05ca8e957] xfs: bump max fsgeom struct version
[29c024027344] xfs: hoist freeing of rt data fork extent mappings
[13b454578ad3] xfs: prevent rt growfs when quota is enabled
[d37145ff1fc1] xfs: rt stubs should return negative errnos when rt disabled
[6f9b2269640b] xfs: fix units conversion error in xfs_bmap_del_extent_delay
[f50b658838a6] xfs: make sure maxlen is still congruent with prod when rounding down
[615077bc8c1d] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
[0c1cb7c1da51] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
[f3a29a7ef69c] xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
[fe06f373a0c0] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
[044f35063aae] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
[d77a09d2f1cd] xfs: convert rt extent numbers to xfs_rtxnum_t
[62403a6a8347] xfs: create a helper to convert rtextents to rtblocks
[cdcf7ec7066f] xfs: create a helper to compute leftovers of realtime extents
[7554cfeea00b] xfs: create a helper to convert extlen to rtextlen
[289f997d7525] xfs: create helpers to convert rt block numbers to rt extent numbers
[903b8250c1b2] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
[2bc367366fa4] xfs: create rt extent rounding helpers for realtime extent blocks
[f60b96941aa2] xfs: use shifting and masking when converting rt extents, if possible
[a024d18f3b34] xfs: convert the rtbitmap block and bit macros to static inline functions
[8808f43be672] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
[02c6a803ba9d] xfs: convert open-coded xfs_rtword_t pointer accesses to helper
[3f58eecd512d] xfs: convert rt summary macros to helpers
[38a9bd42e14a] xfs: create helpers for rtbitmap block/wordcount computations
[d498cbd3e248] xfs: use accessor functions for bitmap words
[bf1339d40051] xfs: create helpers for rtsummary block/wordcount computations
[73550154f276] xfs: use accessor functions for summary info words

Dave Chinner (1):
[eae4934139cc] xfs: consolidate realtime allocation arguments

Omar Sandoval (6):
[a0bdaa6acd56] xfs: cache last bitmap block in realtime allocator
[0e7cd2d75d12] xfs: invert the realtime summary cache
[1670d971eaa0] xfs: return maximum free size from xfs_rtany_summary()
[14c0296bc6a1] xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
[9a2f547ec4be] xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
[8468dc886e05] xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

Shiyang Ruan (1):
[ea9b00e231ae] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind

Code Diffstat:

drivers/dax/super.c            |   3 +-
fs/xfs/libxfs/xfs_bmap.c       |  45 +--
fs/xfs/libxfs/xfs_format.h     |  34 +-
fs/xfs/libxfs/xfs_rtbitmap.c   | 733 +++++++++++++++++++++++++----------------
fs/xfs/libxfs/xfs_rtbitmap.h   | 326 ++++++++++++++++++
fs/xfs/libxfs/xfs_sb.c         |   2 +
fs/xfs/libxfs/xfs_sb.h         |   2 +-
fs/xfs/libxfs/xfs_trans_resv.c |  10 +-
fs/xfs/libxfs/xfs_types.c      |   4 +-
fs/xfs/libxfs/xfs_types.h      |  10 +-
fs/xfs/scrub/bmap.c            |   2 +-
fs/xfs/scrub/common.c          |   6 +-
fs/xfs/scrub/common.h          |  19 ++
fs/xfs/scrub/fscounters.c      |   2 +-
fs/xfs/scrub/inode.c           |   7 +-
fs/xfs/scrub/rtbitmap.c        |  28 +-
fs/xfs/scrub/rtsummary.c       |  57 ++--
fs/xfs/scrub/trace.c           |   1 +
fs/xfs/scrub/trace.h           |   9 +-
fs/xfs/xfs_bmap_util.c         |  50 ++-
fs/xfs/xfs_fsmap.c             |  15 +-
fs/xfs/xfs_inode_item.c        |   3 +-
fs/xfs/xfs_ioctl.c             |   5 +-
fs/xfs/xfs_linux.h             |  12 +
fs/xfs/xfs_mount.h             |   8 +-
fs/xfs/xfs_notify_failure.c    | 108 +++++-
fs/xfs/xfs_ondisk.h            |   4 +
fs/xfs/xfs_rtalloc.c           | 602 +++++++++++++++++----------------
fs/xfs/xfs_rtalloc.h           |  94 +-----
fs/xfs/xfs_super.c             |   3 +-
fs/xfs/xfs_trans.c             |   7 +-
include/linux/mm.h             |   1 +
mm/memory-failure.c            |  21 +-
33 files changed, 1391 insertions(+), 842 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h
