Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E259E7F54
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 17:18:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF8C58F8040
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 15:18:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5xFxKOpzoEqd4WNR for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 15:18:06 -0700 (PDT)
Message-ID: <540E2B1F.9070009@sandeen.net>
Date: Mon, 08 Sep 2014 17:18:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: don't ASSERT on corrupt ftype
References: <540D011B.2000807@redhat.com>
In-Reply-To: <540D011B.2000807@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xfs_dir3_data_get_ftype() gets the file type off
disk, but ASSERTs if it's invalid:

     ASSERT(type < XFS_DIR3_FT_MAX);

We shouldn't ASSERT on bad values read from disk.
V3 dirs are CRC-protected, but V2 dirs + ftype
are not.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index c9aee52..7e42fdf 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -270,7 +270,6 @@ xfs_dir3_data_get_ftype(
  {
      __uint8_t    ftype = dep->name[dep->namelen];
  
-    ASSERT(ftype < XFS_DIR3_FT_MAX);
      if (ftype >= XFS_DIR3_FT_MAX)
          return XFS_DIR3_FT_UNKNOWN;
      return ftype;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
