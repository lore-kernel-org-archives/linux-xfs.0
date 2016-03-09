Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A893F7CA7
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 06:06:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 788428F804B
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 04:06:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DFsZHVAuGzEl6N7X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 04:06:47 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id D8781627F3
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 12:06:46 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v4 2/4] check: Add support for tests without *.out files
Date: Wed,  9 Mar 2016 13:06:36 +0100
Message-Id: <1457525199-15355-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
References: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
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
index 2986d84..1327e1c 100755
--- a/check
+++ b/check
@@ -203,6 +203,13 @@ _prepare_test_list()
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
@@ -635,6 +642,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
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
@@ -647,41 +661,50 @@ for section in $HOST_OPTIONS_SECTIONS; do
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
