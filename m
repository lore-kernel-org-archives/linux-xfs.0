Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4263318C34B
	for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729333044; cv=none; b=Ae8xtDRREElkQB0vvmtCsEfGibPFX+MYxNX7iLWaty8M7Ca0RuKOCXQZJ5LimxtghJyzl7Z/fyTvXKeqrrESlcfRrVB1uo0zJOdIvz4XdrXaut+mbocflroeJhZbqfgcBQgmAo5Wy6TK1rwXKS324rj8n3zUXHphBZ+a3+mFiGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729333044; c=relaxed/simple;
	bh=HRw5qGfcRj9mHnjrF3NOAEiohGNIjkocSEUaZae4GJQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=J2iWpttIU9rPe6TLztD/r2kjYkxstfuWHjLyH3QmN3YgasfEDFmoL7zgBd9BFdsra0LwMdR4Igsl5idOJTMuGOL5QayzqWytT1Kq6cssrfFRYvKyY1gx5KLqO3MzTNINby/X214ntiMFxyZYEqTJyo2XmvKcM4Rqdua52b4C1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iQ11xl5H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iQ11xl5H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729333041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=5dS5T5sJYoJIZfjhKDfpYQPlvfha9YR1wvoRIatQAKg=;
	b=iQ11xl5Hmy9BdN7BTAcsHTfnry7gXBYTKH8Q0guMsloTErUDPgbEbT+roQHI3jvwOr+/ZL
	2YaB6LNf+VBa3pb0UhyR31smdCO0tl0k5nXAIRtVLy3EqtLouMuCaxU3hC1RCUKH+mwwz5
	bHcMY8FViRRr1YCWvrXryeLSU2WA0KQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-SsXkWv6PM_Kf6aD4vH8vRg-1; Sat, 19 Oct 2024 06:17:19 -0400
X-MC-Unique: SsXkWv6PM_Kf6aD4vH8vRg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a9a23eada74so170179666b.3
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2024 03:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729333038; x=1729937838;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5dS5T5sJYoJIZfjhKDfpYQPlvfha9YR1wvoRIatQAKg=;
        b=sKVhuVgpPwWOg/xwfrShl7chjJ91d7wKwmRo7dkP+/FjPgDl2nS3/WMPJSojgVF8Ud
         g37+1ZGE3OXD/lTBLI51fzRQTLfMK1QDThtbqzTkcez1spBJnQkw5m6zIaTHYz8a+9sD
         DcUWckFaWnJBdgoUT9kGgJ7MLGmU53pzLFCqyLjTjV7jxzAYuhdM5U96eNh2llsOui8M
         b13RKtSN0jvwJZPgjkxlUbi5afjgqc8WqOa8aGOoExmuacGnPjJh15aFyOfQloArJRzr
         +5c1cHhOQZWraKsSMVR+RYFlZ0GinmwnPMe4f1dc/wCspdVQ5KgZRnMk8gyHrCWUmwpx
         7nbw==
X-Gm-Message-State: AOJu0YzMbXjvsAKauomctEsB+Lk0MhnO7M051KZuiKorlqs1aHmdnKrj
	AO7Y5rE9B6y/TYA8WnInANi8kPcARX6R4c+Y8Yrnfwo0qpkmjsOP/2p9WrkS9EFJFXO/4bdRMEG
	aN40bqdubEH3IMp9q8sFdD2VXzpogEhghDap9DfJx9avT9FeWhRMzpbGOf+FOiqgaqF0vM2XGK6
	h7M8USRZByP6bTBdxYLiSKAXfqGmTKh00Rir7iWAUU
X-Received: by 2002:a05:6402:5203:b0:5be:f3ae:b9ce with SMTP id 4fb4d7f45d1cf-5ca0ae7fcbcmr3969151a12.27.1729333037722;
        Sat, 19 Oct 2024 03:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyvDwcSkYE9qsrDLFBAaUh9uHJoA3447e5MVzJCUgWKS89/Q2YTNNbfJS53blkPM4QKfE1FQ==
X-Received: by 2002:a05:6402:5203:b0:5be:f3ae:b9ce with SMTP id 4fb4d7f45d1cf-5ca0ae7fcbcmr3969111a12.27.1729333036921;
        Sat, 19 Oct 2024 03:17:16 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ca0b0f958csm1674269a12.89.2024.10.19.03.17.15
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 03:17:16 -0700 (PDT)
Date: Sat, 19 Oct 2024 12:17:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.11.0 released
Message-ID: <3w6k7dcisoom4s2xm4vidlz2fjbxnplwvebpxi4jh2w64rs4cw@dzz3opqrzt6s>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

