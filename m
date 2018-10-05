Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48088 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeJELAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:12 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 01/15] xfsprogs: minor sparse fixes
Date: Thu,  4 Oct 2018 23:03:02 -0500
Message-Id: <1538712196-13625-2-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Remove stray semicolon, add missing return.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 io/init.c         | 1 +
 repair/agheader.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/io/init.c b/io/init.c
index 82774c7..e9449a2 100644
--- a/io/init.c
+++ b/io/init.c
@@ -240,6 +240,7 @@ idle_loop(void *arg)
 {
 	for (;;)
 		pause();
+	return NULL;
 }
 
 void
diff --git a/repair/agheader.c b/repair/agheader.c
index 77e04f6..218ee25 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -245,7 +245,7 @@ secondary_sb_whack(
 	int		do_bzero = 0;
 	int		size;
 	char		*ip;
-	int		rval = 0;;
+	int		rval = 0;
 	uuid_t		tmpuuid;
 
 	rval = do_bzero = 0;
-- 
1.8.3.1
