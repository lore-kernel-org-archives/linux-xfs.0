Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KKclFc024871 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 15:38:48 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5FFA1CA09DA
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 13:38:46 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id aGtjMkYCboCReJut
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 13:38:46 -0700 (PDT)
Received: by bke11 with SMTP id 11so4297110bke.26
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 13:38:45 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfstests: add regression test for extent corruption on ext4
In-Reply-To: <87sjmorog0.fsf@dmbot.sw.ru>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
	<87sjmorog0.fsf@dmbot.sw.ru>
Date: Fri, 21 Oct 2011 00:38:58 +0400
Message-ID: <87pqhrs8il.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org, aelder@sgi.com, tytso@mit.edu

--=-=-=

On Thu, 20 Oct 2011 13:40:15 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> On Wed, 19 Oct 2011 14:29:41 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > xfstests: fsstress should kill children tasks before exit
> > xfstests: add different logging option to fsstress
> > xfstests: add fallocate support to fsstress
> > xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
> > xfstests: Dump inode info when possible
> > xfstests: add fiemap operation
> > 
> > # Following testcase will fail on recent kernel in case of ext4
> > # Some fixes are already available here:
> > # http://www.spinics.net/lists/linux-ext4/msg27857.html
> > xfstests: add new stress test
> FYI: i've run 264'th test on recent tytso/ext4.git(dcf2d804ed6ffe)
> and have got new type of fs-corruption, i haven't seen this before,
> at this moment I dont have a fix for that:
> Pass 1: Checking inodes, blocks, and sizes
> Inode 176 has an invalid extent
>       (logical block 236, invalid physical block 0, len 0)
> Clear? no
> 
> Inode 22293 has an invalid extent
>       (logical block 531, invalid physical block 0, len 0)
> Clear? no
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> ...
Ok, this one appears to be easy. eh_entries updated after
ext4_ext_dirty() was called inside ext4_ext_rm_leaf().
Testcase attached, will send a fix for the issue in a minute.

--=-=-=
Content-Disposition: inline;
 filename=0001-xfstests-add-regression-test-for-extent-corruption-o.patch

>From b24f909727d71647d8721af6f86946ad30fe9b9c Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Fri, 21 Oct 2011 00:32:32 +0400
Subject: [PATCH] xfstests: add regression test for extent corruption on ext4


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 266     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 266.out |   44 ++++++++++++++++++++++++++++++++++++++++
 group   |    1 +
 3 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 266
 create mode 100644 266.out

diff --git a/266 b/266
new file mode 100644
index 0000000..4209532
--- /dev/null
+++ b/266
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FSQA Test No. 266
+#
+# Regression testcase for d583fb87a3ff0 (ext4 extent corruption)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dmonakhov@openvz.org
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seq.full 2>&1
+
+# -onoload and EXT4_SYNC_FL on file is important becase result in
+# metadata sync writes inside ext4_handle_dirty_metadata()
+_scratch_mount -onoload
+touch $SCRATCH_MNT/file
+chattr +S $SCRATCH_MNT/file
+# Create sparse file 
+for ((i = 0; i < 21; i++))
+do
+    dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k count=1 seek=$((i*10))
+done
+# truncate last extent
+truncate $SCRATCH_MNT/file --size $((4096* 200))
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+echo "Check filesystem"
+_check_scratch_fs
+status=$?
+exit
diff --git a/266.out b/266.out
new file mode 100644
index 0000000..a248232
--- /dev/null
+++ b/266.out
@@ -0,0 +1,44 @@
+QA output created by 266
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+Check filesystem
diff --git a/group b/group
index 487051a..281d92b 100644
--- a/group
+++ b/group
@@ -379,4 +379,4 @@ deprecated
 263 rw auto quick
 264 auto rw prealloc ioctl enospc
 265 auto quota rw prealloc ioctl enospc
+266 rw auto quick 
-- 
1.7.1


--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
