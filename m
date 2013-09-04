Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13D417F52
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 21:41:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFA34304082
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 19:41:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CCywpB6ASRoDzc8O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 19:41:21 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r842fHEJ020398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 02:41:20 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r842fGcW011794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 02:41:17 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r842fG1C011789 for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 02:41:16 GMT
Message-ID: <52269DF4.5040305@oracle.com>
Date: Wed, 04 Sep 2013 10:41:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Make the incore inode di_size to xfs_ufsize_t
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Make the incore inode di_size to unsigned, this would be helpful
to catch the negative sizes of it in many cases, so that we don't
need to perform additional check for it being less than ZERO or not.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_inode_fork.c |    3 +--
 fs/xfs/xfs_log_format.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 02f1083..2b60a5a 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -167,8 +167,7 @@ xfs_iformat_fork(
 			}
 
 			di_size = be64_to_cpu(dip->di_size);
-			if (unlikely(di_size < 0 ||
-				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
+			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_warn(ip->i_mount,
 			"corrupt inode %Lu (bad size %Ld for local inode).",
 					(unsigned long long) ip->i_ino,
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index a49ab2c..2795fc5 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -547,7 +547,7 @@ typedef struct xfs_icdinode {
 	xfs_ictimestamp_t di_atime;	/* time last accessed */
 	xfs_ictimestamp_t di_mtime;	/* time last modified */
 	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
-	xfs_fsize_t	di_size;	/* number of bytes in file */
+	xfs_ufsize_t	di_size;	/* number of bytes in file */
 	xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
