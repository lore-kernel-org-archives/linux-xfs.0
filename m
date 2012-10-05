Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEBxp053253 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FBBNd8U8gzs11VY7 for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:38 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFb4H031594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q95EFbZd022121
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 07/10] xfs: make xfs_quota_type() non-static
Date: Fri,  5 Oct 2012 10:17:13 -0400
Message-Id: <1349446636-8611-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Make xfs_quota_type() into a non-static function. This is to
support quota ID filtering in the eofblocks ioctl().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_quota.h    |    1 +
 fs/xfs/xfs_quotaops.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b50ec5b..3ec6224 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -379,6 +379,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
 				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
+int xfs_quota_type(int);
 
 #endif	/* __KERNEL__ */
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index fed504f..fe15aa7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -28,7 +28,7 @@
 #include <linux/quota.h>
 
 
-STATIC int
+int
 xfs_quota_type(int type)
 {
 	switch (type) {
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
