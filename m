Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47EB67F52
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 01:37:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 270C58F8040
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 23:37:26 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id ieBfTK2kD03k2SMK for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 23:37:25 -0700 (PDT)
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/4] xfs: add helper function to convert project id between
	user and kernel space
Date: Wed, 4 Sep 2013 14:38:34 +0800
Message-Id: <1378276717-9663-2-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, Gao feng <gaofeng@cn.fujitsu.com>

Create two helper functions to convert project id between
user and kernel space.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 fs/xfs/xfs_linux.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9bb590..cc9cc5b 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -215,6 +215,25 @@ static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
 	return make_kgid(&init_user_ns, gid);
 }
 
+static inline int
+xfs_convert_to_kernel_projid(__uint32_t prid, prid_t *kprid)
+{
+	kprojid_t kprojid = make_kprojid(current_user_ns(), prid);
+	if (!projid_valid(kprojid))
+		return -1;
+
+	*kprid = from_kprojid(&init_user_ns, kprojid);
+	return 0;
+}
+
+static inline __uint32_t
+xfs_convert_to_user_projid(prid_t kprid)
+{
+	kprojid_t kprojid = make_kprojid(&init_user_ns, kprid);
+
+	return from_kprojid(current_user_ns(), kprojid);
+}
+
 /*
  * Various platform dependent calls that don't fit anywhere else
  */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
