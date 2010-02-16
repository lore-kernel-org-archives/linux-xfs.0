Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jcTc132018 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 430A21CD31F5
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ofqlUItUAt8SChHO for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:56 -0800 (PST)
Message-Id: <20100216084652.945507392@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/10] quota: drop permission checks from
	xfs_fs_set_xstate/xfs_fs_set_xquota
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-drop-permission-checks
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
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

We already do these checks in the generic code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_quotaops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_quotaops.c	2010-02-16 00:15:27.709004380 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_quotaops.c	2010-02-16 00:25:10.992007173 +0100
@@ -68,8 +68,6 @@ xfs_fs_set_xstate(
 		return -EROFS;
 	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	if (uflags & XFS_QUOTA_UDQ_ACCT)
 		flags |= XFS_UQUOTA_ACCT;
@@ -130,8 +128,6 @@ xfs_fs_set_xquota(
 		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	return -xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
