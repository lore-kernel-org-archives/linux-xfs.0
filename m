Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D9oOpf020280 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 04:50:24 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pBFxrsnHgMnwaEy1 for
	<xfs@oss.sgi.com>; Fri, 13 Apr 2012 02:50:22 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3D9oMbV012479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:50:22 -0400
From: tmarek@redhat.com
Subject: [PATCH 2/5] xfstests 233: fix user fsgqa access to fsstress
Date: Fri, 13 Apr 2012 11:49:43 +0200
Message-Id: <1334310586-2281-2-git-send-email-tmarek@redhat.com>
In-Reply-To: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
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
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

From: Tom Marek <tmarek@redhat.com>

User fsgqa may sometimes be unable to run fsstress (when xfstests are owned by
root) because fsgqa doesn't have rights to list directory where the fsstress
utility is located.

This fix changes directory to fsstress location as root before running
fsstress so user fsgqa may run it without any problems.

Signed-off-by: Tom Marek <tmarek@redhat.com>

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 233 |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/233 b/233
index 28e6ac7..e9eacae 100755
--- a/233
+++ b/233
@@ -62,14 +62,16 @@ _fsstress()
 -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 \
 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
 -n $count -d $out -p 7"
-
 	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
-	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seq.full | _filter_num
+	fsstressdir=${FSSTRESS_PROG%/*}
+	cd $fsstressdir
+	if ! su $qa_user -c "./`basename $FSSTRESS_PROG` $args" | tee -a $here/$seq.full | _filter_num
 	then
 		echo "    fsstress $args returned $?"
 		cat $tmp.out | tee -a $here/$seq.full
 		status=1
 	fi
+	cd $here
 }
 
 # real QA test starts here
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
