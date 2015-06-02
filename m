Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D0E87F8B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 14:26:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 905E8AC001
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 12:26:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 00SxDupV57SrC7at (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 12:26:44 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id BC970358A16
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 19:26:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig3HV010485
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/28] xfsprogs: sparse inode chunks
Date: Tue,  2 Jun 2015 14:41:33 -0400
Message-Id: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

Now that the sparse inode chunks feature is merged into the kernel tree
for 4.2, here is the first official drop of userspace support. This
series is based on the current libxfs-4.1-update branch.

Patches 1-10 are libxfs infrastructure and correspond to the similarly
named kernel patches. The bits not relevant to userspace are dropped
along with the bulk of the sparse inode chunk allocation logic from the
kernel due to the combination of non-existent dependencies in userspace
(e.g., xfs_bit.c) and the fact that this code isn't invoked from
userspace. The experimental feature warning was also dropped to avoid
noisy mkfs warnings that lead to spurious xfstests failures. The
subsequent patches add support to mkfs, xfs_db, xfs_info, xfs_repair and
xfs_metadump.

Use the new '-i sparse' option to format a filesystem with sparse inode
chunks enabled:

	mkfs.xfs -f -m crc=1,finobt=1 -i sparse <dev>

Thoughts, reviews, flames appreciated. Thanks.

Brian

Brian Foster (28):
  xfs: create individual inode alloc. helper
  xfs: update free inode record logic to support sparse inode records
  xfs: support min/max agbno args in block allocator
  xfs: add sparse inode chunk alignment superblock field
  xfs: use sparse chunk alignment for min. inode allocation requirement
  xfs: sparse inode chunks feature helpers and mount requirements
  xfs: add fs geometry bit for sparse inode chunks
  xfs: introduce inode record hole mask for sparse inode chunks
  xfs: pass inode count through ordered icreate log item
  xfs: enable sparse inode chunks for v5 superblocks
  mkfs: sparse inode chunk support
  db: support sparse inode chunk inobt record and sb fields
  db: show sparse inodes feature state in version command output
  growfs: display sparse inode status from xfs_info
  repair: handle sparse format inobt record freecount correctly
  repair: remove duplicate field from aghdr_cnts
  repair: use ir_count for filesystems with sparse inode support
  repair: scan and track sparse inode chunks correctly
  repair: scan sparse finobt records correctly
  repair: validate ir_count field for sparse format records
  repair: process sparse inode records correctly
  repair: factor out sparse inodes from finobt reconstruction
  repair: do not account sparse inodes in phase 5 cursor init.
  repair: reconstruct sparse inode records correctly on disk
  repair: do not prefetch holes in sparse inode chunks
  repair: handle sparse inode alignment
  metadump: reorder inode record sanity checks and inode buffer read
  metadump: support sparse inode records

 db/btblock.c              |  45 ++++++++++--
 db/btblock.h              |   3 +
 db/check.c                |   8 +--
 db/field.c                |   4 ++
 db/field.h                |   2 +
 db/init.c                 |   4 +-
 db/metadump.c             |  90 ++++++++++++++++-------
 db/sb.c                   |   3 +
 db/type.c                 |  40 +++++++++++
 db/type.h                 |   1 +
 growfs/xfs_growfs.c       |  13 ++--
 include/libxfs.h          |  16 +++++
 include/xfs_mount.h       |   2 +
 libxfs/xfs_alloc.c        |  42 +++++++++--
 libxfs/xfs_alloc.h        |   2 +
 libxfs/xfs_format.h       |  48 +++++++++++--
 libxfs/xfs_fs.h           |   1 +
 libxfs/xfs_ialloc.c       |  87 +++++++++++++++++-----
 libxfs/xfs_ialloc.h       |   2 +-
 libxfs/xfs_ialloc_btree.c |  11 ++-
 libxfs/xfs_sb.c           |  27 ++++++-
 man/man8/mkfs.xfs.8       |  17 +++++
 mkfs/xfs_mkfs.c           |  37 +++++++++-
 repair/dino_chunks.c      | 162 ++++++++++++++++++++++++-----------------
 repair/incore.h           |  26 ++++++-
 repair/incore_ino.c       |   1 +
 repair/phase5.c           |  58 +++++++++++++--
 repair/prefetch.c         |  17 ++++-
 repair/sb.c               |  25 +++++--
 repair/scan.c             | 178 +++++++++++++++++++++++++++++++++++++---------
 30 files changed, 782 insertions(+), 190 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
