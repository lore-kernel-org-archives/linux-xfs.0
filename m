Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D60C29DF7
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 15:45:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7945BAC005
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:44:59 -0700 (PDT)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
	[209.85.160.174]) by cuda.sgi.com with ESMTP id
	Iffpmandnb1FW3oM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 13:44:58 -0700 (PDT)
Received: by mail-yk0-f174.google.com with SMTP id 20so3802374yks.5
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:44:57 -0700 (PDT)
Date: Mon, 21 Apr 2014 16:44:54 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v3 3/3] generic: fix check for zero range support in
	generic/009
Message-ID: <20140421204454.GD960@wallace>
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

Generic/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

v2: Use new helper function for the check.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/009 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/009 b/tests/generic/009
index b7b0b3f..b4d3e4b 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_falloc_zero
 
 testfile=$TEST_DIR/009.$$
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
