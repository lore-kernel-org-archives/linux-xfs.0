Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EHFodU234926 for <xfs@oss.sgi.com>; Thu, 14 May 2009 12:15:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53D79287FFC
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Sg8IVKeQlyliJGZY for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:58 -0700 (PDT)
Message-Id: <20090514171233.942489000@bombadil.infradead.org>
Date: Thu, 14 May 2009 13:12:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] inode sync refactoring
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a respin of Dave's xfs_sync_inodes refactoring plus a couple of new
patches.  The major difference to the original series is sorting out the
pag_ici_lock locking which was busted in many ways.  We now held the lock
exactly as long as the current code, to do that I had to give up on the
lookup vs execute split for the callbacks which actually improved the
code flow a bit, at the expense of exposing the lock to the callbacks.

The other change is that inode flushing still uses the same old algorithm
instead of bringing over the optimizations from xfs_fs_write_inode which
caused some spurious regressions in test 183 for me.  I still plan to get
these two paths unified, but let's leave that for a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
