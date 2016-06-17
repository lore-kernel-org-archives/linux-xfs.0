Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0DE268354
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:42:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1F8E8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:42:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0EZvhIrb2GLZEABL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:42:42 -0700 (PDT)
Subject: [PATCH 113/145] xfs_db: deal with the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:42:38 -0700
Message-ID: <146612775876.16048.7337361121630211530.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Display the CoW extent hint size when dumping inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 702cdf8..cac19fc 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -172,12 +172,16 @@ const field_t	inode_v3_flds[] = {
 	{ "change_count", FLDT_UINT64D, OI(COFF(changecount)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
+	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
 	{ "reflink", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(__uint64_t) - XFS_DIFLAG2_REFLINK_BIT-1), C1,
 	  0, TYP_NONE },
+	{ "cowextsz", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(__uint64_t) - XFS_DIFLAG2_COWEXTSIZE_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
