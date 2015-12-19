Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9161F819D
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 823118F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:39 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TwTcSVSgBGyJ06cf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:38 -0800 (PST)
Subject: [PATCH 07/53] libxfs: pack the agfl header structure so
	XFS_AGFL_SIZE is correct
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:35 -0800
Message-ID: <20151219090535.14255.81041.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

Because struct xfs_agfl is 36 bytes long and has a 64-bit integer
inside it, gcc will quietly round the structure size up to the nearest
64 bits -- in this case, 40 bytes.  This results in the XFS_AGFL_SIZE
macro returning incorrect results for v5 filesystems on 64-bit
machines (118 items instead of 119).  As a result, a 32-bit xfs_repair
will see garbage in AGFL item 119 and complain.

Therefore, tell gcc not to pad the structure so that the AGFL size
calculation is correct.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 946bcd1..f6100be 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -787,7 +787,7 @@ typedef struct xfs_agfl {
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
 	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
-} xfs_agfl_t;
+} __attribute__((packed)) xfs_agfl_t;
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
