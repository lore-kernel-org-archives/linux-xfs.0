Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA15229DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:52:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 735628F8040
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 12:52:33 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id LgLrJfNgrfzKj4ls (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 12:52:31 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Aug 2013 20:52:31 +0100
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 740306E803A
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 15:52:22 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r71JqRt2183240 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:52:27 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r71JqRLv013456 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:52:27 -0400
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r71JqQCk013447 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:52:27 -0400
Subject: Subject: [PATCH] xfstests: Test all 3 quotas simultaneously.
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 01 Aug 2013 14:52:26 -0500
Message-ID: <1375386746.4155.6.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

Add a test for testing all 3 (user, group and project) quotas together.

This is a modified version of xfstest 050.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 tests/xfs/299     |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/299.out |  170 ++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 419 insertions(+), 0 deletions(-)
 create mode 100755 tests/xfs/299
 create mode 100644 tests/xfs/299.out

diff --git a/tests/xfs/299 b/tests/xfs/299
new file mode 100755
index 0000000..1436575
--- /dev/null
+++ b/tests/xfs/299
@@ -0,0 +1,248 @@
+#! /bin/bash
+# FS QA Test No. 299
+#
+# Exercises basic XFS quota functionality, with all 3 quotas together
+#       uquota, gquota, pquota
+#       uqnoenforce, gqnoenforce, pqnoenforce
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+cp /dev/null $seqres.full
+chmod a+rwx $seqres.full	# arbitrary users will write here
+
+_require_scratch
+_require_xfs_quota
+
+bsoft=100
+bhard=500
+isoft=4
+ihard=10
+
+_filter_report()
+{
+	tr -s '[:space:]' | \
+	perl -npe '
+		s/^\#'$id' /[NAME] /g;
+		s/^\#0 \d+ /[ROOT] 0 /g;
+		s/6 days/7 days/g' |
+	perl -npe '
+		$val = 0;
+		if ($ENV{'LARGE_SCRATCH_DEV'}) {
+			$val = $ENV{'NUM_SPACE_FILES'};
+		}
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g'
+}
+
+# The actual point at which limit enforcement takes place for the
+# hard block limit is variable depending on filesystem blocksize,
+# and iosize.  What we want to test is that the limit is enforced
+# (ie. blksize less than limit but not unduly less - ~85% is kind)
+# nowadays we actually get much closer to the limit before EDQUOT.
+#
+_filter_and_check_blks()
+{
+	perl -npe '
+		if (/^\#'$id'\s+(\d+)/ && '$enforce') {
+			$maximum = '$bhard';
+			$minimum = '$bhard' * 85/100;
+			if (($1 < $minimum || $1 > $maximum) && '$noextsz') {
+				printf(" URK %d: %d is out of range! [%d,%d]\n",
+					'$id', $1, $minimum, $maximum);
+			}
+			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
+		}
+	' | _filter_report
+}
+
+_qsetup()
+{
+	opt=$1
+	enforce=0
+	if [ $opt = "u" -o $opt = "uno" ]; then
+		type=u
+		eval `_choose_uid`
+	elif [ $opt = "g" -o $opt = "gno" ]; then
+		type=g
+		eval `_choose_gid`
+	elif [ $opt = "p" -o $opt = "pno" ]; then
+		type=p
+		eval `_choose_prid`
+	fi
+	[ $opt = "u" -o $opt = "g" -o $opt = "p" ] && enforce=1
+
+	echo "Using type=$type id=$id" >> $seqres.full
+}
+
+_exercise()
+{
+
+	# Figure out whether we're doing large allocations
+	# (bail out if they're so large they stuff the test up)
+	_test_inode_flag extsz-inherit $SCRATCH_MNT
+	noextsz=$?
+	extsize=`_test_inode_extsz $SCRATCH_MNT`
+	[ $extsize -ge 512000 ] && \
+		_notrun "Extent size hint is too large ($extsize bytes)"
+
+	_qsetup $1
+
+	echo "Using type=$type id=$id" >>$seqres.full
+
+	echo
+	echo "*** report no quota settings" | tee -a $seqres.full
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** report initial settings" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
+	echo "ls -l $SCRATCH_MNT" >>$seqres.full
+	ls -l $SCRATCH_MNT >>$seqres.full
+	xfs_quota -D $tmp.projects -P $temp.projid -x \
+		-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
+		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
+		$SCRATCH_DEV
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft inode limit" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/softie1 $id $type 1024 0
+	_file_as_id $SCRATCH_MNT/softie2 $id $type 1024 0
+	_qmount
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft block limit" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/softie $id $type 1024 140
+	_qmount
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	# Note: for quota accounting (not enforcement), EDQUOT is not expected
+	echo "*** push past the hard inode limit (expect EDQUOT)" | tee -a $seqres.full
+	for i in 1 2 3 4 5 6 7 8 9 10 11 12
+	do
+		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
+	done
+	_qmount
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	# Note: for quota accounting (not enforcement), EDQUOT is not expected
+	echo "*** push past the hard block limit (expect EDQUOT)" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/softie $id $type 1024 540
+	echo "ls -l $SCRATCH_MNT" >>$seqres.full
+	ls -l $SCRATCH_MNT >>$seqres.full
+	_qmount
+	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
+
+	echo
+
+}
+
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+cat $tmp.mkfs >>$seqres.full
+# keep the blocksize and data size for dd later
+. $tmp.mkfs
+
+sb_ver=`$XFS_DB_PROG -r -c version $SCRATCH_DEV | awk -F= '{print $2}' | awk -F, '{print $1}' |cut -c3-`
+echo $sb_ver
+
+if [ $sb_ver -lt 5 ]
+then
+	_notrun "Can't run with older versions of superblock"
+fi
+
+cat >$tmp.projects <<EOF
+1:$SCRATCH_MNT
+EOF
+
+cat >$tmp.projid <<EOF
+root:0
+scrach:1
+EOF
+
+projid_file="$tmp.projid"
+
+echo "*** user, group, and project"
+_qmount_option "uquota,gquota,pquota"
+_qmount
+_exercise p
+_exercise g
+_exercise u
+
+echo "*** unmount"
+umount $SCRATCH_MNT
+
+
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+cat $tmp.mkfs >>$seqres.full
+# keep the blocksize and data size for dd later
+. $tmp.mkfs
+
+echo "*** uqnoenforce, gqnoenforce, and pqnoenforce"
+_qmount_option "uqnoenforce,gqnoenforce,pqnoenforce"
+_qmount
+_exercise uno
+_exercise gno
+_exercise pno
+
+echo "*** unmount"
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/299.out b/tests/xfs/299.out
new file mode 100644
index 0000000..b2699b4
--- /dev/null
+++ b/tests/xfs/299.out
@@ -0,0 +1,170 @@
+QA output created by 299
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+5
+*** user, group, and project
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 7 4 10 00 [7 days] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [--------] 7 4 10 00 [7 days] 0 0 0 00 [--------]
+ URK 99: 0 is out of range! [425,500]
+
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+ URK 99: 0 is out of range! [425,500]
+
+*** unmount
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** uqnoenforce, gqnoenforce, and pqnoenforce
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+
+*** report no quota settings
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft block limit
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard inode limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** push past the hard block limit (expect EDQUOT)
+[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+
+*** unmount
diff --git a/tests/xfs/group b/tests/xfs/group
index b4f4eb9..352a4c5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -178,3 +178,4 @@
 296 dump auto quick
 297 auto freeze
 298 auto attr symlink quick
+299 auto quota
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
