Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C9D829DF7
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 15:26:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10D51304043
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:26:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qJtXiosAOtBgfv4g for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:26:49 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3LKQnOg008149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:26:49 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3LKQmDA020728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:26:48 -0400
Message-ID: <53557F09.8090000@redhat.com>
Date: Mon, 21 Apr 2014 15:26:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test X_QUOTARM functionality
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

The Q_XQUOTARM quotactl was not working properly, because
we weren't passing in proper flags.  The xfs_fs_set_xstate()
ioctl handler used the same flags for Q_XQUOTAON/OFF as
well as Q_XQUOTARM, but Q_XQUOTAON/OFF look for
XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
i.e. quota type + state, while Q_XQUOTARM looks only for
the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.

Unfortunately these flag spaces overlap a bit, so we
got semi-random results for Q_XQUOTARM; i.e. the value
for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.

Anyway, here's a simple test that demonstrates it,
kernel patch to fix it will follow.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

It only tests user & group; if we really want project
as well, it could be expanded w/ a little more complexity...

diff --git a/tests/xfs/307 b/tests/xfs/307
new file mode 100755
index 0000000..8969e4a
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 307
+#
+# Test to verify Q_XQUOTARM functionality.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux Irix
+
+_require_scratch
+_require_xfs_quota
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+
+_qmount_option "uquota,gquota"
+_qmount
+
+echo "*** umount"
+umount $SCRATCH_MNT
+
+UQUOTINO=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | grep uquotino | awk '{print $NF}'`
+GQUOTINO=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | grep gquotino | awk '{print $NF}'` 
+
+echo "*** Usage before quotarm ***"
+xfs_db -c "inode $UQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+xfs_db -c "inode $GQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+
+_qmount
+echo "*** turn off user and group quotas"
+xfs_quota -x -c 'off -ug' $SCRATCH_MNT
+xfs_quota -x -c "remove -ug" $SCRATCH_MNT
+echo "*** umount"
+umount $SCRATCH_MNT
+
+echo "*** Usage after quotarm ***"
+xfs_db -c "inode $UQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+xfs_db -c "inode $GQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/307.out b/tests/xfs/307.out
new file mode 100644
index 0000000..b2fce7a
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,10 @@
+QA output created by 307
+*** umount
+*** Usage before quotarm ***
+core.nblocks = 1
+core.nblocks = 1
+*** turn off user and group quotas
+*** umount
+*** Usage after quotarm ***
+core.nblocks = 0
+core.nblocks = 0
diff --git a/tests/xfs/group b/tests/xfs/group
index e9c4808..d3f7148 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -190,3 +190,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
