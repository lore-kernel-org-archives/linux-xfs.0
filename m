Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A86A629F0B
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BDBD8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:10:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id le68puGJte5AqhUf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:10:48 -0700 (PDT)
Subject: [PATCH 51/51] mkfs: hack around not having enough log blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:10:45 -0700
Message-ID: <20151007051045.1504.42037.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Under some circumstances I don't yet understand, mkfs underestimates
the minimum log size and the kernel refuses to mount.  Put in a crude
hack so that this doesn't happen.

DO NOT APPLY!!!

Singed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 556b691..ab1e8f9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2401,6 +2401,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   logversion, lsunit);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
+if (min_logblocks < 860) min_logblocks = 860;
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
 	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
