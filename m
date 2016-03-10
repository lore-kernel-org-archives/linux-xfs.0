Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02DD67CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 12:00:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79C22AC008
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 10:00:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I4bznpxSCTg2Dxc2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 10:00:49 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: ensure committed is initialized in xfs_trans_roll
Message-ID: <56E1B650.8040400@redhat.com>
Date: Thu, 10 Mar 2016 12:00:48 -0600
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
To: xfs@oss.sgi.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>

__xfs_trans_roll() can return without setting the
*committed argument; this was a problem for xfs_bmap_finish():

        int       committed;/* xact committed or not */
...
        error = __xfs_trans_roll(tp, ip, &committed);
        if (error) {
...
                if (committed) {

and we tested an uninitialized "committed" variable on the
error path.  No caller is preserving "committed" state across
calls to __xfs_trans_roll(), so just initialize committed inside
the function to avoid future errors like this.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 748b16a..20c5366 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1028,6 +1028,8 @@ __xfs_trans_roll(
 	struct xfs_trans_res	tres;
 	int			error;
 
+	*committed = 0;
+
 	/*
 	 * Ensure that the inode is always logged.
 	 */
@@ -1082,6 +1084,6 @@ xfs_trans_roll(
 	struct xfs_trans	**tpp,
 	struct xfs_inode	*dp)
 {
-	int			committed = 0;
+	int			committed;
 	return __xfs_trans_roll(tpp, dp, &committed);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
