Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4303C7F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 04:24:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 329F830404E
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:24:28 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id 2FNixNLbiIHeNe2n
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 May 2013 02:24:27 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id hz10so3948621pad.16
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:24:26 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests: check falloc in 285
Date: Sun, 12 May 2013 17:42:09 +0800
Message-Id: <1368351729-17778-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

As linux 3.8, ext4 has supported the seek data/hole operation for
extent-based file and indirect-based file.  But for indirect-based file
it can not support the fallocate(2).  This causes test 285 to fail since
it assumes that all file systems which supports seek data/hole also
support fallocate.  So here we need to check it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Rich Johnston <rjohnston@sgi.com>
---
 tests/generic/285 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/285 b/tests/generic/285
index 22b4a08..d1a1baa 100644
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -40,6 +40,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
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
