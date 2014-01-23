Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F20B7F5D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFA40AC002
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:08 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DW1PHfVjmaV5x806 for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:06 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fC-8s
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004VL-7v
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] metadump: sanitise write_buf/index return values
Date: Thu, 23 Jan 2014 21:23:51 +1100
Message-Id: <1390472635-17225-2-git-send-email-david@fromorbit.com>
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

Write_buf/write_index use confusing boolean values for return,
meaning that it's hard to tell what the correct error return is
supposed to be.  Convert them to return zero on success or a
negative errno otherwise so that it's clear what the error case is.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 117dc42..4104fcb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -145,6 +145,8 @@ print_progress(const char *fmt, ...)
  * even if the dump is exactly aligned, the last index will be full of
  * zeros. If the last index entry is non-zero, the dump is incomplete.
  * Correspondingly, the last chunk will have a count < num_indicies.
+ *
+ * Return 0 for success, -1 for failure.
  */
 
 static int
@@ -156,12 +158,12 @@ write_index(void)
 	metablock->mb_count = cpu_to_be16(cur_index);
 	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
 		print_warning("error writing to file: %s", strerror(errno));
-		return 0;
+		return -errno;
 	}
 
 	memset(block_index, 0, num_indicies * sizeof(__be64));
 	cur_index = 0;
-	return 1;
+	return 0;
 }
 
 static int
@@ -171,6 +173,7 @@ write_buf(
 	char		*data;
 	__int64_t	off;
 	int		i;
+	int		ret;
 
 	/*
 	 * Run the write verifier to recalculate the buffer CRCs and check
@@ -184,7 +187,7 @@ write_buf(
 	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
 				__func__, (long long)buf->bp->b_bn,
 				buf->bp->b_bcount);
-			return buf->bp->b_error;
+			return -buf->bp->b_error;
 		}
 	}
 
@@ -194,11 +197,12 @@ write_buf(
 		block_index[cur_index] = cpu_to_be64(off);
 		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
 		if (++cur_index == num_indicies) {
-			if (!write_index())
-				return 0;
+			ret = write_index();
+			if (ret)
+				return ret;
 		}
 	}
-	return !seenint();
+	return seenint() ? -EINTR : 0;
 }
 
 
@@ -227,7 +231,7 @@ scan_btree(
 		rval = !stop_on_read_error;
 		goto pop_out;
 	}
-	if (!write_buf(iocur_top))
+	if (write_buf(iocur_top))
 		goto pop_out;
 
 	if (!(*func)(iocur_top->data, agno, agbno, level - 1, btype, arg))
@@ -1439,7 +1443,7 @@ process_bmbt_reclist(
 
 				default: ;
 			    }
-			if (!write_buf(iocur_top)) {
+			if (write_buf(iocur_top)) {
 				pop_cur();
 				return 0;
 			}
@@ -1748,7 +1752,7 @@ copy_inode_chunk(
 		xfs_dinode_calc_crc(mp, dip);
 	}
 skip_processing:
-	if (!write_buf(iocur_top))
+	if (write_buf(iocur_top))
 		goto pop_out;
 
 	inodes_copied += XFS_INODES_PER_CHUNK;
@@ -1866,7 +1870,7 @@ scan_ag(
 		if (stop_on_read_error)
 			goto pop_out;
 	} else {
-		if (!write_buf(iocur_top))
+		if (write_buf(iocur_top))
 			goto pop_out;
 	}
 
@@ -1881,7 +1885,7 @@ scan_ag(
 		if (stop_on_read_error)
 			goto pop_out;
 	} else {
-		if (!write_buf(iocur_top))
+		if (write_buf(iocur_top))
 			goto pop_out;
 	}
 
@@ -1896,7 +1900,7 @@ scan_ag(
 		if (stop_on_read_error)
 			goto pop_out;
 	} else {
-		if (!write_buf(iocur_top))
+		if (write_buf(iocur_top))
 			goto pop_out;
 	}
 
@@ -1910,7 +1914,7 @@ scan_ag(
 		if (stop_on_read_error)
 			goto pop_out;
 	} else {
-		if (!write_buf(iocur_top))
+		if (write_buf(iocur_top))
 			goto pop_out;
 	}
 
@@ -2015,7 +2019,7 @@ copy_log(void)
 		print_warning("cannot read log");
 		return !stop_on_read_error;
 	}
-	return write_buf(iocur_top);
+	return !write_buf(iocur_top);
 }
 
 static int
@@ -2121,7 +2125,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = !write_index();
+		exitcode = write_index() < 0;
 
 	if (progress_since_warning)
 		fputc('\n', (outf == stdout) ? stderr : stdout);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
