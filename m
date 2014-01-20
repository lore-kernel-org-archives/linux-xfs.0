Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D07157F5A
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D8678F8040
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dAR50piofNTzBBbx for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Kq-Mh
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004UE-Lk
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfs: support xfs_metadump with external logs
Date: Mon, 20 Jan 2014 17:22:35 +1100
Message-Id: <1390198957-17184-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When running xfstests with an external log, the metadump tests fail
with extra output like:

    +filesystem is marked as having an external log; specify logdev on the mount command line.
    +xfs_metadump: cannot read superblock for ag 0

Add a _scratch_metadump() function to handle different logdev
configurations automatically for metadump.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc     | 10 ++++++++++
 tests/xfs/253 |  3 +--
 tests/xfs/291 |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index d497818..49c86de 100644
--- a/common/rc
+++ b/common/rc
@@ -317,6 +317,16 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+_scratch_metadump()
+{
+	dumpfile=$1
+	options=
+
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		options="-l $SCRATCH_LOGDEV"
+
+	xfs_metadump $options $SCRATCH_DEV $dumpfile
+}
 
 _setup_large_xfs_fs()
 {
diff --git a/tests/xfs/253 b/tests/xfs/253
index f491ef4..4119794 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -171,8 +171,7 @@ ls -R | od -c >> $seqres.full
 cd $here
 
 _scratch_unmount
-
-xfs_metadump -f "${SCRATCH_DEV}" "${METADUMP_FILE}"
+_scratch_metadump $METADUMP_FILE
 
 # Now restore the obfuscated one back and take a look around
 xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
diff --git a/tests/xfs/291 b/tests/xfs/291
index 03c4de9..d5a9b08 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -117,7 +117,7 @@ _xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
-xfs_metadump $SCRATCH_DEV $tmp.metadump || _fail "xfs_metadump failed"
+_scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
 xfs_repair $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
