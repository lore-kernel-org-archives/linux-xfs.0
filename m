Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55EEA7F50
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 12:59:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44A94304043
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:59:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Hkz2z1EkoKox72Jm for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 10:59:12 -0800 (PST)
Message-ID: <54EB787F.5090600@sandeen.net>
Date: Mon, 23 Feb 2015 12:59:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: Ensure we have target_ip for RENAME_EXCHANGE
References: <54EB782F.8020201@redhat.com>
In-Reply-To: <54EB782F.8020201@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Carlos Maiolino <cmaiolin@redhat.com>

We shouldn't get here with RENAME_EXCHANGE set and no
target_ip, but let's be defensive, because xfs_cross_rename()
will dereference it.

Spotted by Coverity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index daafa1f..6163767 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2867,6 +2867,10 @@ xfs_rename(
 	 * Handle RENAME_EXCHANGE flags
 	 */
 	if (flags & RENAME_EXCHANGE) {
+		if (target_ip == NULL) {
+			error = -EINVAL;
+			goto error_return;
+		}
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					 target_dp, target_name, target_ip,
 					 &free_list, &first_block, spaceres);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