e503e1e38032e9c0e04368d5d9e1cbba099232c9

New commits:

Andrey Albershteyn (3):
      [6b32423addd2] xfsprogs: fix permissions on files installed by libtoolize
      [42523142959d] xfsprogs: update gitignore
      [e503e1e38032] xfsprogs: Release v6.11.0

Bastian Germann (6):
      [bb7c05552ac9] debian: Update debhelper-compat level
      [5c68dee37faf] debian: Update public release key
      [b3e43b35c298] debian: Prevent recreating the orig tarball
      [ea75ca724ac8] debian: Add Build-Depends on pkg with systemd.pc
      [1a608469c13f] debian: Modernize build script
      [b92bf9bc2da7] debian: Correct the day-of-week on 2024-09-04

Bill O'Donnell (1):
      [2f0fedf94c54] xfs_db: release ip resource before returning from get_next_unlinked()

Carlos Maiolino (1):
      [aa926341398f] xfs_io: Fix fscrypt macros ordering

Catherine Hoang (1):
      [ee6c5941352a] xfs_io: add RWF_ATOMIC support to pwrite

Christoph Hellwig (8):
      [c4bef0ef27b4] xfs: pass the fsbno to xfs_perag_intent_get
      [611d0eaeb29e] xfs: add a xefi_entry helper
      [328b29c975cc] xfs: reuse xfs_extent_free_cancel_item
      [b52eaa2f6ee1] xfs: remove duplicate asserts in xfs_defer_extent_free
      [02a830d4f89f] xfs: remove xfs_defer_agfl_block
      [8c775051ce9c] xfs: add a ri_entry helper
      [4b7979f5f4b9] xfs: reuse xfs_rmap_update_cancel_item
      [b8c3f60e7c3d] xfs: simplify usage of the rcur local variable in xfs_rmap_finish_one

