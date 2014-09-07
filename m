Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 417447F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5766AC004
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8iIw0F9BC2bkM27M for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:06 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/5] xfs_repair: don't ASSERT on corrupt ftype
Date: Sun,  7 Sep 2014 11:41:04 -0500
Message-Id: <1410108065-18156-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
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

xfs_dir3_dirent_get_ftype() gets the file type
off disk, but ASSERTs if it's invalid:

	ASSERT(type < XFS_DIR3_FT_MAX);

This might be cut & paste from
xfs_dir3_dirent_put_ftype which should be checking
that it's not been passed bad values, but we
shouldn't ASSERT on bad values read from disk.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_da_format.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
index 89a1a21..11f1420 100644
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -561,7 +561,6 @@ xfs_dir3_dirent_get_ftype(
 	if (xfs_sb_version_hasftype(&mp->m_sb)) {
 		__uint8_t	type = dep->name[dep->namelen];
 
-		ASSERT(type < XFS_DIR3_FT_MAX);
 		if (type < XFS_DIR3_FT_MAX)
 			return type;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
