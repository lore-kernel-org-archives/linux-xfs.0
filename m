Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A6347F7E
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AAE69AC007
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CL1HKlc1R0RTjqh8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:45 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/11] quota: Wire up ->sysquota_{on,
	off} callbacks into Q_QUOTA{ON, OFF}
Date: Tue, 11 Nov 2014 22:04:19 +0100
Message-Id: <1415739865-2438-6-git-send-email-jack@suse.cz>
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Make Q_QUOTAON / Q_QUOTAOFF quotactl call ->sysquota_on / ->sysquota_off
callback when provided. To match current behavior of ocfs2 & ext4 we
make these quotactls turn on / off quota enforcement for appropriate
quota type.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c         | 31 +++++++++++++++++++++++++++----
 include/linux/quotaops.h |  2 ++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index fb22cebff946..162d533c4997 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -63,18 +63,43 @@ static int quota_sync_all(int type)
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
+	    !sb->s_qcop->sysquota_on)
 		return -ENOSYS;
 	if (sb->s_qcop->quota_on_meta)
 		return sb->s_qcop->quota_on_meta(sb, type, id);
+	if (sb->s_qcop->sysquota_on)
+		return sb->s_qcop->sysquota_on(sb, qtype_limit_flag(type));
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	return sb->s_qcop->quota_on(sb, type, id, path);
 }
 
+static int quota_quotaoff(struct super_block *sb, int type)
+{
+	if (!sb->s_qcop->quota_off && !sb->s_qcop->sysquota_off)
+		return -ENOSYS;
+	if (sb->s_qcop->sysquota_off)
+		return sb->s_qcop->sysquota_off(sb, qtype_limit_flag(type));
+	return sb->s_qcop->quota_off(sb, type);
+}
+
 static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 {
 	__u32 fmt;
@@ -319,9 +344,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
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
index 1d3eee594cd6..5947a9e54862 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -386,4 +386,6 @@ static inline void dquot_release_reservation_block(struct inode *inode,
 	__dquot_free_space(inode, nr << inode->i_blkbits, DQUOT_SPACE_RESERVE);
 }
 
+unsigned int qtype_limit_flag(int type);
+
 #endif /* _LINUX_QUOTAOPS_ */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
