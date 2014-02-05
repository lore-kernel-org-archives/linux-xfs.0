Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D7E27F53
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:40:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 556948F8037
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 22:40:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	poioyLlHZgdFinPF for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 22:40:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WAw9v-0004FK-O1
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 17:40:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WAw9v-0000mV-Mm
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 17:40:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs/299: users can't modify root owned files
Date: Wed,  5 Feb 2014 17:40:31 +1100
Message-Id: <1391582431-2970-1-git-send-email-david@fromorbit.com>
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

xfs/299 has failed for me for a long time. In fact, looking at my
logs it has never passed on any of my test machines. IOWs, the
test that was committed was fundamentally broken.

The reason is that it tests project quotas before it tests user or
group quotas and so creates a bunch of files that are owned by root
or privileged users. It think tries to manipulate them as a user,
and, unsurprisingly, it fails to do so. This then causes the test to
throw an error.

The reason it has always failed is the error that is thrown
hardcodes a uid/gid into an error message. This uid/gid is what
causes the golden output mismatch (nobody is 65534 on my machines,
not 99):

     *** push past the hard block limit (expect EDQUOT)
     [ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
     [NAME] =OK= 100 500 00 [--------] 7 4 10 00 [7 days] 0 0 0 00 [--------]
    - URK 99: 0 is out of range! [425,500]
    + URK 65534: 0 is out of range! [425,500]

It wasn't until I looked at the xfs/299.full file when trying to
understand why the error was being thrown and whether it shoul dhave
been in the golden output in the first place that I saw the real
problem. That is, All the user/group quota modifications were
failing because of not having permissions to write the files left
behind by the quota test, and that user and group quotas were not
being tested at all by the test.

So, firstly $SCRATCH_MNT needs to be world writeable, and secondly
each test needs to remove the files it created during the test so
they don't impact on furture test iterations.

This then exercises the user and group quotas appropriately, and so
the golden output changes completely to reflect that changes under
user quotas are actually being accounted to the correct user.
Further, the error message that I originally saw errors on goes
away, because everything is now accounted correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/299     |  6 ++++
 tests/xfs/299.out | 96 +++++++++++++++++++++++++------------------------------
 2 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/tests/xfs/299 b/tests/xfs/299
index e374131..d190974 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -193,6 +193,9 @@ _exercise()
 
 	echo
 
+	# clean up our files so we don't pollute the next run
+	rm -f $SCRATCH_MNT/*
+
 }
 
 _scratch_mkfs_xfs -m crc=1 2>/dev/null | _filter_mkfs 2>$tmp.mkfs
@@ -200,6 +203,9 @@ cat $tmp.mkfs >>$seqres.full
 # keep the blocksize and data size for dd later
 . $tmp.mkfs
 
+# non-root users need to be able to write to this filesystem
+chmod 777 $SCRATCH_MNT
+
 cat >$tmp.projects <<EOF
 1:$SCRATCH_MNT
 EOF
diff --git a/tests/xfs/299.out b/tests/xfs/299.out
index 4185c98..d13c7da 100644
--- a/tests/xfs/299.out
+++ b/tests/xfs/299.out
@@ -32,59 +32,51 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 
 *** report no quota settings
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
 
 *** report initial settings
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 7 4 10 00 [7 days] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 12 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [--------] 7 4 10 00 [7 days] 0 0 0 00 [--------]
- URK 99: 0 is out of range! [425,500]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 
 *** report no quota settings
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
 
 *** report initial settings
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 10 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
-#1 500 0 0 00 [--------] 9 0 0 00 [--------] 0 0 0 00 [--------]
- URK 99: 0 is out of range! [425,500]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** unmount
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
@@ -120,50 +112,50 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 
 *** report no quota settings
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
 
 *** report initial settings
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
 
 
 *** report no quota settings
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
 
 *** report initial settings
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 19 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
+[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
