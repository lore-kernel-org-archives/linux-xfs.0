Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D58B7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 07:45:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E01B7AC003
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 05:45:48 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FSbRkidBk2QGuFYx for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 05:45:47 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] 285: Fix file syncing
Date: Thu, 30 May 2013 14:45:38 +0200
Message-Id: <1369917939-22660-2-git-send-email-jack@suse.cz>
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>

The intention of tests 08 and 09 in test generic/285 is to sync the
whole file before checking for data and holes. However the helper is
called with nbytes argument set to 0 which results in not syncing
anything. Set nbytes properly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index eec6903..7d5868b 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -229,7 +229,7 @@ static int test09(int fd, int testnum)
 	 * Sync out dirty pages from bufsz * 100, this will convert
 	 * the dirty page to writeback.
 	 */
-	ret = do_sync_dirty_pages(fd, bufsz * 100, 0);
+	ret = do_sync_dirty_pages(fd, bufsz * 100, filsz);
 	if (ret)
 		goto out;
 
@@ -269,7 +269,7 @@ static int test08(int fd, int testnum)
 		goto out;
 
 	/* Sync out all file */
-	ret = do_sync_dirty_pages(fd, 0, 0);
+	ret = do_sync_dirty_pages(fd, 0, filsz);
 	if (ret)
 		goto out;
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
