Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:50829 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727346AbeJ3UN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:56 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4l-0005bu-09
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:47 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jj-Uu
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] repair: Protect bad inode list with mutex
Date: Tue, 30 Oct 2018 22:20:41 +1100
Message-Id: <20181030112043.6034-6-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To enable phase 6 parallelisation, we need to protect the bad inode
list from concurrent modification and/or access. Wrap it with a
mutex and clean up the nasty typedefs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dir2.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index ba5763ed3d26..a73a675b97c8 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -20,40 +20,50 @@
  * Known bad inode list.  These are seen when the leaf and node
  * block linkages are incorrect.
  */
-typedef struct dir2_bad {
+struct dir2_bad {
 	xfs_ino_t	ino;
 	struct dir2_bad	*next;
-} dir2_bad_t;
+};
 
-static dir2_bad_t *dir2_bad_list;
+static struct dir2_bad	*dir2_bad_list;
+pthread_mutex_t		dir2_bad_list_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void
 dir2_add_badlist(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	struct dir2_bad	*l;
 
-	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
+	l = malloc(sizeof(*l));
+	if (!l) {
 		do_error(
 _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
-			sizeof(dir2_bad_t), ino);
+			sizeof(*l), ino);
 		exit(1);
 	}
+	pthread_mutex_lock(&dir2_bad_list_lock);
 	l->next = dir2_bad_list;
 	dir2_bad_list = l;
 	l->ino = ino;
+	pthread_mutex_unlock(&dir2_bad_list_lock);
 }
 
 int
 dir2_is_badino(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	struct dir2_bad	*l;
+	int		ret = 0;
 
-	for (l = dir2_bad_list; l; l = l->next)
-		if (l->ino == ino)
-			return 1;
-	return 0;
+	pthread_mutex_lock(&dir2_bad_list_lock);
+	for (l = dir2_bad_list; l; l = l->next) {
+		if (l->ino == ino) {
+			ret = 1;
+			break;
+		}
+	}
+	pthread_mutex_unlock(&dir2_bad_list_lock);
+	return ret;
 }
 
 /*
-- 
2.19.1
