Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8642B7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1997DAC005
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:13 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id R23D5dXA8Mb3RRfm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:05 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id D2D4520A44
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:03 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2qb3D6hz5vN3
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:03 +0100 (CET)
Date: Tue, 12 Jan 2016 20:59:28 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 0/6] xfsprogs: Compile with musl libc
Message-ID: <20160112195928.GA568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch series makes xfsprogs compile on linux systems using the
musl c library.

I'm sorry for the large size of the first patch...

Felix Janda (6):
  Move from __uint*_t types to uint*_t and likewise for __int*_t
  libxfs/linux.c: Replace use of ustat by stat
  fsr/xfs_fsr.c: Include <paths.h> for _PATH_MOUNTED
  linux.h: Use off64_t instead of loff_t
  include/linux.h: Include <stdio.h> for fprintf and stderr
  Add configure check for members of dirent for use in io/readdir.c

 configure.ac              |   7 ++
 copy/xfs_copy.c           |  14 ++--
 copy/xfs_copy.h           |   2 +-
 db/attr.c                 |   8 +-
 db/attrshort.c            |   4 +-
 db/bit.c                  |   4 +-
 db/bit.h                  |   2 +-
 db/block.c                |   8 +-
 db/check.c                |  18 ++---
 db/convert.c              |  28 +++----
 db/faddr.c                |  14 ++--
 db/field.c                |  44 +++++------
 db/fprint.c               |   8 +-
 db/frag.c                 |   8 +-
 db/inode.c                |  30 ++++----
 db/io.c                   |   4 +-
 db/io.h                   |   8 +-
 db/metadump.c             |  12 +--
 db/sb.c                   |   6 +-
 fsr/xfs_fsr.c             |   3 +-
 include/builddefs.in      |   4 +
 include/darwin.h          |   9 ---
 include/freebsd.h         |   6 +-
 include/gnukfreebsd.h     |   6 +-
 include/irix.h            |  28 +++----
 include/linux.h           |  11 +--
 include/xfs_arch.h        |  22 +++---
 include/xfs_inode.h       |   4 +-
 include/xfs_log_recover.h |   2 +-
 include/xfs_metadump.h    |   4 +-
 include/xfs_mount.h       |  20 ++---
 io/Makefile               |  10 +++
 libhandle/handle.c        |   2 +-
 libhandle/jdm.c           |   2 +-
 libxfs/darwin.c           |   2 +-
 libxfs/freebsd.c          |   2 +-
 libxfs/init.c             |   2 +-
 libxfs/irix.c             |   2 +-
 libxfs/libxfs_priv.h      |   4 +-
 libxfs/linux.c            |  31 +++++---
 libxfs/logitem.c          |   2 +-
 libxfs/radix-tree.c       |   8 +-
 libxfs/rdwr.c             |   6 +-
 libxfs/util.c             |  14 ++--
 libxfs/xfs_alloc_btree.c  |  10 +--
 libxfs/xfs_attr_remote.c  |   8 +-
 libxfs/xfs_attr_sf.h      |  18 ++---
 libxfs/xfs_bit.h          |  24 +++---
 libxfs/xfs_bmap_btree.c   |   8 +-
 libxfs/xfs_btree.c        |  12 +--
 libxfs/xfs_btree.h        |  14 ++--
 libxfs/xfs_cksum.h        |  14 ++--
 libxfs/xfs_da_btree.c     |   2 +-
 libxfs/xfs_da_btree.h     |   8 +-
 libxfs/xfs_da_format.c    |  24 +++---
 libxfs/xfs_da_format.h    |  60 +++++++--------
 libxfs/xfs_dir2.h         |   8 +-
 libxfs/xfs_dir2_leaf.c    |  12 +--
 libxfs/xfs_dir2_priv.h    |   2 +-
 libxfs/xfs_format.h       |  98 ++++++++++++------------
 libxfs/xfs_fs.h           |  12 +--
 libxfs/xfs_ialloc.c       |   6 +-
 libxfs/xfs_ialloc_btree.c |   4 +-
 libxfs/xfs_inode_buf.c    |   2 +-
 libxfs/xfs_log_format.h   | 190 +++++++++++++++++++++++-----------------------
 libxfs/xfs_quota_defs.h   |   4 +-
 libxfs/xfs_rtbitmap.c     |   2 +-
 libxfs/xfs_sb.c           |   4 +-
 libxfs/xfs_types.h        |  46 +++++------
 logprint/log_misc.c       |   6 +-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/proto.c              |   2 +-
 mkfs/xfs_mkfs.c           |  88 ++++++++++-----------
 quota/edit.c              |  64 ++++++++--------
 quota/free.c              |  44 +++++------
 quota/quot.c              |  24 +++---
 quota/quota.c             |   4 +-
 quota/quota.h             |  12 +--
 quota/report.c            |   2 +-
 quota/state.c             |   2 +-
 quota/util.c              |  66 ++++++++--------
 repair/README             |   2 +-
 repair/agheader.h         |  14 ++--
 repair/attr_repair.h      |  26 +++----
 repair/avl64.c            |  38 +++++-----
 repair/avl64.h            |  18 ++---
 repair/dino_chunks.c      |   2 +-
 repair/dinode.c           |  38 +++++-----
 repair/dinode.h           |   4 +-
 repair/dir2.c             |   2 +-
 repair/globals.h          |  16 ++--
 repair/incore.c           |  10 +--
 repair/incore.h           |  42 +++++-----
 repair/incore_ext.c       |   6 +-
 repair/incore_ino.c       |  72 +++++++++---------
 repair/phase2.c           |   2 +-
 repair/phase3.c           |   6 +-
 repair/phase4.c           |   4 +-
 repair/phase5.c           |  40 +++++-----
 repair/phase6.c           |  18 ++---
 repair/phase7.c           |   6 +-
 repair/progress.c         |  30 ++++----
 repair/progress.h         |   4 +-
 repair/sb.c               |  10 +--
 repair/scan.c             |  42 +++++-----
 repair/scan.h             |  12 +--
 106 files changed, 914 insertions(+), 893 deletions(-)

-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
