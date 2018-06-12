Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54622 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753517AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 7/7] mkfs: remove gotos in parse_defaults_file
Date: Tue, 12 Jun 2018 14:31:23 -0500
Message-Id: <1528831883-21879-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There's no point to the gotos in parse_defaults_file; no cleanup
etc that is normally facilitated by a goto, so just remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 mkfs/config.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mkfs/config.c b/mkfs/config.c
index 173ab9a..f9ca78a 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -636,17 +636,15 @@ parse_defaults_file(
 
 	fp = fdopen(fd, "r");
 	if (!fp)
-		goto out;
+		return -1;
 
 	ret = parse_config_stream(dft, config_file, fp);
 	if (ret) {
 		fclose(fp);
-		goto out;
+		return -1;
 	}
 
 	printf(_("config-file=%s\n"), config_file);
 
 	return 0;
-out:
-	return -1;
 }
-- 
1.8.3.1

