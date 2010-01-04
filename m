Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o047QTQd079672 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 01:26:30 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 311B31505920
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2010 23:27:18 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	XVtbCwMI76DSLyv0 for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2010 23:27:18 -0800 (PST)
Date: Sun, 3 Jan 2010 23:27:13 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH] remove bashisms from xfstests
In-Reply-To: <87vdfjceke.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.01.1001032307210.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<87vdfjceke.fsf@basil.nowhere.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Sun, 3 Jan 2010 at 17:56, Andi Kleen wrote:
> The usual much easier and less riskier change is to just change the
> first line in each script to #!/bin/bash

Hm, but it's less fun that way :-)

OK, here's one with only changing /bin/sh to /bin/bash, for all scripts 
carrying bashisms according to checkbashisms(1). With this patch applied, 
I can now run xfstests w/o changing my /bin/sh to something else.

Thanks,
Christian.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

diff -Nrup xfstests.orig/005 xfstests/005
--- xfstests.orig/005	2010-01-03 23:03:27.977265001 -0800
+++ xfstests/005	2010-01-03 22:19:34.825575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 005
 #
 # Test symlinks & ELOOP
diff -Nrup xfstests.orig/007 xfstests/007
--- xfstests.orig/007	2010-01-03 23:03:27.987270001 -0800
+++ xfstests/007	2010-01-03 22:21:42.535575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 007
 #
 # drive the src/nametest program
diff -Nrup xfstests.orig/010 xfstests/010
--- xfstests.orig/010	2010-01-03 23:03:28.017285001 -0800
+++ xfstests/010	2010-01-03 22:28:35.308153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 010
 #
 # dbtest
diff -Nrup xfstests.orig/016 xfstests/016
--- xfstests.orig/016	2010-01-03 23:03:28.067310001 -0800
+++ xfstests/016	2010-01-03 22:21:32.755575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 016
 #
 # test end of log overwrite bug #796141
diff -Nrup xfstests.orig/020 xfstests/020
--- xfstests.orig/020	2010-01-03 23:03:28.097325001 -0800
+++ xfstests/020	2010-01-03 22:51:21.338153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 020
 #
 # extended attributes
diff -Nrup xfstests.orig/028 xfstests/028
--- xfstests.orig/028	2010-01-03 23:03:28.157355001 -0800
+++ xfstests/028	2010-01-03 22:51:29.958153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 028
 #
 # To test out xfsinvutil
diff -Nrup xfstests.orig/031 xfstests/031
--- xfstests.orig/031	2010-01-03 23:03:28.187370001 -0800
+++ xfstests/031	2010-01-03 22:51:43.908153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 031
 #
 # exercise xfs_repair - ensure repeated use doesn't corrupt
diff -Nrup xfstests.orig/043 xfstests/043
--- xfstests.orig/043	2010-01-03 23:03:28.277415001 -0800
+++ xfstests/043	2010-01-03 22:23:42.965575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 043
 #
 # Test out xfsdump/restore but rmv inventory prior to restore.
diff -Nrup xfstests.orig/044 xfstests/044
--- xfstests.orig/044	2010-01-03 23:03:28.287420001 -0800
+++ xfstests/044	2010-01-03 22:51:53.128153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 044
 #
 # external log uuid/format tests (TODO - version 2 log format)
diff -Nrup xfstests.orig/047 xfstests/047
--- xfstests.orig/047	2010-01-03 23:03:28.317435001 -0800
+++ xfstests/047	2010-01-03 22:52:06.758153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 047
 #
 # invutil with interactive responses
diff -Nrup xfstests.orig/050 xfstests/050
--- xfstests.orig/050	2010-01-03 23:03:28.337445001 -0800
+++ xfstests/050	2010-01-03 22:52:13.168153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 050
 #
 # Exercises basic XFS quota functionality
diff -Nrup xfstests.orig/051 xfstests/051
--- xfstests.orig/051	2010-01-03 23:03:28.347450001 -0800
+++ xfstests/051	2010-01-03 22:21:07.435575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 051
 #
 # Test out ACLs.
diff -Nrup xfstests.orig/053 xfstests/053
--- xfstests.orig/053	2010-01-03 23:03:28.367460001 -0800
+++ xfstests/053	2010-01-03 22:19:28.225575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 053
 #
 # xfs_repair breaks acls
diff -Nrup xfstests.orig/064 xfstests/064
--- xfstests.orig/064	2010-01-03 23:03:28.457505001 -0800
+++ xfstests/064	2010-01-03 22:18:56.425575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 064
 #
 # test multilevel dump and restores with hardlinks
