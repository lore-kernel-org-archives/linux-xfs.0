Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F241E7F66
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E94B98F8040
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 64j5Na9MDos6GKg1 for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:50 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nPR008473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s42H5nqR024096
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/5] xfs/030: filter out extra repair noise for finobt enabled
	fs'
Date: Fri,  2 May 2014 13:13:58 -0400
Message-Id: <1399050842-19633-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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

xfs/030 nukes various on-disk data structures to test for repair. This
can result in extra output when testing finobt enabled filesystems. For
example, xfs_repair detects an invalid free inode btree root block when
the agi is zeroed.

Filter this output directly in xfs/030 such that the test passes for
finobt and non-finobt filesystems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/030 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/030 b/tests/xfs/030
index af03166..a43455f 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -56,7 +56,8 @@ _check_ag()
 	do
 		echo "Corrupting $structure - setting bits to $1"
 		_check_repair $1 "$structure" |
-			sed -e '/^error following ag 0 unlinked list$/d'
+			sed -e '/^error following ag 0 unlinked list$/d' \
+			    -e '/^bad agbno AGBNO for finobt/d'
 	done
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
