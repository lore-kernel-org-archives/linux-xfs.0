Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6067A7F6D
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E38F7AC006
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:47 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ysDiCFQvkX5FdSGq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:46 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/11] quota: Remove quota_on_meta callback
Date: Tue, 11 Nov 2014 22:04:23 +0100
Message-Id: <1415739865-2438-10-git-send-email-jack@suse.cz>
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

There are no more users for quota_on_meta callback. Just remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 5 +----
 include/linux/quota.h | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 162d533c4997..5650b7ce4714 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -79,11 +79,8 @@ unsigned int qtype_limit_flag(int type)
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
 		         struct path *path)
 {
-	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta &&
-	    !sb->s_qcop->sysquota_on)
+	if (!sb->s_qcop->quota_on && !sb->s_qcop->sysquota_on)
 		return -ENOSYS;
-	if (sb->s_qcop->quota_on_meta)
-		return sb->s_qcop->quota_on_meta(sb, type, id);
 	if (sb->s_qcop->sysquota_on)
 		return sb->s_qcop->sysquota_on(sb, qtype_limit_flag(type));
 	if (IS_ERR(path))
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 3a046676e4aa..06a214a21778 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -319,7 +319,6 @@ struct path;
 /* Operations handling requests from userspace */
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
-	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
 	int (*quota_sync)(struct super_block *, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
