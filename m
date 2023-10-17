Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2DDCDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbjJQPnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQPnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:43:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EBF9E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:43:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5DFC433C8;
        Tue, 17 Oct 2023 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557386;
        bh=HxftiU5cbO6UN3DlW8rk1Dpb50Pzkse35i+k4itwiqY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=DMezv+UDuoDULUXe8Pkep0MUKaQ2lcRCHcl1s/2yIpmpqMu/GFRM/Knq0l7i+gWrr
         m2dK6plLa6X7GJJulOgA0HkVwqsoAucz/dmTOBe8jm/HC6u7ec56TgGI+CWTMxRVqI
         TiLVwVPe8iAQKFG+3/qrTx29GyApJdf/lzePoTkrA/3E994B76Keac3I89PtVgnh1G
         fDpFDQAJfZ/mKqI03ur+9x0wPMFDkLOIMrY7HvFiCrZ16bUTym4/2VG7BkE6mg1ySx
         2ERka60EGUDfE4IJ7k/wMw9osPPwlf35p59PE4Hn+iKCsvtAaBNf8zi5WroTE4PUxy
         +zrfiUaoodv/g==
Date:   Tue, 17 Oct 2023 08:43:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        osandov@fb.com, osandov@osandov.com
Subject: Re: [RFC v1.1] xfs-linux: rtalloc-speedups-6.7 updated to
 b67199695696
Message-ID: <20231017154305.GB3058383@frogsfrogsfrogs>
References: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:37:41AM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> It turns out that yesterday's branch broke bisection, so I've push -f'd
> a work branch for all of our realtime cleanups and optimizations in the
> rtalloc-speedups-6.7 branch of the xfs-linux repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> 
> I started by rebasing last week's rt cleanups patchsets against 6.6-rc6
> TOT instead of djwong-dev, then I added Dave's xfs_rtalloc_args cleanup,
> and then added Omar's rt allocator speedups.  This branch has now
> survived overnight testing.
> 
> The new head of the rtalloc-speedups-6.7 branch is commit:
> 
> b67199695696 xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

...and I've already had to push -f to include Christoph's RVBs on Omar's
series.  Make that:

160fc7cbdcf9 xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

--D

> 
> 36 new commits:
> 
> Darrick J. Wong (28):
> [6953ad8d0bae] xfs: make xchk_iget safer in the presence of corrupt inode btrees
> [1948e87e4723] xfs: bump max fsgeom struct version
> [c0f654f9e230] xfs: hoist freeing of rt data fork extent mappings
> [03cc2dc5552c] xfs: prevent rt growfs when quota is enabled
> [b9a1d7039b5b] xfs: rt stubs should return negative errnos when rt disabled
> [2f21b6b1abff] xfs: fix units conversion error in xfs_bmap_del_extent_delay
> [003e9f00c1bb] xfs: make sure maxlen is still congruent with prod when rounding down
> [869a7bb10764] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
> [6e8471604ee5] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
> [1e98fe26bd18] xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
> [fab6068dbd4c] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
> [b5b1ec2011f7] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
> [efafd16f2dcb] xfs: convert rt extent numbers to xfs_rtxnum_t
> [e902ec670453] xfs: create a helper to convert rtextents to rtblocks
> [d0069a4dc6bb] xfs: create a helper to compute leftovers of realtime extents
> [c317ec75fe0d] xfs: create a helper to convert extlen to rtextlen
> [316da55c7ecf] xfs: create helpers to convert rt block numbers to rt extent numbers
> [0e90edd13659] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
> [2d4cf0892cfe] xfs: create rt extent rounding helpers for realtime extent blocks
> [f538cf95a5b8] xfs: use shifting and masking when converting rt extents, if possible
> [e780da4b8067] xfs: convert the rtbitmap block and bit macros to static inline functions
> [710a06e09cfe] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
> [a705854970f8] xfs: convert open-coded xfs_rtword_t pointer accesses to helper
> [4cecf034d685] xfs: convert rt summary macros to helpers
> [4d9e06b25a33] xfs: create helpers for rtbitmap block/wordcount computations
> [625af2f8cf01] xfs: use accessor functions for bitmap words
> [c7078ff43a80] xfs: create helpers for rtsummary block/wordcount computations
> [ac9c57723b70] xfs: use accessor functions for summary info words
> 
> Dave Chinner (1):
> [98ab1a255b81] xfs: consolidate realtime allocation arguments
> 
> Omar Sandoval (6):
> [947d029f1677] xfs: cache last bitmap block in realtime allocator
> [36cb8887dc72] xfs: invert the realtime summary cache
> [c6bebaf43313] xfs: return maximum free size from xfs_rtany_summary()
> [ff31bbc39fb6] xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
> [90127b4188e3] xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
> [b67199695696] xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()
> 
> Shiyang Ruan (1):
> [1937b0813e81] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
> 
> Code Diffstat:
> 
> drivers/dax/super.c            |   3 +-
> fs/xfs/libxfs/xfs_bmap.c       |  45 +--
> fs/xfs/libxfs/xfs_format.h     |  34 +-
> fs/xfs/libxfs/xfs_rtbitmap.c   | 733 +++++++++++++++++++++++++----------------
> fs/xfs/libxfs/xfs_rtbitmap.h   | 326 ++++++++++++++++++
> fs/xfs/libxfs/xfs_sb.c         |   2 +
> fs/xfs/libxfs/xfs_sb.h         |   2 +-
> fs/xfs/libxfs/xfs_trans_resv.c |  10 +-
> fs/xfs/libxfs/xfs_types.c      |   4 +-
> fs/xfs/libxfs/xfs_types.h      |  10 +-
> fs/xfs/scrub/bmap.c            |   2 +-
> fs/xfs/scrub/common.c          |   6 +-
> fs/xfs/scrub/common.h          |  19 ++
> fs/xfs/scrub/fscounters.c      |   2 +-
> fs/xfs/scrub/inode.c           |   7 +-
> fs/xfs/scrub/rtbitmap.c        |  28 +-
> fs/xfs/scrub/rtsummary.c       |  57 ++--
> fs/xfs/scrub/trace.c           |   1 +
> fs/xfs/scrub/trace.h           |   9 +-
> fs/xfs/xfs_bmap_util.c         |  50 ++-
> fs/xfs/xfs_fsmap.c             |  15 +-
> fs/xfs/xfs_inode_item.c        |   3 +-
> fs/xfs/xfs_ioctl.c             |   5 +-
> fs/xfs/xfs_linux.h             |  12 +
> fs/xfs/xfs_mount.h             |   8 +-
> fs/xfs/xfs_notify_failure.c    | 108 +++++-
> fs/xfs/xfs_ondisk.h            |   4 +
> fs/xfs/xfs_rtalloc.c           | 602 +++++++++++++++++----------------
> fs/xfs/xfs_rtalloc.h           |  94 +-----
> fs/xfs/xfs_super.c             |   3 +-
> fs/xfs/xfs_trans.c             |   7 +-
> include/linux/mm.h             |   1 +
> mm/memory-failure.c            |  21 +-
> 33 files changed, 1391 insertions(+), 842 deletions(-)
> create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h
> 
