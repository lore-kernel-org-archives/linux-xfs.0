Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 392F329E04
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 11:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C28C6AC005
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 09:09:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rwxwzGCIRmnfDUol for
	<xfs@oss.sgi.com>; Fri, 01 Nov 2013 09:09:10 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rA1G9AvY030692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 1 Nov 2013 12:09:10 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: _filter_mkfs should consume input from stdin first
	to avoid EPIPE
Date: Sat,  2 Nov 2013 00:08:49 +0800
Message-Id: <1383322129-20322-1-git-send-email-eguan@redhat.com>
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

_filter_mkfs is a filter so that it should read from stdin first
before printing anything out. Otherwise the command prior to the
pipeline may get EPIPE.

I saw this when testing extN with generic/204, _scratch_mkfs_sized was
unable to create fs because of EPIPE, then _scratch_mount failed.

generic/204 12s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/204.out.bad)
    --- tests/generic/204.out   2013-11-01 16:47:56.728591856 +0800
    +++ /root/xfstests/results//generic/204.out.bad     2013-11-01 22:52:53.207828779 +0800
    @@ -1,2 +1,7 @@
     QA output created by 204
    -*** done
    +mount: wrong fs type, bad option, bad superblock on /dev/sda6,
    +       missing codepage or helper program, or other error
    +       In some cases useful info is found in syslog - try
    +       dmesg | tail  or so
    +

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/common/filter b/common/filter
index e37ce69..faf33e3 100644
--- a/common/filter
+++ b/common/filter
@@ -134,16 +134,19 @@ _filter_date()
 # Non XFS filesystems always return a 4k block size and a 256 byte inode.
 _filter_mkfs()
 {
+    local tmp=/tmp/mkfs_filter
+    cat - >$tmp
+
     case $FSTYP in
     xfs)
 	;;
     *)
 	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
+	rm -f $tmp
 	return ;;
     esac
 
-    set -
-    perl -ne '
+    cat $tmp | perl -ne '
     if (/^meta-data=([\w,|\/.-]+)\s+isize=(\d+)\s+agcount=(\d+), agsize=(\d+) blks/) {
 	print STDERR "ddev=$1\nisize=$2\nagcount=$3\nagsize=$4\n";
 	print STDOUT "meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks\n";
@@ -175,6 +178,7 @@ _filter_mkfs()
 	print STDERR "rtdev=$1\nrtextsz=$2\nrtblocks=$3\nrtextents=$4\n";
 	print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
     }'
+    rm -f $tmp
 }
 
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
