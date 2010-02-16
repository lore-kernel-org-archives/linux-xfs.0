Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jboP132007 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBD8313ACA26
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WHtFqXbJDDmcrXSS for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084651.550580191@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/10] quota: simplify permission checking
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=quotactl-cleanup-4
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

Stop having complicated different routines for checking permissions for
XQM vs "VFS" quotas.  Instead do the checks for having sb->s_qcop and
a valid type diretly in do_quotactl, and munge the *quotactl_valid functions
into a check_quotactl_permission helper that only checks for permissions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-11 15:54:40.313002736 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-11 16:11:22.005254866 +0100
@@ -21,69 +21,30 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
-/* Check validity of generic quotactl commands */
-static int generic_quotactl_valid(struct super_block *sb, int type, int cmd,
-				  qid_t id)
+static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
+				     qid_t id)
 {
-	if (type >= MAXQUOTAS)
-		return -EINVAL;
-	if (!sb && cmd != Q_SYNC)
-		return -ENODEV;
-	/* Is operation supported? */
-	if (sb && !sb->s_qcop)
-		return -ENOSYS;
-
-	/* Check privileges */
-	if (cmd == Q_GETQUOTA) {
-		if (((type == USRQUOTA && current_euid() != id) ||
-		     (type == GRPQUOTA && !in_egroup_p(id))) &&
-		    !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-	}
-	else if (cmd != Q_GETFMT && cmd != Q_SYNC && cmd != Q_GETINFO)
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-	return 0;
-}
-
-/* Check validity of XFS Quota Manager commands */
-static int xqm_quotactl_valid(struct super_block *sb, int type, int cmd,
-			      qid_t id)
-{
-	if (type >= XQM_MAXQUOTAS)
-		return -EINVAL;
-	if (!sb)
-		return -ENODEV;
-	if (!sb->s_qcop)
-		return -ENOSYS;
-
-	/* Check privileges */
-	if (cmd == Q_XGETQUOTA) {
-		if (((type == XQM_USRQUOTA && current_euid() != id) ||
-		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
-		     !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-	} else if (cmd != Q_XGETQSTAT && cmd != Q_XQUOTASYNC) {
-		if (!capable(CAP_SYS_ADMIN))
+	switch (cmd) {
+	/* these commands do not require any special privilegues */
+ 	case Q_GETFMT:
+ 	case Q_SYNC:
+ 	case Q_GETINFO:
+ 	case Q_XGETQSTAT:
+ 	case Q_XQUOTASYNC:
+ 		break;
+	/* allow to query information for dquots we "own" */
+	case Q_GETQUOTA:
+	case Q_XGETQUOTA:
+		if ((type == USRQUOTA && current_euid() == id) ||
+		    (type == GRPQUOTA && in_egroup_p(id)))
+			break;
+		/*FALLTHROUGH*/
+ 	default:
+ 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 	}
 
-	return 0;
-}
-
-static int check_quotactl_valid(struct super_block *sb, int type, int cmd,
-				qid_t id)
-{
-	int error;
-
-	if (XQM_COMMAND(cmd))
-		error = xqm_quotactl_valid(sb, type, cmd, id);
-	else
-		error = generic_quotactl_valid(sb, type, cmd, id);
-	if (!error)
-		error = security_quotactl(cmd, type, id, sb);
-	return error;
+	return security_quotactl(cmd, type, id, sb);
 }
 
 #ifdef CONFIG_QUOTA
@@ -313,6 +274,17 @@ static int quota_getxquota(struct super_
 static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		       void __user *addr)
 {
+	int ret;
+
+	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
+ 		return -EINVAL;
+	if (!sb->s_qcop)
+ 		return -ENOSYS;
+
+	ret = check_quotactl_permission(sb, type, cmd, id);
+	if (ret < 0)
+		return ret;
+
 	switch (cmd) {
 	case Q_QUOTAON:
 		return quota_quotaon(sb, type, cmd, id, addr);
@@ -413,9 +385,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, 
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
-	ret = check_quotactl_valid(sb, type, cmds, id);
-	if (ret >= 0)
-		ret = do_quotactl(sb, type, cmds, id, addr);
+	ret = do_quotactl(sb, type, cmds, id, addr);
 
 	drop_super(sb);
 	return ret;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
