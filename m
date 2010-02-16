Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jaia132005 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C592813ACA25
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qWodOkUQzHs9bQwi for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084651.315955655@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] quota: special case Q_SYNC without device name
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=quotactl-cleanup-3
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

The Q_SYNC command can be called without the path to a device, in which case
it iterates over all superblocks.  Special case this variant directly in
sys_quotactl so that the other code always gets a superblock and doesn't
need to deal with this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-10 13:19:42.247004063 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-10 13:21:01.300003435 +0100
@@ -124,10 +124,17 @@ void sync_quota_sb(struct super_block *s
 }
 #endif
 
-static void sync_dquots(int type)
+static int quota_sync_all(int type)
 {
 	struct super_block *sb;
 	int cnt;
+	int ret;
+
+	if (type >= MAXQUOTAS)
+		return -EINVAL;
+	ret = security_quotactl(Q_SYNC, type, 0, NULL);
+	if (ret)
+		return ret;
 
 	spin_lock(&sb_lock);
 restart:
@@ -157,6 +164,8 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+
+	return 0;
 }
 
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
@@ -322,12 +331,9 @@ static int do_quotactl(struct super_bloc
 	case Q_SETQUOTA:
 		return quota_setquota(sb, type, id, addr);
 	case Q_SYNC:
-		if (sb) {
-			if (!sb->s_qcop->quota_sync)
-				return -ENOSYS;
-			sync_quota_sb(sb, type);
-		} else
-			sync_dquots(type);
+		if (!sb->s_qcop->quota_sync)
+			return -ENOSYS;
+		sync_quota_sb(sb, type);
 		return 0;
 	case Q_XQUOTAON:
 	case Q_XQUOTAOFF:
@@ -392,18 +398,26 @@ SYSCALL_DEFINE4(quotactl, unsigned int, 
 	cmds = cmd >> SUBCMDSHIFT;
 	type = cmd & SUBCMDMASK;
 
-	if (cmds != Q_SYNC || special) {
-		sb = quotactl_block(special);
-		if (IS_ERR(sb))
-			return PTR_ERR(sb);
+	/*
+	 * As a special case Q_SYNC can be called without a specific device.
+	 * It will iterate all superblocks that have quota enabled and call
+	 * the sync action on each of them.
+	 */
+	if (!special) {
+		if (cmds == Q_SYNC)
+			return quota_sync_all(type);
+		return -ENODEV;
 	}
 
+	sb = quotactl_block(special);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
 	ret = check_quotactl_valid(sb, type, cmds, id);
 	if (ret >= 0)
 		ret = do_quotactl(sb, type, cmds, id, addr);
-	if (sb)
-		drop_super(sb);
 
+	drop_super(sb);
 	return ret;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
