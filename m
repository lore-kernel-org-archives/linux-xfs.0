Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D5F57F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 01:22:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 681FB304051
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 23:22:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	i9XCDHF4hh4BqaPT for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 23:22:32 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WNG56-0003R1-Jd
	for xfs@oss.sgi.com; Tue, 11 Mar 2014 17:22:28 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WNG56-0000Pi-I6
	for xfs@oss.sgi.com; Tue, 11 Mar 2014 17:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] repair: ensure that unused superblock fields are zeroed
Date: Tue, 11 Mar 2014 17:22:28 +1100
Message-Id: <1394518948-1506-1-git-send-email-david@fromorbit.com>
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

When we grab a superblock off disk via get_sb(), we don't know what
the in-memory superblock we are filling out contained. We ned to
ensure that the entire structure is returned in an initialised
state regardless of which fields libxfs_sb_from_disk() populates
from disk. In this case, it doesn't populate the sb_crc field,
and so uninitialised values can escape through to disk on v4
filesystems because of this. This causes xfs/031 to fail on v4
filesystems.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/sb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/repair/sb.c b/repair/sb.c
index b111aca..d928dc0 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -518,6 +518,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 		exit(1);
 	}
 	memset(buf, 0, size);
+	memset(sbp, 0, sizeof(*sbp));
 
 	/* try and read it first */
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
