Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 160E581EF
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:51:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA86E8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id IBVL7qAiCAGa41rp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:51:08 -0700 (PDT)
Subject: [PATCH 42/71] xfs: don't mix reflink and DAX mode for now
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:51:04 -0700
Message-ID: <147216906459.4420.5585305790072253161.stgit@birch.djwong.org>
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

Since we don't have a strategy for handling both DAX and reflink,
for now we'll just prohibit both being set at the same time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_inode_buf.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 2966d54..3f2049b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -416,6 +416,10 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return false;
 
+	/* don't let reflink and dax mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
+		return false;
+
 	return true;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