diff -Nrup xfstests.orig/065 xfstests/065
--- xfstests.orig/065	2010-01-03 23:03:28.457505001 -0800
+++ xfstests/065	2010-01-03 22:20:08.665575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 065
 #
 # Testing incremental dumps and cumulative restores with
diff -Nrup xfstests.orig/067 xfstests/067
--- xfstests.orig/067	2010-01-03 23:03:28.477515001 -0800
+++ xfstests/067	2010-01-03 22:27:51.538325001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 067
 #
 # Test out acl/dacls which fit in shortform in the inode
diff -Nrup xfstests.orig/068 xfstests/068
--- xfstests.orig/068	2010-01-03 23:03:28.487520001 -0800
+++ xfstests/068	2010-01-03 22:52:31.798153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 068
 #
 # Test case to reproduce xfs_freeze hang under filsystem load.
diff -Nrup xfstests.orig/071 xfstests/071
--- xfstests.orig/071	2010-01-03 23:03:28.507530001 -0800
+++ xfstests/071	2010-01-03 22:52:39.198153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 071
 #
 # Exercise IO at large file offsets.
diff -Nrup xfstests.orig/074 xfstests/074
--- xfstests.orig/074	2010-01-03 23:03:28.537545001 -0800
+++ xfstests/074	2010-01-03 22:52:48.748153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 074
 #
 # fstest
diff -Nrup xfstests.orig/075 xfstests/075
--- xfstests.orig/075	2010-01-03 23:03:28.547550001 -0800
+++ xfstests/075	2010-01-03 22:19:23.145575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 075
 #
 # fsx (non-AIO variant)
diff -Nrup xfstests.orig/076 xfstests/076
--- xfstests.orig/076	2010-01-03 23:03:28.547550001 -0800
+++ xfstests/076	2010-01-03 22:53:01.758153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 076
 #
 # Test blockdev reads in parallel with filesystem reads/writes
diff -Nrup xfstests.orig/084 xfstests/084
--- xfstests.orig/084	2010-01-03 23:03:28.617585001 -0800
+++ xfstests/084	2010-01-03 22:19:08.795575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 084
 #
 # Exercises unwritten extent reads and writes, looking
diff -Nrup xfstests.orig/085 xfstests/085
--- xfstests.orig/085	2010-01-03 23:03:28.627590001 -0800
+++ xfstests/085	2010-01-03 22:53:11.388153000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 085
 #
 # To test log replay by shutdown of file system
diff -Nrup xfstests.orig/086 xfstests/086
--- xfstests.orig/086	2010-01-03 23:03:28.627590001 -0800
+++ xfstests/086	2010-01-03 22:19:45.175575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 086
 #
 # To test log replay with version 2 logs
diff -Nrup xfstests.orig/089 xfstests/089
--- xfstests.orig/089	2010-01-03 23:03:28.657605001 -0800
+++ xfstests/089	2010-01-03 22:53:23.799048001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 089
 #
 # Emulate the way Linux mount manipulates /etc/mtab to attempt to
diff -Nrup xfstests.orig/091 xfstests/091
--- xfstests.orig/091	2010-01-03 23:03:28.677615001 -0800
+++ xfstests/091	2010-01-03 22:53:32.133213001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 091
 #
 # fsx exercising direct IO -- sub-block sizes and concurrent buffered IO
diff -Nrup xfstests.orig/097 xfstests/097
--- xfstests.orig/097	2010-01-03 23:03:28.717635001 -0800
+++ xfstests/097	2010-01-03 22:19:53.435575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 097. Modifed from UDFQA test 033.
 #
 # simple attr tests for EAs:
diff -Nrup xfstests.orig/099 xfstests/099
--- xfstests.orig/099	2010-01-03 23:03:28.737645001 -0800
+++ xfstests/099	2010-01-03 22:23:16.295575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 099. Modified from UDFQA test 036.
 #
 # ACL test
diff -Nrup xfstests.orig/100 xfstests/100
--- xfstests.orig/100	2010-01-03 23:03:28.747650001 -0800
+++ xfstests/100	2010-01-03 22:53:50.292288001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 100. Modified from UDF QA test 030.
 #
 # Test whether a tarred directory structure can be untarred onto
diff -Nrup xfstests.orig/105 xfstests/105
--- xfstests.orig/105	2010-01-03 23:03:28.787670001 -0800
+++ xfstests/105	2010-01-03 22:53:58.046163001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 105
 #
 # Test fix of bug:
diff -Nrup xfstests.orig/108 xfstests/108
--- xfstests.orig/108	2010-01-03 23:03:28.807680001 -0800
+++ xfstests/108	2010-01-03 22:54:07.030653001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 108
 #
 # Simple quota accounting test for direct/buffered/mmap IO.
