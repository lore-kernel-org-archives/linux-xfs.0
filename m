Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CD0D7F50
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 04:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFA4E30404E
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 02:20:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7knKphehievGr7p2 for
	<xfs@oss.sgi.com>; Sun, 03 Feb 2013 02:20:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r13AKR9I002692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2013 05:20:28 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 1/3] xfstests: Provide dumpe2fs via standard common.config
	interface
Date: Sun,  3 Feb 2013 11:19:56 +0100
Message-Id: <1359886798-8818-1-git-send-email-tracek@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

dumpe2fs can be now accessed via $DUMPE2FS_PROG, tests that require it
can check for its availability by _require_dumpe2fs function.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common.config | 1 +
 common.rc     | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/common.config b/common.config
index 57f505d..7174127 100644
--- a/common.config
+++ b/common.config
@@ -159,6 +159,7 @@ export KILLALL_PROG="`set_prog_path killall`"
 export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
 export FSTRIM_PROG="`set_prog_path fstrim`"
+export DUMPE2FS_PROG="`set_prog_path dumpe2fs`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.rc b/common.rc
index 2e8581e..0cccb94 100644
--- a/common.rc
+++ b/common.rc
@@ -1826,6 +1826,13 @@ _test_batched_discard()
 	$FSTRIM_PROG ${1} &>/dev/null
 }
 
+_require_dumpe2fs()
+{
+	if [ -z "$DUMPE2FS_PROG" ]; then
+		_notrun "This test requires dumpe2fs utility."
+	fi
+}
+
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
