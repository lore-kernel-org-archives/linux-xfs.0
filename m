Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42986802C
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 11:59:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E63F304066
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 09:59:45 -0800 (PST)
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id mOWYyTYm3ZNevDyE (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 09:59:45 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] xfstests: don't assume that falloc_punch implies falloc in
	test 255
Date: Tue,  5 Mar 2013 12:59:42 -0500
Message-Id: <1362506382-26974-1-git-send-email-tytso@mit.edu>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

As of Linux 3.9-rc1, ext4 will support the punch operation on file
systems using indirect blocks, but it can not support the fallocate
operation (since there is no way to mark a block as uninitialized
using indirect block scheme).  This caused test 255 to fail, since it
only used _require_xfS_io_falloc_punch assuming that all file systems
which supported punch can also support fallocate.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 255 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/255 b/255
index 0083963..ae1d8e0 100755
--- a/255
+++ b/255
@@ -48,6 +48,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_xfs_io_falloc_punch
+_require_xfs_io_falloc
 _require_xfs_io_fiemap
 
 testfile=$TEST_DIR/255.$$
-- 
1.7.12.rc0.22.gcdd159b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
