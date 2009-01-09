Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09MD0qw027471 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:13:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A577276F86
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:13:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gM8z9Q2VsCeJFfxb for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:13:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LLPbA-0003vY-9q
	for xfs@oss.sgi.com; Fri, 09 Jan 2009 22:13:00 +0000
Message-Id: <20090109221300.068810000@bombadil.infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
Date: Fri, 09 Jan 2009 17:11:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: add a separate lock class for the per-mount list of
	dquots
Content-Disposition: inline;
	filename=xfs-fix-xfs_qm_dqusage_adjust-lockdep-warning
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

We can have both a a quota hash chain and the per-mount list locked at
the same time.  But given that both use the same struct dqhash as list
head we have to tell lockdep that they are different lock classes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2008-12-29 01:27:21.000000000 +0000
+++ xfs/fs/xfs/quota/xfs_qm.c	2008-12-29 01:34:48.000000000 +0000
@@ -1068,6 +1068,13 @@
 	return 0;
 }
 
+/*
+ * The hash chains and the mplist use the same xfs_dqhash structure as
+ * their list head, but we can take the mplist qh_lock and one of the
+ * hash qh_locks at the same time without any problem as they aren't
+ * related.
+ */
+static struct lock_class_key xfs_quota_mplist_class;
 
 /*
  * This initializes all the quota information that's kept in the
@@ -1103,6 +1110,8 @@
 	}
 
 	xfs_qm_list_init(&qinf->qi_dqlist, "mpdqlist", 0);
+	lockdep_set_class(&qinf->qi_dqlist.qh_lock, &xfs_quota_mplist_class);
+
 	qinf->qi_dqreclaims = 0;
 
 	/* mutex used to serialize quotaoffs */

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
