Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 144027F67
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 894E1AC005
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pbnSCMJeHByxXuCe for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:47 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPkMw029400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:46 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkJC004522
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 00/11] xfs: introduce the free inode btree
Date: Tue,  3 Sep 2013 14:24:57 -0400
Message-Id: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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

This is an RFC for the kernel work to support a free inode btree. The free inode
btree (finobt) is equivalent to the existing inode allocation btree with the
exception that the finobt only tracks inode chunks with at least one free inode.
The purpose is to improve lookups for free inode clusters for inode allocation.

Newly allocated inode chunks by definition contain free inodes and are thus
inserted into the finobt immediately. The record for a previously full inode
chunk is inserted to the finobt when the first inode is freed. A record is
removed from the finobt when the last free inode has been allocated or the
entire chunk is completely deallocated.

Patches 1-3 refactor some ialloc btree code to introduce the new finobt type and
feature bit. Patches 4-7 fix up the transaction handling for inode allocation
and deallocation to account for the new tree. Patches 8-10 add the finobt
management code to insert, remove and modify records as appropriate. Patch 11
fixes growfs to support the finobt.

Thoughts, reviews, flames appreciated.

NOTES:
- This is RFC because it is lightly tested and I don't have much userspace code
at the moment (though most of this code should apply).
- I'm not totally sure about the scope of change in patch 6 (use correct
transaction reservations in xfs_inactive()). I started off minimally altering
the reserved blocks value, but the existing transaction management seemed
strange enough that I ended up with the current patch. I figured I'd start here
and pare it back as necessary if the changes are bogus or lead to other
problems.
- I've yet to do any performance testing to measure the benefit of patch 9.

Brian

Brian Foster (11):
  xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
  xfs: reserve v5 superblock read-only compat. feature bit for finobt
  xfs: support the XFS_BTNUM_FINOBT free inode btree type
  xfs: update inode allocation transaction reservations for finobt
  xfs: update ifree transaction reservations for finobt
  xfs: use correct transaction reservations in xfs_inactive()
  xfs: retry trans reservation on ENOSPC in xfs_inactive()
  xfs: insert newly allocated inode chunks into the finobt
  xfs: use and update the finobt on inode allocation
  xfs: update the finobt on inode free
  xfs: add finobt support to growfs

 fs/xfs/xfs_ag.h           |   7 +-
 fs/xfs/xfs_btree.c        |   6 +-
 fs/xfs/xfs_btree.h        |   3 +
 fs/xfs/xfs_fsops.c        |  32 +++++
 fs/xfs/xfs_ialloc.c       | 343 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_ialloc_btree.c |  37 +++--
 fs/xfs/xfs_ialloc_btree.h |  17 ++-
 fs/xfs/xfs_inode.c        |  82 ++++++-----
 fs/xfs/xfs_itable.c       |   6 +-
 fs/xfs/xfs_log_recover.c  |   2 +
 fs/xfs/xfs_sb.h           |  10 +-
 fs/xfs/xfs_stats.h        |  18 ++-
 fs/xfs/xfs_trans_resv.c   |  14 +-
 fs/xfs/xfs_trans_space.h  |   4 +-
 fs/xfs/xfs_types.h        |   2 +-
 15 files changed, 500 insertions(+), 83 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
