Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53JBV135020 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:19 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HHcFLEY3PdGK7YaZ for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaK-0003GQ-O1
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaA-0003dy-Kd
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 034/102] xfs: show uuid when mount fails due to duplicate uuid
Date: Thu, 23 Aug 2012 15:01:52 +1000
Message-Id: <1345698180-13612-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

Upstream commit: 021000e59c0db2d3a8113e906bde3183c33fa84b

When a system tries to mount a filesystem (FS) using UUID, the xfs
returns -EINVAL and shows a message if a FS with the same UUID has
been already mounted. It is useful to output the duplicate UUID
with it.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_mount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3effa7f..2f011fd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -158,7 +158,7 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
+	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
 	return XFS_ERROR(EINVAL);
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
