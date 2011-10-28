Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3hQ9145476 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 744E9203865
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OE1lYbeiz9A7AeXJ for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHp-00038z-VZ
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100341.944837348@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 35/45] xfs: remove log item from AIL in xfs_qm_dqflush after a
	shutdown
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-delete-dquot-from-ail-earlier
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

If a filesystem has been forced shutdown we are never going to write dquots
to disk, which means the dquot items will stay in the AIL forever.
Currently that is not a problem, but a pending chance requires us to
empty the AIL before shutting down the filesystem, in which case this
behaviour is lethal.  Make sure to remove the log item from the AIL
to allow emptying the AIL on shutdown filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:08.598176882 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:11.298171586 +0200
@@ -1010,10 +1010,21 @@ xfs_qm_dqflush(
 	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this dquot
-	 * to disk, because the log record didn't make it to disk!
+	 * to disk, because the log record didn't make it to disk.
+	 *
+	 * We also have to remove the log item from the AIL in this case,
+	 * as we wait for an emptry AIL as part of the unmount process.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 		dqp->dq_flags &= ~XFS_DQ_DIRTY;
+
+		spin_lock(&mp->m_ail->xa_lock);
+		if (lip->li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(mp->m_ail, lip);
+		else
+			spin_unlock(&mp->m_ail->xa_lock);
+
 		xfs_dqfunlock(dqp);
 		return XFS_ERROR(EIO);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
