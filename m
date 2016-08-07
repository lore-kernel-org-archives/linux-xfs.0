Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A2807CEF
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BBA8304048
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:52 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id LURvRUMMNjEQxd8z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:50 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 9100F20A76
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:49 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQY0zytz104T
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:49 +0200 (CEST)
Message-Id: <3be2b10b0037406374a415fda2318cbf95a67546.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 07:43:42 +0200
Subject: [PATCH xfsprogs 13/14] xfs.h: require transparent LFS
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

Since our interfaces depend on the consistent use of a 64bit offset
type, we force downstreams to use transparent LFS
(_FILE_OFFSET_BITS=64), so that it becomes impossible for them to use
32bit interfaces.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/xfs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/xfs.h b/include/xfs.h
index 7bed957..37c95fe 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -47,6 +47,8 @@
 # error unknown platform... have fun porting!
 #endif
 
+extern int xfs_assert_largefile[sizeof(off_t)-8];
+
 /*
  * sparse kernel source annotations
  */
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
