Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51FRvDY158022 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 10:27:57 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB120304059
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 08:27:53 -0700 (PDT)
Received: from xfsqa-alt4.americas.sgi.com (xfsqa-alt4.americas.sgi.com
	[128.162.242.133])
	by estes.americas.sgi.com (Postfix) with ESMTP id C541F7001DC4
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 10:27:53 -0500 (CDT)
Received: by xfsqa-alt4.americas.sgi.com (Postfix, from userid 0)
	id B78A1BFB39; Fri,  1 Jun 2012 10:27:53 -0500 (CDT)
In-Reply-To: <4FC8CF01.9080705@sgi.com>
References: <4FC8CF01.9080705@sgi.com>
From: Alain Renaud <arenaud@sgi.com>
Date: Fri, 1 Jun 2012 09:21:18 -0500
Subject: Re: [PATCH] xfstest: Cleanup test permission and gitignore state. V2
Message-Id: <20120601152753.B78A1BFB39@xfsqa-alt4.americas.sgi.com>
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

Here is version 2 of the patch.


 The new test 284/285/286 do not have execute permission set so set
them. Test 285 and 286 create 2 executable that are not in .gitignore
so add then to the list. Finally 285.full and 286.full should be remove.

Signed-off-by: Alain Renaud <arenaud@sgi.com>
---
 .gitignore |    2 +
 285.full   |  116 ------------------------------------------------------------
 286.full   |   70 ------------------------------------
 3 files changed, 2 insertions(+), 186 deletions(-)
 mode change 100644 => 100755 284
 mode change 100644 => 100755 285
 delete mode 100644 285.full
 mode change 100644 => 100755 286
 delete mode 100644 286.full

diff --git a/.gitignore b/.gitignore
index 900ff95..ab1ca32 100644
--- a/.gitignore
+++ b/.gitignore
@@ -63,6 +63,8 @@ src/rename
 src/resvtest
 src/runas
 src/stale_handle
+src/seek_copy_test
+src/seek_sanity_test
 src/t_access_root
 src/t_dir_offset
 src/t_dir_offset2
