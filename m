Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63819 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbeJ3UNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:54 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0005br-TH
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:47 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jZ-Rn
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
Date: Tue, 30 Oct 2018 22:20:38 +1100
Message-Id: <20181030112043.6034-3-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

I noticed phase 4 writing back lots of inode buffers during recent
testing. The recent rework of clear_inode() in commit 0724d0f4cb53
("xfs_repair: clear_dinode should simply clear, not check contents")
accidentally caught a call to clear_inode_unlinked() as well,
resulting in all inodes being marked dirty whether then needed
updating or not.

Fix it by reverting the erroneous hunk and adding warnings so taht
this corruption is no longer silently fixed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 379f85cf1268..90400128d4bb 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2675,9 +2675,15 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * we're going to find.  check_dups is set to 1 only during
 	 * phase 4.  Ugly.
 	 */
-	if (check_dups && !no_modify) {
-		clear_dinode_unlinked(mp, dino);
-		*dirty += 1;
+	if (check_dups && clear_dinode_unlinked(mp, dino)) {
+		if (no_modify) {
+			do_warn(
+	_("Would clear unlinked_next in inode %" PRIu64 "\n"), lino);
+		} else  {
+			do_warn(
+	_("Cleared unlinked_next in inode %" PRIu64 "\n"), lino);
+			*dirty += 1;
+		}
 	}
 
 	/* set type and map type info */
-- 
2.19.1
