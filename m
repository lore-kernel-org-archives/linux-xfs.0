Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F1367F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:41:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B5A9304053
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:41:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oLQhCzMsohp0DrLy for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:41:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAMH-0000AR-L9
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAMH-0008CX-KR
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: fix sb_meta_uuid usage
Date: Mon,  3 Aug 2015 17:40:22 +1000
Message-Id: <1438587625-31437-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-1-git-send-email-david@fromorbit.com>
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

After changing the UUID on a v5 filesystem, xfstests fails
immediately on a debug kernel with:

XFS: Assertion failed: uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid), file: fs/xfs/xfs_inode.c, line: 799

This needs to check against the sb_meta_uuid, not the user visible
UUID that was changed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb52ff0..4156e37 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -796,7 +796,7 @@ xfs_ialloc(
 
 	if (ip->i_d.di_version == 3) {
 		ASSERT(ip->i_d.di_ino == ino);
-		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
+		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
 		ip->i_d.di_lsn = 0;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
