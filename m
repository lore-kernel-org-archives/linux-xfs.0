Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JDa5sE131876 for <xfs@oss.sgi.com>; Wed, 19 May 2010 08:36:05 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6632B35A3A1
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:38:23 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id J4TEV6CPBwl2qUho for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 06:38:23 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 7/7] Add test of quota limit and info setting
Date: Wed, 19 May 2010 15:38:09 +0200
Message-Id: <1274276289-8839-8-git-send-email-jack@suse.cz>
In-Reply-To: <1274276289-8839-1-git-send-email-jack@suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

Add test stressing addition and removal of quota structures and setting
of quota grace time.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 234     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 234.out |    4 ++
 group   |    1 +
 3 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100755 234
 create mode 100644 234.out

diff --git a/234 b/234
new file mode 100755
index 0000000..84604eb
--- /dev/null
+++ b/234
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 234
+#
+# Stress setquota and setinfo handling.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Jan Kara.  All Rights Reserved.
+#
+# Based on test 219,
+# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
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
+owner=jack@suse.cz
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
+. ./common.quota
+
+test_setting()
+{
+	echo; echo "### test limits and info setting"
+	count=2000
+	procs=5
+	idmod=200000
+
+	for (( i = 0; i < $procs; i++ )); do
+		( SETUCOUNT=1; SETGCOUNT=1; SETUIDS[0]=0; SETGIDS[0]=0
+		for (( j = 0; j < $count; j++ )); do
+			OP=$(($RANDOM%22))
+			UG=$(($OP%2))
+			OP=$(($OP/2))
+			if [ $UG -eq 1 ]; then
+				type='u'
+			else
+				type='g'
+			fi
+			if [ $OP -eq 10 ]; then
+				setquota -t -$type $j $j $SCRATCH_MNT
+			elif [ $OP -lt 5 ]; then
+				ID=$(($RANDOM%$idmod))
+				if [ $UG -eq 1 ]; then
+					SETUIDS[$SETUCOUNT]=$ID
+					SETUCOUNT=$(($SETUCOUNT+1))
+				else
+					SETGIDS[$SETGCOUNT]=$ID
+					SETGCOUNT=$(($SETGCOUNT+1))
+				fi
+				setquota -$type $ID $j $j $j $j $SCRATCH_MNT
+			else
+				if [ $UG -eq 1 ]; then
+					ID=${SETUIDS[$(($RANDOM%$SETUCOUNT))]}
+				else
+					ID=${SETGIDS[$(($RANDOM%$SETGCOUNT))]}
+				fi
+				setquota -$type $ID 0 0 0 0 $SCRATCH_MNT
+			fi
+			
+		done )&
+	done
+	wait
+	echo "### done with testing"
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux #IRIX
+_require_scratch
+_require_quota
+_need_to_be_root
+
+# real QA test starts here
+rm -f $seq.full
+
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon -u -g $SCRATCH_MNT 2>/dev/null
+test_setting
+umount $SCRATCH_DEV
+
+status=0
+exit
diff --git a/234.out b/234.out
new file mode 100644
index 0000000..78d1587
--- /dev/null
+++ b/234.out
@@ -0,0 +1,4 @@
+QA output created by 234
+
+### test limits and info setting
+### done with testing
diff --git a/group b/group
index cc9bdb2..3a95e48 100644
--- a/group
+++ b/group
@@ -347,3 +347,4 @@ deprecated
 231 auto quota
 232 auto quota
 233 auto quota
+234 auto quota
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
