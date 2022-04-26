Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5361C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 23:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356007AbiDZXsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356102AbiDZXsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 19:48:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1B65FD19
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 16:44:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7A7A35351B4
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 09:44:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-004wJl-Bv
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 09:44:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-002rVu-Aj
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 09:44:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs_io: add a quiet option to bulkstat
Date:   Wed, 27 Apr 2022 09:44:52 +1000
Message-Id: <20220426234453.682296-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426234453.682296-1-david@fromorbit.com>
References: <20220426234453.682296-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=626883f9
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=-Jx238IB6GjAhbdtaswA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is purely for driving the kernel bulkstat operations as hard
as userspace can drive them - we don't care about the actual output,
just want to drive maximum IO rates through the inode cache.

Bulkstat at 3.4 million inodes a second via xfs_io currently burns
about 30% of CPU time just formatting and outputting the stat
information to stdout and dumping it to /dev/null.

		wall time	rate	IOPS	bandwidth
unpatched	17.823s		3.4M/s	70k	1.9GB/s
with -q		15.682		6.1M/s  150k	3.5GB/s

The disks are at about 30% of max bandwidth and only at 70kiops, so
this CPU can be used to drive the kernel and IO subsystem harder.

Wall time doesn't really go down on this specific test because the
increase in inode cache turn-over (about 10GB/s of cached metadata
(in-core inodes and buffers) is being cycled through memory on a
machine with 16GB of RAM) and that hammers memory reclaim into a
utter mess that often takes seconds for it to recover from...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/bulkstat.c     | 9 ++++++++-
 man/man8/xfs_io.8 | 6 +++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b29223..411942006591 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -67,6 +67,7 @@ bulkstat_help(void)
 "\n"
 "   -a <agno>  Only iterate this AG.\n"
 "   -d         Print debugging output.\n"
+"   -q         Be quiet, no output.\n"
 "   -e <ino>   Stop after this inode.\n"
 "   -n <nr>    Ask for this many results at once.\n"
 "   -s <ino>   Inode to start with.\n"
@@ -104,11 +105,12 @@ bulkstat_f(
 	uint32_t		ver = 0;
 	bool			has_agno = false;
 	bool			debug = false;
+	bool			quiet = false;
 	unsigned int		i;
 	int			c;
 	int			ret;
 
-	while ((c = getopt(argc, argv, "a:de:n:s:v:")) != -1) {
+	while ((c = getopt(argc, argv, "a:de:n:qs:v:")) != -1) {
 		switch (c) {
 		case 'a':
 			agno = cvt_u32(optarg, 10);
@@ -135,6 +137,9 @@ bulkstat_f(
 				return 1;
 			}
 			break;
+		case 'q':
+			quiet = true;
+			break;
 		case 's':
 			startino = cvt_u64(optarg, 10);
 			if (errno) {
@@ -198,6 +203,8 @@ _("bulkstat: startino=%lld flags=0x%x agno=%u ret=%d icount=%u ocount=%u\n"),
 		for (i = 0; i < breq->hdr.ocount; i++) {
 			if (breq->bulkstat[i].bs_ino > endino)
 				break;
+			if (quiet)
+				continue;
 			dump_bulkstat(&breq->bulkstat[i]);
 		}
 	}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e3c5d3ea99dd..d876490bf65d 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1143,7 +1143,7 @@ for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ] [ \-v " version" ]
+.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
 Display raw stat information about a bunch of inodes in an XFS filesystem.
 Options are as follows:
 .RS 1.0i
@@ -1164,6 +1164,10 @@ Defaults to stopping when the system call stops returning results.
 Retrieve at most this many records per call.
 Defaults to 4,096.
 .TP
+.BI \-q
+Run quietly.
+Does not parse or output retrieved bulkstat information.
+.TP
 .BI \-s " startino"
 Display inode allocation records starting with this inode.
 Defaults to the first inode in the filesystem.
-- 
2.35.1

