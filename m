Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833AAC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595A360F93
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhHBWYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhHBWYw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2C660F36;
        Mon,  2 Aug 2021 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627943082;
        bh=7j0+cEy0rKhjs8TADBoaHmMp2ovslCTM+ZtkvCMMzcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmIGhUOgeZzHJrI3fwRXE2/pMbJwKAENq33ZWMS2R1AKHnh9b1PldCy2FamuNZJr2
         uporgODMPamuVcmJePxFEAYW+6vfVCoydorEGV+aeGX2GwcugCei5HII6asEefygZj
         VCTN+9B3QoOHUIzC9NsSQUff7rKASMsehyEqW5NG7pwXW0AqUJ1gETzT/33M/BVJzE
         N43MuZmL32HKwEG9Ei1i5zLs0JbaPaL6p53KUAVUufYsdw1ZjjMEjgcITltV0T6y7A
         jgp9bU54Ppvu6moxRI9XFzWVj9uasY26/j/chF4pxRBzwJFCmzxux9zqw9hhDCSv3c
         gzbiyN7pQXZ5g==
Date:   Mon, 2 Aug 2021 15:24:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8] xfsprogs: Drop the 'platform_' prefix
Message-ID: <20210802222441.GP3601443@magnolia>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 02, 2021 at 11:50:16PM +0200, Pavel Reichl wrote:
> Hi,
> 
> Eric recently suggested that removing prefix 'platform_' from function
> names in xfsprogs could be a good idea.

Please turn on column wrapping for email...

> It seems to be a relict from times when support from other OSes was
> expected. Since it does not seem to happen it might be a good idea to
> remove the prefix and thus simplify the codebase a bit.
> 
> The core of the changes is in removing 'platform' wrappers around
> standard linux calls and fixing the passed parameters from pointers to
> actual values (if appropriate) e.g.
> 
> -static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
> -{
> -	uuid_copy(*dst, *src);
> -}
> ... 
> -		platform_uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
> +		uuid_copy(hdr3->uuid, mp->m_sb.sb_meta_uuid);
> 
> 
> 
> I attached first WIP version (that builds and passes my limited
> testing) to show the scope of changes and find consensus about some
> choices that need to be done:
> 
>  * Is renaming platform_defs.h.in -> defs.h.in OK?
>  * is renaming libfrog/platform.h -> libfrog/common.h OK, maybe
>  libfrog/libfrog.h is better?
>  * Wrapper platform_nproc() defined in/libfrog/linux.c slightly
>  changes the behavior of nproc() is renaming it to libfrog_nproc() OK?

Not sure what "nproc()" is?  Are you asking if it's ok to rename
platform_nproc to libfrog_nproc because it's not just a straight wrapper
of "sysconf(_SC_NPROCESSORS_ONLN)"?

>  * What would be best for the reviewer - should I prepare a separate
>  patch for every function rename or should I squash the changes into
>  one huge patch?

One patch per function, please.

--D

