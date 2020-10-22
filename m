Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC802C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E672244C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444251AbgJVFPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:15:45 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59673 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444246AbgJVFPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:15:44 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 989B43ABDDB
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 16:15:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-0034Kn-Q7
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-009aoG-IV
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] repair: Protect bad inode list with mutex
Date:   Thu, 22 Oct 2020 16:15:32 +1100
Message-Id: <20201022051537.2286402-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022051537.2286402-1-david@fromorbit.com>
References: <20201022051537.2286402-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=4vG5bgiOaNo-D7GZVj4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To enable phase 6 parallelisation, we need to protect the bad inode
list from concurrent modification and/or access. Wrap it with a
mutex and clean up the nasty typedefs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dir2.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index eabdb4f2d497..23333e59a382 100644
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
2.28.0

