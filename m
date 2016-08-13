Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 959617CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:26:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 589888F8033
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:26:03 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id v32BBlSOikDQ8xms (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:26:01 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id D52DC20449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:59 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDl2Dzlz104L
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:59 +0200 (CEST)
Resent-Message-ID: <20160813172502.GK3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <663326cb534467d534360d23acb02dc535caa909.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:03:16 +0200
Subject: [PATCHv2 xfsprogs 13/14] xfs.h: require transparent LFS for all users
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
type, force downstreams to use transparent LFS (_FILE_OFFSET_BITS=64),
so that it becomes impossible for them to use 32bit interfaces.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/xfs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/xfs.h b/include/xfs.h
index 7bed957..0a294f0 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -48,6 +48,11 @@
 #endif
 
 /*
+ * make sure that any user of the xfs headers has a 64bit off_t type
+ */
+extern int xfs_assert_largefile[sizeof(off_t)-8];
+
+/*
  * sparse kernel source annotations
  */
 #ifndef __user
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
