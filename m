Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFDF37F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 09:21:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1F9D8F8035
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 07:21:40 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id HNpChEeZVVIHWOCH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 07:21:39 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EEBCD7C0017
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 08:21:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: use xfs_io fiemap instead of filefrag V2
Date: Mon, 24 Jun 2013 10:21:36 -0400
Message-ID: <1372083696-10402-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, sandeen@redhat.com

Btrfs has always failed shared/218 because of the way we allocate extents on
disk.  The last part of 218 writes contiguously holey from the start of the file
forward, which for btrfs means we get 16 extents but they are physically
contigous.  filefrag -v shows all 16 extents, but prints out that there is 1
extent, because they are physically contiguous.  This isn't quite right and
makes the test fail.  So instead of using filefrag use xfs_io -c fiemap which
will print the whole map and then get the count from there.  With this patch
btrfs now passes the test, I also verified that ext4 and xfs still pass this
test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: change _require_defrag to check for xfs_io having fiemap support as per
Eric's suggestion.

 common/defrag |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/defrag b/common/defrag
index f04fd42..a4bc976 100644
--- a/common/defrag
+++ b/common/defrag
@@ -38,13 +38,13 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_command $FILEFRAG_PROG
+    _require_xfs_io_fiemap
 }
 
 _extent_count()
 {
-	$FILEFRAG_PROG $1 | awk '{print $2}'
-	$FILEFRAG_PROG -v $1  >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l
+	$XFS_IO_PROG -c "fiemap" $1  >> $seqres.full 2>&1
 }
 
 # Defrag file, check it, and remove it.
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
