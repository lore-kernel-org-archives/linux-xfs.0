Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 72456801C
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 08:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0140BAC004
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 06:34:44 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jDNFpe4FZW6I3Ach (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 06:34:43 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/16] quota: Remove quota_on_meta callback
Date: Mon, 26 Jan 2015 15:34:24 +0100
Message-Id: <1422282873-3381-8-git-send-email-jack@suse.cz>
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
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

There are no more users for quota_on_meta callback. Just remove it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 5 +----
 include/linux/quota.h | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index ce78a70a596f..d14a799c7785 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -82,11 +82,8 @@ unsigned int qtype_enforce_flag(int type)
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
 		         struct path *path)
 {
-	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta &&
-	    !sb->s_qcop->quota_enable)
+	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_enable)
 		return -ENOSYS;
-	if (sb->s_qcop->quota_on_meta)
-		return sb->s_qcop->quota_on_meta(sb, type, id);
 	if (sb->s_qcop->quota_enable)
 		return sb->s_qcop->quota_enable(sb, qtype_enforce_flag(type));
 	if (IS_ERR(path))
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 4da497b807c4..0938159d65c8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -369,7 +369,6 @@ struct qc_dqblk {
 /* Operations handling requests from userspace */
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
-	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
 	int (*quota_enable)(struct super_block *, unsigned int);
 	int (*quota_disable)(struct super_block *, unsigned int);
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