diff -Nrup xfstests.orig/109 xfstests/109
--- xfstests.orig/109	2010-01-03 23:03:28.817685001 -0800
+++ xfstests/109	2010-01-03 22:54:15.604938001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 109
 #
 # ENOSPC deadlock case from Asano Masahiro.
diff -Nrup xfstests.orig/110 xfstests/110
--- xfstests.orig/110	2010-01-03 23:03:28.827690001 -0800
+++ xfstests/110	2010-01-03 22:21:15.615575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 110
 #
 # Incorrect dir2 freetab warning case from Masanori Tsuda.
diff -Nrup xfstests.orig/111 xfstests/111
--- xfstests.orig/111	2010-01-03 23:03:28.837695001 -0800
+++ xfstests/111	2010-01-03 22:20:59.015575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 111
 #
 # Infinite xfs_bulkstat bad-inode loop case from Roger Willcocks.
diff -Nrup xfstests.orig/112 xfstests/112
--- xfstests.orig/112	2010-01-03 23:03:28.847700001 -0800
+++ xfstests/112	2010-01-03 22:21:38.345575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 112
 #
 # fsx (AIO variant, based on 075)
diff -Nrup xfstests.orig/113 xfstests/113
--- xfstests.orig/113	2010-01-03 23:03:28.847700001 -0800
+++ xfstests/113	2010-01-03 22:54:30.972618001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 113
 #
 # aio-stress
diff -Nrup xfstests.orig/114 xfstests/114
--- xfstests.orig/114	2010-01-03 23:03:28.857705001 -0800
+++ xfstests/114	2010-01-03 22:54:38.706483001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 114
 #
 # Test some parent ptr stuff
diff -Nrup xfstests.orig/117 xfstests/117
--- xfstests.orig/117	2010-01-03 23:03:28.887720001 -0800
+++ xfstests/117	2010-01-03 22:54:46.380318001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 117
 #
 # Attempt to cause filesystem corruption with serial fsstresses doing
diff -Nrup xfstests.orig/118 xfstests/118
--- xfstests.orig/118	2010-01-03 23:03:28.897725001 -0800
+++ xfstests/118	2010-01-03 22:54:54.974613001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 118
 #
 # To test out pv#940675 crash in xfs_trans_brelse + quotas
diff -Nrup xfstests.orig/119 xfstests/119
--- xfstests.orig/119	2010-01-03 23:03:28.907730001 -0800
+++ xfstests/119	2010-01-03 22:55:05.629938001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 119
 #
 # Leaking reservation space in the GRH
diff -Nrup xfstests.orig/122 xfstests/122
--- xfstests.orig/122	2010-01-03 23:03:28.927740001 -0800
+++ xfstests/122	2010-01-03 22:55:29.822028001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 122
 #
 # pv#952498
diff -Nrup xfstests.orig/123 xfstests/123
--- xfstests.orig/123	2010-01-03 23:03:28.937745001 -0800
+++ xfstests/123	2010-01-03 22:55:42.188208001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 123
 #
 # Make sure user cannot overwrite, append, delete or move a file created by 
diff -Nrup xfstests.orig/124 xfstests/124
--- xfstests.orig/124	2010-01-03 23:03:28.947750001 -0800
+++ xfstests/124	2010-01-03 22:55:47.270748001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 124
 #
 # Test preallocated_rw_pattern_test modified from CXFSQA test preallocated_rw_pattern_test
diff -Nrup xfstests.orig/134 xfstests/134
--- xfstests.orig/134	2010-01-03 23:03:29.027790001 -0800
+++ xfstests/134	2010-01-03 22:55:56.015118001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 134
 #
 # test to reproduce PV951636:
diff -Nrup xfstests.orig/136 xfstests/136
--- xfstests.orig/136	2010-01-03 23:03:29.037795001 -0800
+++ xfstests/136	2010-01-03 22:56:06.480348001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 136
 #
 # Test the attr2 code
diff -Nrup xfstests.orig/137 xfstests/137
--- xfstests.orig/137	2010-01-03 23:03:29.047800001 -0800
+++ xfstests/137	2010-01-03 22:20:52.045575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 137
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/138 xfstests/138
--- xfstests.orig/138	2010-01-03 23:03:29.057805001 -0800
+++ xfstests/138	2010-01-03 22:23:54.535575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 138
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/139 xfstests/139
--- xfstests.orig/139	2010-01-03 23:03:29.067810001 -0800
+++ xfstests/139	2010-01-03 22:23:48.345575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 139
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/140 xfstests/140
--- xfstests.orig/140	2010-01-03 23:03:29.077815001 -0800
+++ xfstests/140	2010-01-03 22:56:17.856033001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 140
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/149 xfstests/149
--- xfstests.orig/149	2010-01-03 23:03:29.147850001 -0800
+++ xfstests/149	2010-01-03 22:56:33.453828001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 149
 #
 # Exercise xfs_prepair - ensure repeated use doesn't corrupt
