Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EDE57F56
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:08:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAE87AC008
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:08:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S0DJnw7xfPA7cJav for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 11:08:27 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D8F4F61D1A43
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:08:26 -0500 (CDT)
Message-ID: <55D6179B.1040701@sandeen.net>
Date: Thu, 20 Aug 2015 13:08:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfsprogs: Free all data in libxfs_umount;
	call from xfs_copy as well
References: <55D61740.9070507@sandeen.net>
In-Reply-To: <55D61740.9070507@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

libxfs_umount was failing to free a handful of resources; fix that up.
Call it from xfs_copy as well, while we're at it; every other libxfs_mount
has a libxfs_umount counterpart, at least on a clean exit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 copy/xfs_copy.c |    2 ++
 libxfs/init.c   |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index e13f468..4497b7f 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1165,6 +1165,8 @@ main(int argc, char **argv)
 	}
 
 	check_errors();
+	libxfs_umount(mp);
+
 	return 0;
 }
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 2859f94..c7f9dc8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -832,6 +832,15 @@ libxfs_umount(xfs_mount_t *mp)
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		kmem_free(pag);
 	}
+
+	kmem_free(mp->m_attr_geo);
+	kmem_free(mp->m_dir_geo);
+
+	kmem_free(mp->m_rtdev_targp);
+	if (mp->m_logdev_targp != mp->m_ddev_targp)
+		kmem_free(mp->m_logdev_targp);
+	kmem_free(mp->m_ddev_targp);
+	
 }
 
 /*
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
