Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABF6B7CB1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:38:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E9CD8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:38:09 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wy105vmvLDdM7Mla (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:38:08 -0800 (PST)
Subject: [PATCH 06/12] xfs/030: fix output on newer filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:56 -0800
Message-ID: <20160305003756.28738.26362.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/030           |    5 ++++-
 tests/xfs/030.out.linux |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/030 b/tests/xfs/030
index 4cb1524..33c906c 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -57,7 +57,10 @@ _check_ag()
 		echo "Corrupting $structure - setting bits to $1"
 		_check_repair $1 "$structure" |
 			sed -e '/^error following ag 0 unlinked list$/d' \
-			    -e '/^bad agbno AGBNO for finobt/d'
+			    -e '/^bad agbno AGBNO for finobt/d' \
+			    -e '/^bad agbno AGBNO for rmapbt/d' \
+			    -e '/^bad agbno AGBNO for refcntbt/d' \
+			    -e '/^Missing reverse-mapping record.*/d'
 	done
 }
 
diff --git a/tests/xfs/030.out.linux b/tests/xfs/030.out.linux
index cf3259f..14b9b35 100644
--- a/tests/xfs/030.out.linux
+++ b/tests/xfs/030.out.linux
@@ -231,6 +231,8 @@ bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
