Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E01F7CA8
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:46:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 407D2304032
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:30 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LUjTf2gddPaEEB5u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:28 -0800 (PST)
Subject: [PATCH 1/3] generic/304: fix high offset
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Feb 2016 12:46:14 -0800
Message-ID: <20160215204614.7977.2848.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

"Invalid argument" is a better response to an impossibly high offset
dedupe request than "extents don't match", so change the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/304.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/304.out b/tests/generic/304.out
index 4af2a39..7b5ff0e 100644
--- a/tests/generic/304.out
+++ b/tests/generic/304.out
@@ -8,7 +8,7 @@ dedupe: Invalid argument
 Dedupe past maximum file size in dest file (should fail)
 dedupe: Invalid argument
 Dedupe high offset to low offset
-dedupe: Extents did not match.
+dedupe: Invalid argument
 Dedupe past source file EOF (should fail)
 dedupe: Invalid argument
 Dedupe max size at nonzero offset (should fail)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
