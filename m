Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9A877F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 00:26:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C0B098F8037
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 22:26:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1ppZi7xLKGMB8sEE for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 22:26:26 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WJGsv-0002RC-1Z
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:25 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WJGsv-0000Nh-0z
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] metadump: pathname obfuscation overruns symlink buffer
Date: Fri, 28 Feb 2014 17:25:23 +1100
Message-Id: <1393568723-982-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1393568723-982-1-git-send-email-david@fromorbit.com>
References: <1393568723-982-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

In testing the previous metadump changes, fsstress generated an
inline symlink of 336 bytes in length. This caused corruption of the
restored filesystem that wasn't present in the original filesystem -
it corrupted the magic number of the next inode in the chunk. The
reason being that the symlink data is not null terminated in the
inode literal area, and hence when the symlink consumes the entire
literal area like so:

xfs_db> daddr 0x42679
xfs_db> p
000: 494ea1ff 03010000 00000000 00000000 00000001 00000000 00000000 00000000
020: 53101af9 1678d2a8 53101af9 15fec0a8 53101af9 15fec0a8 00000000 00000150
040: 00000000 00000000 00000000 00000000 00000002 00000000 00000000 d868b52d
060: ffffffff 0ce5477a 00000000 00000002 00000002 0000041c 00000000 00000000
080: 00000000 00000000 00000000 00000000 53101af9 15fec0a8 00000000 00042679
0a0: 6c4e9d4e 84944986 a074cffd 0ea042a8 78787878 78787878 78782f78 78787878
0c0: 78787878 2f787878 78787878 78782f78 78787878 78787878 2f787878 78787878
0e0: 78782f78 78787878 78787878 2f787878 78787878 78782f78 78787878 78787878
100: 2f787878 78787878 78782f78 78787878 78787878 2f787878 78787878 78782f78
120: 78787878 78787878 2f787878 78787878 78782f78 78787878 78787878 2f787878
140: 78787878 78782f78 78787878 78787878 2f787878 78787878 78782f78 78787878
160: 78787878 2f787878 78787878 78782f78 78787878 78787878 2f787878 78787878
180: 78782f78 78787878 78787878 2f787878 78787878 78782f78 78787878 78787878
1a0: 2f787878 78787878 78782f78 78787878 78787878 2f787878 78787878 78782f78
1c0: 78787878 78787878 2f787878 78787878 78782f78 78787878 78787878 2f787878
1e0: 78787878 78782f78 78787878 78787878 2f787878 78787878 78782f78 78787878

the symlink data butts right up agains the magic number of the next
inode in the chunk. And then, when obfuscation gets to the final
pathname component, it gets it's length via:

		/* last (or single) component */
		namelen = strlen((char *)comp);
		hash = libxfs_da_hashname(comp, namelen);
		obfuscate_name(hash, namelen, comp);

strlen(), which looks for a null terminator and finds it several
bytes into the next inode. It then proceeds to obfuscate that
length, including the inode magic number of the next inode....

Fix this by ensuring we can't overrun the symlink buffer length
by assuming that the symlink is not null terminated.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3248009..cd489a6 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1015,16 +1015,23 @@ obfuscate_sf_dir(
 	}
 }
 
+/*
+ * The pathname may not be null terminated. It name be terminated by the end of
+ * a buffer or inode literal area, and the start of the next region may contain
+ * any data at all. Hence when we get to the last component of the symlink, we
+ * cannot assume that strlen() will give us the right result. Hence we need to
+ * track the remaining pathname length and use that instead.
+ */
 static void
 obfuscate_path_components(
 	char			*buf,
 	__uint64_t		len)
 {
-	uchar_t			*comp;
+	uchar_t			*comp = (uchar_t *)buf;
+	uchar_t			*end = comp + len;
 	xfs_dahash_t		hash;
 
-	comp = (uchar_t *)buf;
-	while (comp < (uchar_t *)buf + len) {
+	while (comp < end) {
 		char	*slash;
 		int	namelen;
 
@@ -1032,7 +1039,7 @@ obfuscate_path_components(
 		slash = strchr((char *)comp, '/');
 		if (!slash) {
 			/* last (or single) component */
-			namelen = strlen((char *)comp);
+			namelen = strnlen((char *)comp, len);
 			hash = libxfs_da_hashname(comp, namelen);
 			obfuscate_name(hash, namelen, comp);
 			break;
@@ -1041,11 +1048,13 @@ obfuscate_path_components(
 		/* handle leading or consecutive slashes */
 		if (!namelen) {
 			comp++;
+			len--;
 			continue;
 		}
 		hash = libxfs_da_hashname(comp, namelen);
 		obfuscate_name(hash, namelen, comp);
 		comp += namelen + 1;
+		len -= namelen + 1;
 	}
 }
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
