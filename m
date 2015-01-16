Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 587717F5F
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:48:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46C0F8F804B
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:48:09 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id LefpqpJLZ8qBJwBB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 04:48:05 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/17] quota: Make Q_XQUOTASYNC support VFS quota syncing
Date: Fri, 16 Jan 2015 13:47:43 +0100
Message-Id: <1421412471-4747-10-git-send-email-jack@suse.cz>
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
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

Call ->quota_sync method from Q_XQUOTASYNC for better userspace
compatibility.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2cc50b35a3b5..5ec04321aace 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -477,8 +477,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	case Q_XQUOTASYNC:
 		if (sb->s_flags & MS_RDONLY)
 			return -EROFS;
-		/* XFS quotas are fully coherent now, making this call a noop */
-		return 0;
+		if (!sb->s_qcop->quota_sync)
+			return 0;
+		return sb->s_qcop->quota_sync(sb, type);
 	default:
 		return -EINVAL;
 	}
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