Darrick J. Wong (61):
      [71d2969be616] libxfs: dirty buffers should be marked uptodate too
      [8554a59c8528] misc: clean up code around attr_list_by_handle calls
      [2ed5318f360d] libfrog: emulate deprecated attrlist functionality in libattr
      [643778e60849] xfs: avoid redundant AGFL buffer invalidation
      [8a8799bba2d2] xfs: hoist extent size helpers to libxfs
      [fadb819b464c] xfs: hoist inode flag conversion functions to libxfs
      [0687669c9afc] xfs: hoist project id get/set functions to libxfs
      [d490a1d34ef1] libxfs: put all the inode functions in a single file
      [4c300905db8d] libxfs: pass IGET flags through to xfs_iread
      [7ff05ce00ebb] xfs: pack icreate initialization parameters into a separate structure
      [04fd15692ac8] libxfs: pack icreate initialization parameters into a separate structure
      [f3c648be19ef] xfs: implement atime updates in xfs_trans_ichgtime
      [3af8c427dc20] libxfs: rearrange libxfs_trans_ichgtime call when creating inodes
      [5d1e5c013750] libxfs: set access time when creating files
      [ff9ad30a7149] libxfs: when creating a file in a directory, set the project id based on the parent
      [66ecea3e41d2] libxfs: pass flags2 from parent to child when creating files
      [02df725889c0] xfs: split new inode creation into two pieces
      [62c2477deae9] libxfs: split new inode creation into two pieces
      [fdf7f98794ac] libxfs: backport inode init code from the kernel
      [b47055a465de] libxfs: remove libxfs_dir_ialloc
      [2e85cabb0ee9] libxfs: implement get_random_u32
      [fa2f7708223e] xfs: hoist new inode initialization functions to libxfs
      [0f1f674259e7] xfs: hoist xfs_iunlink to libxfs
      [c8fa782f3856] xfs: hoist xfs_{bump,drop}link to libxfs
      [a8d4daf12f58] xfs: separate the icreate logic around INIT_XATTRS
      [7ce57cdc9ce7] xfs: create libxfs helper to link a new inode into a directory
      [926504400091] xfs: create libxfs helper to link an existing inode into a directory
      [45555b3d8f30] xfs: hoist inode free function to libxfs
      [ffed33c5cf10] xfs: create libxfs helper to remove an existing inode/name from a directory
      [273c0ead0234] xfs: create libxfs helper to exchange two directory entries
      [706961634f6b] xfs: create libxfs helper to rename two directory entries
      [2ab755da0ddd] xfs: move dirent update hooks to xfs_dir2.c
      [6a692a500894] xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb
      [9cebfe7aacb3] xfs: clean up extent free log intent item tracepoint callsites
      [ad2fb6bca516] xfs: convert "skip_discard" to a proper flags bitset
      [fea60f70c810] xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c
      [ff6e47b35102] xfs: give rmap btree cursor error tracepoints their own class
      [18c3bc7f6059] xfs: pass btree cursors to rmap btree tracepoints
      [0e95442e45f0] xfs: clean up rmap log intent item tracepoint callsites
      [1d056f92e5a0] xfs: don't bother calling xfs_rmap_finish_one_cleanup in xfs_rmap_finish_one
      [f8a9e37d48d3] xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c
      [7cc6344b4414] xfs: give refcount btree cursor error tracepoints their own class
      [27bc4731311b] xfs: create specialized classes for refcount tracepoints
      [eea5f0e26bc8] xfs: pass btree cursors to refcount btree tracepoints
      [efee29abb3e8] xfs: clean up refcount log intent item tracepoint callsites
      [62ae47e4ae8b] xfs: add a ci_entry helper
      [8c9f8f6c8c43] xfs: reuse xfs_refcount_update_cancel_item
      [a344868860be] xfs: don't bother calling xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
      [21f95f3ac61f] xfs: simplify usage of the rcur local variable in xfs_refcount_finish_one
      [11a046c05508] xfs: move xfs_refcount_update_defer_add to xfs_refcount_item.c
      [7392aa2f6881] xfs: fix di_onlink checking for V1/V2 inodes
      [6431fe69edb6] xfs_db: port the unlink command to use libxfs_droplink
      [cca845516ea6] xfs_db/mkfs/xfs_repair: port to use XFS_ICREATE_UNLINKABLE
      [34f035799f30] xfs_db/mdrestore/repair: don't use the incore struct xfs_sb for offsets into struct xfs_dsb
      [a14190323836] xfs_db: port the iunlink command to use the libxfs iunlink function
      [a91ec6679c52] xfs_repair: fix exchrange upgrade
      [cb62b887de3e] xfs_repair: don't crash in get_inode_parent
      [6dc93b8b56db] xfs_repair: use library functions to reset root/rbm/rsum inodes
      [171c8eec8da3] xfs_repair: use library functions for orphanage creation
      [968cbaf5ae9a] mkfs: clean up the rtinit() function
      [4727b4ff8e09] mkfs: break up the rest of the rtinit() function

Dave Chinner (3):
      [153e35fef680] xfs: AIL doesn't need manual pushing
      [922a67a8e957] xfs: background AIL push should target physical space
      [b2f56fe57fe8] xfs: xfs_finobt_count_blocks() walks the wrong btree

Gerald Yang (1):
      [19dde7fac0f3] fsck.xfs: fix fsck.xfs run by different shells when fsck.mode=force is set

John Garry (1):
      [871d186c79f5] man: Update unit for fsx_extsize and fsx_cowextsize

Julian Sun (1):
      [d488f8152f47] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

Julien Olivain (1):
      [baf5cde86f22] libxfs: provide a memfd_create() wrapper if not present in libc

Long Li (1):
      [9ba014e2e650] xfs: get rid of xfs_ag_resv_rmapbt_alloc

Wenchao Hao (1):
      [06b712627e0c] xfs: Remove header files which are included more than once

Zizhi Wo (1):
      [6211801f306c] xfs: Avoid races with cnt_btree lastrec updates

lei lu (1):
      [6540c8ae3485] xfs: don't walk off the end of a directory data block

