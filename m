Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7OLrx3f113452 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 16:53:59 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 1/3] xfsprogs: xfs_quota: return real-time used data as
	intended
Date: Wed, 24 Aug 2011 16:53:41 -0500
Message-Id: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
In-Reply-To: <1314222823-24101-1-git-send-email-aelder@sgi.com>
References: <1314222823-24101-1-git-send-email-aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

In projects_free_space_data() the real-time used space consumption
is never set.  Instead, that value is returned in the field that
should hold the quota limit.

Found by inspection.  Never seen/noticed because we currently don't
support quotas when a filesystem has a realtime volume.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 quota/free.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/quota/free.c b/quota/free.c
index 825ce34..26ec293 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -177,16 +177,18 @@ projects_free_space_data(
 		*bfree = (d.d_blk_softlimit - d.d_bcount) << 1;
 	}
 	*bused = d.d_bcount << 1;
+
 	if (d.d_ino_softlimit) {
 		*icount = d.d_ino_softlimit;
 		*ifree = (d.d_ino_softlimit - d.d_icount);
 	}
 	*iused = d.d_icount;
+
 	if (d.d_rtb_softlimit) {
 		*rcount = d.d_rtb_softlimit << 1;
 		*rfree = (d.d_rtb_softlimit - d.d_rtbcount) << 1;
 	}
-	*rcount = d.d_rtbcount << 1;
+	*rused = d.d_rtbcount << 1;
 
 	close(fd);
 	return 1;
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
