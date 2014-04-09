Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30D0C8146
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 06:50:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A908BAC019
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 04:50:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Co8rQ9InGglaC9Ha for
	<xfs@oss.sgi.com>; Wed, 09 Apr 2014 04:50:29 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s39BoS9Q031204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 07:50:29 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] ext4/306: disable 64bit feature too
Date: Wed,  9 Apr 2014 19:49:07 +0800
Message-Id: <1397044147-15727-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

mke2fs ext4 without extent feature will fail if 64bit feature is
enabled in mke2fs.conf

mke2fs 1.42.9 (28-Dec-2013)
Extents MUST be enabled for a 64-bit filesystem.  Pass -O extents to rectify.

So disable 64bit feature together with extent explicitly.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/ext4/306 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/306 b/tests/ext4/306
index 9559cf2..fd50b0e 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -48,7 +48,7 @@ _require_scratch
 rm -f $seqres.full
 
 # Make a small ext4 fs with extents disabled & mount it
-yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
+yes | mkfs.ext4 -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
 _scratch_mount || _fail "couldn't mount fs"
 
 # Create a small non-extent-based file
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
