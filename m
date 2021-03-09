Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A24EC4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20A1652AD
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhCIEkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:32914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhCIEkb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AB2665275;
        Tue,  9 Mar 2021 04:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264831;
        bh=uhr8wJ7bb74FE76utpAtAKmZe5Cuj55gHF4cpzpgcPQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rU5Nm0M5I+QGmKD9a0FqUV2AOWd3G9lQ5PhhghxRidEL3Uxy/kT0BmufH/DL+5rSD
         bBRMHk+rti8dPxLFlAHXAfVFMlh9DdofU3DZkLxAd5YE7mNxRx1VhMrnmTSrC7DCm/
         4WnYS2rvURuWPhzSwVg1weR0LSGUpwDHSQNaXRen86Bl4Ep2InRfB0uYcf1XQnvwpF
         cOgoaMMRn76/3CBdNyoBTx4FxSfxeyhZN+x4cuheozH7dT92mAdlgF6LS2SrDK5I3k
         vKJELY/uSjeU8PgpWkywmi2SOwsmfvK4nIOj1OomhDOhHOG2mTQVWvEEHRFc4PzymU
         jqDIouusz1DPw==
Subject: [PATCH 05/10] common/filter: refactor quota report filtering
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:31 -0800
Message-ID: <161526483109.1214319.14555094406560973318.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/299 and xfs/050 share the same function to filter quota reporting
into a format suitable for the golden output.  Refactor this so that we
can use it in a new test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filter |   24 ++++++++++++++++++++++++
 tests/xfs/050 |   30 ++++++------------------------
 tests/xfs/299 |   30 ++++++------------------------
 3 files changed, 36 insertions(+), 48 deletions(-)


diff --git a/common/filter b/common/filter
index 2f3277f7..2efbbd99 100644
--- a/common/filter
+++ b/common/filter
@@ -637,5 +637,29 @@ _filter_getcap()
         sed -e "s/= //" -e "s/\+/=/g"
 }
 
+# Filter user/group/project id numbers out of quota reports, and standardize
+# the block counts to use filesystem block size.  Callers must set the id and
+# bsize variables before calling this function.
+_filter_quota_report()
+{
+	test -n "$id" || echo "id must be set"
+	test -n "$bsize" || echo "block size must be set"
+
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
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
+	perl -npe '
+		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/xfs/050 b/tests/xfs/050
index 53412a13..1df97537 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -47,24 +47,6 @@ bhard=$(( 1000 * $bsize ))
 isoft=4
 ihard=10
 
-_filter_report()
-{
-	tr -s '[:space:]' | \
-	perl -npe '
-		s/^\#'$id' /[NAME] /g;
-		s/^\#0 \d+ /[ROOT] 0 /g;
-		s/6 days/7 days/g' |
-	perl -npe '
-		$val = 0;
-		if ($ENV{'LARGE_SCRATCH_DEV'}) {
-			$val = $ENV{'NUM_SPACE_FILES'};
-		}
-		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
-	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
-	perl -npe '
-		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
-}
-
 # The actual point at which limit enforcement takes place for the
 # hard block limit is variable depending on filesystem blocksize,
 # and iosize.  What we want to test is that the limit is enforced
@@ -84,7 +66,7 @@ _filter_and_check_blks()
 			}
 			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
 		}
-	' | _filter_report
+	' | _filter_quota_report
 }
 
 _qsetup()
@@ -134,7 +116,7 @@ _exercise()
 	echo "*** report no quota settings" | tee -a $seqres.full
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** report initial settings" | tee -a $seqres.full
@@ -147,7 +129,7 @@ _exercise()
 		$SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft inode limit" | tee -a $seqres.full
@@ -159,7 +141,7 @@ _exercise()
 	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft block limit" | tee -a $seqres.full
@@ -169,7 +151,7 @@ _exercise()
 		-c "warn -b -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
@@ -183,7 +165,7 @@ _exercise()
 		-c "warn -i -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
diff --git a/tests/xfs/299 b/tests/xfs/299
index 15e0edf6..b862e67e 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -40,24 +40,6 @@ _require_xfs_quota
 _require_xfs_mkfs_crc
 _require_xfs_crc
 
-_filter_report()
-{
-	tr -s '[:space:]' | \
-	perl -npe '
-		s/^\#'$id' /[NAME] /g;
-		s/^\#0 \d+ /[ROOT] 0 /g;
-		s/6 days/7 days/g' |
-	perl -npe '
-		$val = 0;
-		if ($ENV{'LARGE_SCRATCH_DEV'}) {
-			$val = $ENV{'NUM_SPACE_FILES'};
-		}
-		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
-	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
-	perl -npe '
-		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
-}
-
 # The actual point at which limit enforcement takes place for the
 # hard block limit is variable depending on filesystem blocksize,
 # and iosize.  What we want to test is that the limit is enforced
@@ -77,7 +59,7 @@ _filter_and_check_blks()
 			}
 			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
 		}
-	' | _filter_report
+	' | _filter_quota_report
 }
 
 _qsetup()
@@ -120,7 +102,7 @@ _exercise()
 	echo "*** report no quota settings" | tee -a $seqres.full
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** report initial settings" | tee -a $seqres.full
@@ -133,7 +115,7 @@ _exercise()
 		$SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft inode limit" | tee -a $seqres.full
@@ -145,7 +127,7 @@ _exercise()
 	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	echo "*** push past the soft block limit" | tee -a $seqres.full
@@ -155,7 +137,7 @@ _exercise()
 		-c "warn -b -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
@@ -169,7 +151,7 @@ _exercise()
 		-c "warn -i -$type 0 $id" $SCRATCH_DEV
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
-		_filter_report | LC_COLLATE=POSIX sort -ru
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
 
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected

