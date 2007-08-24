Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 16:26:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7ONQJ4p013427
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 16:26:20 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7ONQID1029989
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 19:26:18 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7ONQInP023901
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 19:26:18 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l7ONQH4I001691
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 19:26:17 -0400
Message-ID: <46CF6919.2050404@sandeen.net>
Date: Fri, 24 Aug 2007 18:26:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix xfsqa test 052 filtering with long device names
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Long devicenames cause this quota output to split onto 2 lines:

# xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
/dev/mapper/testvol-test2
                           880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch

(why, I'm not sure, because that last line is plenty long too)

but if we make that "\n" go away, the test still passes.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-cmds/xfstests/052
===================================================================
--- xfs-cmds.orig/xfstests/052
+++ xfs-cmds/xfstests/052
@@ -82,8 +82,8 @@ xfs_quota -x \
 
 # cross check blks, softblks, hardblks <-> quota, xfs_db
 xfs_quota -c "quota -$type -birnN $id" $SCRATCH_DEV |
-			tr -s '[:space:]' | tee -a $seq.full | perl -ne '
-	if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
+			tr -d '\n' | tr -s '[:space:]' | tee -a $seq.full |
+	perl -ne 'if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
 		print "used_blocks=", $1, "\n";
 		print "soft_blocks=", $2, "\n";
 		print "hard_blocks=", $3, "\n";
