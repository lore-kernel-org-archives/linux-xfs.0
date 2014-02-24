Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 456067F52
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:20:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3847E304066
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:20:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5emgJqTaQcyBh5ud for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:20:25 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1OFKJCi032437
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 10:20:24 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1OEU4Et032633
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:30:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 11/11] xfs: enable the finobt feature on v5 superblocks
Date: Mon, 24 Feb 2014 09:30:03 -0500
Message-Id: <1393252203-7423-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
References: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Add the finobt feature bit to the list of known features. As of
this point, the kernel code knows how to mount and manage both
finobt and non-finobt formatted filesystems.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 070a7f6..9919fb8 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -586,7 +586,8 @@ xfs_sb_has_compat_feature(
 }
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
-#define XFS_SB_FEAT_RO_COMPAT_ALL 0
+#define XFS_SB_FEAT_RO_COMPAT_ALL \
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
