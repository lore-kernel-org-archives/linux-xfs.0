Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34894 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbdLHENR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 23:13:17 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4D8D6614304
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 22:13:14 -0600 (CST)
Subject: [PATCH 1/5] mkfs: Don't emit default config message yet
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <62f67117-150d-e456-d9dd-3a19938cb03a@sandeen.net>
Date: Thu, 7 Dec 2017 22:13:15 -0600
MIME-Version: 1.0
In-Reply-To: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Until we have more than one possible source of configuration,
there is no need to emit the only possibility and clutter
the output.  We can decide how it should all look when we
get more than one source.

Apply some i18n to the config description, though.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 mkfs/xfs_mkfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e38810f..0f7dd92 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3845,7 +3845,7 @@ main(
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
-		.source = "package build definitions",
+		.source = _("package build definitions"),
 		.sectorsize = XFS_MIN_SECTORSIZE,
 		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
 		.sb_feat = {
@@ -3881,10 +3881,12 @@ main(
 	 * defaults. If a file exists in <package location>, read in the new
 	 * default values and overwrite them in the &dft structure. This way the
 	 * new defaults will apply before we parse the CLI, and the CLI will
-	 * still be able to override them. Emit a message to indicate where the
-	 * defaults being used came from.
+	 * still be able to override them. When more than one source is
+	 * implemented, emit a message to indicate where the defaults being
+	 * used came from.
+	 *
+	 * printf(_("Default configuration sourced from %s\n"), dft.source);
 	 */
-	printf(_("Default configuration sourced from %s\n"), dft.source);
 
 	/* copy new defaults into CLI parsing structure */
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
-- 
1.8.3.1

