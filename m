Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51F947F4E
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 03:24:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E556304039
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 01:24:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KL7sx7Uwyg5SrS1V (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 01:24:31 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r8M8OU5J016214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 08:24:31 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8M8OTpZ017340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 08:24:30 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8M8OTlP017332 for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 08:24:29 GMT
Message-ID: <523EA96B.3040904@oracle.com>
Date: Sun, 22 Sep 2013 16:25:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
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

At xfs_iext_realloc_direct(), the new_size is changed by adding
if_bytes if originally the extent records are stored at the inline
extent buffer, and we have to switch from it to a direct extent
list for those new allocated extents, this is wrong. e.g,

Create a file with three extents which was showing as following,

xfs_io -f -c "truncate 100m" /xfs/testme

for i in $(seq 0 5 10); do
	offset=$(($i * $((1 << 20))))
	xfs_io -c "pwrite $offset 1m" /xfs/testme
done

Inline
------
irec:	if_bytes	bytes_diff	new_size
1st	0		16		16
2nd	16		16		32

Switching
---------						rnew_size
3rd	32		16		48 + 32 = 80	roundup=128

In this case, the desired value of new_size should be 48, and then
it will be roundup to 64 and be assigned to rnew_size.

However, this issue has been covered by resetting the if_bytes to
the new_size which is calculated at the begnning of xfs_iext_add()
before leaving out this function, and in turn make the rnew_size
correctly again. Hence, this can not be detected via xfstestes.

This patch fix above problem and revise the new_size comments at
xfs_iext_realloc_direct() to make it more readable.  Also, fix the
comments while switching from the inline extent buffer to a direct
extent list to reflect this change.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_inode_fork.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index dfb4226..7c6192a 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1359,7 +1359,7 @@ xfs_iext_remove_indirect(
 void
 xfs_iext_realloc_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	int		new_size)	/* new size of extents */
+	int		new_size)	/* new size of extents after adding */
 {
 	int		rnew_size;	/* real new size of extents */
 
@@ -1397,13 +1397,8 @@ xfs_iext_realloc_direct(
 				rnew_size - ifp->if_real_bytes);
 		}
 	}
-	/*
-	 * Switch from the inline extent buffer to a direct
-	 * extent list. Be sure to include the inline extent
-	 * bytes in new_size.
-	 */
+	/* Switch from the inline extent buffer to a direct extent list */
 	else {
-		new_size += ifp->if_bytes;
 		if (!is_power_of_2(new_size)) {
 			rnew_size = roundup_pow_of_two(new_size);
 		}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
