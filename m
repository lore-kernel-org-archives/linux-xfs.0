Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196DDC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 23:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiGLXVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 19:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiGLXVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 19:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F68B93E3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 16:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B56661704
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 23:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D965EC3411C;
        Tue, 12 Jul 2022 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657668093;
        bh=o0M4jHvTOdgmMPbCGKp64+JuBTuW2gx5bJpIQwLYPrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dmktlb59uV9aJusQ6cJ/nGTsF5aVZnKciXvHrrEpzNWzo4UBQlY+/466n+hN2iKGa
         oCRxker4FsQ7ivyWOg6DUhq9gfBVyfljveLoGLExpCOH6p5+9IR8tc/A0EGV4sjLR3
         GggUghqTmOFbP8xRt6veu1U9Uz4GhL3Da3Pa9PXMAUQey2emw4CKGJwXoZa5R/jdOh
         yrgta7vYsnTqodSbnkT8dNU0YLgush2tA35i4/lngfrWITfjL6Jh1BvJlnlyMmlhjV
         q4KLovQUZr1poE1KWfnvW2wheIUfMe2a5audb9+GXrXP2EEUFDgAn0u1bYDaLYboAf
         azrdBd1gxJcVA==
Date:   Tue, 12 Jul 2022 16:21:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to c1c71781
Message-ID: <Ys4B/TKxe7WJuvzP@magnolia>
References: <3fb4449d-7e6e-fdb0-96b0-3e9c34f22398@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb4449d-7e6e-fdb0-96b0-3e9c34f22398@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 01:34:47PM -0500, Eric Sandeen wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> I jumped the gun on 5.19.0-rc0, and a couple more libxfs patches got
> added to the kkernel, so I added a new "release" and tag of
> 5.19.0-rc.0.1 after the last libxfs patches were merged.

Are you planning to pick up the following patchsets for 5.19?

xfs_repair: check rt bitmap and summary [reviewed]
https://lore.kernel.org/linux-xfs/165644940561.1091513.10430076522811115702.stgit@magnolia/

mkfs: stop allowing tiny filesystems
https://lore.kernel.org/linux-xfs/165644942559.1091646.1065506297333895934.stgit@magnolia/

I'll resend the nrext64 upgrade and the random fixes rollups shortly,
since they've changed since 28 June.

--D

> After that I picked up most of Darrick's patches that had been reviewed,
> as well as Zhang Boyang's mkfs man page update.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> The new head of the for-next branch is commit:
> 
> c1c71781 mkfs: update manpage of bigtime and inobtcount
> 
> New Commits:
> 
> Darrick J. Wong (16):
>       [41cbb27c] xfs: fix TOCTOU race involving the new logged xattrs control knob
>       [53cbe278] xfs: fix variable state usage
>       [5e572d1a] xfs: empty xattr leaf header blocks are not corruption
>       [c21a5691] xfs: don't hold xattr leaf buffers across transaction rolls
>       [95e3fc7f] misc: fix unsigned integer comparison complaints
>       [053fcbc7] xfs_logprint: fix formatting specifiers
>       [d6bfc06d] libxfs: remove xfs_globals.larp
>       [fa0f9232] xfs_repair: always rewrite secondary supers when needsrepair is set
>       [84c5f08f] xfs_repair: don't flag log_incompat inconsistencies as corruptions
>       [766bfbd7] xfs_db: identify the minlogsize transaction reservation
>       [baf8a5df] xfs_copy: don't use cached buffer reads until after libxfs_mount
>       [b83b2ec0] xfs_repair: clear DIFLAG2_NREXT64 when filesystem doesn't support nrext64
>       [0ec4cd64] xfs_repair: detect and fix padding fields that changed with nrext64
>       [b6fd1034] mkfs: preserve DIFLAG2_NREXT64 when setting other inode attributes
>       [42efbb99] mkfs: document the large extent count switch in the --help screen
>       [ad8a3d7c] mkfs: always use new_diflags2 to initialize new inodes
> 
> Eric Sandeen (1):
>       [e298041e] xfsprogs: Release v5.19.0-rc0.1
> 
> Zhang Boyang (1):
>       [c1c71781] mkfs: update manpage of bigtime and inobtcount
> 
> 
> Code Diffstat:
> 
>  copy/xfs_copy.c          |  2 +-
>  db/check.c               | 10 +++++++---
>  db/logformat.c           |  4 +++-
>  db/metadump.c            | 11 +++++++----
>  include/xfs_mount.h      |  7 -------
>  libxfs/util.c            | 15 ++++++---------
>  libxfs/xfs_attr.c        | 47 ++++++++++++++---------------------------------
>  libxfs/xfs_attr.h        | 17 +----------------
>  libxfs/xfs_attr_leaf.c   | 37 ++++++++++++++++++++-----------------
>  libxfs/xfs_attr_leaf.h   |  3 +--
>  libxfs/xfs_da_btree.h    |  4 +++-
>  logprint/log_print_all.c |  2 +-
>  man/man8/mkfs.xfs.8.in   |  4 ++--
>  mkfs/xfs_mkfs.c          |  2 +-
>  repair/agheader.c        | 23 ++++++++++++++++++++---
>  repair/dinode.c          | 47 +++++++++++++++++++++++++++++++++++++++++++----
>  16 files changed, 130 insertions(+), 105 deletions(-)



