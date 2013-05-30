Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE0067F3F
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 16:21:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F3B4304062
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 14:21:49 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Mya8hdfQ8OKN5HBp for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 14:21:48 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3 v2] 285: Fix indentation of do_pwrite
Date: Thu, 30 May 2013 23:21:44 +0200
Message-Id: <1369948905-6693-2-git-send-email-jack@suse.cz>
In-Reply-To: <1369948905-6693-1-git-send-email-jack@suse.cz>
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
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

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index eec6903..748eec2 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -120,19 +120,19 @@ static int do_sync_dirty_pages(int fd, off64_t offset, off64_t nbytes)
 
 static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
 {
-       ssize_t ret, written = 0;
-
-       while (count > written) {
-               ret = pwrite(fd, buf + written, count - written, offset + written);
-               if (ret < 0) {
-                       fprintf(stderr, "  ERROR %d: Failed to write %ld "
-                               "bytes\n", errno, (long)count);
-                       return ret;
-               }
-               written += ret;
-       }
-
-       return 0;
+	ssize_t ret, written = 0;
+
+	while (count > written) {
+		ret = pwrite(fd, buf + written, count - written, offset + written);
+		if (ret < 0) {
+			fprintf(stderr, "  ERROR %d: Failed to write %ld "
+				"bytes\n", errno, (long)count);
+			return ret;
+		}
+		written += ret;
+	}
+
+	return 0;
 }
 
 #define do_close(x)	do { if ((x) > -1) close(x); } while(0);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
