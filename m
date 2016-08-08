Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E5577CA4
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 01:23:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9457AC004
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 23:23:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HXeo6wG6JWyzfQII for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2016 23:23:01 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
Date: Mon,  8 Aug 2016 16:22:30 +1000
Message-Id: <1470637351-27933-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1470637351-27933-1-git-send-email-david@fromorbit.com>
References: <1470637351-27933-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The flag is checked as supported, but then we do an unconditional
sync of the file, regardless of whether the flag is set or not. Make
the sync conditional on having the FIEMAP_FLAG_SYNC flag set.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 48141b8..189742b 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -470,9 +470,11 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	if (ret)
 		return ret;
 
-	ret = filemap_write_and_wait(inode->i_mapping);
-	if (ret)
-		return ret;
+	if (fi->fi_flags & FIEMAP_FLAG_SYNC) {
+		ret = filemap_write_and_wait(inode->i_mapping);
+		if (ret)
+			return ret;
+	}
 
 	while (len > 0) {
 		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
