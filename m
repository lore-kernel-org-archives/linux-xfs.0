Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB4227F85
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:42:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4924DAC045
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:42:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EPruC7DbaYELG2aw for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:42:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAOG-0000B1-GE
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAOG-0008Ej-ED
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] libxfs: fix uuid check durign inode allocation
Date: Mon,  3 Aug 2015 17:42:29 +1000
Message-Id: <1438587749-31597-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587749-31597-1-git-send-email-david@fromorbit.com>
References: <1438587749-31597-1-git-send-email-david@fromorbit.com>
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

Needs to check sb_meta_uuid now that we the sb_uuid can change on v5
filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 719a5b7..f427d22 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -262,7 +262,7 @@ libxfs_ialloc(
 
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
