Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30D4A7F37
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6BB3AC002
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id U0ZHdCHLAq9kp9J3 for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/8] xfs_fsr: guard against path string overflows
Date: Sat, 26 Jan 2013 16:40:29 -0600
Message-Id: <1359240032-11576-6-git-send-email-sandeen@redhat.com>
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

gettmpname() and getparent() blindly copy strings
into a target array; be sure we limit the copy to
the size of the target and null terminate it.

I don't see a way to get here with a too-long name,
since most paths try to open or stat the file already,
but it can't hurt to be defensive.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2db2224..843f57d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1452,7 +1452,8 @@ gettmpname(char *fname)
 
 	sprintf(sbuf, "/.fsr%d", getpid());
 
-	strcpy(buf, fname);
+	strncpy(buf, fname, PATH_MAX);
+	buf[PATH_MAX] = '\0';
 	ptr = strrchr(buf, '/');
 	if (ptr) {
 		*ptr = '\0';
@@ -1476,7 +1477,8 @@ getparent(char *fname)
 	static char	buf[PATH_MAX+1];
 	char		*ptr;
 
-	strcpy(buf, fname);
+	strncpy(buf, fname, PATH_MAX);
+	buf[PATH_MAX] = '\0';
 	ptr = strrchr(buf, '/');
 	if (ptr) {
 		if (ptr == &buf[0])
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