diff -Nrup xfstests.orig/158 xfstests/158
--- xfstests.orig/158	2010-01-03 23:03:29.217885001 -0800
+++ xfstests/158	2010-01-03 22:56:45.079638001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 158
 #
 # get/set file attributes
diff -Nrup xfstests.orig/165 xfstests/165
--- xfstests.orig/165	2010-01-03 23:03:29.277915001 -0800
+++ xfstests/165	2010-01-03 22:56:54.704448001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 165
 #
 # Test out prealloc, direct writes and buffered read
diff -Nrup xfstests.orig/178 xfstests/178
--- xfstests.orig/178	2010-01-03 23:03:29.387970001 -0800
+++ xfstests/178	2010-01-03 22:19:15.625575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 178
 #
 # Reproduce PV#:967665
diff -Nrup xfstests.orig/179 xfstests/179
--- xfstests.orig/179	2010-01-03 23:03:29.397975001 -0800
+++ xfstests/179	2010-01-03 22:21:22.735575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 179
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/180 xfstests/180
--- xfstests.orig/180	2010-01-03 23:03:29.397975001 -0800
+++ xfstests/180	2010-01-03 22:57:06.130158001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 180
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/182 xfstests/182
--- xfstests.orig/182	2010-01-03 23:03:29.417985001 -0800
+++ xfstests/182	2010-01-03 22:20:02.055575000 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 182
 #
 # Test for NULL files problem
diff -Nrup xfstests.orig/190 xfstests/190
--- xfstests.orig/190	2010-01-03 23:03:29.478015001 -0800
+++ xfstests/190	2010-01-03 22:57:13.493838001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FSQA Test No. 190
 #
 # This test uses xfs_io to unreserve space in a file at various different
diff -Nrup xfstests.orig/200 xfstests/200
--- xfstests.orig/200	2010-01-03 23:03:29.568060001 -0800
+++ xfstests/200	2010-01-03 22:57:22.268223001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 200
 #
 # Check out various mount/remount/unmount scenarious on a read-only blockdev.
diff -Nrup xfstests.orig/203 xfstests/203
--- xfstests.orig/203	2010-01-03 23:03:29.588070001 -0800
+++ xfstests/203	2010-01-03 22:57:30.112143001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 203
 #
 # Test out reallocation of the extent array in xfs_io.
diff -Nrup xfstests.orig/205 xfstests/205
--- xfstests.orig/205	2010-01-03 23:03:29.608080001 -0800
+++ xfstests/205	2010-01-03 22:57:36.685428001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 205
 #
 # Test out ENOSPC flushing on small filesystems.
diff -Nrup xfstests.orig/213 xfstests/213
--- xfstests.orig/213	2010-01-03 23:03:29.678115001 -0800
+++ xfstests/213	2010-01-03 22:57:46.330248001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 213
 #
 # Check some unwritten extent boundary conditions, fallocate version.
diff -Nrup xfstests.orig/215 xfstests/215
--- xfstests.orig/215	2010-01-03 23:03:29.688120001 -0800
+++ xfstests/215	2010-01-03 22:57:52.063113001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 215
 #
 # Test out c/mtime updates after mapped writes.
diff -Nrup xfstests.orig/218 xfstests/218
--- xfstests.orig/218	2010-01-03 23:03:29.718135001 -0800
+++ xfstests/218	2010-01-03 22:58:00.757458001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 218
 #
 # Basic defragmentation sanity tests
diff -Nrup xfstests.orig/219 xfstests/219
--- xfstests.orig/219	2010-01-03 23:03:29.718135001 -0800
+++ xfstests/219	2010-01-03 22:58:09.541848001 -0800
@@ -1,4 +1,4 @@
-#! /bin/sh
+#! /bin/bash
 # FS QA Test No. 219
 #
 # Simple quota accounting test for direct/buffered/mmap IO.
diff -Nrup xfstests.orig/check xfstests/check
--- xfstests.orig/check	2010-01-03 23:03:27.917235001 -0800
+++ xfstests/check	2010-01-03 23:19:32.149110001 -0800
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Control script for QA
 #

-- 
BOFH excuse #36:

dynamic software linking table corrupted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
