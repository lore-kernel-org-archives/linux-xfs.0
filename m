Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4E3529E06
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6E4B8F8035
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:13:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZhAWiXFvdMrPum8f for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbM-0008RQ-L8
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbM-0005Dh-G9
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/30] xfsprogs: Initial CRC support
Date: Fri, 17 May 2013 21:12:55 +1000
Message-Id: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

Hi Folks,

This is the first real "works ok" CRC patchset for xfsprogs. It
provides full support for mkfs.xfs and xfs_repair, and partial
read-only support for xfs_db.

For mkfs.xfs, it does everything properly, and filesystems that are
freshly made also run cleanly through xfs_repair and mount and run
just fine.

For xfs_repair, it reads and writes all metadata with CRC checks,
calculations and validation just like the kernel code does, but it
currently silently ignores the validation done in the IO layer.
Enabling that is future work - it involves adding buffer error checking to
every libxfs_readbuf() call that is made, and we do none of that
right now. It does, however, fully validate all the non-CRC format
metadata just as it does for non-CRC filesystems, and so the
coverage it has is the same for both CRC and non-CRC filesystems.

For xfs_db, there is read-only support for looking at the filesystem
as the xfs_db IO stack does not support CRCs at all. We need to
convert xfs_db to use the libxfs infrastructure to enable that.
Apart from that, xfs_db has partial support for the extended
metadata fields - the directory/attribute blocks don't have extended
support yet, but everything else does.

xfs_check is made special. It currently detects a version 5
superblock, and immediately exits with success. Hence it always says
CRC enabled filesystems are OK. This is a temporary change that
enables running xfstests without full support in xfs_db for all the
new metadata structures (like headers in remote symlink and
attribute blocks). Depending on if we want to keep xfs-check useful
for xfstests, we can revisit this bypass hack once xfs_db has been
converted to use the libxfs IO engine.

Overall, xfstests is now running enough to start to find bugs in the
kernel CRC code - I'm mainly hitting remote attribute block bugs
right now (generic/117!) but there's certainly less problems being
reported than I expected.

Oh, and I've tested it with external log devices and real time
devices, too.

Comments, thoughts, flames, and testing all welcome!

Cheers,

Dave.

$ git diff --minimal --stat --summary 8e78288..
 copy/xfs_copy.c            |    4 +-
 db/agf.c                   |    3 +
 db/agfl.c                  |   16 +
 db/agfl.h                  |    2 +
 db/agi.c                   |    3 +
 db/attr.c                  |   20 +-
 db/btblock.c               |  145 +++++
 db/btblock.h               |   10 +
 db/check.c                 |   34 +-
 db/dir2.c                  |   10 +-
 db/dir2sf.c                |    9 +-
 db/field.c                 |   16 +
 db/field.h                 |    8 +
 db/freesp.c                |   13 +-
 db/init.c                  |   19 +
 db/inode.c                 |   27 +
 db/inode.h                 |    3 +
 db/metadump.c              |    4 +-
 db/sb.c                    |   54 +-
 db/type.c                  |   34 +-
 db/type.h                  |    3 +-
 include/Makefile           |    4 +-
 include/libxfs.h           |  118 ++--
 include/libxlog.h          |    2 +-
 include/xfs_ag.h           |   54 +-
 include/xfs_alloc_btree.h  |   13 +-
 include/xfs_attr_leaf.h    |  124 +++-
 include/xfs_attr_remote.h  |   52 ++
 include/xfs_bmap_btree.h   |   20 +-
 include/xfs_btree.h        |   63 +-
 include/xfs_buf_item.h     |   64 +-
 include/xfs_da_btree.h     |  130 +++-
 include/xfs_dinode.h       |   37 +-
 include/xfs_dir2.h         |    7 +
 include/xfs_dir2_format.h  |  293 ++++++++-
 include/xfs_ialloc_btree.h |   10 +-
 include/xfs_inode.h        |   26 +
 include/xfs_mount.h        |    1 +
 include/xfs_quota.h        |   11 +-
 include/xfs_sb.h           |  166 ++++-
 include/xfs_symlink.h      |   45 ++
 libxfs/Makefile            |    4 +-
 libxfs/init.c              |   84 ++-
 libxfs/logitem.c           |    4 +-
 libxfs/rdwr.c              |  236 ++++---
 libxfs/trans.c             |   17 +-
 libxfs/util.c              |   29 +-
 libxfs/xfs.h               |   37 +-
 libxfs/xfs_alloc.c         |  202 ++++--
 libxfs/xfs_alloc_btree.c   |   99 ++-
 libxfs/xfs_attr.c          |  386 ++----------
 libxfs/xfs_attr_leaf.c     | 1553 ++++++++++++++++++++++++++--------------------
 libxfs/xfs_attr_remote.c   |  527 ++++++++++++++++
 libxfs/xfs_bmap.c          |   49 +-
 libxfs/xfs_bmap_btree.c    |  107 +++-
 libxfs/xfs_btree.c         |  255 ++++++--
 libxfs/xfs_da_btree.c      | 1499 +++++++++++++++++++++++++++-----------------
 libxfs/xfs_dir2_block.c    |  171 +++--
 libxfs/xfs_dir2_data.c     |  266 +++++---
 libxfs/xfs_dir2_leaf.c     |  880 ++++++++++++++++----------
 libxfs/xfs_dir2_node.c     | 1007 +++++++++++++++++++-----------
 libxfs/xfs_dir2_priv.h     |   46 +-
 libxfs/xfs_dir2_sf.c       |    8 +-
 libxfs/xfs_ialloc.c        |   78 ++-
 libxfs/xfs_ialloc_btree.c  |   80 ++-
 libxfs/xfs_inode.c         |  124 +++-
 libxfs/xfs_mount.c         |  137 +++-
 libxfs/xfs_symlink.c       |  154 +++++
 logprint/log_misc.c        |   51 +-
 logprint/log_print_all.c   |    3 +-
 logprint/log_print_trans.c |   18 +
 logprint/logprint.c        |    4 +-
 mdrestore/Makefile         |    2 +-
 mkfs/maxtrres.c            |    4 +-
 mkfs/proto.c               |    6 +-
 mkfs/xfs_mkfs.c            |  170 +++--
 mkfs/xfs_mkfs.h            |   12 +-
 repair/agheader.c          |   36 +-
 repair/attr_repair.c       |  173 +++---
 repair/dino_chunks.c       |   13 +-
 repair/dinode.c            |  200 +++---
 repair/dir2.c              |  167 ++---
 repair/dir2.h              |    6 +-
 repair/phase2.c            |    8 +-
 repair/phase3.c            |    2 +-
 repair/phase5.c            |  156 +++--
 repair/phase6.c            |  172 +++--
 repair/prefetch.c          |    9 +-
 repair/rt.c                |    4 +-
 repair/scan.c              |  169 ++---
 repair/scan.h              |   12 +-
 repair/versions.c          |    2 +-
 repair/xfs_repair.c        |    8 +-
 93 files changed, 7559 insertions(+), 3564 deletions(-)
 create mode 100644 include/xfs_attr_remote.h
 create mode 100644 include/xfs_symlink.h
 create mode 100644 libxfs/xfs_attr_remote.c
 create mode 100644 libxfs/xfs_symlink.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
