Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9931F29EA1
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BDC6304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:33 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8EVaZ3205hV0kVl5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:31 -0800 (PST)
Subject: [PATCH 05/11] xfs/129: require loop
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:11:25 -0800
Message-ID: <20151219091125.15320.31598.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
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

Missed a _require_loop for xfs/129.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/129 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/129 b/tests/xfs/129
index 6fb9bac..c8c47a2 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_loop
 _require_scratch_reflink
 
 rm -f "$seqres.full"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
