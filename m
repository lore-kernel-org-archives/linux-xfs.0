Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UC6O1D032177 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 07:06:24 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vRAmX9HRPLdg0wbC for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 05:06:23 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q6UC6NJ2031757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 08:06:23 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
Date: Mon, 30 Jul 2012 14:06:03 +0200
Message-Id: <1343649963-14079-1-git-send-email-tracek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

Rename fstrim option from "-s" to "-o" and change output message when
verbose option is set.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 251          |    2 +-
 260          |   22 ++++++++++++----------
 src/fstrim.c |   11 ++++++-----
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/251 b/251
index f46b6e2..a70798e 100755
--- a/251
+++ b/251
@@ -107,7 +107,7 @@ fstrim_loop()
 			wait $fpid
 		fi
 		while [ $start -lt $fsize ] ; do
-			$here/src/fstrim -m ${minlen}k -s ${start}k -l ${step}k $SCRATCH_MNT &
+			$here/src/fstrim -m ${minlen}k -o ${start}k -l ${step}k $SCRATCH_MNT &
 			fpid=$!
 			wait $fpid
 			start=$(( $start + $step ))
diff --git a/260 b/260
index b005cd3..52527da 100755
--- a/260
+++ b/260
@@ -59,19 +59,19 @@ max_64bit=$(_math "2^64 - 1")
 # the file system
 
 echo "[+] Start beyond the end of fs (should fail)"
-"$FSTRIM" -s $beyond_eofs $SCRATCH_MNT
+"$FSTRIM" -o $beyond_eofs $SCRATCH_MNT
 [ $? -eq 0 ] && status=1
 
 echo "[+] Start beyond the end of fs with len set (should fail)"
-"$FSTRIM" -s $beyond_eofs -l1M $SCRATCH_MNT
+"$FSTRIM" -o $beyond_eofs -l1M $SCRATCH_MNT
 [ $? -eq 0 ] && status=1
 
 echo "[+] Start = 2^64-1 (should fail)"
-"$FSTRIM" -s $max_64bit $SCRATCH_MNT
+"$FSTRIM" -o $max_64bit $SCRATCH_MNT
 [ $? -eq 0 ] && status=1
 
 echo "[+] Start = 2^64-1 and len is set (should fail)"
-"$FSTRIM" -s $max_64bit -l1M $SCRATCH_MNT
+"$FSTRIM" -o $max_64bit -l1M $SCRATCH_MNT
 [ $? -eq 0 ] && status=1
 
 _scratch_unmount
@@ -85,13 +85,13 @@ echo "[+] Default length (should succeed)"
 "$FSTRIM" $SCRATCH_MNT
 [ $? -ne 0 ] && status=1
 echo "[+] Default length with start set (should succeed)"
-"$FSTRIM" -s10M $SCRATCH_MNT
+"$FSTRIM" -o10M $SCRATCH_MNT
 [ $? -ne 0 ] && status=1
 echo "[+] Length beyond the end of fs (should succeed)"
 "$FSTRIM" -l $beyond_eofs $SCRATCH_MNT
 [ $? -ne 0 ] && status=1
 echo "[+] Length beyond the end of fs with start set (should succeed)"
-"$FSTRIM" -s10M -l $beyond_eofs $SCRATCH_MNT
+"$FSTRIM" -o10M -l $beyond_eofs $SCRATCH_MNT
 [ $? -ne 0 ] && status=1
 
 _scratch_unmount
@@ -101,8 +101,9 @@ _scratch_mount
 # This is a bit fuzzy, but since the file system is fresh
 # there should be at least (fssize/2) free space to trim.
 # This is supposed to catch wrong FITRIM argument handling
-out=$("$FSTRIM" -v -s10M $SCRATCH_MNT)
-bytes=${out%% *}
+out=$("$FSTRIM" -v -o10M $SCRATCH_MNT)
+nopref=${out##*: }
+bytes=${nopref%% *}
 
 if [ $bytes -gt $(_math "$fssize*1024") ]; then
 	status=1
@@ -155,7 +156,7 @@ _scratch_unmount
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 # It should fail since $start is beyond the end of file system
-"$FSTRIM" -s$start -l10M $SCRATCH_MNT &> /dev/null
+"$FSTRIM" -o$start -l10M $SCRATCH_MNT &> /dev/null
 if [ $? -eq 0 ]; then
 	status=1
 	echo "It seems that fs logic handling start"\
@@ -174,7 +175,8 @@ _scratch_mount
 # mapped and since we got here right after the mkfs, there is not
 # enough free extents in the root tree.
 out=$("$FSTRIM" -v -l$len $SCRATCH_MNT)
-bytes=${out%% *}
+nopref=${out##*: }
+bytes=${nopref%% *}
 if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
 	status=1
 	echo "It seems that fs logic handling len argument overflows"
diff --git a/src/fstrim.c b/src/fstrim.c
index e23bcb3..9986d4e 100644
--- a/src/fstrim.c
+++ b/src/fstrim.c
@@ -58,9 +58,9 @@ struct options {
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: %s [-s start] [-l length] [-m minimum-extent]"
+		"Usage: %s [-o offset] [-l length] [-m minimum-extent]"
 		" [-v] {mountpoint}\n\t"
-		"-s Starting Byte to discard from\n\t"
+		"-o Offset in Bytes to discard from\n\t"
 		"-l Number of Bytes to discard from the start\n\t"
 		"-m Minimum extent length to discard\n\t"
 		"-v Verbose - number of discarded bytes\n",
@@ -152,9 +152,9 @@ static int parse_opts(int argc, char **argv, struct options *opts)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "s:l:m:v")) != EOF) {
+	while ((c = getopt(argc, argv, "o:l:m:v")) != EOF) {
 		switch (c) {
-		case 's': /* starting point */
+		case 'o': /* starting point */
 			opts->range->start = get_number(&optarg);
 			break;
 		case 'l': /* length */
@@ -242,7 +242,8 @@ int main(int argc, char **argv)
 	}
 
 	if ((opts->verbose) && (opts->range))
-		fprintf(stdout, "%llu Bytes were trimmed\n", (unsigned long long)opts->range->len);
+		fprintf(stdout, "%s: %llu bytes were trimmed\n", opts->mpoint,
+			(unsigned long long)opts->range->len);
 
 	ret = EXIT_SUCCESS;
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
