Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTMIiG1009496 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 16:18:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CF545072E
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:18:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KVm0WybmbwtRE3cu for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:18:43 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHQRf-0002f9-NW
	for xfs@oss.sgi.com; Mon, 29 Dec 2008 22:18:43 +0000
Message-Id: <20081229221843.642347000@bombadil.infradead.org>
References: <20081229221802.268877000@bombadil.infradead.org>
Date: Mon, 29 Dec 2008 17:18:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 3/3] add a lock class for group/project dquots
Content-Disposition: inline; filename=xfs-add-quota-classes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

We can have both a user and a group/project dquot locked at the same time,
as long as the user dquot is locked first.  Tell lockdep about that fact
by making the group/project dquots a different lock class.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-12-29 12:24:33.018737674 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2008-12-29 12:29:35.132612895 +0100
@@ -73,6 +73,8 @@ int xfs_dqreq_num;
 int xfs_dqerror_mod = 33;
 #endif
 
+static struct lock_class_key xfs_dquot_other_class;
+
 /*
  * Allocate and initialize a dquot. We don't always allocate fresh memory;
  * we try to reclaim a free dquot if the number of incore dquots are above
@@ -139,7 +141,15 @@ xfs_qm_dqinit(
 		 ASSERT(dqp->q_trace);
 		 xfs_dqtrace_entry(dqp, "DQRECLAIMED_INIT");
 #endif
-	 }
+	}
+
+	/*
+	 * In either case we need to make sure group quotas have a different
+	 * lock class than user quotas, to make sure lockdep knows we can
+	 * locks of one of each at the same time.
+	 */
+	if (!(type & XFS_DQ_USER))
+		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
 
 	/*
 	 * log item gets initialized later

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
