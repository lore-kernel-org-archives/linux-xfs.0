Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jaoq131997 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766001D3897
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TjzKjGIpwSr4HVHc for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084651.117932323@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/10] quota: clean up checks for supported quota methods
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=quotactl-cleanup-2
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

Move the checks for sb->s_qcop->foo next to the actual calls for them, same
for sb_has_quota_active checks where applicable.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-09 17:10:31.563263527 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-09 17:11:23.314004970 +0100
@@ -33,54 +33,6 @@ static int generic_quotactl_valid(struct
 	if (sb && !sb->s_qcop)
 		return -ENOSYS;
 
-	switch (cmd) {
-		case Q_GETFMT:
-			break;
-		case Q_QUOTAON:
-			if (!sb->s_qcop->quota_on)
-				return -ENOSYS;
-			break;
-		case Q_QUOTAOFF:
-			if (!sb->s_qcop->quota_off)
-				return -ENOSYS;
-			break;
-		case Q_SETINFO:
-			if (!sb->s_qcop->set_info)
-				return -ENOSYS;
-			break;
-		case Q_GETINFO:
-			if (!sb->s_qcop->get_info)
-				return -ENOSYS;
-			break;
-		case Q_SETQUOTA:
-			if (!sb->s_qcop->set_dqblk)
-				return -ENOSYS;
-			break;
-		case Q_GETQUOTA:
-			if (!sb->s_qcop->get_dqblk)
-				return -ENOSYS;
-			break;
-		case Q_SYNC:
-			if (sb && !sb->s_qcop->quota_sync)
-				return -ENOSYS;
-			break;
-		default:
-			return -EINVAL;
-	}
-
-	/* Is quota turned on for commands which need it? */
-	switch (cmd) {
-		case Q_GETFMT:
-		case Q_GETINFO:
-		case Q_SETINFO:
-		case Q_SETQUOTA:
-		case Q_GETQUOTA:
-			/* This is just an informative test so we are satisfied
-			 * without the lock */
-			if (!sb_has_quota_active(sb, type))
-				return -ESRCH;
-	}
-
 	/* Check privileges */
 	if (cmd == Q_GETQUOTA) {
 		if (((type == USRQUOTA && current_euid() != id) ||
@@ -106,33 +58,6 @@ static int xqm_quotactl_valid(struct sup
 	if (!sb->s_qcop)
 		return -ENOSYS;
 
-	switch (cmd) {
-		case Q_XQUOTAON:
-		case Q_XQUOTAOFF:
-		case Q_XQUOTARM:
-			if (!sb->s_qcop->set_xstate)
-				return -ENOSYS;
-			break;
-		case Q_XGETQSTAT:
-			if (!sb->s_qcop->get_xstate)
-				return -ENOSYS;
-			break;
-		case Q_XSETQLIM:
-			if (!sb->s_qcop->set_xquota)
-				return -ENOSYS;
-			break;
-		case Q_XGETQUOTA:
-			if (!sb->s_qcop->get_xquota)
-				return -ENOSYS;
-			break;
-		case Q_XQUOTASYNC:
-			if (!sb->s_qcop->quota_sync)
-				return -ENOSYS;
-			break;
-		default:
-			return -EINVAL;
-	}
-
 	/* Check privileges */
 	if (cmd == Q_XGETQUOTA) {
 		if (((type == XQM_USRQUOTA && current_euid() != id) ||
@@ -238,12 +163,13 @@ static int quota_quotaon(struct super_bl
 		         void __user *addr)
 {
 	char *pathname;
-	int ret;
+	int ret = -ENOSYS;
 
 	pathname = getname(addr);
 	if (IS_ERR(pathname))
 		return PTR_ERR(pathname);
-	ret = sb->s_qcop->quota_on(sb, type, id, pathname, 0);
+	if (sb->s_qcop->quota_on)
+		ret = sb->s_qcop->quota_on(sb, type, id, pathname, 0);
 	putname(pathname);
 	return ret;
 }
@@ -269,6 +195,10 @@ static int quota_getinfo(struct super_bl
 	struct if_dqinfo info;
 	int ret;
 
+	if (!sb_has_quota_active(sb, type))
+		return -ESRCH;
+	if (!sb->s_qcop->get_info)
+		return -ENOSYS;
 	ret = sb->s_qcop->get_info(sb, type, &info);
 	if (!ret && copy_to_user(addr, &info, sizeof(info)))
 		return -EFAULT;
@@ -281,6 +211,10 @@ static int quota_setinfo(struct super_bl
 
 	if (copy_from_user(&info, addr, sizeof(info)))
 		return -EFAULT;
+	if (!sb_has_quota_active(sb, type))
+		return -ESRCH;
+	if (!sb->s_qcop->set_info)
+		return -ENOSYS;
 	return sb->s_qcop->set_info(sb, type, &info);
 }
 
@@ -290,6 +224,10 @@ static int quota_getquota(struct super_b
 	struct if_dqblk idq;
 	int ret;
 
+	if (!sb_has_quota_active(sb, type))
+		return -ESRCH;
+	if (!sb->s_qcop->get_dqblk)
+		return -ENOSYS;
 	ret = sb->s_qcop->get_dqblk(sb, type, id, &idq);
 	if (ret)
 		return ret;
@@ -305,6 +243,10 @@ static int quota_setquota(struct super_b
 
 	if (copy_from_user(&idq, addr, sizeof(idq)))
 		return -EFAULT;
+	if (!sb_has_quota_active(sb, type))
+		return -ESRCH;
+	if (!sb->s_qcop->set_dqblk)
+		return -ENOSYS;
 	return sb->s_qcop->set_dqblk(sb, type, id, &idq);
 }
 
@@ -314,6 +256,8 @@ static int quota_setxstate(struct super_
 
 	if (copy_from_user(&flags, addr, sizeof(flags)))
 		return -EFAULT;
+	if (!sb->s_qcop->set_xstate)
+		return -ENOSYS;
 	return sb->s_qcop->set_xstate(sb, flags, cmd);
 }
 
@@ -321,7 +265,9 @@ static int quota_getxstate(struct super_
 {
 	struct fs_quota_stat fqs;
 	int ret;
-		
+
+	if (!sb->s_qcop->get_xstate)
+		return -ENOSYS;
 	ret = sb->s_qcop->get_xstate(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
@@ -335,6 +281,8 @@ static int quota_setxquota(struct super_
 
 	if (copy_from_user(&fdq, addr, sizeof(fdq)))
 		return -EFAULT;
+	if (!sb->s_qcop->set_xquota)
+		return -ENOSYS;
 	return sb->s_qcop->set_xquota(sb, type, id, &fdq);
 }
 
@@ -344,6 +292,8 @@ static int quota_getxquota(struct super_
 	struct fs_disk_quota fdq;
 	int ret;
 
+	if (!sb->s_qcop->get_xquota)
+		return -ENOSYS;
 	ret = sb->s_qcop->get_xquota(sb, type, id, &fdq);
 	if (!ret && copy_to_user(addr, &fdq, sizeof(fdq)))
 		return -EFAULT;
@@ -358,6 +308,8 @@ static int do_quotactl(struct super_bloc
 	case Q_QUOTAON:
 		return quota_quotaon(sb, type, cmd, id, addr);
 	case Q_QUOTAOFF:
+		if (!sb->s_qcop->quota_off)
+			return -ENOSYS;
 		return sb->s_qcop->quota_off(sb, type, 0);
 	case Q_GETFMT:
 		return quota_getfmt(sb, type, addr);
@@ -370,9 +322,11 @@ static int do_quotactl(struct super_bloc
 	case Q_SETQUOTA:
 		return quota_setquota(sb, type, id, addr);
 	case Q_SYNC:
-		if (sb)
+		if (sb) {
+			if (!sb->s_qcop->quota_sync)
+				return -ENOSYS;
 			sync_quota_sb(sb, type);
-		else
+		} else
 			sync_dquots(type);
 		return 0;
 	case Q_XQUOTAON:
@@ -386,13 +340,12 @@ static int do_quotactl(struct super_bloc
 	case Q_XGETQUOTA:
 		return quota_getxquota(sb, type, id, addr);
 	case Q_XQUOTASYNC:
+		if (!sb->s_qcop->quota_sync)
+			return -ENOSYS;
 		return sb->s_qcop->quota_sync(sb, type);
-	/* We never reach here unless validity check is broken */
 	default:
-		BUG();
+		return -EINVAL;
 	}
-
-	return 0;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
