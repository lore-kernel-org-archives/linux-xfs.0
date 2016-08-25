Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DF68821A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:51:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7B43AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id INWacP4GGrIMuZcZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:46 -0700 (PDT)
Subject: [PATCH 48/71] xfs_db: print one array element per line
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:51:41 -0700
Message-ID: <147216910176.4420.2022527266903445188.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Print one array element per line so that the debugger output isn't
a gigantic pile of screen snow.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/print.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/print.c b/db/print.c
index 998daf4..e31372f 100644
--- a/db/print.c
+++ b/db/print.c
@@ -197,7 +197,7 @@ print_sarray(
 	     i < count && !seenint();
 	     i++, bitoff += size) {
 		if (array)
-			dbprintf("%d:", i + base);
+			dbprintf("\n%d:", i + base);
 		for (f = flds, first = 1; f->name; f++) {
 			if (f->flags & FLD_SKIPALL)
 				continue;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
