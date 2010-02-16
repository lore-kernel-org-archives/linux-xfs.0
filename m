Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jbKf132008 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EAFE1D3898
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LYSgYWPoMfBehEDz for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Message-Id: <20100216084652.167390973@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/10] quota: remove invalid optimization from quota_sync_all
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=make-quota_sync_all-generic
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

Checking the "VFS" quota enabled and dirty bits from generic code means
this code will never get called for other implementations, e.g. XFS and
GFS2.  Grabbing the reference on the superblock really isn't much overhead
for a global Q_SYNC call, so just drop this optimization.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-16 00:24:14.432004170 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-16 00:24:58.589255532 +0100
@@ -51,7 +51,6 @@ static int check_quotactl_permission(str
 static int quota_sync_all(int type)
 {
 	struct super_block *sb;
-	int cnt;
 	int ret;
 
 	if (type >= MAXQUOTAS)
@@ -66,20 +65,6 @@ restart:
 		if (!sb->s_qcop || !sb->s_qcop->quota_sync)
 			continue;
 
-		/* This test just improves performance so it needn't be
-		 * reliable... */
-		for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-			if (type != -1 && type != cnt)
-				continue;
-			if (!sb_has_quota_active(sb, cnt))
-				continue;
-			if (!info_dirty(&sb_dqopt(sb)->info[cnt]) &&
-			   list_empty(&sb_dqopt(sb)->info[cnt].dqi_dirty_list))
-				continue;
-			break;
-		}
-		if (cnt == MAXQUOTAS)
-			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
