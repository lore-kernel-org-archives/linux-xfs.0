Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E8C57F72
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 16:01:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F1CC8F8040
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 14:01:19 -0800 (PST)
Received: from mail-pd0-f180.google.com (mail-pd0-f180.google.com
	[209.85.192.180]) by cuda.sgi.com with ESMTP id
	I3YCaHsQ1qfQIPtf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 14:01:18 -0800 (PST)
Received: by mail-pd0-f180.google.com with SMTP id ft15so10997016pdb.11
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 14:01:17 -0800 (PST)
From: Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH] xfs: fix typo
Date: Fri, 23 Jan 2015 14:00:51 -0800
Message-Id: <1422050451-11486-1-git-send-email-computersforpeace@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Norris <computersforpeace@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

'tobe' should be two words.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 18e2f3bbae5e..af729e8975aa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1161,7 +1161,7 @@ xfs_vm_writepage(
 	ASSERT(iohead);
 
 	/*
-	 * Any errors from this point onwards need tobe reported through the IO
+	 * Any errors from this point onwards need to be reported through the IO
 	 * completion path as we have marked the initial page as under writeback
 	 * and unlocked it.
 	 */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
