Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 142977F94
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:51:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA2AD8F8074
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8wKK6k0xRboxbfHY for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:49 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AFpmEH006939
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:48 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9AFpmED016436
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/12] xfsprogs: introduce the free inode btree
Date: Thu, 10 Oct 2013 11:51:00 -0400
Message-Id: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
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

This is the userspace portion of v1 finobt support corresponding to:

http://oss.sgi.com/archives/xfs/2013-10/msg00206.html

Patches 1-9 are straight application of the corresponding kernel patches
with omissions where appropriate. At this point, I'd suggest review of
those patches target the kernel equivalents, as this set will progress
using the kernel set as a base.

The remaining three patches add basic mkfs support, the ability to print
the agi_free_root and agi_free_level from xfs_db and fix a minor bug in
repair. Real support for repair is not yet available. Reviews on the
additional userspace specific bits are appreciated. Otherwise, this set
is probably more useful for testing/experimentation on the feature
itself.

Brian

Brian Foster (12):
  xfsprogs: refactor xfs_ialloc_btree.c to support multiple inobt
    numbers
  xfsprogs: reserve v5 superblock read-only compat. feature bit for
    finobt
  xfsprogs: support the XFS_BTNUM_FINOBT free inode btree type
  xfsprogs: update inode allocation/free transaction reservations for
    finobt
  xfsprogs: insert newly allocated inode chunks into the finobt
  xfsprogs: use and update the finobt on inode allocation
  xfsprogs: refactor xfs_difree() inobt bits into xfs_difree_inobt()
    helper
  xfsprogs: update the finobt on inode free
  xfsprogs: enable the finobt feature on v5 superblocks
  xfsprogs/mkfs: finobt mkfs support
  xfsprogs/db: finobt support
  xfsprogs/repair: account for finobt in ag 0 geometry pre-calculation

 db/agi.c                   |   2 +
 db/btblock.c               |  12 +
 include/xfs_ag.h           |  32 ++-
 include/xfs_btree.h        |   3 +
 include/xfs_ialloc_btree.h |  17 +-
 include/xfs_sb.h           |  10 +-
 include/xfs_trans_space.h  |   7 +-
 include/xfs_types.h        |   2 +-
 libxfs/xfs_btree.c         |   6 +-
 libxfs/xfs_ialloc.c        | 616 ++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_ialloc_btree.c  |  68 ++++-
 libxfs/xfs_trans_resv.c    |  47 +++-
 mkfs/xfs_mkfs.c            |  97 +++++--
 repair/xfs_repair.c        |   2 +
 14 files changed, 770 insertions(+), 151 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
