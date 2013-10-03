Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5BD529DFC
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 06:58:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41B1CAC003
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 04:58:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j80ksjJUdXjKEC38 for
	<xfs@oss.sgi.com>; Thu, 03 Oct 2013 04:58:15 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r93BwFKI019601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 3 Oct 2013 07:58:15 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests generic/260: get correct trimmed bytes
Date: Thu,  3 Oct 2013 19:57:17 +0800
Message-Id: <1380801437-1191-1-git-send-email-eguan@redhat.com>
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

Newer fstrim(1) reports trimmed bytes differently, e.g.

new fstrim: /mnt/ext4: 9.7 GiB (10411118592 bytes) trimmed
old fstrim: /mnt/ext4: 10411118592 bytes were trimmed

generic/260 reports syntax error

    +./tests/generic/260: line 111: [: 9.7: integer expression expected
    +./tests/generic/260: line 121: [: 9.7: integer expression expected
    +./tests/generic/260: line 183: [: 9.7: integer expression expected

Fix it so 260 passes with both old and new fstrim.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/260 | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tests/generic/260 b/tests/generic/260
index dc8b822..bc9eb3b 100755
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -104,9 +104,8 @@ _scratch_mount
 # This is a bit fuzzy, but since the file system is fresh
 # there should be at least (fssize/2) free space to trim.
 # This is supposed to catch wrong FITRIM argument handling
-out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT)
-nopref=${out##*: }
-bytes=${nopref%% *}
+out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT | egrep -o "[0-9]+ bytes")
+bytes=${out%% *}
 
 if [ $bytes -gt $(_math "$fssize*1024") ]; then
 	status=1
@@ -177,9 +176,8 @@ _scratch_mount
 # It is because btrfs does not have not-yet-used parts of the device
 # mapped and since we got here right after the mkfs, there is not
 # enough free extents in the root tree.
-out=$($FSTRIM_PROG -v -l$len $SCRATCH_MNT)
-nopref=${out##*: }
-bytes=${nopref%% *}
+out=$($FSTRIM_PROG -v -l$len $SCRATCH_MNT | egrep -o "[0-9]+ bytes")
+bytes=${out%% *}
 if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
 	status=1
 	echo "It seems that fs logic handling len argument overflows"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
