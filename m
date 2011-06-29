Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TG4ltj117983 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 11:04:47 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C6EB1673493
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:04:44 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id NZEP2Ezo6MbCBqS8 for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 09:04:44 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C5B788AC33
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:04:43 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v3] xfstests: Improve test 219 to work with different
	filesystems
Date: Wed, 29 Jun 2011 18:04:40 +0200
Message-Id: <1309363480-22268-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Different filesystems account different amount of metadata in quota. Thus it is
impractical to check for a particular amount of space occupied by a file
because there is no right value. Change the test to verify whether the amount
of space is between the expected amount of space and the expected amount +5%.
The number of files is checked exactly as previously.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 219     |   25 +++++++++++++++++++++++--
 219.out |   18 ++----------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/219 b/219
index 836d703..ad4e64d 100755
--- a/219
+++ b/219
@@ -58,6 +58,23 @@ test_files()
 	done
 }
 
+check_usage()
+{
+	wroteblocks=$1
+	wrotefiles=$2
+	read id exceed blocks bsoft bhard inodes isoft ihard
+	if [ "$blocks" -lt "$wroteblocks" ]; then
+		echo "Too few blocks used (type=$type)"
+	# Save 5% for overhead of metadata or different block size
+	elif [ "$blocks" -gt $((wroteblocks+wroteblocks/20)) ]; then
+		echo "Too many blocks used (type=$type)"
+	elif [ "$inodes" != "$wrotefiles" ]; then
+		echo "Bad number of inodes used (type=$type)"
+	else
+		echo "Usage OK (type=$type)"
+	fi
+}
+
 test_accounting()
 {
 	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
@@ -77,8 +94,12 @@ test_accounting()
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
 
-	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
+	if [ $type == 'u' ]; then
+		id=$uid
+	else
+		id=$gid
+	fi
+	repquota -$type -n $SCRATCH_MNT  | grep "^#$id" | check_usage 144 3
 }
 
 # real QA test starts here
diff --git a/219.out b/219.out
index fadfafc..23ec57c 100644
--- a/219.out
+++ b/219.out
@@ -22,14 +22,7 @@ QA output created by 219
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for user quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
-                        Block limits                File limits
-User            used    soft    hard  grace    used  soft  hard  grace
-----------------------------------------------------------------------
-#1        --     144       0       0              3     0     0       
-
-
+Usage OK (type=u)
 
 ### test group accounting
 
@@ -53,11 +46,4 @@ User            used    soft    hard  grace    used  soft  hard  grace
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for group quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
-                        Block limits                File limits
-Group           used    soft    hard  grace    used  soft  hard  grace
-----------------------------------------------------------------------
-#2        --     144       0       0              3     0     0       
-
-
+Usage OK (type=g)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
