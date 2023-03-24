Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2068C6FD20
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Mar 2023 13:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjCXNes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Mar 2023 09:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCXNer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2023 09:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7391219C60
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 06:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1709D62AE7
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 13:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D2CC433D2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 13:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679664861;
        bh=BzOy70AFEkEHEKvs9rBqrN7uCHvJIlJ3WBEJGn5fBVA=;
        h=Date:From:To:Subject:From;
        b=gFivFMGff3hbNiZcZXIjPskIBJLiZ0OfQLtREVwDipnRTzQPynbokxjOuDkiXNOoT
         /YpsxNapS6NaES2eVpXg3zs2cZI24gazAwtI9GNPBNsLUTB78wQFwJes87eXmRnkc4
         ZgSjJo2KzcJO4gZ239qK+6MpIm30KbBCiAIZNWTOxREcsChCTEMAjnsAdtHRGDqZYk
         Ftd9UCa3GcRYNyFiOMA8TLMqFp0nHLQJY9glfAHeAWSS8W4i08wAYOt/+XR11eopvN
         Tu6/FOo+FBOUq1zRGhi94IUTOQ31w7mF4Hp8VfSkr/0tYYgoRyt8+lvwqSZpfYnnXZ
         bTiI+Um5cp5jQ==
Date:   Fri, 24 Mar 2023 14:34:17 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.2.0 released
Message-ID: <20230324133417.vg5co4ta7mbfbizo@andromeda>
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

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The for-next branch has also been updated to reflect the state of master

The new head of the master branch is commit:

a68dabd45f3591456ecf7e35f6a6077db79f6bc6

27 new commits:

Andrey Albershteyn (1):
      [a0d79cb37] xfs_db: make flist_find_ftyp() to check for field existance on disk

Arjun Shankar (1):
      [d6642ab8c] Remove several implicit function declarations

Catherine Hoang (4):
      [d9151538d] xfs_io: add fsuuid command
      [e7cd89b2d] xfs_admin: get UUID of mounted filesystem
      [77e8ce78c] xfs_admin: correctly parse IO_OPTS parameters
      [e9f142486] xfs_admin: get/set label of mounted filesystem

Darrick J. Wong (15):
      [5a77e0e7c] xfs_spaceman: fix broken -g behavior in freesp command
      [085fce0ba] xfs_scrub: fix broken realtime free blocks unit conversions
      [647078745] xfs_io: set fs_path when opening files on foreign filesystems
      [b1faed5f7] xfs_io: fix bmap command not detecting realtime files with xattrs
      [c3fce4f9b] mkfs: check dirent names when reading protofile
      [fb22e1b1b] mkfs: use suboption processing for -p
      [e0aeb0581] mkfs: substitute slashes with spaces in protofiles
      [b7b81f336] xfs_repair: fix incorrect dabtree hashval comparison
      [4f82f9218] xfs_db: fix complaints about unsigned char casting
      [9061d756b] xfs: add debug knob to slow down writeback for fun
      [fb084f350] xfs: add debug knob to slow down write for fun
      [d1dca9f6b] xfs: hoist refcount record merge predicates
      [b445624f0] xfs: estimate post-merge refcounts correctly
      [88765eda1] xfs: invalidate xfs_bufs when allocating cow extents
      [a68dabd45] xfs: fix off-by-one error in xfs_btree_space_to_height

Dave Chinner (4):
      [0f1291c3b] progs: autoconf fails during debian package builds
      [d8eab7600] progs: just use libtoolize
      [1dcdf5051] xfs: use iomap_valid method to detect stale cached iomaps
      [d712be6a9] xfs: drop write error injection is unfixable, remove it

Guo Xuenan (1):
      [f5ef81288] xfs: get rid of assert from xfs_btree_islastblock

Jason A. Donenfeld (1):
      [9a046f967] treewide: use get_random_u32_below() instead of deprecated function

Code Diffstat:

 Makefile               |  16 +-----
 db/crc.c               |   2 +-
 db/flist.c             |  12 +++-
 db/flist.h             |   3 +-
 db/namei.c             |   4 +-
 db/xfs_admin.sh        |  66 ++++++++++++++++++----
 io/Makefile            |   6 +-
 io/bmap.c              |   2 +-
 io/fsuuid.c            |  49 +++++++++++++++++
 io/init.c              |   1 +
 io/inject.c            |   2 +
 io/io.h                |   1 +
 io/open.c              |   3 +-
 libxfs/libxfs_priv.h   |   2 +-
 libxfs/xfs_alloc.c     |   2 +-
 libxfs/xfs_bmap.c      |   8 ++-
 libxfs/xfs_btree.c     |   7 ++-
 libxfs/xfs_btree.h     |   1 -
 libxfs/xfs_errortag.h  |  18 +++---
 libxfs/xfs_ialloc.c    |   2 +-
 libxfs/xfs_refcount.c  | 146 +++++++++++++++++++++++++++++++++++++++++++------
 m4/package_libcdev.m4  |   7 ++-
 man/man8/mkfs.xfs.8.in |  32 +++++++++--
 man/man8/xfs_io.8      |   3 +
 mkfs/proto.c           |  37 ++++++++++++-
 mkfs/proto.h           |   3 +-
 mkfs/xfs_mkfs.c        |  72 +++++++++++++++++++++---
 repair/da_util.c       |   2 +-
 scrub/fscounters.c     |   2 +-
 spaceman/freesp.c      |   1 -
 30 files changed, 422 insertions(+), 90 deletions(-)
 create mode 100644 io/fsuuid.c

-- 
Carlos Maiolino
