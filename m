Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC50AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 15:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8903020708
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 15:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P/f+y3MZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETPja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 11:39:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETPj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 11:39:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KFbTfG139191;
        Wed, 20 May 2020 15:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DnIbBOQWzn3gEc+GRfJ4HeB3M/uVanf2ZHm6GqKg5q8=;
 b=P/f+y3MZ6+J/OtTfxiF9wrs9ixFzgFF6MAvhkhbeUbNrYPPS0FZAXktCdpLnIomgMq86
 0MeNx6eu16B36m/LZ4IQuGJqg9l5Pjp6FYOsgmu5RDiI69pUqscXvMZuuVoam6zhb5Gs
 4g9GtFDFpa1QibM5bO0hArXEjnbbiPjfoYK/2mS7WrUwiO1PDFRU9mLRUClpgvsUOZb4
 SAKNiWzTVrMon27dOfEtsUpJnq3POq5aAWLQ4YPZU6QC25twAJe0cHmLxImVulpIUGLk
 tR+vxDtFceFqYu9sINKFGi4j9cBwduxmlSBiDfI97sgCgNegufN2HaQlndB/6q6CCt+Z lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31501racjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 15:39:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KFcdWv056978;
        Wed, 20 May 2020 15:39:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 314gm79p8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 15:39:24 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KFdNTP015977;
        Wed, 20 May 2020 15:39:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 08:39:23 -0700
Date:   Wed, 20 May 2020 08:39:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 0/4] fstests: more quota related tests
Message-ID: <20200520153922.GU17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 02:59:01PM -0500, Eric Sandeen wrote:
> This collects zorro's outstanding patch to test per-type quota
> timers, as well as one test from darrick to test limit survival
> after quotacheck,  plus 2 more from me to test grace time extension.
> 
> zorro's still needs ENOSPC vs. EDQUOT filtering, darrick's might
> need to be made generic, and mine are new.

Err, I saw the following quota fstests regressions overnight.  Are these
expected?  Note that I didn't patch any of the userspace, nor have I
added any of the tests in this series...

--D

--- RESULTS FOR HOST: doh-mtr00.local
FSTESTS LOG DIR "/var/tmp/fstests":
SECTION      -- -no-sections-
FSTYP        -- xfs
MKFS_OPTIONS --  -m reflink=1,rmapbt=1, -i sparse=1,
MOUNT_OPTIONS --  -o usrquota,grpquota,prjquota,
HOST_OPTIONS -- local.config
CHECK_OPTIONS -- -g auto
XFS_MKFS_OPTIONS -- -bsize=4096
TIME_FACTOR  -- 1
LOAD_FACTOR  -- 1
TEST_DIR     -- /mnt
TEST_DEV     -- /dev/sda
SCRATCH_DEV  -- /dev/sdf
SCRATCH_MNT  -- /opt
OVL_UPPER    -- ovl-upper
OVL_LOWER    -- ovl-lower
OVL_WORK     -- ovl-work
KERNEL       -- 5.7.0-rc4-djw
--- xfs/106.out
+++ xfs/106.out.bad
@@ -151,7 +151,7 @@
 checking restore command (type=u)
 
 checking report command (type=u)
-fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+fsgqa 1024 512 2048 00 [0 days] 15 10 20 00 [0 days]
 
 
 checking state command (type=u)
@@ -159,9 +159,9 @@
  Accounting: ON
  Enforcement: ON
  Inode: #[INO] (X blocks, Y extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 cleanup files
 ----------------------- gquota,sync ---------------------------
 init quota limit and timer, and dump it
@@ -315,7 +315,7 @@
 checking restore command (type=g)
 
 checking report command (type=g)
-fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+fsgqa 1024 512 2048 00 [0 days] 15 10 20 00 [0 days]
 
 
 checking state command (type=g)
@@ -323,9 +323,9 @@
  Accounting: ON
  Enforcement: ON
  Inode: #[INO] (X blocks, Y extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 cleanup files
 ----------------------- pquota,sync ---------------------------
 init quota limit and timer, and dump it
@@ -479,7 +479,7 @@
 checking restore command (type=p)
 
 checking report command (type=p)
-fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+fsgqa 1024 512 2048 00 [0 days] 15 10 20 00 [0 days]
 
 
 checking state command (type=p)
@@ -487,7 +487,7 @@
  Accounting: ON
  Enforcement: ON
  Inode: #[INO] (X blocks, Y extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 cleanup files
--- xfs/299.out
+++ xfs/299.out.bad
@@ -16,19 +16,19 @@
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 200 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 200 100 500 00 [7 days] 6 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 200 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 200 100 500 00 [7 days] 9 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 0 [7 days] 9 4 10 00 [0 days] 0 0 0 00 [--------]
 
 
 *** report no quota settings
--- xfs/050.out
+++ xfs/050.out.bad
@@ -16,19 +16,20 @@
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
+ URK 65534: 0 is out of range! [3481600,4096000]
 
 *** unmount
 *** group
@@ -48,19 +49,19 @@
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** unmount
 *** uqnoenforce
@@ -144,19 +145,19 @@
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 300 200 1000 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 9 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 200 1000 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [7 days] 9 4 10 00 [0 days] 0 0 0 00 [--------]
 
 *** unmount
 *** pqnoenforce
--- generic/594.out
+++ generic/594.out.bad
@@ -5,31 +5,31 @@
 *** Report for group quotas on device SCRATCH_DEV
 Block grace time: DEF_TIME; Inode grace time: DEF_TIME
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
 
 2. set group quota timer
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: DEF_TIME; Inode grace time: DEF_TIME
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
 
 3. set user quota timer
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00
 
 4. cycle mount test-1
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00
 
 5. fsck to force quota check
 
@@ -37,14 +37,14 @@
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00
 
 7. cycle mount test-3
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00
--- generic/235.out
+++ generic/235.out.bad
@@ -1,25 +1,25 @@
 QA output created by 235
 *** Report for user quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
+Block grace time: 00:00; Inode grace time: 00:00
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 fsgqa     --       0       0       0              1     0     0       
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
+Block grace time: 00:00; Inode grace time: 00:00
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 fsgqa     --       0       0       0              1     0     0       
 touch: cannot touch 'SCRATCH_MNT/failed': Read-only file system
 *** Report for user quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
+Block grace time: 00:00; Inode grace time: 00:00
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 fsgqa     --       0       0       0              2     0     0       
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
+Block grace time: 00:00; Inode grace time: 00:00
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
--- xfs/263.out
+++ xfs/263.out.bad
@@ -14,9 +14,9 @@
   Accounting: OFF
   Enforcement: OFF
   Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: grpquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
@@ -30,9 +30,9 @@
   Accounting: OFF
   Enforcement: OFF
   Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: usrquota,grpquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
@@ -62,9 +62,9 @@
   Accounting: ON
   Enforcement: ON
   Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: usrquota,prjquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
@@ -98,9 +98,9 @@
   Accounting: OFF
   Enforcement: OFF
   Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: grpquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
@@ -114,9 +114,9 @@
   Accounting: OFF
   Enforcement: OFF
   Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: usrquota,grpquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
@@ -146,9 +146,9 @@
   Accounting: ON
   Enforcement: ON
   Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: usrquota,prjquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
@@ -178,9 +178,9 @@
   Accounting: ON
   Enforcement: ON
   Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
+Blocks grace time: [--------]
+Inodes grace time: [--------]
+Realtime Blocks grace time: [--------]
 == Options: usrquota,grpquota,prjquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
