Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 101EA7F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:42:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A34BCAC045
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:42:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	74tD2RvFPceYr5HA for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:42:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAOG-0000B0-EY
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAOG-0008Ee-Dv
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:42:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] repair: use sb_meta_uuid for checking of metadata headers
Date: Mon,  3 Aug 2015 17:42:28 +1000
Message-Id: <1438587749-31597-2-git-send-email-david@fromorbit.com>
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

Now that we can change the uuid on v5 filesystems, we always need to
verify the metadata uuid against sb_meta_uuid, not sb_uuid. This
fixes quite a few xfstests failures when UUIDs are changed before
executing tests.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 2 +-
 repair/scan.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 09da2e2..ad9be38 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1960,7 +1960,7 @@ _("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
 		return 1;
 	}
 	/* verify uuid */
-	if (platform_uuid_compare(uuid, &mp->m_sb.sb_uuid) != 0) {
+	if (platform_uuid_compare(uuid, &mp->m_sb.sb_meta_uuid) != 0) {
 		do_warn(
 _("wrong FS UUID, directory inode %" PRIu64 " block %" PRIu64 "\n"),
 			ino, bp->b_bn);
diff --git a/repair/scan.c b/repair/scan.c
index 8711b94..95b8ade 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -237,7 +237,7 @@ _("expected block %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
 		}
 		/* verify uuid */
 		if (platform_uuid_compare(&block->bb_u.l.bb_uuid,
-					  &mp->m_sb.sb_uuid) != 0) {
+					  &mp->m_sb.sb_meta_uuid) != 0) {
 			do_warn(
 _("wrong FS UUID, bmbt block %" PRIu64 "\n"),
 				bno);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
