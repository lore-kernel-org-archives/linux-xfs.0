Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q52EReaN258000 for <xfs@oss.sgi.com>; Sat, 2 Jun 2012 09:27:40 -0500
Message-ID: <4FCA22BD.3030801@oracle.com>
Date: Sat, 02 Jun 2012 22:27:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: Introduce test case 285 to check statfs(2)
	will not cause ASSERT(XFS_IS_QUOTA_RUNNING(mp)) failed.
References: <4F87ED3D.5060105@oracle.com> <20120416174929.GD2924@sgi.com>
In-Reply-To: <20120416174929.GD2924@sgi.com>
Reply-To: jeff.liu@oracle.com
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi Ben,

Sorry for the delay! I have worked on another task in the past few weeks.

On 04/17/2012 01:49 AM, Ben Myers wrote:

>> +					>/dev/null 2>&1
>> +du -sh $proj_dir			>/dev/null 2>&1
> 
> I was unable to reproduce this until I changed 'du -sh' to 'df'.  Now it does
> crash consistently without your fix for xfs_fs_statfs().
> 
> With that change you can consider this
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> -Ben


This patch was fixed per your comments, I have to adjust the case number to 287 since seek_data/seek_hole tests were merged, and thanks
you for help fixing issues for them!

Regards,
-Jeff


287: add a project quota test

This test is a negative test case. Pre-vanilla kernel-3.4, if the "pquota"
or "projquota" mount option was not enabled on the underlying XFS partition,
call statfs(2) against a project quota directory causes xfs_qm_dqget()->
ASSERT(XFS_IS_QUOTA_RUNNING(mp)) failed.

Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 287     |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 287.out |    2 +
 group   |    1 +
 3 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100755 287
 create mode 100644 287.out

diff --git a/287 b/287
new file mode 100755
index 0000000..736d632
--- /dev/null
+++ b/287
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. 287
+#
+# This test verify statfs(2) against a project directory will not cause
+# ASSERT(XFS_IS_QUOTA_RUNNING(mp)) at xfs_qm_dqget() failed if the project
+# quota option was not enabled on the underlying partition.  It was failed
+# pre-vanilla kernel 3.4.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Oracle Liu Jie.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  021101301  USA
+# ---------------------------------------------------------------------
+#
+# creator
+owner=jeff.liu@oracle.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+echo "Silence is golden."
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_quota
+_require_scratch
+
+proj_dir="${SCRATCH_MNT}/test_project"
+test_file="${proj_dir}/test_file"
+
+_scratch_mkfs_xfs			>/dev/null 2>&1
+_qmount
+
+mkdir $proj_dir
+touch $test_file
+
+$XFS_QUOTA_PROG -x -c "project -s -p ${proj_dir} 2012" $SCRATCH_DEV \
+					>/dev/null 2>&1
+df $proj_dir				>/dev/null 2>&1
+
+# Clean up
+rm -rf $proj_dir
+_scratch_unmount
+
+status=0
+exit
diff --git a/287.out b/287.out
new file mode 100644
index 0000000..e61bda7
--- /dev/null
+++ b/287.out
@@ -0,0 +1,2 @@
+QA output created by 287
+Silence is golden.
diff --git a/group b/group
index cbe9101..21566af 100644
--- a/group
+++ b/group
@@ -405,3 +405,4 @@ deprecated
 284 auto
 285 auto rw
 286 other
+287 auto quick quota
-- 
1.7.9


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
