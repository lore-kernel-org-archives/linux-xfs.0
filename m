Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F8E87F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 02:03:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 207F88F8039
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:03:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mSPJVi9AHu7UO695 for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 00:03:39 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WAxSK-0004Op-R6
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:03:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WAxSK-0001NT-Pn
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:03:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs/021: filter v5 filesystem metadata
Date: Wed,  5 Feb 2014 19:03:36 +1100
Message-Id: <1391587416-5262-1-git-send-email-david@fromorbit.com>
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

The xfs_db output is different for v5 filesystem metadata, and so
the test fails due to golden image mismatches rather than an actual
test failure. Improve the filter to hide the differences between the
metadata format outputs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/021 | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tests/xfs/021 b/tests/xfs/021
index a727b51..a548092 100755
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -135,10 +135,19 @@ xfs_db -r -c "inode $inum_1" -c "print a.sfattr" $SCRATCH_DEV | \
 
 echo "*** dump attributes (2)"
 
+# There is a fair bit of filtering here to convert v5 filesystem output
+# into the v4 format that holds the meaningful information for the test.
 xfs_db -r -c "inode $inum_2" -c "a a.bmx[0].startblock" -c print $SCRATCH_DEV \
 	| perl -ne '
 s/,secure//;
 s/,parent//;
+s/info.hdr/info/;
+/hdr.info.crc/ && next;
+/hdr.info.bno/ && next;
+/hdr.info.uuid/ && next;
+/hdr.info.lsn/ && next;
+/hdr.info.owner/ && next;
+s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
 s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
 s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
 s/^(entries\[0-2] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
