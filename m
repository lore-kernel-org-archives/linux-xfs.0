Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 657E27F5E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 01:33:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3422D8F8050
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 23:33:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6N3p3UdL2Zgd9RaH for
	<xfs@oss.sgi.com>; Thu, 03 Oct 2013 23:33:00 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r946WxdK028610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 4 Oct 2013 02:33:00 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfstests generic/260: get correct trimmed bytes
Date: Fri,  4 Oct 2013 14:32:56 +0800
Message-Id: <1380868376-16783-1-git-send-email-eguan@redhat.com>
In-Reply-To: <20131004010737.GE4446@dastard>
References: <20131004010737.GE4446@dastard>
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

Starting from util-linux v2.23 fstrim(1) reports trimmed bytes
differently, e.g.

new fstrim: /mnt/ext4: 9.7 GiB (10411118592 bytes) trimmed
old fstrim: /mnt/ext4: 10411118592 bytes were trimmed

generic/260 reports syntax error

    +./tests/generic/260: line 111: [: 9.7: integer expression expected
    +./tests/generic/260: line 121: [: 9.7: integer expression expected
    +./tests/generic/260: line 183: [: 9.7: integer expression expected

Add a new filter called _filter_fstrim in common/filter and get the
correct trimmed bytes in generic/260, so the test passes with both old
and new fstrim.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2: add _filter_fstrim to filter the output as Dave suggested

 common/filter     | 8 ++++++++
 tests/generic/260 | 8 ++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/common/filter b/common/filter
index ee738ca..9144863 100644
--- a/common/filter
+++ b/common/filter
@@ -280,5 +280,13 @@ _filter_size_to_bytes()
 	echo $((${size:0:${#size}-1}*$mul))
 }
 
+# Print trimmed bytes of fstrim
+# Starting from util-linux v2.23 fstrim usees human readable sizes in
+# verbose output
+_filter_fstrim()
+{
+	egrep -o "[0-9]+ bytes" | $AWK_PROG '{print $1}'
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/260 b/tests/generic/260
index dc8b822..a003a7f 100755
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -104,9 +104,7 @@ _scratch_mount
 # This is a bit fuzzy, but since the file system is fresh
 # there should be at least (fssize/2) free space to trim.
 # This is supposed to catch wrong FITRIM argument handling
-out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT)
-nopref=${out##*: }
-bytes=${nopref%% *}
+bytes=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT | _filter_fstrim)
 
 if [ $bytes -gt $(_math "$fssize*1024") ]; then
 	status=1
@@ -177,9 +175,7 @@ _scratch_mount
 # It is because btrfs does not have not-yet-used parts of the device
 # mapped and since we got here right after the mkfs, there is not
 # enough free extents in the root tree.
-out=$($FSTRIM_PROG -v -l$len $SCRATCH_MNT)
-nopref=${out##*: }
-bytes=${nopref%% *}
+bytes=$($FSTRIM_PROG -v -l$len $SCRATCH_MNT | _filter_fstrim)
 if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
 	status=1
 	echo "It seems that fs logic handling len argument overflows"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
