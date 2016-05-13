Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B732C7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 20:40:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8952F304048
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 18:40:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aGb5GKRH2cggpTiB for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 18:40:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1b125N-0006Rd-M8
	for xfs@oss.sgi.com; Fri, 13 May 2016 11:40:13 +1000
Received: from dave by disappointment with local (Exim 4.87)
	(envelope-from <dave@disappointment.disaster>) id 1b125D-0003oL-7S
	for xfs@oss.sgi.com; Fri, 13 May 2016 11:40:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] db: limit AGFL bno array printing
Date: Fri, 13 May 2016 11:40:03 +1000
Message-Id: <1463103603-14610-1-git-send-email-david@fromorbit.com>
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

When asking for a single agfl entry such as:

# xfs_db -c "agfl 0" -c "p bno[1]" /dev/ram0
bno[1] = 1:6 2:7 3:8 4:null .....

The result should be just the single entry being asked for.
Currently this outputs the entire remainder of the array starting at
the given index. This makes it difficult to extract single entry
values.

This occurs because the printing of a flat array of number types
does not take into account the range that is specified on the
command line, which is held in fl->low and fl->high. To make this
work for flat arrays of number types (print function fp_num), change
print_flist() to limit the count of values to be emitted to the
range specified. This now gives:

# xfs_db -c "agfl 0" -c "p bno[1-2]" /dev/ram0
bno[1-2] = 1:6 2:7

To further simplify external parsing of single entry values, if only
a single value is requested from the array of fp_num type, don't
print the array index - it's already known. Hence:

# xfs_db -c "agfl 0" -c "p bno[1]" /dev/ram0
bno[1] = 6

This change will take effect on all types of flat number arrays that
are printed. e.g. the range limiting will work for things like the
AGI unlinked list arrays.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/fprint.c | 2 +-
 db/print.c  | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/db/fprint.c b/db/fprint.c
index f2b3794..fd7e7f4 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -93,7 +93,7 @@ fp_num(
 			val == -1LL : val == ((1LL << size) - 1LL);
 		if ((arg & FTARG_SKIPNULL) && isnull)
 			continue;
-		if (array)
+		if (array && count > 1)
 			dbprintf("%d:", i + base);
 		if ((arg & FTARG_DONULL) && isnull)
 			dbprintf(_("null"));
diff --git a/db/print.c b/db/print.c
index 3ff2548..998daf4 100644
--- a/db/print.c
+++ b/db/print.c
@@ -107,6 +107,7 @@ print_flist_1(
 	const ftattr_t	*fa;
 	flist_t		*fl;
 	int		low;
+	int		count;
 	int		neednl;
 	char		**pfx;
 
@@ -139,10 +140,12 @@ print_flist_1(
 				low = fl->low;
 			else
 				low = 0;
+			count = fcount(f, iocur_top->data, parentoff);
+			if (fl->flags & FL_OKHIGH)
+				count = min(count, fl->high - low + 1);
 			if (fa->prfunc) {
 				neednl = fa->prfunc(iocur_top->data, fl->offset,
-					fcount(f, iocur_top->data, parentoff),
-					fa->fmtstr,
+					count, fa->fmtstr,
 					fsize(f, iocur_top->data, parentoff, 0),
 					fa->arg, low,
 					(f->flags & FLD_ARRAY) != 0);
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
