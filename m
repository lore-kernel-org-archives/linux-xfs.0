Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3A8cnor074471 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 03:38:50 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DRIbQ7qcGBgWGC7Z for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 01:38:48 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3A8clS0023073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 04:38:48 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: Change the diff output of failed tests
Date: Tue, 10 Apr 2012 10:38:33 +0200
Message-Id: <1334047113-32720-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Currently the entire diff is printed to the stdout in the case that the
test output template differs from the actual test run. However in some
cases the diff can be _very_ long. This commit changes it so that we
print only first 10 lines of the diff.

Also indent the diff output from the left by four spaces for better
output readability.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/check b/check
index f792009..c5d67a5 100755
--- a/check
+++ b/check
@@ -286,7 +286,11 @@ do
 		else
 		    echo " - output mismatch (see $seq.out.bad)"
 		    mv $tmp.out $seq.out.bad
-		    $diff $seq.out $seq.out.bad
+		    $diff $seq.out $seq.out.bad | head -n 10 | \
+			sed -e 's/^\(.\)/    \1/'
+		    echo "     ..."
+		    echo "     (Run '$diff $seq.out $seq.out.bad' to see the" \
+			 "entire diff)"
 		    err=true
 		fi
 	    fi
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
