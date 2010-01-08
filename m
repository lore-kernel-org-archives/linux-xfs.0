Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08IDq8a061864 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 12:13:52 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 713B7AC033
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 10:14:42 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH 1/2] xfstests: 050: ignore duplicates reported by repquota
Date: Fri, 8 Jan 2010 12:14:41 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6933@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Arrange to ignore duplicate entries reported by the "repquota"
xfs_quota command.  This can happen if an id is used more than once
(such as when two user names are assigned the same uid).

Since we are already sorting the output we can accomplish this by
adding the "-u" (unique) option to the sort command.  Shorten some
long lines while we're at it.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 050 |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

Index: b/050
===================================================================
--- a/050
+++ b/050
@@ -118,7 +118,9 @@
 
 	echo
 	echo "*** report no quota settings" | tee -a $seq.full
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_report | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** report initial settings" | tee -a $seq.full
@@ -129,20 +131,26 @@
 		-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
 		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
 		$SCRATCH_DEV
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_report | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft inode limit" | tee -a $seq.full
 	_file_as_id $SCRATCH_MNT/softie1 $id $type 1024 0
 	_file_as_id $SCRATCH_MNT/softie2 $id $type 1024 0
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_report | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft block limit" | tee -a $seq.full
 	_file_as_id $SCRATCH_MNT/softie $id $type 1024 140
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_report | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
@@ -152,7 +160,9 @@
 		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
 	done
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_report | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
@@ -161,7 +171,9 @@
 	echo "ls -l $SCRATCH_MNT" >>$seq.full
 	ls -l $SCRATCH_MNT >>$seq.full
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -birnN -$type" $SCRATCH_DEV | _filter_and_check_blks | LC_COLLATE=POSIX sort -r
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** unmount"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
