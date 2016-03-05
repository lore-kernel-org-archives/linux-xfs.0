Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 508427CB0
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:38:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0629E304048
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:38:24 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IXhwLaWw5L5WrR8n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:38:23 -0800 (PST)
Subject: [PATCH 08/12] xfs/122: define _GNU_SOURCE when compiling test program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:38:09 -0800
Message-ID: <20160305003809.28738.85961.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This makes it so we don't get warnings about off64_t not being
defined when compiling the test program.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 758cb50..dc28c56 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ oprog=$tmp.get_structs
 progout=$tmp.output
 
 cat >$cprog <<EOF
+#define _GNU_SOURCE
 #include <stdio.h>
 EOF
 for hdr in /usr/include/xfs/xfs*.h; do

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
