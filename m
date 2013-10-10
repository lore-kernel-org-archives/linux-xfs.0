Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB9887F8B
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:51:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C08C8F807A
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CwmfS2mPRVkEhe1L for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:49 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AFpneN001151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:49 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9AFpnOJ023393
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/12] xfsprogs: enable the finobt feature on v5 superblocks
Date: Thu, 10 Oct 2013 11:51:09 -0400
Message-Id: <1381420272-13249-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
References: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
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

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_sb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 83e037b..a0861f5 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -584,7 +584,8 @@ xfs_sb_has_compat_feature(
 }
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
-#define XFS_SB_FEAT_RO_COMPAT_ALL 0
+#define XFS_SB_FEAT_RO_COMPAT_ALL \
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
