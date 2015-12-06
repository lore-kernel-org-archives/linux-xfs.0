Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A33407F56
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 11:37:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95294304039
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 09:37:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QOJQ1YJ6NuqSeOZr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Dec 2015 09:37:46 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 0BF90461D5
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 17:37:46 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v2 4/6] check: Add support for tests without *.out files
Date: Sun,  6 Dec 2015 18:37:29 +0100
Message-Id: <1449423451-29845-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
References: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Add support for tests which report their status through their exit code
instead of producing output that is compared with the expected output.

When such a test returns with exit code 77, it is assumed to have been
skipped; all other non-zero exit codes are treated as test failures.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 check | 77 +++++++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/check b/check
index 4a9b332..5ecc12b 100755
--- a/check
+++ b/check
@@ -204,6 +204,13 @@ _prepare_test_list()
 	fi
 }
 
+# Check if a test has any .out* files
+has_out_files()
+{
+    set -- "$1".out*
+    [ $# -gt 0 -a -e "$1" ]
+}
+
 # Process command arguments first.
 while [ $# -gt 0 ]; do
 	case "$1" in
@@ -612,6 +619,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		    err=true
 		fi
 
+		if ! has_out_files $seq; then
+		    if [ $sts -eq 77 ]; then
+			cat $tmp.out > $seqres.notrun
+			sts=0
+		    fi
+		fi
+
 		if [ -f $seqres.notrun ]
 		then
 		    $timestamp || echo -n " [not run] "
@@ -624,41 +638,50 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			echo -n " [failed, exit status $sts]"
 			err=true
 		    fi
-		    if [ ! -f $seq.out ]
-		    then
-			echo " - no qualified output"
-			err=true
-		    else
 
-			# coreutils 8.16+ changed quote formats in error messages from
-			# `foo' to 'foo'. Filter old versions to match the new version.
-			sed -i "s/\`/\'/g" $tmp.out
-			if diff $seq.out $tmp.out >/dev/null 2>&1
+		    if has_out_files $seq; then
+			if [ ! -f $seq.out ]
 			then
-			    if $err
+			    echo " - no qualified output"
+			    err=true
+			else
+			    # coreutils 8.16+ changed quote formats in error messages from
+			    # `foo' to 'foo'. Filter old versions to match the new version.
+			    sed -i "s/\`/\'/g" $tmp.out
+
+			    if ! diff $seq.out $tmp.out >/dev/null 2>&1
 			    then
-				:
-			    else
-				echo "$seqnum `expr $stop - $start`" >>$tmp.time
-				echo -n " `expr $stop - $start`s"
+				echo " - output mismatch (see $seqres.out.bad)"
+				mv $tmp.out $seqres.out.bad
+				$diff $seq.out $seqres.out.bad | {
+				    if test "$DIFF_LENGTH" -le 0; then
+					    cat
+				    else
+					    head -n "$DIFF_LENGTH"
+					    echo "..."
+					    echo "(Run '$diff $seq.out $seqres.out.bad'" \
+						    " to see the entire diff)"
+				    fi; } | \
+				    sed -e 's/^\(.\)/    \1/'
+				err=true
 			    fi
-			    echo ""
+			fi
+		    else
+			if ! $err; then
+			    mv $tmp.out $seqres.out.good
 			else
-			    echo " - output mismatch (see $seqres.out.bad)"
 			    mv $tmp.out $seqres.out.bad
-			    $diff $seq.out $seqres.out.bad | {
-				if test "$DIFF_LENGTH" -le 0; then
-					cat
-				else
-					head -n "$DIFF_LENGTH"
-					echo "..."
-					echo "(Run '$diff $seq.out $seqres.out.bad'" \
-						" to see the entire diff)"
-				fi; } | \
-				sed -e 's/^\(.\)/    \1/'
-			    err=true
+			    echo " - output (see $seqres.out.bad)"
+			    cat $seqres.out.bad
 			fi
 		    fi
+
+		    if ! $err; then
+			echo "$seqnum `expr $stop - $start`" >>$tmp.time
+			echo -n " `expr $stop - $start`s"
+			echo ""
+		    fi
+
 		    try="$try $seqnum"
 		    n_try=`expr $n_try + 1`
 		    _check_filesystems
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