>  
> Thanks! 
> 
> Pavel Reichl (8):
>   xfsprogs: Rename platform_defs.h.in -> defs.h.in
>   xfsprogs: Rename platform.h -> common.h
>   xfsprogs: remove platform_uuid_compare()
>   xfsprogs: remove platform_{test_xfs_fd,path,fstatfs}
>   xfsprogs: Rename platform_getoptreset -> getoptreset
>   xfsprogs: remove all platform_ prefixes in linux.h
>   xfsprogs: Remove platform_ prefixes in libfrog/common.h
>   xfsprogs: remove platform_ from man xfsctl man page
> 
>  .gitignore                                |  2 +-
>  Makefile                                  | 10 ++--
>  configure.ac                              |  2 +-
>  copy/xfs_copy.c                           | 26 +++++-----
>  db/command.c                              |  2 +-
>  db/fprint.c                               |  2 +-
>  db/sb.c                                   | 14 ++---
>  debian/rules                              |  4 +-
>  fsr/xfs_fsr.c                             |  8 +--
>  growfs/xfs_growfs.c                       |  2 +-
>  include/Makefile                          |  4 +-
>  include/{platform_defs.h.in => defs.h.in} |  8 +--
>  include/libxfs.h                          |  2 +-
>  include/linux.h                           | 62 ++++-------------------
>  io/bmap.c                                 |  2 +-
>  io/bulkstat.c                             |  2 +-
>  io/cowextsize.c                           |  2 +-
>  io/crc32cselftest.c                       |  2 +-
>  io/encrypt.c                              |  2 +-
>  io/fiemap.c                               |  2 +-
>  io/fsmap.c                                |  2 +-
>  io/fsync.c                                |  2 +-
>  io/init.c                                 |  4 +-
>  io/label.c                                |  2 +-
>  io/log_writes.c                           |  2 +-
>  io/open.c                                 |  4 +-
>  io/stat.c                                 |  2 +-
>  io/sync.c                                 |  2 +-
>  libfrog/avl64.c                           |  2 +-
>  libfrog/bitmap.c                          |  2 +-
>  libfrog/common.h                          | 26 ++++++++++
>  libfrog/convert.c                         |  2 +-
>  libfrog/crc32.c                           |  2 +-
>  libfrog/fsgeom.c                          |  2 +-
>  libfrog/linux.c                           | 30 +++++------
>  libfrog/paths.c                           |  2 +-
>  libfrog/paths.h                           |  2 +-
>  libfrog/platform.h                        | 26 ----------
>  libfrog/projects.h                        |  2 +-
>  libfrog/ptvar.c                           |  2 +-
>  libfrog/radix-tree.c                      |  2 +-
>  libfrog/topology.c                        |  8 +--
>  libfrog/util.c                            |  2 +-
>  libhandle/handle.c                        |  2 +-
>  libhandle/jdm.c                           |  2 +-
>  libxcmd/command.c                         |  4 +-
>  libxcmd/help.c                            |  2 +-
>  libxcmd/input.c                           |  2 +-
>  libxcmd/quit.c                            |  2 +-
>  libxfs/init.c                             | 34 ++++++-------
>  libxfs/libxfs_io.h                        |  2 +-
>  libxfs/libxfs_priv.h                      |  5 +-
>  libxfs/rdwr.c                             |  6 +--
>  libxfs/xfs_ag.c                           |  6 +--
>  libxfs/xfs_attr_leaf.c                    |  2 +-
>  libxfs/xfs_attr_remote.c                  |  2 +-
>  libxfs/xfs_btree.c                        |  4 +-
>  libxfs/xfs_da_btree.c                     |  2 +-
>  libxfs/xfs_dir2_block.c                   |  2 +-
>  libxfs/xfs_dir2_data.c                    |  2 +-
>  libxfs/xfs_dir2_leaf.c                    |  2 +-
>  libxfs/xfs_dir2_node.c                    |  2 +-
>  libxfs/xfs_dquot_buf.c                    |  2 +-
>  libxfs/xfs_ialloc.c                       |  4 +-
>  libxfs/xfs_inode_buf.c                    |  2 +-
>  libxfs/xfs_sb.c                           |  6 +--
>  libxfs/xfs_symlink_remote.c               |  2 +-
>  libxlog/util.c                            |  8 +--
>  logprint/log_misc.c                       |  2 +-
>  man/man3/xfsctl.3                         |  9 +---
>  mdrestore/xfs_mdrestore.c                 |  4 +-
>  mkfs/xfs_mkfs.c                           | 22 ++++----
>  quota/free.c                              |  2 +-
>  repair/agheader.c                         | 16 +++---
>  repair/attr_repair.c                      |  2 +-
>  repair/dinode.c                           |  8 +--
>  repair/phase4.c                           |  6 +--
>  repair/phase5.c                           |  6 +--
>  repair/phase6.c                           |  2 +-
>  repair/prefetch.c                         |  2 +-
>  repair/scan.c                             |  4 +-
>  repair/slab.c                             |  2 +-
>  repair/xfs_repair.c                       |  8 +--
>  scrub/common.c                            |  2 +-
>  scrub/descr.c                             |  2 +-
>  scrub/disk.c                              |  6 +--
>  scrub/fscounters.c                        |  2 +-
>  scrub/inodes.c                            |  2 +-
>  scrub/xfs_scrub.c                         |  2 +-
>  spaceman/health.c                         |  2 +-
>  spaceman/init.c                           |  2 +-
>  91 files changed, 235 insertions(+), 281 deletions(-)
>  rename include/{platform_defs.h.in => defs.h.in} (95%)
>  create mode 100644 libfrog/common.h
>  delete mode 100644 libfrog/platform.h
> 
> -- 
> 2.31.1
> 
