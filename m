Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7OLrvZR113432 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 16:53:57 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 3/3] xfsprogs: xfs_quota: improve calculation for percentage
	display
Date: Wed, 24 Aug 2011 16:53:43 -0500
Message-Id: <5f21f0e86c8400108a701084a85ebcd97694a074.1314222483.git.aelder@sgi.com>
In-Reply-To: <1314222823-24101-1-git-send-email-aelder@sgi.com>
References: <1314222823-24101-1-git-send-email-aelder@sgi.com>
In-Reply-To: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
References: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
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

The pct_to_string() function determines the percentage it produces
in a strange way.  Simplify the function, and make it return the
simple rounded percentage value.  Handle the case of an error
return from snprintf() as well.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 quota/util.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/quota/util.c b/quota/util.c
index 18ccae2..179aafd 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -172,18 +172,18 @@ num_to_string(
 
 char *
 pct_to_string(
-	__uint64_t	v,
-	__uint64_t	t,
-	char		*sp,
+	__uint64_t	portion,
+	__uint64_t	whole,
+	char		*buf,
 	uint		size)
 {
-	if (t == 0 || v == 0)
-		snprintf(sp, size, "%3u", (uint)0);
-	else if (t == v)
-		snprintf(sp, size, "%3u", (uint)100);
-	else
-		snprintf(sp, size, "%3u", (uint)(((double)v / t) * 100 + 1));
-	return sp;
+	uint		percent;
+
+	percent = whole ? (uint) (100.0 * portion / whole + 0.5) : 0;
+	if (snprintf(buf, size, "%3u", percent) < 0)
+		return "???";
+
+	return buf;
 }
 
 char *
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
