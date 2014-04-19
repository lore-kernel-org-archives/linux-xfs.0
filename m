Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0A4D7F58
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 14:08:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 839F7304039
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 12:08:20 -0700 (PDT)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id mBNiWDtLrHKgo52C
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Apr 2014 12:08:19 -0700 (PDT)
Received: by mail-qa0-f45.google.com with SMTP id cm18so2619826qab.32
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 12:08:18 -0700 (PDT)
Date: Sat, 19 Apr 2014 15:08:15 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix check for zero range support in ext4/001
Message-ID: <20140419190815.GB2116@wallace>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

Ext4/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/001 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/001 b/tests/ext4/001
index d575d9a..827d806 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -45,7 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs ext4
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/001.$$
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
