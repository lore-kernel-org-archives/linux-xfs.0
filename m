Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3EEA7F5F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:37:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75AC0AC00D
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:37:57 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4z1WKqqt2uCdqiHA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:55 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/25] quota: Wire up ->quota_{enable,
	disable} callbacks into Q_QUOTA{ON, OFF}
Date: Thu, 18 Dec 2014 16:37:19 +0100
Message-Id: <1418917059-23870-6-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Make Q_QUOTAON / Q_QUOTAOFF quotactl call ->quota_enable /
->quota_disable callback when provided. To match current behavior of
ocfs2 & ext4 we make these quotactls turn on / off quota enforcement for
appropriate quota type.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c         | 31 +++++++++++++++++++++++++++----
 include/linux/quotaops.h |  2 ++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 5b307e2b5719..748716ffee48 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -66,18 +66,43 @@ static int quota_sync_all(int type)
 	return ret;
 }
 
+unsigned int qtype_limit_flag(int type)
+{
+	switch (type) {
+	case USRQUOTA:
+		return FS_QUOTA_UDQ_ENFD;
+	case GRPQUOTA:
+		return FS_QUOTA_GDQ_ENFD;
+	case PRJQUOTA:
+		return FS_QUOTA_PDQ_ENFD;
+	}
+	return 0;
+}
+
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
 		         struct path *path)
 {
-	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta)
+	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta &&
+	    !sb->s_qcop->quota_enable)
 		return -ENOSYS;
 	if (sb->s_qcop->quota_on_meta)
 		return sb->s_qcop->quota_on_meta(sb, type, id);
+	if (sb->s_qcop->quota_enable)
+		return sb->s_qcop->quota_enable(sb, qtype_limit_flag(type));
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	return sb->s_qcop->quota_on(sb, type, id, path);
 }
 
+static int quota_quotaoff(struct super_block *sb, int type)
+{
+	if (!sb->s_qcop->quota_off && !sb->s_qcop->quota_disable)
+		return -ENOSYS;
+	if (sb->s_qcop->quota_disable)
+		return sb->s_qcop->quota_disable(sb, qtype_limit_flag(type));
+	return sb->s_qcop->quota_off(sb, type);
+}
+
 static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 {
 	__u32 fmt;
@@ -328,9 +353,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	case Q_QUOTAON:
 		return quota_quotaon(sb, type, cmd, id, path);
 	case Q_QUOTAOFF:
-		if (!sb->s_qcop->quota_off)
-			return -ENOSYS;
-		return sb->s_qcop->quota_off(sb, type);
+		return quota_quotaoff(sb, type);
 	case Q_GETFMT:
 		return quota_getfmt(sb, type, addr);
 	case Q_GETINFO:
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f23538a6e411..20b77d115551 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -386,4 +386,6 @@ static inline void dquot_release_reservation_block(struct inode *inode,
 	__dquot_free_space(inode, nr << inode->i_blkbits, DQUOT_SPACE_RESERVE);
 }
 
+unsigned int qtype_limit_flag(int type);
+
 #endif /* _LINUX_QUOTAOPS_ */
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
