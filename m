Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 922BD8188
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:50:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA128AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:04 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zpTx7lymq44raZXV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:03 -0700 (PDT)
Subject: [PATCH 32/71] xfs: teach get_bmapx and fiemap about shared extents
	and the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:49:53 -0700
Message-ID: <147216899385.4420.12429549267505931508.stgit@birch.djwong.org>
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

Teach xfs_getbmapx how to report shared extents and CoW fork contents,
then modify the FIEMAP formatters to set the appropriate flags.  A
previous version of this patch only modified the fiemap formatter,
which is insufficient.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f291a53..bb70066 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -105,14 +105,16 @@ struct getbmapx {
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
 #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
+#define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
 #define BMV_IF_VALID	\
 	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
-	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
+	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)
 
 /*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
 #define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
+#define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
