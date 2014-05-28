Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACDA17F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:28:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 919D28F8087
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 20:28:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aFzGMDLlgYjfEfiF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 20:27:57 -0700 (PDT)
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] xfsprogs: xfs_copy: fix data corruption of target
Date: Wed, 28 May 2014 11:28:07 +0800
Message-Id: <1401247687-6444-1-git-send-email-junxiao.bi@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, joe.jin@oracle.com, junxiao.bi@oracle.com

The unit of XFS_AGFL_DADDR(mp) is "basic block" whose size is "BBSIZE"
(512 bytes), so when "source_sectorsize" is not 512, it will cause the
target a corrupted filesystem.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 copy/xfs_copy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 39bb9d7..6b3396d 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -687,7 +687,7 @@ main(int argc, char **argv)
 	if (source_blocksize > source_sectorsize)  {
 		/* get number of leftover sectors in last block of ag header */
 
-		tmp_residue = ((XFS_AGFL_DADDR(mp) + 1) * source_sectorsize)
+		tmp_residue = ((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
 					% source_blocksize;
 		first_residue = (tmp_residue == 0) ? 0 :
 			source_blocksize - tmp_residue;
@@ -700,10 +700,10 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	first_agbno = (((XFS_AGFL_DADDR(mp) + 1) * source_sectorsize)
+	first_agbno = (((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
 				+ first_residue) / source_blocksize;
 	ASSERT(first_agbno != 0);
-	ASSERT( ((((XFS_AGFL_DADDR(mp) + 1) * source_sectorsize)
+	ASSERT(((((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
 				+ first_residue) % source_blocksize) == 0);
 
 	/* now open targets */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
