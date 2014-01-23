Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B2FC7F5D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E37D304064
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9XDvxNLbPEbc32Op for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:05 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fD-9Q
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004VQ-8W
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] metadump: support writing discontiguous io cursors
Date: Thu, 23 Jan 2014 21:23:52 +1100
Message-Id: <1390472635-17225-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1390472635-17225-1-git-send-email-david@fromorbit.com>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
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

To handle discontiguous buffers, metadump needs to be able to handle
io cursrors that use discontiguous buffer mappings. Factor
write_buf() to extract the data copy routine and use that to
implement support for both flat and discontiguous buffer maps.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 4104fcb..a8bc297 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -166,12 +166,34 @@ write_index(void)
 	return 0;
 }
 
+/*
+ * Return 0 for success, -errno for failure.
+ */
+static int
+write_buf_segment(
+	char		*data,
+	__int64_t	off,
+	int		len)
+{
+	int		i;
+	int		ret;
+
+	for (i = 0; i < len; i++, off++, data += BBSIZE) {
+		block_index[cur_index] = cpu_to_be64(off);
+		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
+		if (++cur_index == num_indicies) {
+			ret = write_index();
+			if (ret)
+				return -EIO;
+		}
+	}
+	return 0;
+}
+
 static int
 write_buf(
 	iocur_t		*buf)
 {
-	char		*data;
-	__int64_t	off;
 	int		i;
 	int		ret;
 
@@ -191,15 +213,20 @@ write_buf(
 		}
 	}
 
-	for (i = 0, off = buf->bb, data = buf->data;
-			i < buf->blen;
-			i++, off++, data += BBSIZE) {
-		block_index[cur_index] = cpu_to_be64(off);
-		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
-		if (++cur_index == num_indicies) {
-			ret = write_index();
+	/* handle discontiguous buffers */
+	if (!buf->bbmap) {
+		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
+		if (ret)
+			return ret;
+	} else {
+		int	len = 0;
+		for (i = 0; i < buf->bbmap->nmaps; i++) {
+			ret = write_buf_segment(buf->data + BBTOB(len),
+						buf->bbmap->b[i].bm_bn,
+						buf->bbmap->b[i].bm_len);
 			if (ret)
 				return ret;
+			len += buf->bbmap->b[i].bm_len;
 		}
 	}
 	return seenint() ? -EINTR : 0;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
