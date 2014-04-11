Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D4517F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 17:49:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 080B2AC003
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:49:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5lYUrFsxTmNkq7kR for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 15:49:29 -0700 (PDT)
Message-ID: <53487179.7040008@sandeen.net>
Date: Fri, 11 Apr 2014 17:49:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 08/14 V2] xfsprogs: free resources in libxfs_alloc_file_space
	error paths
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<1396999504-13769-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-9-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

The bmap freelist & transaction pointer weren't
being freed in libxfs_alloc_file_space error paths;
more or less copy the error handling that exists
in kernelspace to resolve this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix comment, remove XXX :)

Although:  That ASSERT, while matching kernelspace, seems
weird.  We *can* get other errors out of xfs_trans_reserve.
EIO etc... What's the assert all about?

 libxfs/util.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 1b05540..f1aa4c6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -582,8 +582,17 @@ libxfs_alloc_file_space(
 		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 					  resblks, 0);
-		if (error)
+		/*
+		 * Check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == ENOSPC);
+			xfs_trans_cancel(tp, 0);
 			break;
+		}
 		xfs_trans_ijoin(tp, ip, 0);
 		xfs_trans_ihold(tp, ip);
 
@@ -593,12 +602,12 @@ libxfs_alloc_file_space(
 				&reccount, &free_list);
 
 		if (error)
-			break;
+			goto error0;
 
 		/* complete the transaction */
 		error = xfs_bmap_finish(&tp, &free_list, &committed);
 		if (error)
-			break;
+			goto error0;
 
 		error = xfs_trans_commit(tp, 0);
 		if (error)
@@ -612,6 +621,11 @@ libxfs_alloc_file_space(
 		allocatesize_fsb -= allocated_fsb;
 	}
 	return error;
+
+error0:	/* Cancel bmap, cancel trans */
+	xfs_bmap_cancel(&free_list);
+	xfs_trans_cancel(tp, 0);
+	return error;
 }
 
 unsigned int


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
