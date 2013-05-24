Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C7BA7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 23:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B19DAC001
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 21:33:07 -0700 (PDT)
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id XVGwx6SZFwOpbeIM (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 21:33:06 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] add generic/286 to the auto and quick groups
Date: Fri, 24 May 2013 00:33:01 -0400
Message-Id: <1369369981-7035-1-git-send-email-tytso@mit.edu>
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

The generic/286 test tests SEEK_HOLE and SEEK_DATA, and is reasonably
fast.  We should just run the test by default.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/generic/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/group b/tests/generic/group
index e2ef70e..bd443c1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -103,7 +103,7 @@
 277 auto ioctl quick metadata
 280 auto quota freeze dangerous
 285 auto rw
-286 other
+286 auto quick other
 288 auto quick ioctl trim
 294 auto quick
 299 auto aio enospc rw stress
-- 
1.7.12.rc0.22.gcdd159b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
