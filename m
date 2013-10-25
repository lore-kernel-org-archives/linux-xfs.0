Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C10A7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:55:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF552AC007
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:55:38 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	OcWowRMEumZhvdKT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 04:55:36 -0700 (PDT)
Received: by mail-lb0-f172.google.com with SMTP id c11so653898lbj.3
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:55:35 -0700 (PDT)
From: Denis Efremov <yefremov.denis@gmail.com>
Subject: [PATCH v2] xfs:xfs_dir2_node.c: pointer use before check for null
Date: Fri, 25 Oct 2013 15:53:25 +0400
Message-Id: <1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
In-Reply-To: <20131022203322.GA2797@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ldv-project@linuxtesting.org, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Denis Efremov <yefremov.denis@gmail.com>

ASSERT on args takes place after args dereference.
This assertion is redundant since we are going to panic anyway.

Found by Linux Driver Verification project (linuxtesting.org) -
PVS-Studio analyzer.

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 fs/xfs/xfs_dir2_node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4c3dba7..dc814df 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1366,7 +1366,6 @@ xfs_dir2_leafn_split(
 	 */
 	args = state->args;
 	mp = args->dp->i_mount;
-	ASSERT(args != NULL);
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
