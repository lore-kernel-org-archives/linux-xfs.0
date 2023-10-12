Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC6CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 12:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378358AbjJLMBG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbjJLMAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 08:00:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E469D132
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 05:00:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21A3C433C7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697112027;
        bh=x6466dNpz75H9z5oSNzuCVDNsxCrZIuOHrXqUvJZlME=;
        h=Date:From:To:Subject:From;
        b=dobESElkTyixK73VRei9j5C2VNlSByf1jdwVTM7qjjzQGvWyVrJdDaC/V9kiBKvwi
         10TjC3HUpbnN31K+DsCqXXl/YV1qziO7U5OJgvWnF0rbVCPENf3qNrzmOUF/A4L1fP
         stk0DJTci1Zw+3Ua5eiVgFum+/1YoJJ2lrhhPH4st1PfQPwzyVdLvI4Vyw+cr08MIY
         VxcoG7S1IG5kFUFhaL4WsFqlN340t24973Xo4N8hKmx8/s/TSeQ6jHGeppb7eg6jic
         7PH9YM7cc36avCJ0Z5SDubBACahKWxpNsceW0yaBQrEWsQGxMUkQAd2yxjLXB1Ey/u
         HB4svAvCditKQ==
Date:   Thu, 12 Oct 2023 14:00:23 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.5.0 released
Message-ID: <20231012120023.fcflqy4qfmhflame@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs repository, located at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to reflect the state of master

Any question, let me know

The new head of the master branch is commit:

91d9bdb83 xfsprogs: Release v6.5.0

New Commits:

Carlos Maiolino (1):
      [91d9bdb83] xfsprogs: Release v6.5.0

Darrick J. Wong (13):
      [69b07d331] xfs_db: dump unlinked buckets
      [4a9f92d02] xfs_db: create unlinked inodes
      [e5b18d7d1] mkfs: enable large extent counts by default
      [bcd5b1b76] mkfs: enable reverse mapping by default
      [1e8897d53] mkfs: add a config file for 6.6 LTS kernels
      [244199cd9] libxfs: make platform_set_blocksize optional with directio
      [1bd1a58a7] xfs_db: use directio for device access
      [12838bda1] libfrog: fix overly sleep workqueues
      [03582d3f3] libfrog: don't fail on XFS_FSOP_GEOM_FLAGS_NREXT64 in xfrog_bulkstat_single5
      [7f5bbe286] libxfs: use XFS_IGET_CREATE when creating new files
      [92c185116] xfs_scrub: actually return errno from check_xattr_ns_names
      [75325b82a] xfs_repair: set aformat and anextents correctly when clearing the attr fork
      [21226bb46] libxfs: fix atomic64_t detection on x86 32-bit architectures

Krzesimir Nowak (1):
      [e51b89e65] libfrog: drop build host crc32 selftest


Code Diffstat:

 VERSION                  |   2 +-
 configure.ac             |   2 +-
 db/Makefile              |   2 +-
 db/command.c             |   1 +
 db/command.h             |   1 +
 db/init.c                |   1 +
 db/iunlink.c             | 400 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 debian/changelog         |   6 ++
 doc/CHANGES              |  14 +++
 libfrog/Makefile         |  14 +--
 libfrog/bulkstat.c       |   2 +-
 libfrog/crc32.c          |  21 ----
 libfrog/workqueue.c      |  34 +++++--
 libfrog/workqueue.h      |   1 +
 libxfs/init.c            |   8 +-
 libxfs/libxfs_api_defs.h |   2 +
 libxfs/util.c            |   2 +-
 m4/package_urcu.m4       |   9 +-
 man/man8/mkfs.xfs.8.in   |  11 +-
 man/man8/xfs_db.8        |  30 ++++++
 mkfs/Makefile            |   3 +-
 mkfs/lts_6.6.conf        |  14 +++
 mkfs/xfs_mkfs.c          |   4 +-
 repair/dinode.c          |   2 -
 scrub/phase5.c           |   1 +
 25 files changed, 526 insertions(+), 61 deletions(-)
 create mode 100644 db/iunlink.c
 create mode 100644 mkfs/lts_6.6.conf


Carlos
