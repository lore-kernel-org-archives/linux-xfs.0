Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27F3B7F37
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 11:08:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18A57304039
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 09:08:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eWCR4HuHWCjTN2n8 for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2016 09:08:25 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 694E061A5FC7
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 11:08:25 -0600 (CST)
Subject: [PATCH] xfs_repair: Fix untranslatable strings
References: <20160124155853.GA10063@stranger.qboosh.pl>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A50508.4060207@sandeen.net>
Date: Sun, 24 Jan 2016 11:08:24 -0600
MIME-Version: 1.0
In-Reply-To: <20160124155853.GA10063@stranger.qboosh.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Don't substitute in "would" or "will" for %s here, it makes
it untranslatable.  Just spell it out twice like every other
message in the function.

Reported-by: Jakub Bogusz <qboosh@pld-linux.org>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/versions.c b/repair/versions.c
index 1585385..978f48b 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -224,10 +224,17 @@ _("WARNING:  you have disallowed attr2 attributes but this filesystem\n"
 	}
 
 	if (!(sb->sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
-		do_warn(
-_("WARNING: you have a V1 inode filesystem. It %s be converted to a\n"
+		if (!no_modify) {
+			do_warn(
+_("WARNING: you have a V1 inode filesystem. It will be converted to a\n"
   "\tversion 2 inode filesystem. If you do not want this, run an older\n"
-  "\tversion of xfs_repair.\n"), no_modify ? "would" : "will");
+  "\tversion of xfs_repair.\n"));
+		} else  {
+			do_warn(
+_("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
+  "\tversion 2 inode filesystem. If you do not want this, run an older\n"
+  "\tversion of xfs_repair.\n"));
+		}
 	}
 
 	if (xfs_sb_version_hasquota(sb))  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
