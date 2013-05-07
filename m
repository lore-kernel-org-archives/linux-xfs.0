Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 637A729E03
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:09:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 554A3304067
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 15:09:40 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OW208j9RXJFie3iH for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 15:09:39 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4ABBBA5077
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 00:09:39 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] Make test 306 use null and zero device nodes on
	SCRATCH_MNT
Date: Wed,  8 May 2013 00:09:33 +0200
Message-Id: <1367964573-29620-2-git-send-email-jack@suse.cz>
In-Reply-To: <1367964573-29620-1-git-send-email-jack@suse.cz>
References: <1367964573-29620-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

In one place of test 306, we mistakenly used /dev/null and /dev/zero
instead of equivalent devices created on tested filesystem. So we were
not really testing the functionality we intended.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/306 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/306 b/tests/generic/306
index e8e0fc0..f45d142 100644
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -73,9 +73,9 @@ _scratch_mount -o ro || _fail "Could not mount scratch readonly"
 echo "== try to create new file"
 touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
 echo "== pwrite to null device"
-$XFS_IO_PROG -F -c "pwrite 0 512" /dev/null | _filter_xfs_io
+$XFS_IO_PROG -F -c "pwrite 0 512" $DEVNULL | _filter_xfs_io
 echo "== pread from zero device"
-$XFS_IO_PROG -F -c "pread 0 512" /dev/zero | _filter_xfs_io
+$XFS_IO_PROG -F -c "pread 0 512" $DEVZERO | _filter_xfs_io
 
 echo "== truncating write to null device"
 echo foo > $DEVNULL 2>&1 | _filter_scratch
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
