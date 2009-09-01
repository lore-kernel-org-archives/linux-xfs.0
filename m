Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n812bvSH139915 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 21:38:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83A05413BD3
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 19:38:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OAMQ49ITDedBY83I for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 19:38:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MiJDM-0000TP-PE
	for xfs@oss.sgi.com; Tue, 01 Sep 2009 02:35:20 +0000
Date: Mon, 31 Aug 2009 22:35:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: pull request
Message-ID: <20090901023520.GA32097@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

First big batch for 2.6.32:  the ialloc changes + xfs_trans_iget
simplification plus the O_SYNC fixup.


The following changes since commit 1da1daed813c534263a87ffc36d5b775e65231ad:
  Felix Blyakher (1):
        Merge branch 'master' of ssh+git://oss.sgi.com/oss/git/xfs/xfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs.git master

Christoph Hellwig (6):
      xfs: improve xfs_inobt_get_rec prototype
      xfs: improve xfs_inobt_update prototype
      xfs: untangle xfs_dialloc
      xfs: rationalize xfs_inobt_lookup*
      xfs: merge fsync and O_SYNC handling
      xfs: simplify xfs_trans_iget

Dave Chinner (3):
      xfs: factor out inode initialisation
      xfs: factor out debug checks from xfs_dialloc and xfs_difree
      xfs: speed up free inode search

 fs/xfs/linux-2.6/xfs_aops.c |    1 -
 fs/xfs/linux-2.6/xfs_file.c |   19 +-
 fs/xfs/linux-2.6/xfs_lrw.c  |    7 +-
 fs/xfs/xfs_ag.h             |    9 +
 fs/xfs/xfs_ialloc.c         |  805 ++++++++++++++++++++++---------------------
 fs/xfs/xfs_ialloc.h         |   18 +-
 fs/xfs/xfs_iget.c           |   27 --
 fs/xfs/xfs_inode.h          |    3 -
 fs/xfs/xfs_inode_item.c     |   10 -
 fs/xfs/xfs_inode_item.h     |    2 -
 fs/xfs/xfs_itable.c         |   96 +++---
 fs/xfs/xfs_rw.c             |   84 -----
 fs/xfs/xfs_rw.h             |    1 -
 fs/xfs/xfs_trans.h          |    2 +-
 fs/xfs/xfs_trans_inode.c    |   86 +-----
 fs/xfs/xfs_vnodeops.c       |   11 +-
 16 files changed, 499 insertions(+), 682 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
