Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49FAA7F47
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC6F6AC003
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VyGR9hrOSw3qM5K5 for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 8/8] xfs_fsr: remove extraneous close() in fsrallfs()
Date: Sat, 26 Jan 2013 16:40:32 -0600
Message-Id: <1359240032-11576-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

After the fork(), the parent does a close(fd); on an
fd which is long-since closed (prior to the while loop).
Just remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 5eaabb5..3d017ca 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -627,7 +627,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 			break;
 		default:
 			wait(&error);
-			close(fd);
 			if (WIFEXITED(error) && WEXITSTATUS(error) == 1) {
 				/* child timed out & did fsrall_cleanup */
 				exit(0);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
