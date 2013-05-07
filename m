Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCD0629E03
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:09:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69AC6AC002
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 15:09:41 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id aUF7mYSiluN9LFTQ for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 15:09:39 -0700 (PDT)
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3B9FAA41E0
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 00:09:39 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] Fix test 298 to work for non-XFS filesystems
Date: Wed,  8 May 2013 00:09:32 +0200
Message-Id: <1367964573-29620-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Call to xfs_io in test 298 forgot to specify -F flag so it failed for
non-XFS filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/shared/298 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shared/298 b/tests/shared/298
index f1a3432..d5bed1c 100644
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -49,7 +49,7 @@ _cleanup()
 
 get_holes()
 {
-	$XFS_IO_PROG -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
+	$XFS_IO_PROG -F -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
 }
 
 get_free_sectors()
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
