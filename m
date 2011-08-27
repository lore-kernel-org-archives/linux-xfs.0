Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7R6EDoE179887 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 01:14:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF0321937561
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 23:14:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	X5aYQECouzklVXcd for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 23:14:12 -0700 (PDT)
Date: Sat, 27 Aug 2011 02:14:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] writeback: avoid redirtying when ->write_inode failed
	to clear I_DIRTY
Message-ID: <20110827061409.GA6854@infradead.org>
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
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Right now ->write_inode has no way to safely return a EAGAIN without explicitly
redirtying the inode, as we would lose the dirty state otherwise.  Most
filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
the flusher thread when ->write_inode hits contentended inode locks.  A
contended ilock is something XFS can hit very easibly when extending files, as
the data I/O completion handler takes the lock to update the size, and the
->write_inode call can race with it fairly easily if writing enough data
in one go so that the completion for the first write come in just before
we call ->write_inode.

Change the handling of this case to use requeue_io for a quick retry instead
of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
delaying the writeout more and more with every failed attempt to get the lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2011-08-26 14:47:42.137050059 +0200
+++ linux-2.6/fs/fs-writeback.c	2011-08-26 15:06:47.003493601 +0200
@@ -464,8 +464,18 @@ writeback_single_inode(struct inode *ino
 			 * operations, such as delayed allocation during
 			 * submission or metadata updates after data IO
 			 * completion.
+			 *
+			 * For the latter case it is very important to give
+			 * the inode another turn on b_more_io instead of
+			 * redirtying it.  Constantly moving dirtied_when
+			 * forward will prevent us from ever writing out
+			 * the metadata dirtied in the I/O completion handler.
+			 *
+			 * For files on XFS that constantly get appended to
+			 * calling redirty_tail means they will never get
+			 * their updated i_size written out.
 			 */
-			redirty_tail(inode, wb);
+			requeue_io(inode, wb);
 		} else {
 			/*
 			 * The inode is clean.  At this point we either have

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
