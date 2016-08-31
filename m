Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A017D7CA0
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 17:35:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D7D7304032
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 15:35:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iXyeV875tVuQ52HO for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2016 15:35:44 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] db: write via array indexing doesn't work
Date: Thu,  1 Sep 2016 08:34:43 +1000
Message-Id: <1472682883-16585-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

This command to write a specific AGFL index:

# xfs_db -x -c "agfl 0" -c "write -d bno[32] 78" /dev/ram0

doesn't write to array index 32 - it incorrectly writes to
/somewhere/ in the entire array range.

The issue here is that the write_struct() code assumes that the
object it is printing always a structure member and any array
indexes will be exposed as children of the parent type. This works
just fine for structures with internal arrays, but when the type
being decoded is an array, we get a direct reference to the offset
to be written in the parent object.

Hence we need to take into account the array index returned by the
parent object parsing when calculating the size of the region to be
modified rather than using fcount() as that results in the size
always being set to the size of the entire array and the
modification being written to the wrong place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/write.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/db/write.c b/db/write.c
index 82a0c74..5c83874 100644
--- a/db/write.c
+++ b/db/write.c
@@ -701,8 +701,24 @@ write_struct(
 		sfl = sfl->child;
 	}
 
+	/*
+	 * For structures, fsize * fcount tells us the size of the region we are
+	 * modifying, which is usually a single structure member and is pointed
+	 * to by the last child in the list.
+	 *
+	 * However, if the base structure is an array and we have a direct index
+	 * into the array (e.g. write bno[5]) then we are returned a single
+	 * flist object with the offset pointing directly at the location we
+	 * need to modify. The length of the object we are modifying is then
+	 * determined by the size of the individual array entry (fsize) and the
+	 * indexes defined in the object, not the overall size of the array
+	 * (which is what fcount returns).
+	 */
 	bit_length = fsize(sfl->fld, iocur_top->data, parentoffset, 0);
-	bit_length *= fcount(sfl->fld, iocur_top->data, parentoffset);
+	if (sfl->fld->flags & FLD_ARRAY)
+		bit_length *= sfl->high - sfl->low + 1;
+	else
+		bit_length *= fcount(sfl->fld, iocur_top->data, parentoffset);
 
 	/* convert this to a generic conversion routine */
 	/* should be able to handle str, num, or even labels */
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