diff --git a/284 b/284
old mode 100644
new mode 100755
diff --git a/285 b/285
old mode 100644
new mode 100755
diff --git a/285.full b/285.full
deleted file mode 100644
index f384aab..0000000
--- a/285.full
+++ /dev/null
@@ -1,116 +0,0 @@
-File system supports the default behavior.
-File system magic#: 0x58465342
-Allocation size: 4096
-
-01. Test empty file                                   
-01.01 SEEK_DATA expected -1 with errno -6, got -6.                succ
-01.02 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-01.03 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-
-02. Test a tiny full file                             
-02.01 SEEK_HOLE expected 8 or 8, got 8.                           succ
-02.02 SEEK_DATA expected 0 or 0, got 0.                           succ
-02.03 SEEK_DATA expected 1 or 1, got 1.                           succ
-02.04 SEEK_HOLE expected 8 or 8, got 8.                           succ
-02.05 SEEK_DATA expected 7 or 7, got 7.                           succ
-02.06 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-02.07 SEEK_DATA expected -1 with errno -6, got -6.                succ
-02.08 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-02.09 SEEK_DATA expected -1 with errno -6, got -6.                succ
-
-03. Test a larger full file                           
-03.01 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
-03.02 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
-03.03 SEEK_DATA expected 0 or 0, got 0.                           succ
-03.04 SEEK_DATA expected 1 or 1, got 1.                           succ
-03.05 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
-03.06 SEEK_DATA expected 8291 or 8291, got 8291.                  succ
-03.07 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-03.08 SEEK_DATA expected -1 with errno -6, got -6.                succ
-03.09 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-03.10 SEEK_DATA expected -1 with errno -6, got -6.                succ
-
-04. Test file hole at beg, data at end                
-04.01 SEEK_HOLE expected 0 or 8200, got 0.                        succ
-04.02 SEEK_HOLE expected 1 or 8200, got 1.                        succ
-04.03 SEEK_DATA expected 8192 or 0, got 8192.                     succ
-04.04 SEEK_DATA expected 8192 or 1, got 8192.                     succ
-04.05 SEEK_HOLE expected 8191 or 8200, got 8191.                  succ
-04.06 SEEK_DATA expected 8192 or 8191, got 8192.                  succ
-04.07 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
-04.08 SEEK_DATA expected 8192 or 8192, got 8192.                  succ
-04.09 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
-04.10 SEEK_DATA expected 8193 or 8193, got 8193.                  succ
-04.11 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
-04.12 SEEK_DATA expected 8199 or 8199, got 8199.                  succ
-04.13 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-04.14 SEEK_DATA expected -1 with errno -6, got -6.                succ
-04.15 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-04.16 SEEK_DATA expected -1 with errno -6, got -6.                succ
-
-05. Test file data at beg, hole at end                
-05.01 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
-05.02 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
-05.03 SEEK_DATA expected 0 or 0, got 0.                           succ
-05.04 SEEK_DATA expected 1 or 1, got 1.                           succ
-05.05 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
-05.06 SEEK_DATA expected 4095 or 4095, got 4095.                  succ
-05.07 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
-05.08 SEEK_DATA expected -1 with errno -6, got -6.                succ
-05.09 SEEK_HOLE expected 4097 or 16384, got 4097.                 succ
-05.10 SEEK_DATA expected -1 with errno -6, got -6.                succ
-05.11 SEEK_HOLE expected 16383 or 16384, got 16383.               succ
-05.12 SEEK_DATA expected -1 with errno -6, got -6.                succ
-05.13 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-05.14 SEEK_DATA expected -1 with errno -6, got -6.                succ
-05.15 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-05.16 SEEK_DATA expected -1 with errno -6, got -6.                succ
-
-06. Test file hole data hole data                     
-06.01 SEEK_HOLE expected 0 or 16384, got 0.                       succ
-06.02 SEEK_HOLE expected 1 or 16384, got 1.                       succ
-06.03 SEEK_DATA expected 4096 or 0, got 4096.                     succ
-06.04 SEEK_DATA expected 4096 or 1, got 4096.                     succ
-06.05 SEEK_HOLE expected 4095 or 16384, got 4095.                 succ
-06.06 SEEK_DATA expected 4096 or 4095, got 4096.                  succ
-06.07 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
-06.08 SEEK_DATA expected 4096 or 4096, got 4096.                  succ
-06.09 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
-06.10 SEEK_DATA expected 4097 or 4097, got 4097.                  succ
-06.11 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
-06.12 SEEK_DATA expected 8191 or 8191, got 8191.                  succ
-06.13 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
-06.14 SEEK_DATA expected 12288 or 8192, got 8192.                 succ
-06.15 SEEK_HOLE expected 8193 or 16384, got 16384.                succ
-06.16 SEEK_DATA expected 12288 or 8193, got 8193.                 succ
-06.17 SEEK_HOLE expected 12287 or 16384, got 16384.               succ
-06.18 SEEK_DATA expected 12288 or 12287, got 12287.               succ
-06.19 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
-06.20 SEEK_DATA expected 12288 or 12288, got 12288.               succ
-06.21 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
-06.22 SEEK_DATA expected 12289 or 12289, got 12289.               succ
-06.23 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
-06.24 SEEK_DATA expected 16383 or 16383, got 16383.               succ
-06.25 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-06.26 SEEK_DATA expected -1 with errno -6, got -6.                succ
-06.27 SEEK_HOLE expected -1 with errno -6, got -6.                succ
-06.28 SEEK_DATA expected -1 with errno -6, got -6.                succ
-
-07. Test file with unwritten extents, only have dirty pages
-07.01 SEEK_HOLE expected 0 or 4194304, got 4194304.               succ
-07.02 SEEK_HOLE expected 1 or 4194304, got 4194304.               succ
-07.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
-07.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
-
-08. Test file with unwritten extents, only have unwritten pages
-08.01 SEEK_HOLE expected 0 or 4194304, got 4194304.               succ
-08.02 SEEK_HOLE expected 1 or 4194304, got 4194304.               succ
-08.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
-08.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
-
-09. Test file with unwritten extents, have both dirty && unwritten pages
-09.01 SEEK_HOLE expected 0 or 8388608, got 8388608.               succ
-09.02 SEEK_HOLE expected 1 or 8388608, got 8388608.               succ
-09.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
-09.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
-
diff --git a/286 b/286
old mode 100644
new mode 100755
diff --git a/286.full b/286.full
deleted file mode 100644
index b4e4f08..0000000
--- a/286.full
+++ /dev/null
@@ -1,70 +0,0 @@
-*** test01() create sparse file ***
-wrote 1048576/1048576 bytes at offset 0
-1 MiB, 256 ops; 0.0000 sec (1.242 GiB/sec and 325699.7455 ops/sec)
-wrote 1048576/1048576 bytes at offset 5242880
-1 MiB, 256 ops; 0.0000 sec (1.160 GiB/sec and 304038.0048 ops/sec)
-wrote 1048576/1048576 bytes at offset 10485760
-1 MiB, 256 ops; 0.0000 sec (1.112 GiB/sec and 291571.7540 ops/sec)
-wrote 1048576/1048576 bytes at offset 15728640
-1 MiB, 256 ops; 0.0000 sec (1.095 GiB/sec and 286995.5157 ops/sec)
-wrote 1048576/1048576 bytes at offset 20971520
-1 MiB, 256 ops; 0.0000 sec (1.094 GiB/sec and 286674.1321 ops/sec)
-wrote 1048576/1048576 bytes at offset 26214400
-1 MiB, 256 ops; 0.0000 sec (1.085 GiB/sec and 284444.4444 ops/sec)
-wrote 1048576/1048576 bytes at offset 31457280
-1 MiB, 256 ops; 0.0000 sec (1.065 GiB/sec and 279171.2105 ops/sec)
-wrote 1048576/1048576 bytes at offset 36700160
-1 MiB, 256 ops; 0.0000 sec (1.064 GiB/sec and 278867.1024 ops/sec)
-wrote 1048576/1048576 bytes at offset 41943040
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
-wrote 1048576/1048576 bytes at offset 47185920
-1 MiB, 256 ops; 0.0000 sec (1.058 GiB/sec and 277356.4464 ops/sec)
-wrote 1048576/1048576 bytes at offset 52428800
-1 MiB, 256 ops; 0.0000 sec (1.067 GiB/sec and 279781.4208 ops/sec)
-wrote 1048576/1048576 bytes at offset 57671680
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
-wrote 1048576/1048576 bytes at offset 62914560
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
-wrote 1048576/1048576 bytes at offset 68157440
-1 MiB, 256 ops; 0.0000 sec (1.074 GiB/sec and 281628.1628 ops/sec)
-wrote 1048576/1048576 bytes at offset 73400320
-1 MiB, 256 ops; 0.0000 sec (1.071 GiB/sec and 280701.7544 ops/sec)
-wrote 1048576/1048576 bytes at offset 78643200
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
-wrote 1048576/1048576 bytes at offset 83886080
-1 MiB, 256 ops; 0.0000 sec (1.073 GiB/sec and 281318.6813 ops/sec)
-wrote 1048576/1048576 bytes at offset 89128960
-1 MiB, 256 ops; 0.0000 sec (1.068 GiB/sec and 280087.5274 ops/sec)
-wrote 1048576/1048576 bytes at offset 94371840
-1 MiB, 256 ops; 0.0000 sec (1.085 GiB/sec and 284444.4444 ops/sec)
-wrote 1048576/1048576 bytes at offset 99614720
-1 MiB, 256 ops; 0.0000 sec (1.055 GiB/sec and 276457.8834 ops/sec)
-wrote 1048576/1048576 bytes at offset 104857600
-1 MiB, 256 ops; 0.0000 sec (1.140 GiB/sec and 298716.4527 ops/sec)
-*** test01() create sparse file done ***
-
-*** test02() create sparse file ***
-wrote 1048576/1048576 bytes at offset 6291456
-1 MiB, 256 ops; 0.0000 sec (1.360 GiB/sec and 356545.9610 ops/sec)
-wrote 1048576/1048576 bytes at offset 16777216
-1 MiB, 256 ops; 0.0000 sec (1.385 GiB/sec and 363120.5674 ops/sec)
-wrote 1048576/1048576 bytes at offset 27262976
-1 MiB, 256 ops; 0.0000 sec (1.340 GiB/sec and 351165.9808 ops/sec)
-wrote 1048576/1048576 bytes at offset 37748736
-1 MiB, 256 ops; 0.0000 sec (1.309 GiB/sec and 343163.5389 ops/sec)
-wrote 1048576/1048576 bytes at offset 48234496
-1 MiB, 256 ops; 0.0000 sec (1.267 GiB/sec and 332036.3165 ops/sec)
-wrote 1048576/1048576 bytes at offset 58720256
-1 MiB, 256 ops; 0.0000 sec (1.285 GiB/sec and 336842.1053 ops/sec)
-wrote 1048576/1048576 bytes at offset 69206016
-1 MiB, 256 ops; 0.0000 sec (1.288 GiB/sec and 337730.8707 ops/sec)
-wrote 1048576/1048576 bytes at offset 79691776
-1 MiB, 256 ops; 0.0000 sec (1.278 GiB/sec and 335078.5340 ops/sec)
-wrote 1048576/1048576 bytes at offset 90177536
-1 MiB, 256 ops; 0.0000 sec (1.293 GiB/sec and 339072.8477 ops/sec)
-wrote 1048576/1048576 bytes at offset 100663296
-1 MiB, 256 ops; 0.0000 sec (1.280 GiB/sec and 335517.6933 ops/sec)
-wrote 1048576/1048576 bytes at offset 111149056
-1 MiB, 256 ops; 0.0000 sec (1.285 GiB/sec and 336842.1053 ops/sec)
-*** test02() create sparse file done ***
-
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
