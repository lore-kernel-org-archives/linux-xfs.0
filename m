Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75A537F55
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 14:48:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56D8D8F8073
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 12:48:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PqfzccRBp7fYLmOp for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 12:48:46 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r99JmktX002309
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 15:48:46 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r99JmjUZ013180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 15:48:45 -0400
Message-ID: <5255B31D.3050306@redhat.com>
Date: Wed, 09 Oct 2013 14:48:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix xfs/205 for new log size defaults
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
To: xfs-oss <xfs@oss.sgi.com>

test xfs/205 expects a certain log size, but defaults have
changed, the logs are bigger, and this test now fails w/ early
ENOSPC:

     QA output created by 205
    +   !!! disk full (expected)
    +   !!! disk full (expected)
    +   !!! disk full (expected)
     *** one file
    +   !!! disk full (expected)
     *** one file, a few bytes at a time
     ...

Fix this by specifying the log size at mkfs time, so freespace is
as the test expects it to be.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/205 b/tests/xfs/205
index c9b73a1..0c071ca 100755
--- a/tests/xfs/205
+++ b/tests/xfs/205
@@ -41,7 +41,7 @@ _require_scratch
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -d size=16m -b size=512 >> $seqres.full 2>&1
+_scratch_mkfs_xfs -d size=16m -b size=512 -l size=4944b >> $seqres.full 2>&1
 _scratch_mount
 
 # fix the reserve block pool to a known size so that the enospc calculations

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
