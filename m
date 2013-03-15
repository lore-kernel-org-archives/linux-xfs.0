Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 213D6801D
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0495E8F8040
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vRdXDDd2GgN3xFOr for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCt-0001U9-KX
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:55 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCj-0005iX-Ha
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/13] xfstests: correct quota file count for --large-fs
Date: Fri, 15 Mar 2013 22:53:31 +1100
Message-Id: <1363348411-21867-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

The files used to fill space when using --large-fs contribute
towards the quota of uid 0. Modify the quota output filter in test
050 to "hide" these files from the test output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 050       |    8 +++++++-
 common.rc |    2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/050 b/050
index cf70b5a..acca654 100755
--- a/050
+++ b/050
@@ -69,7 +69,13 @@ _filter_report()
 	perl -npe '
 		s/^\#'$id' /[NAME] /g;
 		s/^\#0 \d+ /[ROOT] 0 /g;
-		s/6 days/7 days/g'
+		s/6 days/7 days/g' |
+	perl -npe '
+		$val = 0;
+		if ($ENV{'LARGE_SCRATCH_DEV'}) {
+			$val = $ENV{'NUM_SPACE_FILES'};
+		}
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g'
 }
 
 # The actual point at which limit enforcement takes place for the
diff --git a/common.rc b/common.rc
index 96d5077..319680d 100644
--- a/common.rc
+++ b/common.rc
@@ -308,6 +308,7 @@ _setup_large_xfs_fs()
 		-c "falloc -k 0 $file_size" \
 		-c "chattr +d" \
 		$SCRATCH_MNT/.use_space 2>&1 > /dev/null
+	export NUM_SPACE_FILES=1
 	status=$?
 	umount $SCRATCH_MNT
 	if [ $status -ne 0 ]; then
@@ -417,6 +418,7 @@ _setup_large_ext4_fs()
 			$SCRATCH_MNT/.use_space.$nfiles 2>&1
 		status=$?
 	fi
+	export NUM_SPACE_FILES=$nfiles
 
 	umount $SCRATCH_MNT
 	if [ $status -ne 0 ]; then
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
