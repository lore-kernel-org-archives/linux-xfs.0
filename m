Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BACAA7F69
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 02:38:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A0218F8035
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 00:38:37 -0700 (PDT)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id ant2XC2JpxIHRIqX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Oct 2013 00:38:33 -0700 (PDT)
Received: by mail-la0-f51.google.com with SMTP id ea20so2396290lab.24
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 00:38:31 -0700 (PDT)
From: Denis Efremov <yefremov.denis@gmail.com>
Subject: [PATCH] xfs:xfs_dir2_node.c: pointer use before check for null
Date: Tue, 22 Oct 2013 11:36:15 +0400
Message-Id: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: ldv-project@linuxtesting.org, Alex Elder <elder@kernel.org>, Denis Efremov <yefremov.denis@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Reorder of assert and args pointer dereference.

Found by Linux Driver Verification project (linuxtesting.org) -
PVS-Studio analyzer.

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 fs/xfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4c3dba7..0ba7382 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1365,8 +1365,8 @@ xfs_dir2_leafn_split(
 	 * Allocate space for a new leaf node.
 	 */
 	args = state->args;
-	mp = args->dp->i_mount;
 	ASSERT(args != NULL);
+	mp = args->dp->i_mount;
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
