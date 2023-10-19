Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7864BCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJSQIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbjJSQH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:07:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD395130
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:07:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F74C433C8;
        Thu, 19 Oct 2023 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697731677;
        bh=zBGnizDn9DmF73v/zymy/5jPysOLafkOUnw2R3HoWUg=;
        h=Date:From:To:Cc:Subject:From;
        b=PrPBHDD4y7xsY6Pp4hrA0gar/HIjkQ3I6S04mKLBqBsbHw8nYE/SYn/8ZiAIY0e7C
         yJLaRLpXqsYmkW4L51myL6ZdCGSIEOKGDiVh6xYwA3ZJejzlur8vv2Oqm5ClY8M5QI
         hpupB7CPx3yed6CukItJ9h6J459LX8qva9E7GMNIJldf8DmcvIeRXq60BQKnPFggg9
         dX5Z9rA+EwRCagM6ZErpFO7Z0bwaUhGgA09/WuTtBJ2j5rtwGmW9PS8jPbAfuiQQ4l
         JlTOva39L7QY4At+Jm30cyzPjkgIj8Ml63Tw7svtzrpwMKOTyajJ24NliHtJECkCke
         Jerfx4B8te9lQ==
Date:   Thu, 19 Oct 2023 09:07:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        osandov@fb.com, osandov@osandov.com,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: [ANNOUNCE] xfs-linux: realtime work branch rtalloc-speedups-6.7
 updated to e0f7422f54b0
Message-ID: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The rtalloc-speedups-6.7 branch of the xfs-linux repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated.  Now that the entire series of cleanups have
passed review, I'm resending the entire patchbomb one last time.  If I
don't hear any objections in the next day or so, I'll ask Chandan to
pull them for the 6.7 merge.

The new head of the rtalloc-speedups-6.7 branch is commit:

e0f7422f54b0 xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

37 new commits:

Darrick J. Wong (30):
[948806280594] xfs: bump max fsgeom struct version
[6c664484337b] xfs: hoist freeing of rt data fork extent mappings
[b73494fa9a30] xfs: prevent rt growfs when quota is enabled
[c2988eb5cff7] xfs: rt stubs should return negative errnos when rt disabled
[ddd98076d5c0] xfs: fix units conversion error in xfs_bmap_del_extent_delay
[f6a2dae2a1f5] xfs: make sure maxlen is still congruent with prod when rounding down
[13928113fc5b] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
[a684c538bc14] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
[03f4de332e2e] xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
[f29c3e745dc2] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
[3d2b6d034f0f] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
[2d5f216b77e3] xfs: convert rt extent numbers to xfs_rtxnum_t
[fa5a38723086] xfs: create a helper to convert rtextents to rtblocks
[68db60bf01c1] xfs: create a helper to compute leftovers of realtime extents
[2c2b981b737a] xfs: create a helper to convert extlen to rtextlen
[5dc3a80d46a4] xfs: create helpers to convert rt block numbers to rt extent numbers
[055641248f64] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
[5f57f7309d9a] xfs: create rt extent rounding helpers for realtime extent blocks
[ef5a83b7e597] xfs: use shifting and masking when converting rt extents, if possible
[90d98a6ada1d] xfs: convert the rtbitmap block and bit macros to static inline functions
[add3cddaea50] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
[a9948626849c] xfs: convert open-coded xfs_rtword_t pointer accesses to helper
[097b4b7b64ef] xfs: convert rt summary macros to helpers
[d0448fe76ac1] xfs: create helpers for rtbitmap block/wordcount computations
[312d61021b89] xfs: create a helper to handle logging parts of rt bitmap/summary blocks
[97e993830a1c] xfs: use accessor functions for bitmap words
[bd85af280de6] xfs: create helpers for rtsummary block/wordcount computations
[663b8db7b025] xfs: use accessor functions for summary info words
[5b1d0ae9753f] xfs: simplify xfs_rtbuf_get calling conventions
[e2cf427c9149] xfs: simplify rt bitmap/summary block accessor functions

Dave Chinner (1):
[41f33d82cfd3] xfs: consolidate realtime allocation arguments

Omar Sandoval (6):
[e94b53ff699c] xfs: cache last bitmap block in realtime allocator
[e23aaf450de7] xfs: invert the realtime summary cache
[1b5d63963f98] xfs: return maximum free size from xfs_rtany_summary()
[ec5857bf0763] xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
[85fa2c774397] xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
[e0f7422f54b0] xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

Code Diffstat:

fs/xfs/libxfs/xfs_bmap.c       |  45 +--
fs/xfs/libxfs/xfs_format.h     |  34 +-
fs/xfs/libxfs/xfs_rtbitmap.c   | 803 ++++++++++++++++++++++-------------------
fs/xfs/libxfs/xfs_rtbitmap.h   | 383 ++++++++++++++++++++
fs/xfs/libxfs/xfs_sb.c         |   2 +
fs/xfs/libxfs/xfs_sb.h         |   2 +-
fs/xfs/libxfs/xfs_trans_resv.c |  10 +-
fs/xfs/libxfs/xfs_types.c      |   4 +-
fs/xfs/libxfs/xfs_types.h      |  10 +-
fs/xfs/scrub/bmap.c            |   2 +-
fs/xfs/scrub/fscounters.c      |   2 +-
fs/xfs/scrub/inode.c           |   3 +-
fs/xfs/scrub/rtbitmap.c        |  28 +-
fs/xfs/scrub/rtsummary.c       |  72 ++--
fs/xfs/scrub/trace.c           |   1 +
fs/xfs/scrub/trace.h           |  15 +-
fs/xfs/xfs_bmap_util.c         |  50 ++-
fs/xfs/xfs_fsmap.c             |  15 +-
fs/xfs/xfs_inode_item.c        |   3 +-
fs/xfs/xfs_ioctl.c             |   5 +-
fs/xfs/xfs_linux.h             |  12 +
fs/xfs/xfs_mount.h             |   8 +-
fs/xfs/xfs_ondisk.h            |   4 +
fs/xfs/xfs_rtalloc.c           | 618 ++++++++++++++++---------------
fs/xfs/xfs_rtalloc.h           |  94 +----
fs/xfs/xfs_super.c             |   3 +-
fs/xfs/xfs_trans.c             |   7 +-
27 files changed, 1321 insertions(+), 914 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h
