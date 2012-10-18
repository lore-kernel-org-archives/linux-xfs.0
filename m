Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I8iIem168668 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 03:44:18 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EEbwsvyLk5XqveVF for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 01:45:57 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9I8juH5019272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 04:45:57 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 2/3] Provide dumpe2fs via standard common.config interface
Date: Thu, 18 Oct 2012 10:45:45 +0200
Message-Id: <1350549946-17192-2-git-send-email-tracek@redhat.com>
In-Reply-To: <1350549946-17192-1-git-send-email-tracek@redhat.com>
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

dumpe2fs can be now accessed via $DUMPE2FS, tests that require it can
check for its availability by _require_dumpe2fs function.

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
index b5edd22..6d2d5b9 100644
--- a/common.rc
+++ b/common.rc
@@ -1804,6 +1804,13 @@ _test_batched_discard()
 	$FSTRIM_PROG ${1} &>/dev/null
 }
 
+_require_dumpe2fs()
+{
+	if [ -z "$DUMPE2FS_PROG" ]; then
+		_notrun "This test requires dumpe2fs utility."
+	fi
+}
+
 _create_loop_device()
 {
 	file=$1
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
