Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C4it4T217513 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:44:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BAADEFE5C0
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 20:45:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	5RLL3I0svHRveite for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 20:45:49 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11406830-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:15:48 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYdV-0004g7-NS
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:45:45 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYZJ-0005zg-AT
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfsqa: filter log size in 206
Date: Tue, 12 Jan 2010 15:41:08 +1100
Message-Id: <1263271269-18997-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263271269-18997-1-git-send-email-david@fromorbit.com>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
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

With the log size now going past 128MB, test 206 creates a filesystem
with a much larger log than 128MB. The golden output expects at
128MB log size, so the test breaks. Filter the log size out of the
mkfs output and golden output so that the test works on both older and
newer mkfs binaries.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 206     |    9 ++++++---
 206.out |    6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/206 b/206
index b1b2286..0935335 100755
--- a/206
+++ b/206
@@ -75,19 +75,22 @@ dd if=/dev/zero of=$tmpfile bs=1 seek=19998630180864 count=1 >/dev/null 2>&1 \
 # mkfs slightly smaller than that
 echo "=== mkfs.xfs ==="
 mkfs.xfs -f -bsize=4096 -dagsize=76288719b,size=3905982455b -llazy-count=0 $tmpfile \
-	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g"
+	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
+		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/"
 
 mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
 
 # see what happens when we growfs it
 echo "=== xfs_growfs ==="
 xfs_growfs $tmpdir \
-	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g"
+	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
+		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/"
 
 # and double-check the new geometry
 echo "=== xfs_info ==="
 xfs_info $tmpdir \
-	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g"
+	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
+		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/"
 
 # _cleanup cleans up for us
 
diff --git a/206.out b/206.out
index 57d4f4e..da70d01 100644
--- a/206.out
+++ b/206.out
@@ -6,7 +6,7 @@ meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal log           bsize=4096   blocks=32768, version=2
+log      =internal log           bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
 === xfs_growfs ===
@@ -15,7 +15,7 @@ meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal               bsize=4096   blocks=32768, version=2
+log      =internal               bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
 data blocks changed from 3905982455 to 4882478016
@@ -25,6 +25,6 @@ meta-data=FILE                   isize=256    agcount=64, agsize=76288719 blks
 data     =                       bsize=4096   blocks=4882478016, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
-log      =internal               bsize=4096   blocks=32768, version=2
+log      =internal               bsize=4096   blocks=XXXXX, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
 realtime =none                   extsz=4096   blocks=0, rtextents=0
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
