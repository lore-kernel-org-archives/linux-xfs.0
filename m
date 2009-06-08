Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58Fhk4f235766 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 10:43:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82F2E2DD053
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 08:44:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id C4Wu3TyYKmMfarmX for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 08:44:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MDh13-0007Mz-7P
	for xfs@oss.sgi.com; Mon, 08 Jun 2009 15:44:05 +0000
Date: Mon, 8 Jun 2009 11:44:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: pull request: sync changes + misc other bits for 2.6.31
Message-ID: <20090608154405.GA28165@infradead.org>
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

Hi Felix,

please pull git://git.kernel.org/pub/scm/fs/xfs/xfs.git for the
following changes:


Christoph Hellwig (8):
      xfs: update max log size
      xfs: validate quota log items during log recovery
      xfs: kill xfs_qmops
      xfs: split inode flushing from xfs_sync_inodes_ag
      xfs: use generic inode iterator in xfs_qm_dqrele_all_inodes
      xfs: split xfs_sync_inodes
      xfs: remove SYNC_IOWAIT
      xfs: remove SYNC_BDFLUSH

Dave Chinner (4):
      xfs: split inode data writeback from xfs_sync_inodes_ag
      xfs: factor out inode validation for sync
      xfs: remove unused parameter from xfs_reclaim_inodes
      xfs: introduce a per-ag inode iterator

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