Code Diffstat:

 .gitignore                      |  12 +-
 Makefile                        |   3 +
 VERSION                         |   4 +-
 configure.ac                    |   6 +-
 db/iunlink.c                    | 132 +------
 db/namei.c                      |  23 +-
 db/sb.c                         |   4 +-
 debian/changelog                |   8 +-
 debian/compat                   |   2 +-
 debian/control                  |   2 +-
 debian/rules                    |  81 ++---
 debian/upstream/signing-key.asc | 106 +++---
 doc/CHANGES                     |   5 +
 fsck/xfs_fsck.sh                |   4 +-
 include/builddefs.in            |   3 +-
 include/libxfs.h                |   1 +
 include/linux.h                 |   5 +
 include/xfs_inode.h             |  93 ++++-
 include/xfs_mount.h             |  11 +-
 include/xfs_trace.h             |  11 +-
 include/xfs_trans.h             |   2 +-
 io/encrypt.c                    |  67 ++--
 io/pwrite.c                     |   8 +-
 libfrog/Makefile                |   8 +-
 libfrog/fakelibattr.h           |  36 ++
 libfrog/fsprops.c               |  22 +-
 libxfs/Makefile                 |  13 +
 libxfs/defer_item.c             | 222 ++++++------
 libxfs/defer_item.h             |  16 +
 libxfs/inode.c                  | 254 ++++++++++++++
 libxfs/iunlink.c                | 163 +++++++++
 libxfs/iunlink.h                |  24 ++
 libxfs/libxfs_api_defs.h        |   5 +
 libxfs/libxfs_priv.h            |  26 +-
 libxfs/rdwr.c                   |  97 +-----
 libxfs/trans.c                  |   1 +
 libxfs/util.c                   | 336 +-----------------
 libxfs/xfile.c                  |  16 +
 libxfs/xfs_ag.c                 |   2 +-
 libxfs/xfs_ag_resv.h            |  19 -
 libxfs/xfs_alloc.c              | 235 +++++++------
 libxfs/xfs_alloc.h              |  18 +-
 libxfs/xfs_alloc_btree.c        |  64 ----
 libxfs/xfs_bmap.c               |  55 ++-
 libxfs/xfs_bmap.h               |   3 +
 libxfs/xfs_bmap_btree.c         |   2 +-
 libxfs/xfs_btree.c              |  51 ---
 libxfs/xfs_btree.h              |  16 +-
 libxfs/xfs_defer.c              |   2 +-
 libxfs/xfs_dir2.c               | 661 ++++++++++++++++++++++++++++++++++-
 libxfs/xfs_dir2.h               |  49 ++-
 libxfs/xfs_dir2_data.c          |  31 +-
 libxfs/xfs_dir2_priv.h          |   7 +
 libxfs/xfs_format.h             |   9 +-
 libxfs/xfs_ialloc.c             |  20 +-
 libxfs/xfs_ialloc_btree.c       |   4 +-
 libxfs/xfs_inode_buf.c          |  14 +-
 libxfs/xfs_inode_util.c         | 746 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h         |  62 ++++
 libxfs/xfs_ondisk.h             |   1 +
 libxfs/xfs_quota_defs.h         |   2 +-
 libxfs/xfs_refcount.c           | 156 +++------
 libxfs/xfs_refcount.h           |  11 +-
 libxfs/xfs_refcount_btree.c     |   2 +-
 libxfs/xfs_rmap.c               | 268 +++++----------
 libxfs/xfs_rmap.h               |  15 +-
 libxfs/xfs_rmap_btree.c         |   7 +-
 libxfs/xfs_shared.h             |   7 -
 libxfs/xfs_trans_inode.c        |   2 +
 libxfs/xfs_trans_resv.c         |  29 +-
 m4/package_attr.m4              |  25 --
 m4/package_libcdev.m4           |  33 ++
 man/man2/ioctl_xfs_fsgetxattr.2 |   6 +-
 man/man8/xfs_io.8               |   8 +-
 mdrestore/xfs_mdrestore.c       |   6 +-
 mkfs/proto.c                    | 294 +++++++++++-----
 repair/agheader.c               |  12 +-
 repair/bulkload.c               |   3 +-
 repair/incore_ino.c             |   2 +-
 repair/phase2.c                 |   2 +-
 repair/phase6.c                 | 226 ++++--------
 scrub/Makefile                  |   4 -
 scrub/phase5.c                  |  59 ++--
 83 files changed, 3299 insertions(+), 1783 deletions(-)
 create mode 100644 libfrog/fakelibattr.h
 create mode 100644 libxfs/inode.c
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h
 create mode 100644 libxfs/xfs_inode_util.c
 create mode 100644 libxfs/xfs_inode_util.h
 delete mode 100644 m4/package_attr.m4

