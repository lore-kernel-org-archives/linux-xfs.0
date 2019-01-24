Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35728 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfAXIdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 03:33:21 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] xfs/068: Add fsstress generated file count to golden output
Date: Thu, 24 Jan 2019 10:33:10 +0200
Message-Id: <20190124083310.25928-2-amir73il@gmail.com>
In-Reply-To: <20190124083310.25928-1-amir73il@gmail.com>
References: <20190124083310.25928-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

This test has the number of files/dirs created by fsstress hardcoded
in golden output.

When fsstress is added new ops, the number of files/dirs created with
the same random seed changes and this regularly breaks this test.

So when new fsstress ops are added they should be either added to the
dump test blacklist or golden output of this test needs to be ammended
to reflect the change.

Since the golden output includes only the file count after dump/restore,
add also the file count before dump/restore so developers are less
likely to forget to check the validity of golden output before commiting
the change.

For some reason the file count reported by xfsrestore has one directory
more than the file count reported by 'find'. I did not investigate why
that is, but did verify that this was the same with the original test
fsstress ops (i.e. without the added ops
insert/mread/mwrite/aread/awrite/readv/writev).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dump       | 7 +++++++
 tests/xfs/068     | 1 +
 tests/xfs/068.out | 1 +
 3 files changed, 9 insertions(+)

diff --git a/common/dump b/common/dump
index 47d14601..23f42216 100644
--- a/common/dump
+++ b/common/dump
@@ -1515,6 +1515,13 @@ _check_quota_file()
    _check_quota 'xfsdump_quotas' 'xfsdump_quotas_group' 'xfsdump_quotas_proj'
 }
 
+_count_dumpdir_files()
+{
+	local ndirs=$(find $dump_dir -type d | wc -l)
+	local nents=$(find $dump_dir | wc -l)
+
+	echo "Created $ndirs directories and $nents entries"
+}
 
 # make sure this script returns success
 /bin/true
diff --git a/tests/xfs/068 b/tests/xfs/068
index 95a8cd12..ffc293bd 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -28,6 +28,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _create_dumpdir_stress_num 4096
+_count_dumpdir_files
 _do_dump_restore
 
 # success, all done
diff --git a/tests/xfs/068.out b/tests/xfs/068.out
index fa3a5523..61cbbfa4 100644
--- a/tests/xfs/068.out
+++ b/tests/xfs/068.out
@@ -4,6 +4,7 @@ Creating directory system to dump using fsstress.
 -----------------------------------------------
 fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
 -----------------------------------------------
+Created 382 directories and 1334 entries
 xfsdump|xfsrestore ...
 xfsdump  -s DUMP_SUBDIR - SCRATCH_MNT | xfsrestore  - RESTORE_DIR
 xfsrestore: using file dump (drive_simple) strategy
-- 
2.17.1
