Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DC3D7F59
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 03:20:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ED255304039
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:20:21 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id l10YRAPY77UE8Aix
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:20:21 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id hz11so320871pad.16
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:20:20 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: check falloc in 285
Date: Tue, 26 Mar 2013 16:35:57 +0800
Message-Id: <1364286957-29140-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

As linux 3.8, ext4 has supported the seek data/hole operation for
extent-based file and indirect-based file.  But for indirect-based file
it can not support the fallocate(2).  This causes test 285 to fail since
it assumes that all file systems which supports seek data/hole also
support fallocate.  So here we need to check it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 285 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/285 b/285
index a18fc71..8726b9e 100644
--- a/285
+++ b/285
@@ -41,6 +41,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_xfs_io_falloc
+
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
